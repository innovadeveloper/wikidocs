# Diccionario de Datos - Sistema de Transporte Urbano

**Versión:** 2.1 Optimizada  
**Fecha:** Noviembre 2025  
**Base de Datos:** PostgreSQL 14+

---

## MÓDULO DE USUARIOS Y AUTENTICACIÓN

### user_profiles
**Propósito:** Almacena perfiles locales vinculados a usuarios LDAP/WSO2IS para datos operativos específicos del sistema de transporte.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único del perfil |
| ldap_uid | VARCHAR(50) | UNIQUE, NOT NULL | UID del usuario en LDAP/WSO2IS |
| dni | VARCHAR(8) | UNIQUE | Documento Nacional de Identidad |
| is_active | BOOLEAN | DEFAULT true | Estado activo del perfil |
| preferences | JSONB | | Preferencias personalizadas (UI, notificaciones) |
| last_login | TIMESTAMP | | Último acceso registrado |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |

**Notas:**
- Los roles se gestionan en LDAP/WSO2IS vía OAuth/OIDC (no en esta tabla)
- El campo `user_type` fue eliminado por redundancia con roles LDAP
- `ldap_uid` es el puente entre sistema de autenticación y BD operativa

**Datos de ejemplo:**
```sql
INSERT INTO user_profiles (ldap_uid, dni, preferences) VALUES
('jperez', '12345678', '{"theme": "dark", "notifications_enabled": true}'),
('mlopez', '87654321', '{"theme": "light", "default_route": 1}'),
('cgarcia', '45678901', '{"alerts_sound": true, "dashboard_refresh": 10}');
```

---

### drivers
**Propósito:** Gestiona información específica de conductores, incluyendo licencias, asignaciones de vehículos y estado operativo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único del conductor |
| user_profile_id | INTEGER | UNIQUE, NOT NULL, FK | Referencia al perfil LDAP |
| driver_license | VARCHAR(20) | UNIQUE, NOT NULL | Número de licencia de conducir |
| license_type | VARCHAR(10) | NOT NULL, CHECK | Tipo: A-IIa, A-IIb |
| license_expiry | DATE | NOT NULL | Fecha de vencimiento |
| status | VARCHAR(20) | DEFAULT 'ACTIVE', CHECK | ACTIVE, SUSPENDED, TERMINATED |
| current_vehicle_id | INTEGER | FK | Vehículo actualmente asignado |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |

**Notas:**
- Extiende `user_profiles` con datos específicos del rol CONDUCTOR
- `license_type` A-IIa: transporte público, A-IIb: carga
- `current_vehicle_id` permite tracking de asignaciones actuales

**Datos de ejemplo:**
```sql
INSERT INTO drivers (user_profile_id, driver_license, license_type, license_expiry, current_vehicle_id) VALUES
(1, 'Q12345678', 'A-IIa', '2027-12-31', 25),
(3, 'Q87654321', 'A-IIa', '2026-06-15', 42),
(5, 'Q45678901', 'A-IIa', '2028-03-20', NULL);
```

---

## MÓDULO DE RUTAS Y VEHÍCULOS

### routes
**Propósito:** Define las rutas principales del sistema de transporte.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| name | VARCHAR(100) | NOT NULL | Nombre descriptivo |
| code | VARCHAR(20) | UNIQUE, NOT NULL | Código alfanumérico único |
| color | VARCHAR(7) | DEFAULT '#0066CC' | Color hex para visualización |
| is_active | BOOLEAN | DEFAULT true | Estado activo |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Notas:**
- Tabla maestra que agrupa las polylines (segmentos direccionales)
- `code` es el identificador operativo visible para usuarios
- `color` se usa en mapas y dashboards

**Datos de ejemplo:**
```sql
INSERT INTO routes (name, code, color) VALUES
('Ruta Norte-Sur', '2411', '#0066CC'),
('Ruta Este-Oeste', '5522', '#CC6600'),
('Ruta Circular Centro', 'C1', '#00CC66');
```

---

## route_polylines

**Propósito:** Almacena geometrías de rutas para visualización en mapas (trazado de líneas).

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| route_id | INTEGER | NOT NULL, FK | Ruta a la que pertenece |
| name | VARCHAR(100) | NOT NULL | Nombre del segmento |
| direction | VARCHAR(20) | NOT NULL, CHECK | IDA, VUELTA, BIDIRECCIONAL |
| coordinates_json | JSONB | NOT NULL | Coordenadas en formato GeoJSON LineString |
| encoded_polyline | TEXT | | Polilínea codificada (Google format) |
| color | VARCHAR(7) | | Color específico del segmento |
| stroke_width | INTEGER | DEFAULT 4 | Ancho de línea para visualización |
| stroke_opacity | DECIMAL(3,2) | DEFAULT 0.8 | Opacidad (0.0-1.0) |
| total_distance_km | DECIMAL(6,2) | | Distancia total calculada |
| estimated_time_minutes | INTEGER | | Tiempo estimado de recorrido |
| is_active | BOOLEAN | DEFAULT true | Estado activo |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |
| created_by_profile_id | INTEGER | FK | Usuario creador |

