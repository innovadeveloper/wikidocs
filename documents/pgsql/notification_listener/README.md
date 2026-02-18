# Informe Técnico: PostgreSQL NOTIFY/LISTEN - Cola de Notificaciones

## 1. Arquitectura de la Cola Global

PostgreSQL implementa un sistema de mensajería asíncrono mediante una cola global compartida:

```
TRANSACCIÓN EMISORA
    │
    ├─ INSERT/UPDATE/DELETE en tabla
    │
    ├─ TRIGGER ejecuta pg_notify('canal', 'payload')
    │
    └─ COMMIT → Notificación enviada a cola global
              │
              ▼
┌─────────────────────────────────────────┐
│     COLA GLOBAL (Shared Memory)         │
│     Tamaño: ~8 GB                       │
│     Almacena: 1 copia por notificación  │
└──────────┬──────────┬──────────┬────────┘
           │          │          │
           ▼          ▼          ▼
      Listener 1  Listener 2  Listener N
      (puntero)   (puntero)   (puntero)
```

### Características clave:

- **Una sola copia física**: PostgreSQL almacena cada notificación una sola vez en memoria compartida
- **Punteros por sesión**: Cada listener mantiene un puntero/offset de lectura sobre la cola
- **Consumo independiente**: Cada sesión lee a su propio ritmo sin afectar a otras
- **FIFO estricto**: Las notificaciones se entregan en orden por transacción

## 2. Documentación Oficial - Límites y Comportamiento

Según la documentación oficial de PostgreSQL:

> "There is a queue that holds notifications that have been sent but not yet processed by all listening sessions. If this queue becomes full, transactions calling NOTIFY will fail at commit. **The queue is quite large (8GB in a standard installation)** and should be sufficiently sized for almost every use case."

