# Modelo 1: Multithreading Blocking (Thread-per-request)

## Flujo lógico

```text
                ┌─────────────────────┐
Cliente 1 ─────▶│ Hilo 1 (bloqueado)  │
                └─────────────────────┘

                ┌─────────────────────┐
Cliente 2 ─────▶│ Hilo 2 (bloqueado)  │
                └─────────────────────┘

                ┌─────────────────────┐
Cliente 3 ─────▶│ Hilo 3 (bloqueado)  │
                └─────────────────────┘

                ...
```

---

## Relación con los núcleos del sistema

Supongamos:

* 8 núcleos CPU
* 100 clientes concurrentes

```text
CPU Cores:   [Core1][Core2][Core3][Core4][Core5][Core6][Core7][Core8]

Threads:     T1 T2 T3 T4 T5 T6 T7 T8 T9 T10 ... T100
```

El SO debe:

* Hacer context switching constante
* Mover hilos entre núcleos
* Guardar/restaurar estados de ejecución

---

## ⚠ Problemas

```text
1 conexión = 1 hilo
1000 conexiones = 1000 hilos
```

Consecuencias:

* Alto consumo de RAM (stack por hilo)
* Mucho context switching
* El scheduler del SO se satura
* Rendimiento degrada aunque la CPU no esté al 100%

---

# Modelo 2: Blocking + ExecutorService (Pool controlado)

Aquí cambia completamente la arquitectura.

---

## Flujo lógico

```text
Clientes entrantes
        │
        ▼
┌─────────────────────┐
│  Thread Principal   │ (accept)
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│   ExecutorService   │
│   (Pool de 8 hilos) │
└─────────────────────┘
   │    │    │    │
   ▼    ▼    ▼    ▼
 [T1] [T2] [T3] [T4] ... hasta T8
```

Si llegan 100 solicitudes:

```text
8 ejecutando
92 en cola
```

---

## Relación con núcleos

Supongamos:

* 8 núcleos CPU
* Pool de 8 hilos

```text
CPU Cores:   [Core1][Core2][Core3][Core4][Core5][Core6][Core7][Core8]
Threads:      T1     T2     T3     T4     T5     T6     T7     T8
```

Aquí:

✔ Cada núcleo ejecuta 1 hilo
✔ No hay sobrecarga excesiva
✔ Context switching mínimo
✔ Sistema estable

---

# Comparación Visual Directa

## Thread por Request

```text
Clientes: 100
Hilos:    100
Cores:    8

CPU:
[Core1] T1 T9 T17 T25 ...
[Core2] T2 T10 T18 ...
...
(Alta rotación de hilos)
```

Mucho cambio de contexto.

---

## Pool Controlado

```text
Clientes: 100
Hilos:    8 activos
Cola:     92
Cores:    8

CPU:
[Core1] T1
[Core2] T2
...
[Core8] T8
```

Los demás esperan turno.

---

# Diferencia clave conceptual

### Sin Pool

```
Conexión = Hilo
Hilo compite por CPU
```

### Con Pool

```
Conexión ≠ Hilo
Solicitud = Tarea
Pool decide cuándo ejecutarla
```

---

# ¿Qué pasa con la latencia?

| Modelo   | Latencia bajo carga                |
| -------- | ---------------------------------- |
| Sin pool | Baja al inicio, luego colapso      |
| Con pool | Aumenta gradualmente, pero estable |

---

# Cómo se relaciona con los núcleos

Un núcleo solo puede ejecutar:

```
1 hilo a la vez
```

Si tienes:

* 8 núcleos
* 200 hilos activos

El SO debe intercambiarlos constantemente.

Eso es:

```
Context Switching
```

Costo real:

* Guardar registros
* Cambiar stack
* Invalidar caché CPU
* Cargar otro hilo

Demasiados hilos → rendimiento cae aunque CPU no esté saturada.

---

# Arquitectura recomendada (backend típico)

```text
                ┌──────────────┐
Clientes ──────▶│  Accept Loop │
                └──────────────┘
                        │
                        ▼
                ┌─────────────────┐
                │  Executor Pool  │  ← tamaño ≈ núcleos * factor
                └─────────────────┘
                        │
                        ▼
                    Procesamiento
```

---

# Idea fundamental

La CPU no trabaja con conexiones.
Trabaja con hilos.

Si los hilos > núcleos por mucho:

→ El sistema pierde eficiencia.

El pool es una herramienta para:

> Alinear concurrencia con capacidad real de CPU.

---

# Conclusión arquitectónica

* Thread-per-request escala mal en alta concurrencia.
* ExecutorService controla el paralelismo.
* El tamaño ideal del pool depende de:

  * CPU-bound vs IO-bound
  * Número de núcleos
  * Latencia esperada

---


# TIPOS DE PROCESOS DE CPU

# CPU-Intensive / CPU-Bound

Significan prácticamente lo mismo.

## Definición

Un proceso es **CPU-bound** cuando:

> La mayor parte del tiempo está usando activamente la CPU para calcular cosas.

No está esperando red.
No está esperando disco.
No está esperando base de datos.

Está calculando.

---

## Ejemplos reales

* Cifrado / desencriptado
* Compresión de archivos
* Procesamiento de imágenes
* Machine learning
* Cálculos matemáticos grandes
* Generación de PDFs pesados
* Hashing masivo

---

## Regla importante

Si algo es CPU-bound:

```
Número ideal de hilos ≈ número de núcleos
```

Porque:

Un núcleo solo puede ejecutar 1 hilo al mismo tiempo.

Si tienes:

* 8 núcleos
* 200 hilos CPU-bound

No vas más rápido.
Solo generas context switching.

---

# IO-Bound

Lo contrario.

Un proceso es **IO-bound** cuando:

> La mayor parte del tiempo está esperando algo externo.

Puede ser:

* Base de datos
* Disco
* Red
* API externa
* Microservicio
* Kafka
* Redis

---

## Ejemplos reales

* Guardar en DB
* Llamar REST externo
* Leer archivo grande
* Esperar respuesta HTTP
* Leer desde socket

---
