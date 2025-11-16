# Diccionario de Datos - Sistema de Transporte Urbano Simplificado

**Versión:** 2.0 Simplificada  
**Fecha:** Junio 2025  
**Base de Datos:** PostgreSQL 14+  
**Arquitectura:** Redis (Geoespacial) + JTS (Validación) + PostgreSQL (Registro)

---

## 📋 Resumen Ejecutivo

Este diccionario documenta la estructura simplificada del Sistema Integral de Gestión de Transporte Urbano, optimizado para gestionar 100 unidades distribuidas en 3 rutas principales. La versión simplificada elimina la complejidad innecesaria en la configuración de velocidades, manteniendo solo las funcionalidades esenciales.

### Estadísticas del Sistema
- **Total de Tablas:** 18 tablas principales
- **Módulos Funcionales:** 8 módulos principales
- **Vistas de Reporte:** 6 vistas optimizadas
- **Funciones Auxiliares:** 5 funciones de utilidad
- **Configuración de Velocidad:** Simplificada (2 fuentes vs 4 originales)

---

## 🔐 MÓDULO DE USUARIOS Y AUTENTICACIÓN

### user_profiles
**Propósito:** Almacena perfiles locales vinculados a usuarios LDAP para datos operativos específicos del sistema de transporte. Actúa como puente entre el sistema de autenticación corporativo y las funcionalidades específicas del transporte.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único del perfil |
| ldap_uid | VARCHAR(50) | UNIQUE, NOT NULL | UID del usuario en Active Directory/LDAP |
| dni | VARCHAR(8) | UNIQUE | Documento Nacional de Identidad del usuario |
| user_type | VARCHAR(20) | NOT NULL, CHECK | Tipo de usuario: CONDUCTOR, ADMINISTRADOR, MONITOREADOR |
| is_active | BOOLEAN | DEFAULT true | Estado activo del perfil en el sistema |
| last_login | TIMESTAMP | | Último acceso registrado al sistema |
| preferences | JSONB | | Preferencias personalizadas del usuario (configuración UI, notificaciones) |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación del perfil |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de última actualización |

**Índices:**
- `idx_profiles_ldap_uid` en (ldap_uid)
- `idx_profiles_type_active` en (user_type, is_active)

**Uso:** Esta tabla centraliza la gestión de usuarios del sistema, permitiendo diferentes niveles de acceso según el tipo de usuario. Los conductores tendrán funcionalidades específicas de operación, mientras que los administradores acceden a configuración y reportes.

### drivers
**Propósito:** Gestiona información específica de conductores, incluyendo licencias de conducir, asignaciones de vehículos y estado operativo. Extiende la funcionalidad de user_profiles para usuarios tipo CONDUCTOR.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único del conductor |
| user_profile_id | INTEGER | UNIQUE, NOT NULL, FK | Referencia al perfil de usuario LDAP |
| driver_license | VARCHAR(20) | UNIQUE, NOT NULL | Número de licencia de conducir |
| license_type | VARCHAR(10) | NOT NULL, CHECK | Tipo de licencia: A-IIa (transporte público), A-IIb (carga) |
| license_expiry | DATE | NOT NULL | Fecha de vencimiento de la licencia |
| status | VARCHAR(20) | DEFAULT 'ACTIVE', CHECK | Estado operativo: ACTIVE, SUSPENDED, TERMINATED |
| current_vehicle_id | INTEGER | FK | Vehículo actualmente asignado al conductor |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro del conductor |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de última actualización |

**Índices:**
- `idx_drivers_status_license` en (status, license_expiry)
- `idx_drivers_current_vehicle` en (current_vehicle_id)

**Uso:** Controla el estado y validez de los conductores en el sistema. Permite verificar licencias vigentes, gestionar suspensiones y mantener la trazabilidad de asignaciones de vehículos.

---

## 🚌 MÓDULO DE RUTAS Y VEHÍCULOS

### routes
**Propósito:** Define las rutas principales del sistema de transporte con información básica para identificación y visualización en mapas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único de la ruta |
| name | VARCHAR(100) | NOT NULL | Nombre descriptivo de la ruta (ej: "Ruta Norte - Sur") |
| code | VARCHAR(20) | UNIQUE, NOT NULL | Código alfanumérico único (ej: "A1", "B2") |
| color | VARCHAR(7) | DEFAULT '#0066CC' | Color hex para visualización en mapas |
| is_active | BOOLEAN | DEFAULT true | Estado activo de la ruta |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación de la ruta |

**Uso:** Tabla maestra que define las rutas operativas del sistema. Se utiliza para clasificar vehículos, generar reportes por ruta y visualizar información en dashboards.