**Notas:**
- Solo para visualización en mapas, no para cálculos de proximidad GPS
- `coordinates_json` formato: `{"type":"LineString","coordinates":[[lon,lat],...]}`
- Detección de desvíos y paraderos se hace con tabla `geofences`

**Datos de ejemplo:**
```sql
INSERT INTO route_polylines (route_id, name, direction, coordinates_json, total_distance_km) VALUES
(1, 'Av. Arequipa Norte-Sur', 'IDA', 
 '{"type":"LineString","coordinates":[[-77.0428,-12.0463],[-77.0430,-12.0475],[-77.0431,-12.0489]]}', 
 12.5);
```

---

### vehicles
**Propósito:** Registro maestro de todos los vehículos de la flota.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| plate_number | VARCHAR(10) | UNIQUE, NOT NULL | Número de placa oficial |
| internal_code | VARCHAR(20) | UNIQUE, NOT NULL | Código interno de la empresa |
| route_id | INTEGER | FK | Ruta actualmente asignada |
| status | VARCHAR(20) | DEFAULT 'ACTIVE', CHECK | ACTIVE, INACTIVE, MAINTENANCE |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |

**Notas:**
- Inventario central de la flota (100 unidades)
- `internal_code` es identificador operativo interno
- `route_id` permite cambios dinámicos de asignación

**Datos de ejemplo:**
```sql
INSERT INTO vehicles (plate_number, internal_code, route_id, status) VALUES
('ABC-123', 'BUS-001', 1, 'ACTIVE'),
('DEF-456', 'BUS-002', 1, 'ACTIVE'),
('GHI-789', 'BUS-003', 2, 'MAINTENANCE');
```

---

## trackers

**Propósito:** Gestiona dispositivos GPS y tablets Android instalados en vehículos.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| device_id | VARCHAR(50) | UNIQUE, NOT NULL | ID único del dispositivo |
| device_type | VARCHAR(20) | NOT NULL, CHECK | TRACKER_GPS, ANDROID_ID, SERIAL_NUMBER, IMEI, MAC_ADDRESS |
| vehicle_id | INTEGER | FK | Vehículo al que está instalado |
| posting_interval | INTEGER | DEFAULT 30 | Intervalo de transmisión en segundos |
| status | VARCHAR(20) | DEFAULT 'ACTIVE', CHECK | ACTIVE, INACTIVE, ERROR |
| last_seen | TIMESTAMP | | Última transmisión recibida |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de instalación |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |

**Notas:**
- `device_id` formato según tipo: `TRK-001-ABC123`, `AND-9774d56d682e549c`, `867123456789012`
- `device_type` indica método de identificación del dispositivo
- Soporta trackers GPS dedicados y tablets/celulares Android

**Datos de ejemplo:**
```sql
INSERT INTO trackers (device_id, device_type, vehicle_id, posting_interval) VALUES
('TRK-001-ABC123', 'TRACKER_GPS', 1, 10),
('AND-9774d56d682e549c', 'ANDROID_ID', 2, 30),
('867123456789012', 'IMEI', 3, 10);
```

---

## MÓDULO DE GEOCERCAS Y GEOFENCING

### geofence_types
**Propósito:** Catálogo de tipos de geocercas con configuraciones por defecto.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| name | VARCHAR(50) | UNIQUE, NOT NULL | Nombre interno |
| display_name | VARCHAR(100) | NOT NULL | Nombre para mostrar al usuario |
| default_alert_priority | VARCHAR(10) | DEFAULT 'MEDIUM', CHECK | LOW, MEDIUM, HIGH, CRITICAL |
| color | VARCHAR(7) | DEFAULT '#FF0000' | Color hex para visualización |
| is_active | BOOLEAN | DEFAULT true | Estado activo |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Notas:**
- Catálogo estático de tipos de zonas geográficas
- Define comportamiento por defecto para cada tipo

**Datos de ejemplo:**
```sql
INSERT INTO geofence_types (name, display_name, default_alert_priority, color) VALUES
('BUS_STOP', 'Paradero de Bus', 'MEDIUM', '#0066CC'),
('TERMINAL', 'Terminal', 'HIGH', '#FF6600'),
('SPEED_ZONE', 'Zona de Velocidad', 'HIGH', '#FF0000'),
('SECURITY_ZONE', 'Zona de Seguridad', 'CRITICAL', '#CC0000'),
('ROUTE_CORRIDOR', 'Corredor de Ruta', 'HIGH', '#00CC66');
```

---

