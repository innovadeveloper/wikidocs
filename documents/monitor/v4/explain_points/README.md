# Dudas-001
explícame brevemente q función cumplirá frequency_control (no me des código extenso, a lo mucho unos registros básicos para entenderlo si fuera necesariamente requerido) . Y confírmame si estoy en lo correcto respecto a estas entidades : 

- Solo existe una tabla de alertas para manejar eventos de alertas causados por el sistema : exceso de velocidad, desvío de ruta, otros. (Analizar si esto cubre las alertas de caducidad de documentos). Considerar crear la tabla 'core_operations.panic_alert' y 'core_operations.panic_alert_type' para registrar las alertas generadas por el conductor desde su dispositivo : gps, etc.
- La tabla 'core_operations.dispatch_queue' puede lograr ser altamente riesgosa de caer en incidentes si no hay un buen análisis y consideración de q el reordenamiento está sujeto a cambios (manuales, prioritarios, automáticos). Se sugiere poder tener una tabla 'core_operations.dispatch_queue_log' con un trigger amarrados a las ediciones o aplicar un registro de logs en el mismo backend para la comprobación exitosa del reordenamiento.
- La tabla 'dispatch_exception' no requiere tener FK a un despacho debido a q esta actuará como indicador de hacer un bypass de N despachos durante el ciclo de vida del DispatchException.


## `frequency_control` - Función

Registra mediciones **reales** de frecuencias observadas en puntos críticos de la ruta. El despachador/sistema compara la frecuencia programada vs. real para detectar incumplimientos.

**Ejemplo:**
```sql
-- Ruta 301 debe despachar cada 10 min
-- Inspector mide en Av. Universitaria de 6:00 a 7:00 AM

route_id: 1
target_frequency_minutes: 10
avg_interval_minutes: 12.5  -- ⚠️ Incumplimiento
compliance_percentage: 80.0  -- (10/12.5 * 100)
vehicles_counted: 5
min_interval: 8, max_interval: 18
```

Se usa para:
- Auditorías de cumplimiento ATU
- Detectar "huecos" en el servicio
- Aplicar multas por baja frecuencia
- Optimizar programación


## Uso de `frequency_control`

Esta tabla registra **cada despacho individual** en terminal para medir intervalos reales vs. esperados.

### Flujo de registro

```sql
-- Despacho 1: Bus sale a las 6:00 AM
INSERT INTO frequency_control (
    route_id, terminal_id, 
    control_timestamp, current_dispatch_time,
    previous_dispatch_time, -- NULL (primer despacho)
    interval_seconds, -- 0
    expected_frequency_seconds, -- 600 (10 min)
    deviation_seconds, -- NULL
    is_compliant -- true
) VALUES (1, 1, '2026-01-27 06:00:00', '2026-01-27 06:00:00', 
         NULL, 0, 600, NULL, true);

-- Despacho 2: Bus sale a las 6:12 (retraso 2 min)
INSERT INTO frequency_control (
    route_id, terminal_id,
    control_timestamp, current_dispatch_time,
    previous_dispatch_time, -- 6:00
    interval_seconds, -- 720 (12 min real)
    expected_frequency_seconds, -- 600 (10 min esperado)
    deviation_seconds, -- +120 (2 min de retraso)
    is_compliant -- false
) VALUES (1, 1, '2026-01-27 06:12:00', '2026-01-27 06:12:00',
         '2026-01-27 06:00:00', 720, 600, 120, false);
```

### Se usa para:

1. **Alertas automáticas** - Si `deviation_seconds > tolerance` → alerta al supervisor
2. **Reportes ATU** - % cumplimiento de frecuencias por ruta/terminal
3. **Penalizaciones** - Multas por incumplimiento sostenido
4. **Optimización** - Identificar horas pico con intervalos irregulares

### Diferencia vs `frequency_check` (inspection)

- `frequency_control` → Registro **automático** en terminal (cada despacho)
- `frequency_check` → Medición **manual** del inspector en campo (spot checks)


---

**son redundantes control_timestamp y current_dispatch_time en la mayoría de casos**.

### Casos donde podrían diferir:

**1. Retraso en registro:**
- `current_dispatch_time`: 06:00:00 (hora real que salió el bus)
- `control_timestamp`: 06:02:30 (hora en que se registró en sistema)

**2. Registro manual posterior:**
- Despachador registra a las 08:00 AM despachos que ocurrieron a las 06:00 y 06:10

### Recomendación:

**Elimina `control_timestamp`** y quédate solo con `current_dispatch_time`. El `created_at` ya registra cuándo se insertó el record.

```sql
-- Versión simplificada
frequency_control_id
route_id
terminal_id
previous_dispatch_time
current_dispatch_time      -- ← Este es el timestamp real
interval_seconds
expected_frequency_seconds
deviation_seconds
is_compliant
created_at                 -- ← Ya registra cuándo se guardó
```

Si necesitas auditar retrasos de registro: `created_at - current_dispatch_time` te da la diferencia.



---
---

## Validación de tus Observaciones

### ✅ **CORRECTO - Tabla única de alertas**
```
core_operations.alert cubre TODO tipo de alertas:
- GPS (velocidad, desvío, geofence)
- Documentos vencidos (SOAT, licencia) ← via alert_type
- Técnicas (falla mecánica)
```

**NO necesitas tablas separadas.** Usa `alert_type` y `category`:
- `PANIC_BUTTON` (category: SAFETY, severity: CRITICAL)
- `DOC_SOAT_EXPIRED` (category: DOCUMENTS)
- `SPEED_LIMIT` (category: SAFETY)

### ✅ **CORRECTO - `dispatch_queue` necesita auditoría**
```
Opciones:
1. Tabla audit: core_operations.dispatch_queue_history
   - queue_id, old_priority, new_priority, reordered_by, reason
   
2. Usar audit.change_log (YA EXISTE en schema audit)
   - Captura automáticamente old_values/new_values JSONB
   - Trigger en dispatch_queue
```

**Recomendación:** Usa `audit.change_log` que ya tienes. Agrega trigger:
```sql
CREATE TRIGGER trg_dispatch_queue_audit 
AFTER UPDATE ON core_operations.dispatch_queue
FOR EACH ROW EXECUTE FUNCTION audit.log_change();
```

### ✅ **CORRECTO - `dispatch_exception` sin FK a dispatch**
```
dispatch_exception actúa como "whitelist temporal":
- restriction_type_id: DOC_SOAT_EXPIRED
- entity_id: vehicle_id = 5
- validity: 7 días

Durante esos 7 días, el sistema permite N despachos del vehículo 5
sin bloquear por SOAT vencido.
```

**Flujo:**
1. Vehículo tiene restricción activa
2. Se crea excepción temporal
3. Sistema valida: ¿existe excepción válida? → permite despacho
4. Excepción expira → restricción vuelve a bloquear

No necesita FK a `dispatch` porque es una **política temporal**, no un evento puntual.

---

# Dudas-002