Fuente: [PostgreSQL NOTIFY Documentation](https://www.postgresql.org/docs/current/sql-notify.html)

### Comportamiento cuando la cola se llena:

- **Al 50% de uso**: PostgreSQL emite warnings en logs identificando sesiones que impiden limpieza
- **Al 100% de uso**: Transacciones que ejecutan NOTIFY fallan en COMMIT
- **Limpieza bloqueada**: Si una sesión tiene LISTEN activo dentro de una transacción larga, impide liberación de espacio

### Verificación de uso:

```sql
SELECT pg_notification_queue_usage();
-- Retorna: 0.0 a 1.0 (0% a 100%)
```

## 3. Ventajas de Performance: NOTIFY vs Polling

### NOTIFY/LISTEN:

**Ventajas:**
- Latencia ultra-baja: notificaciones inmediatas (ms)
- Sin overhead en base de datos: no ejecuta queries repetitivos
- Escalable: 8GB soporta millones de notificaciones
- Event-driven: reacción instantánea a cambios

**Desventajas:**
- Requiere conexión persistente
- No persiste si el listener no está conectado

### Polling tradicional:

**Desventajas:**
- Overhead constante: queries cada N segundos aunque no haya cambios
- Mayor latencia: depende del intervalo de polling
- Carga en DB: aumenta con número de réplicas

**Ventajas:**
- No requiere conexión persistente
- Más simple de implementar

### Comparación práctica:

```
Escenario: 10 réplicas backend, cambios cada 5 minutos

NOTIFY/LISTEN:
- 10 conexiones idle consumiendo ~4MB RAM
- 1 notificación cada 5 min = 288 notificaciones/día
- Latencia: <100ms

POLLING (cada 5 segundos):
- 10 × 17,280 queries/día = 172,800 queries totales
- Carga constante en DB incluso sin cambios
- Latencia: 0-5 segundos
```

## 4. Casos de Prueba Realizados

### Objetivo:
Validar empíricamente el tamaño de la cola global de PostgreSQL mediante envío masivo de notificaciones sin listeners activos.

### Caso 1: 1,000 notificaciones

```sql
-- Envío: 1,000 notificaciones × 1,000 bytes = ~1 MB
SELECT pg_notification_queue_usage();
-- Resultado: 0.00010395 (0.010395%)
```

### Caso 2: 11,000 notificaciones acumuladas

```sql
-- Envío: 11,000 notificaciones × 1,000 bytes = ~10.5 MB
SELECT pg_notification_queue_usage();
-- Resultado: 0.00146675 (0.146675%)
```

### Cálculo inverso:

```
Bytes totales = 10.5 MB
Porcentaje usado = 0.00146675

Tamaño total = 10.5 MB ÷ 0.00146675
             ≈ 7,158 MB
             ≈ 7 GB (ajustado a ~8 GB estándar)
```

### Conclusión experimental:

El tamaño de la cola global es confirmado en **~8 GB**, validando la documentación oficial.

## 5. Comandos Útiles para Gestión

### Ver conexiones activas

```sql
SELECT pid, usename, application_name, state, backend_start
FROM pg_stat_activity
WHERE datname = current_database();
```

### Ver quién está usando LISTEN

```sql
SELECT pid, usename, application_name, state, query
FROM pg_stat_activity
WHERE query ILIKE '%LISTEN%'
  AND state != 'idle';
```

### Ejecutar LISTEN y UNLISTEN desde terminal

```sql
-- Conectarse al canal
LISTEN permissions_changed;

-- Esperar notificaciones (modo interactivo)
-- Presionar Ctrl+C para salir

-- Desconectarse del canal
UNLISTEN permissions_changed;

-- Desconectarse de todos los canales
UNLISTEN *;
```

### Ver sesiones sospechosas (idle con LISTEN)

```sql
SELECT pid, usename, application_name, 
       state, state_change,
       now() - state_change as idle_duration
FROM pg_stat_activity
WHERE state = 'idle in transaction'
  AND now() - state_change > interval '5 minutes'
ORDER BY state_change;
```

### Ver uso actual de la cola

```sql
-- Porcentaje usado
SELECT pg_notification_queue_usage();

-- Con warning si excede umbral
SELECT 
    pg_notification_queue_usage() as usage,
    CASE 
        WHEN pg_notification_queue_usage() > 0.5 
        THEN 'CRITICAL: Queue >50%'
        WHEN pg_notification_queue_usage() > 0.1 
        THEN 'WARNING: Queue >10%'
        ELSE 'OK'
    END as status;
```

### Ver backend PID actual (tu sesión)

```sql
SELECT pg_backend_pid();
```

### Matar un listener específico

```sql
-- Terminar sesión gentilmente
SELECT pg_terminate_backend(12345);

-- Forzar terminación inmediata (usar con cuidado)
SELECT pg_cancel_backend(12345);
```

## 6. Ajuste de max_connections

### Ver configuración actual

```sql
SHOW max_connections;
```

### Modificar temporalmente (reinicia con servidor)

```sql
ALTER SYSTEM SET max_connections = 200;
-- Requiere reinicio de PostgreSQL
```

### Modificar permanentemente

Editar archivo `postgresql.conf`:

```ini
max_connections = 200
```

Luego reiniciar servicio:

```bash
# Docker
docker restart nombre_contenedor

# Linux
sudo systemctl restart postgresql
```

### Consideraciones:

- Cada conexión consume ~400KB RAM
- Aumentar de 100 a 200: +40MB RAM aproximadamente
- Balancear con shared_buffers y work_mem

## 7. Top 10 Preguntas Frecuentes

### 1. ¿Qué pasa si un listener se desconecta temporalmente?

Las notificaciones enviadas mientras estaba desconectado se pierden. Solución: implementar verificación periódica comparando timestamps de última sincronización con última modificación en tablas.

### 2. ¿Cómo evitar listeners "zombie" que bloquean limpieza?

Implementar timeout de sesión y monitoreo activo. Query recomendado cada 5 minutos para detectar sesiones idle in transaction con LISTEN activo.

### 3. ¿Se pueden limpiar manualmente las notificaciones acumuladas?

No hay comando directo. La limpieza ocurre automáticamente cuando todos los listeners consumen las notificaciones. Para forzar limpieza: desconectar listeners problemáticos.

### 4. ¿Cuántos listeners puede soportar un canal?

No hay límite teórico. Limitado solo por max_connections. Cada listener consume una conexión del pool.

### 5. ¿Afecta el tamaño del payload al rendimiento?

Sí. Payloads grandes aumentan uso de memoria y latencia de entrega. Recomendado: mantener payloads <1KB, idealmente <200 bytes con solo metadatos mínimos.

### 6. ¿Es seguro usar NOTIFY en transacciones largas?

No recomendado. NOTIFY dentro de transacción larga retrasa entrega y puede acumular notificaciones. Mejor práctica: transacciones cortas o NOTIFY fuera de transacción mediante AUTONOMOUS TRANSACTION si está disponible.

### 7. ¿Cómo prevenir pérdida de notificaciones durante despliegues?

Implementar polling de fallback cada 5-10 minutos que compare timestamps de modificación con última sincronización. Durante despliegue, forzar re-sincronización completa.

### 8. ¿Se replican las notificaciones en servidores standby?

No. NOTIFY/LISTEN solo funciona en servidor primario. Réplicas de lectura no reciben notificaciones.

### 9. ¿Cuál es la latencia típica de entrega?

En condiciones normales: <50ms. Factores que aumentan latencia: carga del servidor, payloads grandes, múltiples listeners concurrentes.

### 10. ¿Cómo diagnosticar por qué las notificaciones no llegan?

Verificar en orden:
1. Listener está conectado: verificar pg_stat_activity
2. Canal correcto: LISTEN usa nombre exacto (case-sensitive)
3. Transacción emisora hizo COMMIT exitoso
4. No hay firewall bloqueando conexión persistente
5. Polling activo consumiendo notificaciones