### geofences
**Propósito:** Define todas las geocercas del sistema (paraderos, terminales, zonas de velocidad) con geometría y configuración de alertas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| name | VARCHAR(100) | NOT NULL | Nombre geográfico de la zona |
| geofence_type_id | INTEGER | NOT NULL, FK | Tipo de geocerca |
| route_polyline_id | INTEGER | FK | Polyline específica (dirección) |
| geometry_type | VARCHAR(20) | NOT NULL, CHECK | CIRCLE, POLYGON |
| center_latitude | DECIMAL(10,8) | | Latitud del centro (círculos) |
| center_longitude | DECIMAL(11,8) | | Longitud del centro (círculos) |
| radius_meters | INTEGER | | Radio en metros (círculos) |
| coordinates_json | JSONB | | Coordenadas (polígonos) |
| alert_on_entry | BOOLEAN | DEFAULT false | Generar alerta al entrar |
| alert_on_exit | BOOLEAN | DEFAULT true | Generar alerta al salir |
| alert_on_dwell | BOOLEAN | DEFAULT false | Generar alerta por permanencia |
| max_dwell_seconds | INTEGER | DEFAULT 300 | Tiempo máximo de permanencia |
| alert_priority | VARCHAR(10) | DEFAULT 'MEDIUM', CHECK | Prioridad de alertas |
| max_speed_kmh | INTEGER | | Velocidad máxima en la zona |
| min_speed_kmh | INTEGER | | Velocidad mínima en la zona |
| speed_alert_enabled | BOOLEAN | DEFAULT true | Habilitar alertas de velocidad |
| speed_tolerance_kmh | INTEGER | DEFAULT 5 | Tolerancia de velocidad |
| config_hash | VARCHAR(64) | | Hash MD5 de configuración |
| redis_sync_key | VARCHAR(100) | | Clave Redis para sincronización |
| redis_synced_at | TIMESTAMP | | Última sincronización Redis |
| jts_cached_at | TIMESTAMP | | Última validación JTS |
| is_active | BOOLEAN | DEFAULT true | Estado activo |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |
| created_by_profile_id | INTEGER | FK | Usuario creador |

**Notas:**
- **MODIFICACIÓN CLAVE:** Usa `route_polyline_id` (no `route_id`) para asociar a dirección específica
- `name` describe ubicación geográfica (ej: "Av. Arequipa c/ Javier Prado")
- Tabla base para paraderos, zonas de velocidad y zonas de seguridad
- Redis almacena: `GEOADD geofences:all {lon} {lat} "gf_{id}"`
- JTS valida polígonos complejos cuando `geometry_type = 'POLYGON'`
 
**Estrategia:**
- **CIRCLE** → Redis GEORADIUS (rápido, 0.5-1ms)
- **POLYGON** → JTS PreparedGeometry (preciso, 2-10μs)

**Campos NULL según geometría:**

**CIRCLE:**
- `center_latitude`, `center_longitude`, `radius_meters` → **NOT NULL**
- `coordinates_json` → **NULL**

**POLYGON:**
- `center_latitude`, `center_longitude`, `radius_meters` → **NULL**
- `coordinates_json` → **NOT NULL**

**Constraint recomendado:**
```sql
ALTER TABLE geofences ADD CONSTRAINT check_geometry_fields CHECK (
    (geometry_type = 'CIRCLE' AND center_latitude IS NOT NULL 
     AND center_longitude IS NOT NULL AND radius_meters IS NOT NULL)
    OR
    (geometry_type = 'POLYGON' AND coordinates_json IS NOT NULL)
);
```


**Datos de ejemplo:**
```sql
INSERT INTO geofences (name, geofence_type_id, route_polyline_id, geometry_type, center_latitude, center_longitude, radius_meters, coordinates_json) VALUES
-- Paraderos (CIRCLE)
('Paradero Javier Prado Norte', 1, 1, 'CIRCLE', -12.0463, -77.0428, 50, NULL),
('Paradero República', 1, 1, 'CIRCLE', -12.0475, -77.0430, 50, NULL),
('Paradero 28 de Julio', 1, 1, 'CIRCLE', -12.0489, -77.0431, 50, NULL),
('Paradero Angamos Este', 1, 2, 'CIRCLE', -12.0502, -77.0433, 50, NULL),

-- Terminales (CIRCLE)
('Terminal Naranjal', 2, 1, 'CIRCLE', -12.0500, -77.0430, 100, NULL),
('Terminal Plaza Norte', 2, 2, 'CIRCLE', -11.9950, -77.0600, 120, NULL),

-- Zonas de velocidad (CIRCLE)
('Zona Escolar San Isidro', 3, NULL, 'CIRCLE', -12.0480, -77.0350, 200, NULL),
('Zona Hospital Rebagliati', 3, NULL, 'CIRCLE', -12.0890, -77.0020, 250, NULL),

-- Zona de seguridad (CIRCLE)
('Zona Alto Riesgo - La Victoria', 4, NULL, 'CIRCLE', -12.0650, -77.0180, 300, NULL),

-- Corredor de ruta (POLYGON con JTS)
('Corredor Av. Arequipa IDA', 5, 1, 'POLYGON', NULL, NULL, NULL, 
 '{"type":"Polygon","coordinates":[[[-77.0418,-12.0453],[-77.0438,-12.0453],[-77.0441,-12.0499],[-77.0421,-12.0499],[-77.0418,-12.0453]]]}');
```