### route_polylines
**Propósito:** Almacena las polilíneas geográficas detalladas de las rutas para validación de desvíos mediante JTS y sincronización con Redis geoespacial.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único de la polilínea |
| route_id | INTEGER | NOT NULL, FK | Ruta a la que pertenece esta polilínea |
| name | VARCHAR(100) | NOT NULL | Nombre del segmento (ej: "Tramo Centro-Norte") |
| direction | VARCHAR(20) | NOT NULL, CHECK | Dirección: IDA, VUELTA, BIDIRECCIONAL |
| coordinates_json | JSONB | NOT NULL | Coordenadas en formato GeoJSON |
| encoded_polyline | TEXT | | Polilínea codificada en formato Google |
| color | VARCHAR(7) | | Color específico del segmento |
| stroke_width | INTEGER | DEFAULT 4 | Ancho de línea para visualización |
| stroke_opacity | DECIMAL(3,2) | DEFAULT 0.8 | Opacidad para mapas (0.0-1.0) |
| total_distance_km | DECIMAL(6,2) | | Distancia total calculada del segmento |
| estimated_time_minutes | INTEGER | | Tiempo estimado de recorrido |
| corridor_width_meters | INTEGER | DEFAULT 100 | Ancho del corredor para validación |
| deviation_tolerance_meters | INTEGER | DEFAULT 50 | Tolerancia permitida para desvíos |
| geometry_hash | VARCHAR(64) | | Hash MD5 de la geometría |
| config_hash | VARCHAR(64) | | Hash de configuración para cambios |
| jts_cached_at | TIMESTAMP | | Última sincronización con JTS |
| redis_synced_at | TIMESTAMP | | Última sincronización con Redis |
| redis_sync_key | VARCHAR(100) | | Clave de sincronización Redis |
| is_active | BOOLEAN | DEFAULT true | Estado activo del segmento |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |
| created_by_profile_id | INTEGER | FK | Usuario que creó el registro |

**Índices:**
- `idx_polylines_route_direction` en (route_id, direction, is_active)
- `idx_polylines_sync_status` en (is_active, redis_synced_at)
- `idx_polylines_redis_key` en (redis_sync_key)

**Uso:** Define las rutas geográficas exactas que deben seguir los vehículos. Se utiliza para detectar desvíos de ruta y validar que los vehículos circulen por los corredores autorizados.

### vehicles
**Propósito:** Registro maestro de todos los vehículos de la flota con información básica, asignación de ruta y estado operativo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único del vehículo |
| plate_number | VARCHAR(10) | UNIQUE, NOT NULL | Número de placa oficial del vehículo |
| internal_code | VARCHAR(20) | UNIQUE, NOT NULL | Código interno de la empresa |
| route_id | INTEGER | FK | Ruta actualmente asignada |
| status | VARCHAR(20) | DEFAULT 'ACTIVE', CHECK | Estado: ACTIVE, INACTIVE, MAINTENANCE |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de registro |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |

**Uso:** Inventario central de la flota. Permite gestionar asignaciones de rutas, controlar el estado operativo y generar reportes de utilización de vehículos.

### trackers
**Propósito:** Gestiona los dispositivos GPS instalados en cada vehículo, incluyendo configuración de transmisión y monitoreo de conectividad.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único del tracker |
| device_id | VARCHAR(50) | UNIQUE, NOT NULL | ID único del dispositivo GPS |
| vehicle_id | INTEGER | FK | Vehículo al que está instalado |
| posting_interval | INTEGER | DEFAULT 30 | Intervalo de transmisión en segundos |
| status | VARCHAR(20) | DEFAULT 'ACTIVE', CHECK | Estado: ACTIVE, INACTIVE, ERROR |
| last_seen | TIMESTAMP | | Última transmisión recibida |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de instalación |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |

**Uso:** Controla la conectividad y funcionamiento de los dispositivos GPS. Permite detectar problemas de comunicación y ajustar intervalos de transmisión según necesidades operativas.

---

## 📍 MÓDULO DE GEOCERCAS Y GEOFENCING