---


## bus_stops

**Propósito:** Registra paraderos específicos con configuración operativa, vinculados a geocercas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| name | VARCHAR(100) | NOT NULL | Nombre operativo del paradero |
| code | VARCHAR(20) | UNIQUE | Código alfanumérico del paradero |
| route_polyline_id | INTEGER | NOT NULL, FK | Polyline específica (dirección) |
| stop_order | INTEGER | NOT NULL | Orden en la secuencia de ruta |
| geofence_id | INTEGER | NOT NULL, FK | Geocerca asociada para detección |
| is_checkpoint | BOOLEAN | DEFAULT false | Paradero es checkpoint de progreso (rutas circulares) |
| min_stop_seconds | INTEGER | DEFAULT 30 | Tiempo mínimo de parada |
| max_stop_seconds | INTEGER | DEFAULT 300 | Tiempo máximo de parada |
| is_active | BOOLEAN | DEFAULT true | Estado activo |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Notas:**
- **MODIFICACIONES:**
  - `latitude`, `longitude` eliminados (se obtienen de geofences)
  - `is_terminal` eliminado (se identifica por geofence_type_id)
  - `route_id` reemplazado por `route_polyline_id`
- `name` es nombre operativo (puede diferir de geofences.name)
- `stop_order` define secuencia de paradas en la ruta
- `is_checkpoint`: evita falsos positivos en rutas circulares
- Para rutas circulares: marcar 3 paraderos **consecutivos** como checkpoint (principal ±1)
- Coordenadas se obtienen mediante JOIN con geofences
- Sobre el atributo 'is_checkpoint', se considera lo siguientes : 
    - Rutas convencionales: ambos NULL/false
    - Rutas circulares: true/false

**Datos de ejemplo:**
```sql
INSERT INTO bus_stops (name, code, route_polyline_id, stop_order, geofence_id, is_checkpoint) VALUES
('Paradero Javier Prado Norte', 'P-001', 1, 1, 1, false),
('Paradero República', 'P-002', 1, 2, 2, true),
('Paradero 28 de Julio', 'P-003', 1, 3, 3, true),
('Paradero Angamos', 'P-004', 1, 4, 4, true),
('Terminal Naranjal', 'T-001', 1, 15, 5, false);
```

---
## dispatches

**Propósito:** Registra salidas programadas de buses por ruta y horario.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| dispatch_code | VARCHAR(50) | UNIQUE, NOT NULL | Código único del despacho |
| route_id | INTEGER | NOT NULL, FK | Ruta asignada |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo asignado |
| driver_profile_id | INTEGER | NOT NULL, FK | Conductor asignado |
| scheduled_departure | TIMESTAMP | NOT NULL | Hora de salida programada |
| actual_departure | TIMESTAMP | | Hora de salida real |
| scheduled_arrival | TIMESTAMP | | Hora de llegada programada (terminal final) |
| actual_arrival | TIMESTAMP | | Hora de llegada real |
| current_stop_sequence | INTEGER | DEFAULT 0 | Última parada detectada |
| last_checkpoint_passed | INTEGER | | Último checkpoint pasado (stop_order) |
| status | VARCHAR(20) | DEFAULT 'SCHEDULED', CHECK | SCHEDULED, DEPARTED, COMPLETED, CANCELLED |
| delay_minutes | INTEGER | | Retraso en minutos |
| cancellation_reason | TEXT | | Razón de cancelación |
| notes | TEXT | | Notas adicionales |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |
| created_by_profile_id | INTEGER | FK | Usuario que programó |

**Notas:**
- `dispatch_code` formato: `DESP-YYYY-ROUTE-HHMM` (ej: DESP-2025-2411-0830)
- `current_stop_sequence`: previene falsos positivos en rutas circulares
- `last_checkpoint_passed`: para validación de progreso
    - Sin last_checkpoint_passed no sabes si ya pasó un checkpoint en este despacho.
        ```md
        Ruta con 10 paraderos [P1, P2, ...., P10]
        Despacho sale 5pm
        5:05pm → Detecta P10 (final de ruta)
        ```
    - Con last_checkpoint_passed:
        ```java
        if (dispatch.last_checkpoint_passed == null) {
            // Rechazar P10: aún no pasó ningún checkpoint
        }
        ```
    - En rutas lineales: No necesario (stop_order siempre crece secuencialmente)
    - En rutas circulares : Esencial (evita falsos positivos por paraderos que se repiten en el circuito)



**Datos de ejemplo:**
```sql
INSERT INTO dispatches (dispatch_code, route_id, vehicle_id, driver_profile_id, scheduled_departure) VALUES
('DESP-2025-2411-0830', 1, 25, 1, '2025-11-17 08:30:00');
```

---


## dispatch_stops

**Propósito:** Registra paradas programadas y ejecutadas por cada despacho.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| dispatch_id | INTEGER | NOT NULL, FK | Despacho al que pertenece |
| bus_stop_id | INTEGER | NOT NULL, FK | Paradero programado |
| scheduled_arrival | TIMESTAMP | NOT NULL | Hora programada de llegada |
| actual_arrival | TIMESTAMP | | Hora real de llegada |
| actual_departure | TIMESTAMP | | Hora real de salida |
| dwell_seconds | INTEGER | | Tiempo de permanencia |
| delay_seconds | INTEGER | | Retraso en segundos |
| compliance_status | VARCHAR(20) | CHECK | ON_TIME, LATE, EARLY, SKIPPED |
| was_skipped | BOOLEAN | DEFAULT false | Si fue saltado |
| notes | TEXT | | Notas |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Constraint:**
```sql
CONSTRAINT unique_dispatch_stop UNIQUE (dispatch_id, bus_stop_id)
```


**Notas:**
- Orden de paradas viene de `bus_stops.stop_order` via JOIN
- Se crea al programar despacho con todas las paradas esperadas
- `actual_arrival` se actualiza desde `bus_stop_events`
- El atributo `was_skipped` será true cuando:
    - Bus NO detecta entrada al geofence del paradero
    - Pasa directo sin detenerse
    - Sistema no recibe bus_stop_events de ese paradero
- El atributo `was_skipped` se marca automáticamente si:
    - Llega al siguiente paradero sin haber marcado el anterior
    - Termina despacho con actual_arrival = NULL

**Datos de ejemplo:**
```sql
INSERT INTO dispatch_stops (dispatch_id, bus_stop_id, scheduled_arrival, actual_arrival, delay_seconds, compliance_status) VALUES
(1, 1, '2025-11-17 08:35:00', '2025-11-17 08:35:15', 15, 'LATE'),
(1, 2, '2025-11-17 08:42:00', '2025-11-17 08:41:50', -10, 'EARLY'),
(1, 3, '2025-11-17 08:50:00', NULL, NULL, 'SKIPPED');
```

---

## MÓDULO DE CONFIGURACIÓN DE VELOCIDAD

### global_speed_config
**Propósito:** Configuración global de velocidades con múltiples perfiles y tolerancias.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| config_name | VARCHAR(50) | UNIQUE, NOT NULL | Nombre de la configuración |
| max_speed_kmh | INTEGER | NOT NULL | Velocidad máxima global |
| warning_speed_kmh | INTEGER | NOT NULL | Velocidad de advertencia |
| critical_speed_kmh | INTEGER | | Velocidad crítica |
| gps_accuracy_tolerance_kmh | INTEGER | DEFAULT 3 | Tolerancia por precisión GPS |
| processing_tolerance_kmh | INTEGER | DEFAULT 2 | Tolerancia de procesamiento |
| consecutive_violations_threshold | INTEGER | DEFAULT 3 | Umbral de violaciones consecutivas |
| violation_duration_threshold_seconds | INTEGER | DEFAULT 15 | Duración mínima de violación |
| applies_to_routes | JSONB | | Array de route_ids aplicables |
| priority_order | INTEGER | DEFAULT 1 | Orden de prioridad |
| is_active | BOOLEAN | DEFAULT true | Estado activo |
| effective_from | TIMESTAMP | | Fecha de inicio de vigencia |
| effective_until | TIMESTAMP | | Fecha de fin de vigencia |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |
| created_by_profile_id | INTEGER | FK | Usuario creador |

**Notas:**
- Fallback cuando no hay geofence con velocidad específica
- Permite configuraciones diferentes por tipo de vía
- `applies_to_routes`: `[2411, 2412, ...]` en formato JSON
- Prioridad: Geofence específica > Global config > Default sistema

**Datos de ejemplo:**
```sql
INSERT INTO global_speed_config (
    config_name, 
    max_speed_kmh, 
    warning_speed_kmh, 
    critical_speed_kmh,
    applies_to_routes,
    priority_order
) VALUES
('DEFAULT_URBAN', 60, 55, 70, NULL, 1),
('DEFAULT_HIGHWAY', 90, 85, 100, '[2, 5, 8]', 2),
('EMERGENCY_MODE', 40, 35, 50, NULL, 3),
('SCHOOL_ZONE_HOURS', 30, 25, 40, NULL, 4),
('NIGHT_MODE', 50, 45, 60, NULL, 5);

-- Con vigencia temporal
INSERT INTO global_speed_config (
    config_name,
    max_speed_kmh,
    warning_speed_kmh,
    effective_from,
    effective_until,
    priority_order
) VALUES
('HOLIDAY_RESTRICTION', 45, 40, '2025-12-24 00:00:00', '2025-12-26 23:59:59', 6);
```

---

## MÓDULO DE EVENTOS PROCESADOS


## geofence_events