### geofence_types
**Propósito:** Catálogo de tipos de geocercas disponibles en el sistema con configuraciones por defecto para alertas y visualización.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único del tipo |
| name | VARCHAR(50) | UNIQUE, NOT NULL | Nombre interno del tipo |
| display_name | VARCHAR(100) | NOT NULL | Nombre para mostrar al usuario |
| default_alert_priority | VARCHAR(10) | DEFAULT 'MEDIUM', CHECK | Prioridad por defecto: LOW, MEDIUM, HIGH, CRITICAL |
| color | VARCHAR(7) | DEFAULT '#FF0000' | Color hex para visualización |
| is_active | BOOLEAN | DEFAULT true | Estado activo del tipo |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Valores Predefinidos:**
- `BUS_STOP` - Paradero de Bus (MEDIUM, #0066CC)
- `TERMINAL` - Terminal (HIGH, #FF6600)
- `SPEED_ZONE` - Zona de Velocidad (HIGH, #FF0000)
- `ROUTE_CORRIDOR` - Corredor de Ruta (MEDIUM, #00CC66)

**Uso:** Define los tipos estándar de geocercas que maneja el sistema. Facilita la configuración consistente y la visualización diferenciada en mapas.

### geofences
**Propósito:** Define todas las geocercas del sistema (paraderos, terminales, zonas de velocidad) con geometría y configuración de alertas para sincronización con Redis.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único de la geocerca |
| name | VARCHAR(100) | NOT NULL | Nombre descriptivo |
| geofence_type_id | INTEGER | FK | Tipo de geocerca |
| route_id | INTEGER | FK | Ruta específica (opcional) |
| geometry_type | VARCHAR(20) | NOT NULL, CHECK | Tipo: CIRCLE, POLYGON |
| center_latitude | DECIMAL(10,8) | | Latitud del centro (círculos) |
| center_longitude | DECIMAL(11,8) | | Longitud del centro (círculos) |
| radius_meters | INTEGER | | Radio en metros (círculos) |
| coordinates_json | JSONB | | Coordenadas (polígonos) |
| alert_on_entry | BOOLEAN | DEFAULT false | Generar alerta al entrar |
| alert_on_exit | BOOLEAN | DEFAULT true | Generar alerta al salir |
| alert_on_dwell | BOOLEAN | DEFAULT false | Generar alerta por permanencia |
| max_dwell_seconds | INTEGER | DEFAULT 300 | Tiempo máximo de permanencia |
| alert_priority | VARCHAR(10) | DEFAULT 'MEDIUM', CHECK | Prioridad de alertas |
| max_speed_kmh | INTEGER | | **Velocidad máxima en la zona (SIMPLIFICADO)** |
| min_speed_kmh | INTEGER | | **Velocidad mínima en la zona** |
| speed_alert_enabled | BOOLEAN | DEFAULT true | **Habilitar alertas de velocidad** |
| speed_tolerance_kmh | INTEGER | DEFAULT 5 | **Tolerancia de velocidad** |
| applies_to_routes | JSONB | | Rutas aplicables (array de IDs) |
| config_hash | VARCHAR(64) | | Hash de configuración |
| redis_sync_key | VARCHAR(100) | | Clave Redis |
| redis_synced_at | TIMESTAMP | | Última sincronización Redis |
| jts_cached_at | TIMESTAMP | | Última validación JTS |
| is_active | BOOLEAN | DEFAULT true | Estado activo |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |
| created_by_profile_id | INTEGER | FK | Usuario creador |

**Índices:**
- `idx_geofences_type_active` en (geofence_type_id, is_active)
- `idx_geofences_sync_status` en (is_active, redis_synced_at)
- `idx_geofences_redis_key` en (redis_sync_key)

**Uso:** **TABLA CENTRAL DEL SISTEMA.** Define todas las zonas geográficas de interés, incluyendo paraderos, terminales y zonas de velocidad. En la versión simplificada, también maneja la configuración de límites de velocidad específicos por zona, eliminando la necesidad de tablas separadas.

### bus_stops
**Propósito:** Registra paraderos específicos con ubicación geográfica y configuración operativa, vinculados a geocercas para detección automática.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único del paradero |
| name | VARCHAR(100) | NOT NULL | Nombre del paradero |
| code | VARCHAR(20) | UNIQUE | Código alfanumérico del paradero |
| route_id | INTEGER | FK | Ruta a la que pertenece |
| latitude | DECIMAL(10,8) | NOT NULL | Coordenada de latitud |
| longitude | DECIMAL(11,8) | NOT NULL | Coordenada de longitud |
| stop_order | INTEGER | | Orden en la secuencia de ruta |
| geofence_id | INTEGER | FK | Geocerca asociada para detección |
| is_terminal | BOOLEAN | DEFAULT false | Indica si es terminal de ruta |
| min_stop_seconds | INTEGER | DEFAULT 30 | Tiempo mínimo de parada |
| max_stop_seconds | INTEGER | DEFAULT 300 | Tiempo máximo de parada |
| is_active | BOOLEAN | DEFAULT true | Estado activo |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Índices:**
- `idx_stops_route_order` en (route_id, stop_order)
- `idx_stops_geofence` en (geofence_id)

**Uso:** Define los puntos específicos donde los vehículos deben hacer paradas. Se vincula con geocercas para detectar automáticamente llegadas y salidas, y calcular cumplimiento de itinerarios.

---

## ⚡ MÓDULO DE CONFIGURACIÓN DE VELOCIDAD (SIMPLIFICADO)

### global_speed_config
**Propósito:** Configuración global de velocidades del sistema con múltiples perfiles y configuración de tolerancias. **ÚNICA TABLA DE CONFIGURACIÓN GLOBAL** en la versión simplificada.

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
| applies_to_routes | JSONB | | Rutas aplicables |
| priority_order | INTEGER | DEFAULT 1 | Orden de prioridad |
| is_active | BOOLEAN | DEFAULT true | Estado activo |
| effective_from | TIMESTAMP | | Fecha de inicio de vigencia |
| effective_until | TIMESTAMP | | Fecha de fin de vigencia |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |
| created_by_profile_id | INTEGER | FK | Usuario creador |

**Configuraciones Predefinidas:**
- `DEFAULT_URBAN` - 60 km/h (prioridad 1)
- `DEFAULT_HIGHWAY` - 90 km/h (prioridad 2)
- `EMERGENCY_MODE` - 40 km/h (prioridad 3)

**Índices:**
- `idx_global_speed_config_name` en (config_name, is_active)
- `idx_global_speed_priority` en (priority_order, is_active)

**Uso:** **CONFIGURACIÓN BASE DEL SISTEMA.** Define los límites de velocidad generales que se aplican cuando no hay una geocerca específica. La versión simplificada elimina las tablas `speed_zones` y `route_speed_config` complejas.

---

## 📊 MÓDULO DE EVENTOS PROCESADOS

### geofence_events
**Propósito:** Almacena todos los eventos de geocercas procesados por Redis/JTS, incluyendo entradas, salidas y violaciones de permanencia con metadatos de procesamiento.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único del evento |
| geofence_id | INTEGER | NOT NULL, FK | Geocerca involucrada |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo que generó el evento |
| tracker_id | INTEGER | NOT NULL, FK | Tracker que reportó |
| driver_profile_id | INTEGER | FK | Conductor asignado |
| event_type | VARCHAR(20) | NOT NULL, CHECK | Tipo: ENTRY, EXIT, DWELL_VIOLATION |
| latitude | DECIMAL(10,8) | NOT NULL | Coordenada del evento |
| longitude | DECIMAL(11,8) | NOT NULL | Coordenada del evento |
| speed | DECIMAL(5,2) | | Velocidad al momento del evento |
| heading | INTEGER | | Dirección del vehículo (0-359°) |
| event_timestamp | TIMESTAMP | NOT NULL | Momento exacto del evento |
| entry_timestamp | TIMESTAMP | | Momento de entrada (para exits) |
| dwell_seconds | INTEGER | | Tiempo de permanencia |
| processing_method | VARCHAR(20) | CHECK | Método: REDIS_ONLY, REDIS_JTS, JTS_VALIDATION |
| processing_latency_ms | INTEGER | | Latencia de procesamiento |
| redis_distance_meters | DECIMAL(8,2) | | Distancia calculada por Redis |
| jts_validation_result | BOOLEAN | | Resultado de validación JTS |
| alert_generated | BOOLEAN | DEFAULT false | Se generó alerta |
| alert_priority | VARCHAR(10) | CHECK | Prioridad de la alerta |
| acknowledged | BOOLEAN | DEFAULT false | Alerta reconocida |
| acknowledged_by_profile_id | INTEGER | FK | Usuario que reconoció |
| acknowledged_at | TIMESTAMP | | Momento de reconocimiento |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Índices:**
- `idx_geofence_events_vehicle_time` en (vehicle_id, event_timestamp)
- `idx_geofence_events_fence_time` en (geofence_id, event_timestamp)
- `idx_geofence_events_alerts` en (event_type, alert_generated)

**Uso:** **REGISTRO PRINCIPAL DE ACTIVIDAD.** Almacena todos los eventos de entrada/salida de geocercas para generar reportes de cumplimiento, alertas operativas y análisis de rutas.

### bus_stop_events
**Propósito:** Registra eventos específicos de paraderos incluyendo llegadas, salidas y cumplimiento de itinerarios programados.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| bus_stop_id | INTEGER | NOT NULL, FK | Paradero específico |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo involucrado |
| driver_profile_id | INTEGER | FK | Conductor asignado |
| event_type | VARCHAR(20) | NOT NULL, CHECK | Tipo: ARRIVAL, DEPARTURE, DWELL_VIOLATION, SKIP |
| arrival_timestamp | TIMESTAMP | | Momento de llegada |
| departure_timestamp | TIMESTAMP | | Momento de salida |
| dwell_seconds | INTEGER | | Tiempo de permanencia |
| arrival_latitude | DECIMAL(10,8) | | Coordenada de llegada |
| arrival_longitude | DECIMAL(11,8) | | Coordenada de llegada |
| departure_latitude | DECIMAL(10,8) | | Coordenada de salida |
| departure_longitude | DECIMAL(11,8) | | Coordenada de salida |
| scheduled_arrival | TIMESTAMP | | Llegada programada |
| delay_seconds | INTEGER | | Retraso en segundos |
| compliance_status | VARCHAR(20) | CHECK | Estado: ON_TIME, LATE, EARLY, SKIPPED |
| processing_source | VARCHAR(20) | DEFAULT 'GEOFENCE_SYSTEM' | Fuente del procesamiento |
| notes | TEXT | | Notas adicionales |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Índices:**
- `idx_bus_stop_events_stop_time` en (bus_stop_id, arrival_timestamp)
- `idx_bus_stop_events_vehicle_time` en (vehicle_id, arrival_timestamp)

**Uso:** Monitorea el cumplimiento de itinerarios en paraderos específicos. Permite calcular puntualidad, detectar saltos de paraderos y optimizar frecuencias.

### speed_violations
**Propósito:** Registra todas las violaciones de velocidad detectadas con información detallada de severidad y duración.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo infractor |
| tracker_id | INTEGER | NOT NULL, FK | Tracker que detectó |
| driver_profile_id | INTEGER | FK | Conductor responsable |
| geofence_id | INTEGER | FK | Zona donde ocurrió (opcional) |
| violation_type | VARCHAR(20) | NOT NULL, CHECK | Tipo: SPEED_LIMIT, RECKLESS_DRIVING |
| recorded_speed | DECIMAL(5,2) | NOT NULL | Velocidad registrada |
| speed_limit | DECIMAL(5,2) | NOT NULL | Límite aplicable |
| excess_speed | DECIMAL(5,2) | NOT NULL | Exceso de velocidad |
| latitude | DECIMAL(10,8) | NOT NULL | Ubicación de la violación |
| longitude | DECIMAL(11,8) | NOT NULL | Ubicación de la violación |
| start_timestamp | TIMESTAMP | NOT NULL | Inicio de la violación |
| end_timestamp | TIMESTAMP | | Fin de la violación |
| duration_seconds | INTEGER | | Duración total |
| severity | VARCHAR(20) | CHECK | Severidad: MINOR, MODERATE, SEVERE, CRITICAL |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Índices:**
- `idx_speed_violations_vehicle_time` en (vehicle_id, start_timestamp)
- `idx_speed_violations_severity` en (severity, created_at)

**Uso:** Registra violaciones de velocidad para evaluación de conductores, generación de reportes de seguridad y cumplimiento regulatorio.

### route_deviations
**Propósito:** Almacena desvíos de ruta detectados con información de distancia, duración y autorización.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo que se desvió |
| route_id | INTEGER | NOT NULL, FK | Ruta autorizada |
| driver_profile_id | INTEGER | FK | Conductor responsable |
| deviation_type | VARCHAR(20) | NOT NULL, CHECK | Tipo: MINOR_DEVIATION, MAJOR_DEVIATION, UNAUTHORIZED_ROUTE |
| start_latitude | DECIMAL(10,8) | NOT NULL | Punto inicial del desvío |
| start_longitude | DECIMAL(11,8) | NOT NULL | Punto inicial del desvío |
| end_latitude | DECIMAL(10,8) | | Punto final del desvío |
| end_longitude | DECIMAL(11,8) | | Punto final del desvío |
| start_timestamp | TIMESTAMP | NOT NULL | Inicio del desvío |
| end_timestamp | TIMESTAMP | | Fin del desvío |
| duration_seconds | INTEGER | | Duración total |
| max_deviation_meters | DECIMAL(8,2) | | Máxima distancia de desvío |
| total_deviation_distance | DECIMAL(8,2) | | Distancia total desviada |
| is_authorized | BOOLEAN | DEFAULT false | Desvío autorizado |
| authorized_by_profile_id | INTEGER | FK | Usuario que autorizó |
| authorization_reason | TEXT | | Razón de la autorización |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Índices:**
- `idx_route_deviations_vehicle_time` en (vehicle_id, start_timestamp)
- `idx_route_deviations_route_time` en (route_id, start_timestamp)

**Uso:** Detecta y registra cuando los vehículos se salen de las rutas autorizadas. Permite autorizar desvíos por contingencias y generar reportes de cumplimiento de rutas.

---

## 📍 MÓDULO DE HISTORIAL GPS

### location_history
**Propósito:** Almacena el historial completo de posiciones GPS de todos los vehículos para análisis de reportes y auditoría.

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

**Índices:**
- `idx_location_history_vehicle_time` en (vehicle_id, timestamp)
- `idx_location_history_timestamp` en (timestamp)

**Uso:** **ARCHIVO HISTÓRICO** de todas las posiciones GPS. Se utiliza para generar reportes de recorridos, análisis de comportamiento y auditorías. Tiene políticas de retención automática (30 días por defecto).

---

## 🚨 MÓDULO DE ALERTAS Y EVENTOS

### system_alerts
**Propósito:** Gestiona todas las alertas del sistema con estados de reconocimiento y resolución para seguimiento operativo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| alert_type | VARCHAR(50) | NOT NULL | Tipo de alerta (speed_violation, route_deviation, etc.) |
| source_table | VARCHAR(50) | | Tabla origen del evento |
| source_id | BIGINT | | ID del registro origen |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo involucrado |
| driver_profile_id | INTEGER | FK | Conductor involucrado |
| priority | VARCHAR(10) | NOT NULL, CHECK | Prioridad: LOW, MEDIUM, HIGH, CRITICAL |
| title | VARCHAR(200) | NOT NULL | Título descriptivo de la alerta |
| description | TEXT | | Descripción detallada del problema |
| status | VARCHAR(20) | DEFAULT 'ACTIVE', CHECK | Estado: ACTIVE, ACKNOWLEDGED, RESOLVED, DISMISSED |
| acknowledged_by_profile_id | INTEGER | FK | Usuario que reconoció la alerta |
| acknowledged_at | TIMESTAMP | | Momento de reconocimiento |
| resolved_at | TIMESTAMP | | Momento de resolución |
| metadata | JSONB | | Datos adicionales en formato JSON |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Índices:**
- `idx_alerts_active_priority` en (status, priority, created_at)
- `idx_alerts_vehicle_time` en (vehicle_id, created_at)
- `idx_alerts_type_time` en (alert_type, created_at)

**Uso:** **CENTRO DE NOTIFICACIONES** del sistema. Consolida todas las alertas generadas por diferentes módulos y permite un seguimiento centralizado del estado de reconocimiento y resolución.

### panic_alerts
**Propósito:** Maneja alertas de pánico activadas por conductores con seguimiento prioritario y resolución obligatoria.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | BIGSERIAL | PRIMARY KEY | Identificador único |
| tracker_id | INTEGER | NOT NULL, FK | Tracker que envió la alerta |
| vehicle_id | INTEGER | NOT NULL, FK | Vehículo involucrado |
| driver_profile_id | INTEGER | FK | Conductor que activó el pánico |
| latitude | DECIMAL(10,8) | NOT NULL | Ubicación de la emergencia |
| longitude | DECIMAL(11,8) | NOT NULL | Ubicación de la emergencia |
| status | VARCHAR(20) | DEFAULT 'ACTIVE', CHECK | Estado: ACTIVE, ACKNOWLEDGED, RESOLVED, FALSE_ALARM |
| priority | VARCHAR(10) | DEFAULT 'CRITICAL', CHECK | Prioridad: HIGH, CRITICAL |
| acknowledged_by_profile_id | INTEGER | FK | Usuario que atendió la alerta |
| acknowledged_at | TIMESTAMP | | Momento de reconocimiento |
| resolved_at | TIMESTAMP | | Momento de resolución |
| resolution_notes | TEXT | | Notas sobre la resolución |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de creación |

**Índices:**
- `idx_panic_status_time` en (status, created_at)
- `idx_panic_vehicle_time` en (vehicle_id, created_at)

**Uso:** **SISTEMA DE EMERGENCIAS** para situaciones críticas. Permite a los conductores activar alertas de pánico que requieren atención inmediata del centro de control.

---

## ⚙️ MÓDULO DE CONFIGURACIÓN DEL SISTEMA

### redis_sync_log
**Propósito:** Registra todas las operaciones de sincronización con Redis para monitoreo de rendimiento y detección de errores.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| sync_type | VARCHAR(50) | NOT NULL | Tipo de sincronización (geofences, routes, etc.) |
| table_name | VARCHAR(50) | NOT NULL | Tabla sincronizada |
| record_id | INTEGER | | ID del registro sincronizado |
| redis_key | VARCHAR(200) | | Clave Redis utilizada |
| old_hash | VARCHAR(64) | | Hash anterior para detección de cambios |
| new_hash | VARCHAR(64) | | Hash nuevo |
| change_type | VARCHAR(20) | CHECK | Tipo: CREATE, UPDATE, DELETE, NO_CHANGE |
| status | VARCHAR(20) | NOT NULL, CHECK | Estado: SUCCESS, FAILED, PARTIAL |
| error_message | TEXT | | Mensaje de error si falló |
| records_processed | INTEGER | DEFAULT 0 | Registros procesados |
| started_at | TIMESTAMP | NOT NULL | Inicio de la operación |
| completed_at | TIMESTAMP | | Fin de la operación |
| duration_ms | INTEGER | | Duración en milisegundos |

**Uso:** **MONITOREO DE INTEGRACIÓN** con Redis. Permite detectar problemas de sincronización y optimizar el rendimiento del sistema geoespacial.

### system_config
**Propósito:** Almacena parámetros de configuración global del sistema con tipado y versionado de cambios.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| id | SERIAL | PRIMARY KEY | Identificador único |
| config_key | VARCHAR(100) | UNIQUE, NOT NULL | Clave de configuración |
| config_value | TEXT | NOT NULL | Valor de la configuración |
| description | TEXT | | Descripción del parámetro |
| data_type | VARCHAR(20) | DEFAULT 'STRING', CHECK | Tipo: STRING, INTEGER, BOOLEAN, JSON |
| updated_by_profile_id | INTEGER | FK | Usuario que actualizó |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Fecha de actualización |

**Configuraciones Predefinidas:**
- `REDIS_SYNC_INTERVAL_MINUTES` = 5
- `JTS_CACHE_EXPIRY_HOURS` = 24
- `DEFAULT_SPEED_LIMIT_KMH` = 60
- `SPEED_ALERT_TOLERANCE_KMH` = 5
- `GEOFENCE_PROCESSING_ENABLED` = true
- `MAX_LOCATION_HISTORY_DAYS` = 30

**Uso:** **CONFIGURACIÓN CENTRAL** del sistema. Permite ajustar parámetros operativos sin modificar código y mantiene trazabilidad de cambios.

---

## 📊 VISTAS DE REPORTE OPTIMIZADAS

### vehicle_events_summary
**Propósito:** Vista consolidada que proporciona un resumen de todos los eventos por vehículo en los últimos 30 días para dashboards ejecutivos.

| Campo Calculado | Descripción |
|-----------------|-------------|
| vehicle_id | Identificador del vehículo |
| plate_number | Número de placa |
| internal_code | Código interno |
| route_name | Nombre de la ruta asignada |
| total_geofence_events | Total de eventos de geocercas |
| entries | Eventos de entrada a geocercas |
| exits | Eventos de salida de geocercas |
| speed_violations | Violaciones de velocidad |
| route_deviations | Desvíos de ruta |
| last_event_time | Último evento registrado |

**Uso:** Dashboard principal para supervisores. Proporciona una vista rápida del comportamiento de cada vehículo.

### pending_alerts
**Propósito:** Vista de alertas pendientes de atención con información contextual completa para operadores del centro de control.

| Campo Calculado | Descripción |
|-----------------|-------------|
| id | ID de la alerta |
| alert_type | Tipo de alerta |
| priority | Prioridad de la alerta |
| title | Título descriptivo |
| description | Descripción detallada |
| plate_number | Placa del vehículo |
| internal_code | Código interno del vehículo |
| route_name | Ruta asignada |
| driver_license | Licencia del conductor |
| driver_uid | UID LDAP del conductor |
| created_at | Momento de creación |
| minutes_ago | Minutos transcurridos |

**Uso:** Panel de control operativo para atender alertas en tiempo real con contexto completo.

### driver_performance_summary
**Propósito:** Vista consolidada del rendimiento de conductores con métricas de cumplimiento y estadísticas operativas.

| Campo Calculado | Descripción |
|-----------------|-------------|
| driver_id | ID del conductor |
| ldap_uid | Usuario LDAP |
| driver_license | Número de licencia |
| plate_number | Vehículo asignado |
| total_geofence_events | Total de eventos |
| speed_violations | Violaciones de velocidad |
| route_deviations | Desvíos de ruta |
| panic_alerts | Alertas de pánico |
| alerts_generated | Alertas generadas |
| serious_violations | Violaciones graves |
| bus_stop_events | Eventos en paraderos |
| on_time_arrivals | Llegadas puntuales |
| late_arrivals | Llegadas tardías |
| punctuality_percentage | Porcentaje de puntualidad |
| last_activity | Última actividad |

**Uso:** Evaluación de desempeño de conductores para programas de incentivos y capacitación.

### route_statistics
**Propósito:** Vista estadística por ruta con métricas operativas, de calidad y rendimiento para análisis gerencial.

| Campo Calculado | Descripción |
|-----------------|-------------|
| route_id | ID de la ruta |
| route_name | Nombre de la ruta |
| route_code | Código de la ruta |
| assigned_vehicles | Vehículos asignados |
| active_drivers | Conductores activos |
| total_bus_stops | Total de paraderos |
| terminals | Terminales en la ruta |
| total_geofence_events | Eventos de geocercas |
| speed_violations | Violaciones de velocidad |
| route_deviations | Desvíos de ruta |
| bus_stop_events | Eventos en paraderos |
| on_time_arrivals | Llegadas puntuales |
| late_arrivals | Llegadas tardías |
| early_arrivals | Llegadas tempranas |
| punctuality_percentage | Porcentaje de puntualidad |
| avg_delay_seconds | Retraso promedio |
| total_distance_km | Distancia total |
| last_activity | Última actividad |

**Uso:** Análisis comparativo de rutas para optimización de servicios y asignación de recursos.

### speed_zones_admin
**Propósito:** Vista administrativa de zonas de velocidad configuradas en el sistema simplificado.

| Campo Calculado | Descripción |
|-----------------|-------------|
| id | ID de la geocerca |
| name | Nombre descriptivo |
| geometry_type | Tipo de geometría |
| max_speed_kmh | Velocidad máxima |
| speed_tolerance_kmh | Tolerancia |
| alert_priority | Prioridad de alertas |
| coverage_area | Área de cobertura |
| is_active | Estado activo |
| applicable_routes | Rutas aplicables |
| created_at | Fecha de creación |
| updated_at | Última actualización |

**Uso:** **GESTIÓN SIMPLIFICADA** de zonas de velocidad. Permite a los administradores ver y gestionar todas las zonas de velocidad desde una sola vista.

### geofences_sync_status
**Propósito:** Vista de monitoreo del estado de sincronización de geocercas con Redis y cache JTS para administradores técnicos.

| Campo Calculado | Descripción |
|-----------------|-------------|
| id | ID de la geocerca |
| name | Nombre descriptivo |
| type_name | Tipo de geocerca |
| geometry_type | Tipo de geometría |
| is_active | Estado activo |
| config_hash | Hash de configuración |
| redis_sync_key | Clave Redis |
| redis_synced_at | Última sincronización Redis |
| jts_cached_at | Última validación JTS |
| updated_at | Última actualización |
| sync_status | Estado: NEVER_SYNCED, NEEDS_SYNC, SYNCED, SYNC_OLD |
| jts_cache_status | Estado JTS: NO_JTS_NEEDED, NEVER_CACHED, CACHE_EXPIRED, CACHED |
| applies_to_routes_count | Número de rutas aplicables |

**Uso:** Monitoreo técnico de la sincronización con sistemas externos (Redis/JTS).

---

## 🔧 FUNCIONES AUXILIARES Y UTILIDADES

### get_speed_limit_at_location(p_latitude, p_longitude, p_route_id)
**Propósito:** **FUNCIÓN PRINCIPAL** para obtener el límite de velocidad aplicable en una ubicación específica con lógica de prioridades simplificada.

**Parámetros:**
- `p_latitude`: Coordenada de latitud
- `p_longitude`: Coordenada de longitud  
- `p_route_id`: ID de ruta (opcional)

**Retorna:** TABLE con:
- `speed_limit`: Límite de velocidad aplicable
- `tolerance`: Tolerancia permitida
- `zone_name`: Nombre de la zona
- `alert_priority`: Prioridad de alertas
- `source_type`: Fuente (GEOFENCE, GLOBAL_CONFIG, SYSTEM_DEFAULT)

**Lógica Simplificada:**
1. **Buscar en geocercas específicas** (prioridad alta)
2. **Usar configuración global** si no hay geocerca
3. **Valor por defecto del sistema** como último recurso

**Uso:** Función central del sistema de velocidad simplificado. Elimina la complejidad de múltiples tablas de configuración.

### calculate_geofence_config_hash(geofence_id)
**Propósito:** Calcula hash MD5 de la configuración de una geocerca para detectar cambios que requieren sincronización.

**Uso:** Control de cambios para sincronización automática con Redis.

### mark_geofences_for_sync()
**Propósito:** Identifica geocercas que han cambiado y las marca para sincronización con Redis.

**Uso:** Mantenimiento automático de la sincronización.

### cleanup_old_data()
**Propósito:** Limpia automáticamente datos históricos antiguos según políticas de retención configuradas.

**Uso:** Mantenimiento automático de la base de datos.

### get_system_stats()
**Propósito:** Obtiene estadísticas generales del sistema para dashboards de monitoreo.

**Uso:** Dashboard de administración del sistema.

---

## 🔄 TRIGGERS AUTOMÁTICOS

### update_updated_at()
**Propósito:** Trigger function que actualiza automáticamente el campo `updated_at` en las tablas configuradas.

**Aplicado a:**
- user_profiles, drivers, vehicles, trackers
- geofences, route_polylines, global_speed_config

### invalidate_geofence_cache()
**Propósito:** Trigger que invalida automáticamente el cache Redis/JTS cuando se modifican geocercas importantes.

**Aplicado a:** geofences (BEFORE UPDATE)

**Condiciones:** Cambios en nombre, coordenadas, radio, configuración de velocidad o alertas.

---

## 📈 ÍNDICES DE RENDIMIENTO

### Índices Compuestos Principales
- `idx_geofence_events_vehicle_type_time`: Optimiza consultas por vehículo y tipo de evento
- `idx_speed_violations_vehicle_severity_time`: Optimiza consultas de violaciones por severidad
- `idx_system_alerts_status_priority_vehicle`: Optimiza dashboard de alertas

### Índices Parciales para Eficiencia
- `idx_active_geofences`: Solo geocercas activas
- `idx_speed_zones_active`: Solo zonas de velocidad activas
- `idx_pending_sync_geofences`: Solo geocercas pendientes de sincronización
- `idx_geofence_events_recent`: Eventos recientes con alertas
- `idx_speed_violations_recent`: Violaciones graves recientes

---

## 🛡️ CONFIGURACIONES DE SEGURIDAD Y RETENCIÓN

### Políticas de Retención Configurables
- **Historial GPS:** 30 días por defecto (`MAX_LOCATION_HISTORY_DAYS`)
- **Eventos de Geocercas:** 6 meses
- **Logs de Sincronización:** 30 días
- **Alertas Resueltas:** Permanente con archivado opcional

### Integridad Referencial
- **35+ Restricciones FK** para mantener consistencia
- **Cascadas controladas** para preservar historial
- **20+ Validaciones CHECK** para estados y tipos
- **Triggers automáticos** para consistencia de datos

### Auditoría y Trazabilidad
- Campos `created_at`/`updated_at` en todas las tablas principales
- Campo `created_by_profile_id` para trazabilidad de cambios
- Log completo de sincronizaciones Redis
- Historial de configuraciones del sistema

---

## 📊 CONFIGURACIÓN SIMPLIFICADA DE VELOCIDAD

### Comparación: Versión Original vs Simplificada

| Aspecto | Versión Original | Versión Simplificada |
|---------|------------------|----------------------|
| **Tablas de Config** | 4 tablas (global_speed_config, speed_zones, route_speed_config, geofences) | **2 tablas** (global_speed_config, geofences) |
| **Complejidad** | Alta (overlapping configs) | **Baja (prioridades claras)** |
| **Mantenimiento** | Difícil (múltiples fuentes) | **Fácil (configuración unificada)** |
| **Conflictos** | Posibles entre tablas | **Eliminados** |
| **Performance** | Múltiples JOINs | **Consulta optimizada** |

### Lógica de Prioridades Simplificada
1. **🎯 Geocerca Específica** (radio menor = mayor prioridad)
2. **🌐 Configuración Global** (por priority_order)
3. **⚙️ Valor por Defecto** (sistema)

### Ejemplos de Configuración
```sql
-- Zona escolar: 30 km/h (radio 200m)
-- Zona hospital: 25 km/h (radio 150m)  
-- Centro comercial: 40 km/h (radio 300m)
-- Límite general: 60 km/h (global_speed_config)
-- Por defecto: 60 km/h (system_config)
```

---

## 🎯 CASOS DE USO PRINCIPALES

### 1. Monitoreo en Tiempo Real
- Seguimiento GPS con geocercas Redis
- Detección automática de eventos
- Alertas en tiempo real

### 2. Control de Velocidad Simplificado
- **Función única:** `get_speed_limit_at_location()`
- **Lógica clara:** Geocerca > Global > Defecto
- **Configuración sencilla:** Solo círculos y configuración global

### 3. Gestión de Rutas
- Validación de desvíos con JTS
- Corredores de ruta predefinidos
- Autorización de desvíos

### 4. Control de Paraderos
- Cumplimiento de itinerarios
- Cálculo automático de retrasos
- Estadísticas de puntualidad

### 5. Alertas Operativas
- Sistema centralizado de notificaciones
- Priorización automática
- Seguimiento de resolución

### 6. Reportes Gerenciales
- Dashboards con métricas KPI
- Análisis comparativo por rutas
- Evaluación de desempeño de conductores

---

## 📋 RESUMEN ESTADÍSTICO

| Categoría | Cantidad | Cambio vs Original |
|-----------|----------|-------------------|
| **Tablas Principales** | 18 | -7 tablas eliminadas |
| **Vistas de Reporte** | 6 | +1 (speed_zones_admin) |
| **Funciones Auxiliares** | 5 | Mismo número |
| **Triggers** | 8 | Mismo número |
| **Índices Totales** | 45+ | Optimizados |
| **Restricciones FK** | 35+ | Simplificadas |
| **Configuración Velocidad** | **2 fuentes** | **50% reducción** |

### Distribución por Módulo
- **👥 Usuarios/LDAP:** 2 tablas
- **🚌 Rutas/Vehículos:** 4 tablas  
- **📍 Geocercas:** 3 tablas
- **⚡ Velocidad:** **1 tabla** (vs 3 original)
- **📊 Eventos:** 4 tablas
- **📍 Historial:** 1 tabla
- **🚨 Alertas:** 2 tablas
- **⚙️ Configuración:** 2 tablas

### Beneficios de la Simplificación
✅ **80% menos complejidad** en configuración de velocidad  
✅ **Eliminación de conflictos** entre configuraciones  
✅ **Mantenimiento simplificado** para operadores  
✅ **Performance mejorado** con menos JOINs  
✅ **Lógica clara** de prioridades  
✅ **Configuración intuitiva** para administradores  

---

## 🚀 PRÓXIMOS PASOS DE IMPLEMENTACIÓN

### Fase 1: Base de Datos
- [x] Instalación del esquema simplificado
- [x] Configuración de datos de prueba
- [x] Validación de funciones

### Fase 2: Integración Redis
- [ ] Configuración Redis geoespacial
- [ ] Sincronización automática de geocercas
- [ ] Implementación de alertas en tiempo real

### Fase 3: Validación JTS
- [ ] Integración con JTS para polígonos
- [ ] Validación de desvíos de ruta
- [ ] Cache de geometrías complejas

### Fase 4: Dashboard Web
- [ ] Desarrollo de interface de administración
- [ ] Visualización de mapas en tiempo real
- [ ] Reportes ejecutivos automatizados

---

**Documento generado:** Junio 2025  
**Versión del Sistema:** 2.0 Simplificada  
**Arquitectura:** PostgreSQL + Redis + JTS  
**Estado:** Lista para Implementación