**Propósito:** Log técnico completo de todos los eventos de geocercas (paraderos, zonas de velocidad, seguridad, corredores).

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| geofence_id | INTEGER | NOT NULL, FK | Geocerca involucrada |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo que generó el evento |
| tracker_id | INTEGER | NOT NULL, FK | Tracker que reportó |
| driver_profile_id | INTEGER | FK | Conductor asignado |
| event_type | VARCHAR(20) | NOT NULL, CHECK | ENTRY, EXIT, DWELL_VIOLATION |
| latitude | DECIMAL(10,8) | NOT NULL | Coordenada del evento |
| longitude | DECIMAL(11,8) | NOT NULL | Coordenada del evento |
| speed | DECIMAL(5,2) | | Velocidad al momento del evento |
| heading | INTEGER | | Dirección del vehículo (0-359°) |
| event_timestamp | TIMESTAMP | NOT NULL | Momento exacto del evento |
| entry_timestamp | TIMESTAMP | | Momento de entrada (para EXIT) |
| dwell_seconds | INTEGER | | Tiempo de permanencia |
| processing_method | VARCHAR(20) | CHECK | REDIS_ONLY, REDIS_JTS, JTS_VALIDATION |
| processing_latency_ms | INTEGER | | Latencia de procesamiento |
| redis_distance_meters | DECIMAL(8,2) | | Distancia calculada por Redis |
| jts_validation_result | BOOLEAN | | Resultado de validación JTS |
| alert_generated | BOOLEAN | DEFAULT false | Se generó alerta |
| alert_priority | VARCHAR(10) | CHECK | Prioridad de la alerta |
| acknowledged | BOOLEAN | DEFAULT false | Alerta reconocida |
| acknowledged_by_profile_id | INTEGER | FK | Usuario que reconoció |
| acknowledged_at | TIMESTAMP | | Momento de reconocimiento |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Notas:**
- Registra TODOS los tipos de geofences (no solo paraderos)
- Si evento es de paradero con despacho activo → actualiza `dispatch_stops`
- `entry_timestamp` solo se llena en eventos EXIT (copia del ENTRY previo)
- `dwell_seconds` = `event_timestamp - entry_timestamp` (calculado en EXIT)
- `processing_method` indica qué sistema detectó el evento
- Requiere cache Redis: `vehicle:{id}:current_geofences` (Set de geofence_ids)

**Datos de ejemplo:**
```sql
INSERT INTO geofence_events (geofence_id, vehicle_id, tracker_id, event_type, latitude, longitude, event_timestamp, processing_method) VALUES
(1, 1, 1, 'ENTRY', -12.0463, -77.0428, '2025-11-17 08:35:15', 'REDIS_ONLY'),
(1, 1, 1, 'EXIT', -12.0464, -77.0429, '2025-11-17 08:36:45', 'REDIS_ONLY'),
(7, 1, 1, 'ENTRY', -12.0480, -77.0350, '2025-11-17 08:40:00', 'REDIS_ONLY'); -- Zona escolar
```

---

### speed_violations
**Propósito:** Registra violaciones de velocidad con severidad y duración.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo infractor |
| tracker_id | INTEGER | NOT NULL, FK | Tracker que detectó |
| driver_profile_id | INTEGER | FK | Conductor responsable |
| geofence_id | INTEGER | FK | Zona donde ocurrió (opcional) |
| violation_type | VARCHAR(20) | NOT NULL, CHECK | SPEED_LIMIT, RECKLESS_DRIVING |
| recorded_speed | DECIMAL(5,2) | NOT NULL | Velocidad registrada |
| speed_limit | DECIMAL(5,2) | NOT NULL | Límite aplicable |
| excess_speed | DECIMAL(5,2) | NOT NULL | Exceso de velocidad |
| latitude | DECIMAL(10,8) | NOT NULL | Ubicación de la violación |
| longitude | DECIMAL(11,8) | NOT NULL | Ubicación de la violación |
| start_timestamp | TIMESTAMP | NOT NULL | Inicio de la violación |
| end_timestamp | TIMESTAMP | | Fin de la violación |
| duration_seconds | INTEGER | | Duración total |
| severity | VARCHAR(20) | CHECK | MINOR, MODERATE, SEVERE, CRITICAL |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Notas:**
- Registra inicio y fin de violación para calcular duración
- `excess_speed` = `recorded_speed - speed_limit`
- `severity` calculado según exceso y duración
- `geofence_id` opcional (puede ser en zona sin geocerca específica)

**Datos de ejemplo:**
```sql
INSERT INTO speed_violations (vehicle_id, tracker_id, recorded_speed, speed_limit, excess_speed, latitude, longitude, start_timestamp, severity) VALUES
(1, 1, 85.5, 60.0, 25.5, -12.0463, -77.0428, '2025-11-17 09:15:00', 'SEVERE');
```

---

### route_deviations
**Propósito:** Almacena desvíos de ruta con información de distancia, duración y autorización.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo que se desvió |
| route_id | INTEGER | NOT NULL, FK | Ruta autorizada |
| driver_profile_id | INTEGER | FK | Conductor responsable |
| deviation_type | VARCHAR(20) | NOT NULL, CHECK | MINOR_DEVIATION, MAJOR_DEVIATION, UNAUTHORIZED_ROUTE |
| start_latitude | DECIMAL(10,8) | NOT NULL | Punto inicial del desvío |
| start_longitude | DECIMAL(11,8) | NOT NULL | Punto inicial del desvío |
| end_latitude | DECIMAL(10,8) | | Punto final del desvío |
| end_longitude | DECIMAL(11,8) | | Punto final del desvío |
| start_timestamp | TIMESTAMP | NOT NULL | Inicio del desvío |
| end_timestamp | TIMESTAMP | | Fin del desvío (regreso a ruta) |
| duration_seconds | INTEGER | | Duración total |
| max_deviation_meters | DECIMAL(8,2) | | Máxima distancia de desvío |
| total_deviation_distance | DECIMAL(8,2) | | Distancia total desviada |
| is_authorized | BOOLEAN | DEFAULT false | Desvío autorizado retrospectivamente |
| authorized_by_profile_id | INTEGER | FK | Usuario que autorizó |
| authorization_reason | TEXT | | Razón de la autorización |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Notas:**
- Registra inicio (salida de corredor) y fin (regreso a corredor)
- `is_authorized`: permite justificar desvíos por contingencias (accidentes, bloqueos)
- Requiere cache Redis: `vehicle:{id}:deviation_status` (ID del desvío activo)
- `duration_seconds` = `end_timestamp - start_timestamp`
- Se pueden considerar las siguientes reglas de negocio : 
    - En caso que la unidad se haya ido a guardar (cochera), entonces para q el registro no se quede mucho tiempo con los valores en cache o memoria de start_timestamp sin end_timestamp, se puede colocar como end_timestamp un valor fijo de 1 hora para indicar q pudo haber sido eso o más (web). 

**Datos de ejemplo:**
```sql
INSERT INTO route_deviations (vehicle_id, route_id, deviation_type, start_latitude, start_longitude, start_timestamp, max_deviation_meters) VALUES
(1, 1, 'MINOR_DEVIATION', -12.0500, -77.0400, '2025-11-17 10:00:00', 150.5);
```

---

## MÓDULO DE HISTORIAL GPS

### location_history
**Propósito:** Almacena historial completo de posiciones GPS para análisis y auditoría.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| tracker_id | INTEGER | NOT NULL, FK | Tracker que envió la posición |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo rastreado |
| latitude | DECIMAL(10,8) | NOT NULL | Coordenada de latitud |
| longitude | DECIMAL(11,8) | NOT NULL | Coordenada de longitud |
| speed | DECIMAL(5,2) | DEFAULT 0 | Velocidad registrada |
| heading | INTEGER | | Dirección del vehículo (0-359°) |
| timestamp | TIMESTAMP | NOT NULL | Momento de la posición |
| received_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Momento de recepción en servidor |

**Notas:**
- Tabla de alto volumen (100 vehículos × 10 seg = 864,000 registros/día)
- **Recomendación:** Particionar por timestamp (mensual)
- Política de retención: 30 días por defecto (configurable en system_config)
- `timestamp` vs `received_at`: diferencia para detectar delays de transmisión

**Datos de ejemplo:**
```sql
INSERT INTO location_history (tracker_id, vehicle_id, latitude, longitude, speed, heading, timestamp) VALUES
(1, 1, -12.0463, -77.0428, 45.5, 180, '2025-11-17 08:30:00'),
(1, 1, -12.0465, -77.0429, 47.2, 182, '2025-11-17 08:30:10'),
(1, 1, -12.0467, -77.0430, 48.8, 185, '2025-11-17 08:30:20');
```

---

## MÓDULO DE ALERTAS Y EVENTOS

### system_alerts
**Propósito:** Gestiona todas las alertas operativas del sistema con estados de reconocimiento.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| alert_type | VARCHAR(50) | NOT NULL | Tipo (speed_violation, route_deviation, etc.) |
| source_table | VARCHAR(50) | | Tabla origen del evento |
| source_id | BIGINT | | ID del registro origen |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo involucrado |
| driver_profile_id | INTEGER | FK | Conductor involucrado |
| priority | VARCHAR(10) | NOT NULL, CHECK | LOW, MEDIUM, HIGH, CRITICAL |
| title | VARCHAR(200) | NOT NULL | Título descriptivo |
| description | TEXT | | Descripción detallada |
| status | VARCHAR(20) | DEFAULT 'ACTIVE', CHECK | ACTIVE, ACKNOWLEDGED, RESOLVED, DISMISSED |
| acknowledged_by_profile_id | INTEGER | FK | Usuario que reconoció |
| acknowledged_at | TIMESTAMP | | Momento de reconocimiento |
| resolved_at | TIMESTAMP | | Momento de resolución |
| metadata | JSONB | | Datos adicionales en JSON |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Notas:**
- Alertas operativas automáticas generadas por el sistema
- Prioridad variable según tipo de evento
- `source_table` + `source_id` referencian al evento origen
- `metadata` puede contener datos específicos del tipo de alerta

**Datos de ejemplo:**
```sql
INSERT INTO system_alerts (alert_type, source_table, source_id, vehicle_id, priority, title, description) VALUES
('SPEED_VIOLATION', 'speed_violations', 1, 1, 'HIGH', 'Exceso de velocidad detectado', 'Bus ABC-123 a 85 km/h en zona de 60 km/h');
```

---

### panic_alerts
**Propósito:** Maneja alertas de pánico activadas por conductores con seguimiento prioritario.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| tracker_id | INTEGER | NOT NULL, FK | Tracker que envió la alerta |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo involucrado |
| driver_profile_id | INTEGER | FK | Conductor que activó el pánico |
| latitude | DECIMAL(10,8) | NOT NULL | Ubicación de la emergencia |
| longitude | DECIMAL(11,8) | NOT NULL | Ubicación de la emergencia |
| status | VARCHAR(20) | DEFAULT 'ACTIVE', CHECK | ACTIVE, ACKNOWLEDGED, RESOLVED, FALSE_ALARM |
| priority | VARCHAR(10) | DEFAULT 'CRITICAL', CHECK | HIGH, CRITICAL |
| acknowledged_by_profile_id | INTEGER | FK | Usuario que atendió |
| acknowledged_at | TIMESTAMP | | Momento de reconocimiento |
| resolved_at | TIMESTAMP | | Momento de resolución |
| resolution_notes | TEXT | | Notas sobre la resolución |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Notas:**
- Emergencias del conductor (botón de pánico manual)
- Siempre prioridad CRITICAL o HIGH
- Requiere protocolo de respuesta diferenciado (seguridad vs operativo)
- Diferencia con system_alerts: origen manual vs automático

**Datos de ejemplo:**
```sql
INSERT INTO panic_alerts (tracker_id, vehicle_id, driver_profile_id, latitude, longitude, priority) VALUES
(1, 1, 1, -12.0463, -77.0428, 'CRITICAL');
```

---

## MÓDULO DE CONFIGURACIÓN DEL SISTEMA (POR REVISAR ********************************)

### redis_sync_log
**Propósito:** Registra operaciones de sincronización con Redis para monitoreo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| sync_type | VARCHAR(50) | NOT NULL | Tipo (geofences, routes, etc.) |
| table_name | VARCHAR(50) | NOT NULL | Tabla sincronizada |
| record_id | INTEGER | | ID del registro sincronizado |
| redis_key | VARCHAR(200) | | Clave Redis utilizada |
| old_hash | VARCHAR(64) | | Hash anterior |
| new_hash | VARCHAR(64) | | Hash nuevo |
| change_type | VARCHAR(20) | CHECK | CREATE, UPDATE, DELETE, NO_CHANGE |
| status | VARCHAR(20) | NOT NULL, CHECK | SUCCESS, FAILED, PARTIAL |
| error_message | TEXT | | Mensaje de error si falló |
| records_processed | INTEGER | DEFAULT 0 | Registros procesados |
| started_at | TIMESTAMP | NOT NULL | Inicio de la operación |
| completed_at | TIMESTAMP | | Fin de la operación |
| duration_ms | INTEGER | | Duración en milisegundos |

**Notas:**
- Auditoría de sincronización con Redis
- Permite detectar problemas de performance
- `change_type` indica si hubo cambios reales

**Datos de ejemplo:**
```sql
INSERT INTO redis_sync_log (sync_type, table_name, record_id, status, started_at, completed_at, duration_ms) VALUES
('GEOFENCES', 'geofences', 1, 'SUCCESS', '2025-11-17 08:00:00', '2025-11-17 08:00:01', 1250);
```

---

### system_config
**Propósito:** Almacena parámetros de configuración global del sistema.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| config_key | VARCHAR(100) | UNIQUE, NOT NULL | Clave de configuración |
| config_value | TEXT | NOT NULL | Valor de la configuración |
| description | TEXT | | Descripción del parámetro |
| data_type | VARCHAR(20) | DEFAULT 'STRING', CHECK | STRING, INTEGER, BOOLEAN, JSON |
| updated_by_profile_id | INTEGER | FK | Usuario que actualizó |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |

**Notas:**
- Configuración centralizada sin reiniciar aplicación
- `data_type` permite validación de valores
- Trazabilidad de cambios con `updated_by_profile_id`

**Datos de ejemplo:**
```sql
INSERT INTO system_config (config_key, config_value, data_type, description) VALUES
('REDIS_SYNC_INTERVAL_MINUTES', '5', 'INTEGER', 'Intervalo de sincronización con Redis'),
('JTS_CACHE_EXPIRY_HOURS', '24', 'INTEGER', 'Expiración del cache JTS'),
('MAX_LOCATION_HISTORY_DAYS', '30', 'INTEGER', 'Días de retención de historial GPS'),
('GEOFENCE_PROCESSING_ENABLED', 'true', 'BOOLEAN', 'Habilitar procesamiento de geocercas');
```

---

**PENDIENTES :**
- Lógica de datero (mostrar unidades de atrás y adelante)
- Tablas de mensajería instantánea (tts, calls/video-calls, cam monitor, notifications)
