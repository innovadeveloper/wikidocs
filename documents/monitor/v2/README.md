# DICCIONARIO DE DATOS - SISTEMA DE GESTIÓN DE TRANSPORTE

**Versión:** 3.0  
**Fecha:** Diciembre 2024  
**Base de Datos:** PostgreSQL 14+  
**Arquitectura:** 1 BD por cliente (aislamiento total)

---

## SCHEMAS (v2) :

### **Schema: `identity`**
```
1.  user                       -- Usuarios del sistema (LDAP/WSO2)
2.  user_company_access        -- Acceso de usuarios a empresas
3.  user_permission            -- Permisos granulares por usuario y empresa
4.  user_session               -- Sesiones activas y auditoría
5.  permission                 -- Catálogo de permisos del sistema
6.  permission_template        -- Plantillas reutilizables de permisos
7.  permission_template_detail -- Detalle de permisos en plantillas
8.  activity_log               -- Auditoría de acciones de usuarios
9.  login_attempt              -- Intentos de autenticación
```

### **Schema: `shared`**
```
10. company                    -- Empresas de transporte
11. authority                  -- Autoridades reguladoras del transporte
12. concession                 -- Concesiones otorgadas para la operación del servicio
13. concessionaire             -- Empresas concesionarias
14. terminal                   -- Terminales de transporte
15. catalog                    -- Catálogos generales del sistema
16. document_type              -- Tipos de documentos del sistema
17. configuration              -- Parámetros de configuración del sistema
18. notification_template      -- Plantillas de notificaciones
19. file_storage              -- Archivos adjuntos del sistema
```

### **Schema: `core_operations`**
```
20. route                      -- Rutas (asignadas a empresa)
21. route_polyline             -- Geometría de visualización
22. route_stop                 -- Paradas de ruta
23. route_schedule             -- Horarios programados por ruta
24. service                    -- Servicios de transporte
25. dispatch                   -- Despachos programados
26. trip                       -- Viajes realizados
27. trip_stop                  -- Paradas de viaje
28. trip_passenger_count       -- Conteo de pasajeros
29. trip_location              -- Trackeo GPS del viaje
30. trip_speed_event           -- Eventos de velocidad
31. frequency_control          -- Control de frecuencias
32. route_compliance           -- Cumplimiento de ruta
33. incident                   -- Incidentes operativos
34. incident_photo             -- Fotos de incidentes
35. incident_resolution        -- Resolución de incidentes
36. operational_report         -- Reportes operativos consolidados
37. operational_metric         -- Métricas operativas por ruta/servicio
38. passenger_complaint        -- Quejas de pasajeros
39. complaint_followup         -- Seguimiento de quejas
40. timetable                  -- Horarios publicados
41. timetable_exception        -- Excepciones de horarios
42. schedule_change_log        -- Historial de cambios de programación
```

### **Schema: `core_finance`**
```
43. fare_table                 -- Tabla tarifaria vigente
44. fare_history               -- Historial de tarifas
45. ticket_sale                -- Venta de boletos
46. ticket_transaction         -- Transacciones de boletos
47. sale_batch                 -- Lotes de ventas consolidados
48. settlement                 -- Liquidaciones de conductores
49. settlement_detail          -- Detalle de liquidación
50. settlement_discrepancy     -- Discrepancias en liquidación
51. cash_collection            -- Recaudación de efectivo
52. cash_denomination          -- Denominaciones de billetes/monedas
53. cash_transfer              -- Transferencias entre cajas
54. cash_reconciliation        -- Conciliación de caja
55. bank_deposit               -- Depósitos bancarios
56. payment                    -- Pagos a terceros
57. invoice                    -- Facturas emitidas
58. revenue_report             -- Reportes de ingresos
59. fare_evasion_report        -- Reportes de evasión tarifaria
60. financial_closing          -- Cierres financieros
61. accounting_export          -- Exportaciones contables
```

### **Schema: `fleet`**
```
62. vehicle                    -- Vehículos de la flota
63. vehicle_photo              -- Fotos de vehículos
64. vehicle_assignment         -- Asignación vehículo-conductor
65. vehicle_maintenance        -- Mantenimientos programados
66. maintenance_task           -- Tareas de mantenimiento
67. maintenance_part           -- Repuestos utilizados
68. vehicle_fuel               -- Carga de combustible
69. vehicle_tire               -- Control de neumáticos
70. tire_rotation              -- Rotación de neumáticos
71. vehicle_insurance          -- Seguros de vehículos
72. vehicle_document           -- Documentos de vehículos
73. vehicle_gps_device         -- Dispositivos GPS
74. vehicle_inspection_schedule-- Programación de inspecciones
75. vehicle_downtime           -- Tiempos fuera de servicio
76. vehicle_cost               -- Costos operativos
```

### **Schema: `hr`**
```
77. driver                     -- Conductores
78. driver_document            -- Documentos de conductor
79. driver_license             -- Licencias de conducir
80. driver_medical_exam        -- Exámenes médicos
81. driver_training            -- Capacitaciones
82. driver_certification       -- Certificaciones
83. driver_performance         -- Evaluación de desempeño
84. driver_infraction          -- Infracciones
85. driver_sanction            -- Sanciones aplicadas
86. driver_attendance          -- Asistencia de conductores
87. driver_payroll             -- Nómina de conductores
88. payroll_deduction          -- Deducciones de nómina
89. employee                   -- Personal administrativo
90. employee_document          -- Documentos de empleados
91. employee_contract          -- Contratos laborales
92. employee_attendance        -- Asistencia de empleados
93. employee_payroll           -- Nómina administrativa
94. leave_request              -- Solicitudes de permisos
95. overtime_record            -- Registro de horas extra
96. disciplinary_action        -- Acciones disciplinarias
97. performance_review         -- Evaluaciones de desempeño
98. training_program           -- Programas de capacitación
99. training_enrollment        -- Inscripciones a capacitaciones
100. salary_advance            -- Adelantos de salario
101. benefit                   -- Beneficios laborales
```

### **Schema: `inspection`**
```
102. field_inspection          -- Inspecciones de campo
103. route_verification        -- Verificaciones de ruta
104. vehicle_inspection        -- Inspecciones de vehículos
105. inspection_finding        -- Hallazgos de inspecciones
106. inspection_evidence       -- Evidencias fotográficas
107. inspection_report         -- Reportes consolidados
```

### **Schema: `audit`**
```
108. change_log                -- Registro de cambios en entidades
109. data_retention_policy     -- Políticas de retención
110. archived_data             -- Datos archivados históricos
```

---

# EXPLAIN TABLES (V3)

## SCHEMA: `identity`

Gestión de autenticación, autorización y auditoría de accesos al sistema.

---

### **1. user**

**Descripción:** Usuarios del sistema vinculados a LDAP/WSO2 IS. Almacena solo información local necesaria para operación, la autenticación se delega completamente a WSO2.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| user_id | BIGSERIAL | PRIMARY KEY | Identificador único interno |
| external_id | VARCHAR(255) | UNIQUE, NOT NULL | LDAP DN o WSO2 subject |
| username | VARCHAR(100) | UNIQUE, NOT NULL | Nombre de usuario |
| email | VARCHAR(255) | UNIQUE, NOT NULL | Correo electrónico (cached desde LDAP) |
| full_name | VARCHAR(255) | | Nombre completo |
| is_active | BOOLEAN | DEFAULT true | Usuario activo en el sistema |
| last_login_at | TIMESTAMPTZ | | Último acceso exitoso |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **user_company_access**

**Descripción:** Define a qué empresas tiene acceso cada usuario. Base para permisos granulares, permite que un usuario opere en múltiples empresas simultáneamente.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| user_company_access_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| user_id | BIGINT | NOT NULL, FK → user | Usuario con acceso |
| company_id | INT | NOT NULL, FK → company | Empresa accesible |
| granted_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de otorgamiento |
| granted_by | BIGINT | FK → user | Usuario que otorgó acceso |
| is_active | BOOLEAN | DEFAULT true | Acceso vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **user_permission**

**Descripción:** Permisos granulares por usuario y empresa. Permite control detallado: un usuario puede tener permisos diferentes en cada empresa que opera.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| user_permission_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| user_id | BIGINT | NOT NULL | Usuario receptor |
| company_id | INT | NOT NULL | Empresa donde aplica permiso |
| permission_id | INT | NOT NULL, FK → permission | Permiso otorgado |
| granted_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de asignación |
| granted_by | BIGINT | FK → user | Usuario que otorgó permiso |
| expires_at | TIMESTAMPTZ | | Fecha de expiración (opcional) |
| is_active | BOOLEAN | DEFAULT true | Permiso vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **2. user_session**

**Descripción:** Registro de sesiones activas de usuarios para control de accesos concurrentes, cierre remoto de sesiones y auditoría de actividad en tiempo real.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| session_id | BIGSERIAL | PRIMARY KEY | Identificador único de sesión |
| user_id | BIGINT | NOT NULL, FK → user | Usuario de la sesión |
| token_jti | VARCHAR(255) | UNIQUE | JWT ID (jti claim) |
| ip_address | INET | | Dirección IP de conexión |
| user_agent | TEXT | | Navegador/dispositivo |
| login_at | TIMESTAMPTZ | DEFAULT NOW() | Inicio de sesión |
| last_activity_at | TIMESTAMPTZ | DEFAULT NOW() | Última actividad detectada |
| logout_at | TIMESTAMPTZ | | Cierre de sesión |
| is_active | BOOLEAN | DEFAULT true | Sesión activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **3. permission**

**Descripción:** Catálogo de permisos granulares del sistema organizados por módulo, recurso y acción. Permite autorización detallada independiente de roles LDAP.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| permission_id | SERIAL | PRIMARY KEY | Identificador único |
| module | VARCHAR(50) | NOT NULL | Módulo (operations, finance, hr, fleet) |
| resource | VARCHAR(100) | NOT NULL | Recurso (dispatch, settlement, driver) |
| action | VARCHAR(50) | NOT NULL | Acción (create, read, update, delete, approve) |
| code | VARCHAR(150) | UNIQUE, NOT NULL | Código único (ej: operations.dispatch.create) |
| description | TEXT | | Descripción del permiso |
| is_active | BOOLEAN | DEFAULT true | Permiso activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **4. user_permission**

**Descripción:** Asignación directa de permisos a usuarios sin usar roles intermedios. Permite flexibilidad total donde un cajero puede tener permisos de despachador y monitoreador simultáneamente.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| user_permission_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| user_id | BIGINT | NOT NULL, FK → user | Usuario receptor |
| permission_id | INT | NOT NULL, FK → permission | Permiso otorgado |
| granted_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de asignación |
| granted_by | BIGINT | FK → user | Usuario que otorgó permiso |
| expires_at | TIMESTAMPTZ | | Fecha de expiración (opcional) |
| is_active | BOOLEAN | DEFAULT true | Permiso vigente |

**Unique Constraint:** (user_id, permission_id)

---

### **5. permission_template**

**Descripción:** Plantillas reutilizables de conjuntos de permisos (ej: "Cajero Básico", "Cajero + Despachador"). Facilita asignación masiva sin obligar su uso.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| template_id | SERIAL | PRIMARY KEY | Identificador único |
| name | VARCHAR(100) | UNIQUE, NOT NULL | Nombre de la plantilla |
| description | TEXT | | Descripción del conjunto de permisos |
| is_active | BOOLEAN | DEFAULT true | Plantilla activa |
| created_by | BIGINT | FK → user | Creador de la plantilla |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **6. permission_template_detail**

**Descripción:** Detalle de permisos incluidos en cada plantilla. Relación muchos a muchos entre templates y permissions.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| template_detail_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| template_id | INT | NOT NULL, FK → permission_template | Plantilla |
| permission_id | INT | NOT NULL, FK → permission | Permiso incluido |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de inclusión |

**Unique Constraint:** (template_id, permission_id)

---

### **7. activity_log**

**Descripción:** Auditoría completa de acciones de usuarios en el sistema. Registra qué, quién, cuándo y desde dónde se realizó cada operación crítica.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| log_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| user_id | BIGINT | FK → user | Usuario que ejecutó acción |
| action | VARCHAR(100) | NOT NULL | Acción realizada |
| resource_type | VARCHAR(100) | | Tipo de recurso afectado |
| resource_id | BIGINT | | ID del recurso afectado |
| ip_address | INET | | IP desde donde se ejecutó |
| user_agent | TEXT | | Navegador/dispositivo |
| changes | JSONB | | Datos antes/después (opcional) |
| status | VARCHAR(20) | | SUCCESS, FAILED, PARTIAL |
| error_message | TEXT | | Mensaje de error si aplica |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del evento |

---

### **8. login_attempt**

**Descripción:** Registro de intentos de autenticación (exitosos y fallidos) para detectar patrones de acceso no autorizados y bloquear ataques de fuerza bruta.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| attempt_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| username | VARCHAR(100) | NOT NULL | Usuario intentado |
| ip_address | INET | NOT NULL | IP de origen |
| user_agent | TEXT | | Navegador/dispositivo |
| success | BOOLEAN | NOT NULL | Intento exitoso |
| failure_reason | VARCHAR(100) | | Razón del fallo |
| attempted_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del intento |

---

## SCHEMA: `shared`

Catálogos compartidos, configuración y entidades organizacionales base del sistema.

---

### **9. company**

**Descripción:** Empresa operadora de transporte (1 por base de datos). Representa al concesionario u operador que ejecuta las rutas autorizadas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| company_id | SERIAL | PRIMARY KEY | Identificador único |
| tax_id | VARCHAR(20) | UNIQUE, NOT NULL | RUC de la empresa |
| legal_name | VARCHAR(255) | NOT NULL | Razón social completa |
| trade_name | VARCHAR(255) | | Nombre comercial |
| address | TEXT | | Dirección legal |
| phone | VARCHAR(50) | | Teléfono principal |
| email | VARCHAR(255) | | Email corporativo |
| logo_url | VARCHAR(500) | | URL del logo |
| is_active | BOOLEAN | DEFAULT true | Empresa activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **10. concession**

**Descripción:** Concesión otorgada por autoridad reguladora. Representa el marco legal bajo el cual opera la empresa en determinadas rutas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| concession_id | SERIAL | PRIMARY KEY | Identificador único |
| authority_id | INT | NOT NULL, FK → authority | Autoridad otorgante |
| concession_code | VARCHAR(50) | UNIQUE, NOT NULL | Código oficial de concesión |
| concession_name | VARCHAR(255) | NOT NULL | Nombre descriptivo |
| grant_date | DATE | NOT NULL | Fecha de otorgamiento |
| expiry_date | DATE | | Fecha de vencimiento |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, SUSPENDED, EXPIRED |
| terms_document_url | VARCHAR(500) | | URL del documento de términos |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **11. concessionaire**

**Descripción:** Concesionario titular de la concesión. Puede ser la misma empresa operadora o un consorcio diferente que subcontrata operación.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| concessionaire_id | SERIAL | PRIMARY KEY | Identificador único |
| tax_id | VARCHAR(20) | UNIQUE, NOT NULL | RUC del concesionario |
| legal_name | VARCHAR(255) | NOT NULL | Razón social |
| concession_id | INT | FK → concession | Concesión asociada |
| is_active | BOOLEAN | DEFAULT true | Concesionario activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **12. authority**

**Descripción:** Autoridades reguladoras del transporte (ATU, municipalidades). Entidad que otorga concesiones y supervisa cumplimiento normativo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| authority_id | SERIAL | PRIMARY KEY | Identificador único |
| name | VARCHAR(255) | NOT NULL | Nombre de la autoridad |
| acronym | VARCHAR(20) | | Siglas (ATU, MML) |
| jurisdiction | VARCHAR(100) | | Ámbito de jurisdicción |
| contact_email | VARCHAR(255) | | Email de contacto |
| contact_phone | VARCHAR(50) | | Teléfono de contacto |
| is_active | BOOLEAN | DEFAULT true | Autoridad vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |


---

### **14. catalog**

**Descripción:** Catálogo genérico tipo clave-valor para listas parametrizables (estados, tipos, categorías). Evita crear tablas para cada enumeración.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| catalog_id | SERIAL | PRIMARY KEY | Identificador único |
| category | VARCHAR(50) | NOT NULL | Categoría (vehicle_status, trip_status) |
| code | VARCHAR(50) | NOT NULL | Código único en categoría |
| name | VARCHAR(100) | NOT NULL | Nombre descriptivo |
| description | TEXT | | Descripción detallada |
| display_order | INT | DEFAULT 0 | Orden de visualización |
| is_active | BOOLEAN | DEFAULT true | Valor activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

**Unique Constraint:** (category, code)

---

### **15. document_type**

**Descripción:** Catálogo de los 14 tipos de documentos obligatorios para conductores (licencia, DNI, antecedentes, exámenes médicos, etc.) según normativa ATU.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| document_type_id | SERIAL | PRIMARY KEY | Identificador único |
| code | VARCHAR(50) | UNIQUE, NOT NULL | Código único (LICENSE, DNI, SOAT) |
| name | VARCHAR(100) | NOT NULL | Nombre del documento |
| description | TEXT | | Descripción detallada |
| is_mandatory | BOOLEAN | DEFAULT true | Documento obligatorio |
| requires_expiry | BOOLEAN | DEFAULT false | Tiene fecha de vencimiento |
| alert_days_before | INT | | Días de anticipación para alertar |
| restriction_type | VARCHAR(20) | | CRITICAL, WARNING, NONE |
| is_active | BOOLEAN | DEFAULT true | Tipo vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **16. configuration**

**Descripción:** Parámetros globales del sistema tipo clave-valor. Permite ajustar comportamiento sin redeployar código (intervalos, límites, flags).

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| config_id | SERIAL | PRIMARY KEY | Identificador único |
| config_key | VARCHAR(100) | UNIQUE, NOT NULL | Clave de configuración |
| config_value | TEXT | NOT NULL | Valor del parámetro |
| data_type | VARCHAR(20) | DEFAULT 'STRING' | STRING, INTEGER, BOOLEAN, JSON |
| category | VARCHAR(50) | | Categoría (SYSTEM, OPERATIONS, FINANCE) |
| description | TEXT | | Descripción del parámetro |
| is_editable | BOOLEAN | DEFAULT true | Permite edición desde UI |
| updated_by | BIGINT | FK → user | Usuario que actualizó |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **17. notification_template**

**Descripción:** Plantillas de notificaciones (email, SMS, push) para eventos del sistema. Soporta variables dinámicas para personalización.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| template_id | SERIAL | PRIMARY KEY | Identificador único |
| code | VARCHAR(50) | UNIQUE, NOT NULL | Código identificador |
| name | VARCHAR(100) | NOT NULL | Nombre de la plantilla |
| channel | VARCHAR(20) | NOT NULL | EMAIL, SMS, PUSH, IN_APP |
| subject | VARCHAR(255) | | Asunto (para email) |
| body_template | TEXT | NOT NULL | Cuerpo con variables {{variable}} |
| variables | JSONB | | Lista de variables disponibles |
| is_active | BOOLEAN | DEFAULT true | Plantilla activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **18. file_storage**

**Descripción:** Registro de archivos almacenados externamente (S3/MinIO). Vincula URLs de archivos adjuntos con entidades del sistema (documentos, evidencias).

| Campo | Tipo | Restriccientos | Descripción |
|-------|------|---------------|-------------|
| file_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| file_name | VARCHAR(255) | NOT NULL | Nombre original del archivo |
| file_path | VARCHAR(500) | NOT NULL | Ruta/key en storage |
| file_url | VARCHAR(500) | | URL pública de acceso |
| file_size_bytes | BIGINT | | Tamaño en bytes |
| mime_type | VARCHAR(100) | | Tipo MIME |
| entity_type | VARCHAR(100) | | Tipo de entidad asociada |
| entity_id | BIGINT | | ID de la entidad |
| uploaded_by | BIGINT | FK → user | Usuario que subió |
| expires_at | TIMESTAMPTZ | | Fecha de expiración (temporal) |
| is_public | BOOLEAN | DEFAULT false | Acceso público |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de carga |

---

## SCHEMA: `core_operations`

Núcleo operativo del sistema: rutas, despachos, viajes, monitoreo GPS y gestión de frecuencias.

---

### **terminal**

**Descripción:** Terminales operativos exclusivos por ruta. Cada ruta tiene sus propios terminales (Lado A y B) con configuración independiente de geocercas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| terminal_id | SERIAL | PRIMARY KEY | Identificador único |
| route_id | INT | NOT NULL, FK → route | Ruta propietaria del terminal |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| name | VARCHAR(255) | NOT NULL | Nombre del terminal |
| code | VARCHAR(20) | | Código identificador |
| side_code | VARCHAR(1) | NOT NULL, CHECK | Lado de ruta: 'A' o 'B' |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud GPS |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud GPS |
| geofence_radius_meters | INT | DEFAULT 100 | Radio de geocerca (metros) |
| address | TEXT | | Dirección física |
| has_infrastructure | BOOLEAN | DEFAULT false | Infraestructura física disponible |
| is_active | BOOLEAN | DEFAULT true | Terminal operativo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |


---

### **19. route**

**Descripción:** Rutas de transporte asignadas a la empresa. Define recorridos autorizados con código oficial otorgado por la autoridad.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| route_id | SERIAL | PRIMARY KEY | Identificador único |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| concession_id | INT | FK → concession | Concesión bajo la cual opera |
| code | VARCHAR(20) | UNIQUE, NOT NULL | Código oficial de ruta |
| name | VARCHAR(100) | NOT NULL | Nombre descriptivo |
| route_type | VARCHAR(20) | NOT NULL | LINEAR, CIRCULAR |
| color | VARCHAR(7) | DEFAULT '#0066CC' | Color hex para visualización |
| is_bidirectional | BOOLEAN | DEFAULT true | Ruta con ida y vuelta |
| total_distance_km | DECIMAL(6,2) | | Distancia total del recorrido |
| estimated_duration_minutes | INT | | Duración estimada |
| is_active | BOOLEAN | DEFAULT true | Ruta operativa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **20. route_polyline**

**Descripción:** Geometrías de rutas para visualización en mapas. Almacena trazado de líneas (polilíneas) sin usarse para cálculos de proximidad GPS.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| polyline_id | SERIAL | PRIMARY KEY | Identificador único |
| route_id | INT | NOT NULL, FK → route | Ruta asociada |
| name | VARCHAR(100) | NOT NULL | Nombre del segmento |
| direction | VARCHAR(20) | NOT NULL | IDA, VUELTA, BIDIRECCIONAL |
| coordinates_json | JSONB | NOT NULL | GeoJSON LineString |
| encoded_polyline | TEXT | | Polyline codificada (Google) |
| color | VARCHAR(7) | | Color específico del segmento |
| stroke_width | INT | DEFAULT 4 | Ancho de línea |
| stroke_opacity | DECIMAL(3,2) | DEFAULT 0.8 | Opacidad (0.0-1.0) |
| segment_distance_km | DECIMAL(6,2) | | Distancia del segmento |
| is_active | BOOLEAN | DEFAULT true | Segmento activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **21. route_side**

**Descripción:** Lados de ruta (Lado A / Lado B) para rutas lineales. Define terminal de origen/destino por dirección de recorrido.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| route_side_id | SERIAL | PRIMARY KEY | Identificador único |
| route_id | INT | NOT NULL, FK → route | Ruta asociada |
| side_code | VARCHAR(1) | NOT NULL | A, B |
| terminal_id | INT | NOT NULL, FK → terminal | Terminal del lado |
| direction_name | VARCHAR(100) | | Nombre dirección (IDA, VUELTA) |
| is_active | BOOLEAN | DEFAULT true | Lado operativo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

**Unique Constraint:** (route_id, side_code)

---

### **22. stop**

**Descripción:** Paraderos oficiales de las rutas. Puntos georeferenciados donde las unidades deben detenerse obligatoriamente según recorrido autorizado.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| stop_id | SERIAL | PRIMARY KEY | Identificador único |
| route_id | INT | NOT NULL, FK → route | Ruta asociada |
| name | VARCHAR(255) | NOT NULL | Nombre del paradero |
| code | VARCHAR(50) | | Código identificador |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud GPS |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud GPS |
| geofence_radius_meters | INT | DEFAULT 50 | Radio de detección |
| sequence_order | INT | NOT NULL | Orden en recorrido |
| direction | VARCHAR(20) | | IDA, VUELTA, BOTH |
| stop_type | VARCHAR(20) | | TERMINAL, MAIN, INTERMEDIATE |
| is_mandatory | BOOLEAN | DEFAULT false | Parada obligatoria |
| is_active | BOOLEAN | DEFAULT true | Paradero operativo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **stop_event**

**Descripción:** Eventos de paso por paraderos (llegada/salida). Registra timestamp, pasajeros y tiempo de detención para análisis operativo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| stop_event_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| stop_id | INT | NOT NULL, FK → stop | Paradero asociado |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo |
| driver_id | INT | FK → driver | Conductor |
| trip_id | BIGINT | FK → trip | Viaje asociado |
| event_type | VARCHAR(20) | NOT NULL | ARRIVAL, DEPARTURE |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud del evento |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud del evento |
| distance_to_stop_meters | INT | | Distancia al centro paradero |
| passengers_boarded | INT | DEFAULT 0 | Pasajeros subidos |
| passengers_alighted | INT | DEFAULT 0 | Pasajeros bajados |
| dwell_time_seconds | INT | | Tiempo detenido (para DEPARTURE) |
| is_on_schedule | BOOLEAN | | Dentro de horario esperado |
| schedule_deviation_seconds | INT | | Desviación del horario |
| event_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp del evento |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **23. checkpoint**

**Descripción:** Controles de paso con tiempos máximos/mínimos esperados. Validan cumplimiento de recorrido y detectan desvíos o demoras excesivas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| checkpoint_id | SERIAL | PRIMARY KEY | Identificador único |
| route_id | INT | NOT NULL, FK → route | Ruta asociada |
| name | VARCHAR(255) | NOT NULL | Nombre del control |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud GPS |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud GPS |
| geofence_radius_meters | INT | DEFAULT 50 | Radio de detección |
| sequence_order | INT | NOT NULL | Orden en recorrido |
| direction | VARCHAR(20) | | IDA, VUELTA, BOTH |
| min_time_minutes | INT | | Tiempo mínimo esperado |
| max_time_minutes | INT | | Tiempo máximo esperado |
| is_critical | BOOLEAN | DEFAULT false | Control crítico |
| is_active | BOOLEAN | DEFAULT true | Control operativo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **checkpoint_event**

**Descripción:** Eventos de paso por controles de tiempo. Valida cumplimiento de tiempos esperados y detecta retrasos/adelantos.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| checkpoint_event_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| checkpoint_id | INT | NOT NULL, FK → checkpoint | Control asociado |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo |
| driver_id | INT | FK → driver | Conductor |
| trip_id | BIGINT | FK → trip | Viaje asociado |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud del evento |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud del evento |
| distance_to_checkpoint_meters | INT | | Distancia al centro control |
| elapsed_time_minutes | INT | NOT NULL | Minutos desde inicio viaje |
| expected_time_minutes | INT | | Tiempo esperado (promedio min/max) |
| is_on_time | BOOLEAN | NOT NULL | Dentro de rango min/max |
| deviation_minutes | INT | | Desviación del tiempo óptimo |
| status | VARCHAR(20) | NOT NULL | ON_TIME, EARLY, LATE |
| event_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp del evento |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **24. speed_zone**

**Descripción:** Zonas con límites de velocidad específicos. Genera alertas cuando unidades exceden velocidad máxima permitida en sectores determinados.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| speed_zone_id | SERIAL | PRIMARY KEY | Identificador único |
| route_id | INT | FK → route | Ruta asociada (opcional) |
| name | VARCHAR(255) | NOT NULL | Nombre de la zona |
| zone_type | VARCHAR(20) | | SCHOOL, RESIDENTIAL, HIGHWAY |
| coordinates_json | JSONB | NOT NULL | GeoJSON Polygon |
| max_speed_kmh | INT | NOT NULL | Velocidad máxima permitida |
| alert_threshold_kmh | INT | | Umbral para alerta |
| is_active | BOOLEAN | DEFAULT true | Zona activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **28. frequency_schedule**

**Descripción:** Frecuencias objetivo por ruta y franja horaria. Define intervalos esperados entre despachos según demanda histórica (pico, valle).

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| frequency_schedule_id | SERIAL | PRIMARY KEY | Identificador único |
| route_id | INT | NOT NULL, FK → route | Ruta asociada |
| day_type | VARCHAR(20) | NOT NULL | WEEKDAY, SATURDAY, SUNDAY, HOLIDAY |
| time_start | TIME | NOT NULL | Inicio de franja |
| time_end | TIME | NOT NULL | Fin de franja |
| target_frequency_minutes | INT | NOT NULL | Frecuencia objetivo |
| min_frequency_minutes | INT | | Frecuencia mínima aceptable |
| max_frequency_minutes | INT | | Frecuencia máxima aceptable |
| required_vehicles | INT | | Vehículos necesarios |
| is_active | BOOLEAN | DEFAULT true | Configuración activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **29. operational_restriction**

**Descripción:** Restricciones operativas aplicadas a conductores o vehículos. Pueden bloquear despacho (depende de restriction_type.blocks_dispatch) hasta resolución (documentos vencidos, deuda, mantenimiento).

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| restriction_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| restriction_type_id | INT | NOT NULL, FK → restriction_type | Tipo de restricción |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| entity_type | VARCHAR(20) | NOT NULL | DRIVER, VEHICLE |
| entity_id | BIGINT | NOT NULL | ID del conductor o vehículo |
| severity | VARCHAR(20) | NOT NULL | CRITICAL, WARNING, INFO |
| reason | TEXT | NOT NULL | Motivo de la restricción |
| applied_by | BIGINT | FK → user | Usuario que aplicó |
| applied_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de aplicación |
| expires_at | TIMESTAMPTZ | | Vencimiento automático |
| resolved_at | TIMESTAMPTZ | | Fecha de resolución |
| resolved_by | BIGINT | FK → user | Usuario que resolvió |
| resolution_notes | TEXT | | Notas de resolución |
| is_active | BOOLEAN | DEFAULT true | Restricción vigente |

---

### **30. restriction_type**

**Descripción:** Catálogo de tipos de restricciones con reglas de negocio. Define comportamiento y nivel de bloqueo para cada caso.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| restriction_type_id | SERIAL | PRIMARY KEY | Identificador único |
| code | VARCHAR(50) | UNIQUE, NOT NULL | Código (DOC_EXPIRED, LOW_FUEL, DEBT) |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | Descripción detallada |
| default_severity | VARCHAR(20) | NOT NULL | Severidad por defecto |
| blocks_dispatch | BOOLEAN | DEFAULT true | Bloquea despacho |
| requires_approval | BOOLEAN | DEFAULT false | Requiere autorización supervisor |
| is_active | BOOLEAN | DEFAULT true | Tipo activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **31. dispatch_schedule**

**Descripción:** Programación maestra de salidas elaborada por Analista de Operaciones. Define horarios planificados para día siguiente según demanda.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| dispatch_schedule_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| route_id | INT | NOT NULL, FK → route | Ruta programada |
| terminal_id | INT | NOT NULL, FK → terminal | Terminal de salida |
| schedule_date | DATE | NOT NULL | Fecha programada |
| schedule_type | VARCHAR(20) | DEFAULT 'REGULAR' | REGULAR, SPECIAL, HOLIDAY |
| created_by | BIGINT | NOT NULL, FK → user | Analista creador |
| approved_by | BIGINT | FK → user | Jefe que aprobó |
| status | VARCHAR(20) | DEFAULT 'DRAFT' | DRAFT, APPROVED, ACTIVE, CANCELLED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **32. dispatch_schedule_detail**

**Descripción:** Detalle horario de cada salida programada. Lista completa de horarios con vehículo y conductor asignado idealmente.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| schedule_detail_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| dispatch_schedule_id | BIGINT | NOT NULL, FK → dispatch_schedule | Programación maestra |
| scheduled_time | TIME | NOT NULL | Hora programada de salida |
| sequence_number | INT | NOT NULL | Número secuencial |
| vehicle_id | INT | FK | Vehículo asignado (opcional) |
| driver_id | INT | FK | Conductor asignado (opcional) |
| side_code | VARCHAR(1) | | A o B (lado de ruta) |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **33. dispatch_queue**

**Descripción:** Cola de despacho en tiempo real. Unidades en espera ordenadas por llegada, prioridad o programación para autorización del despachador.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| queue_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| terminal_id | INT | NOT NULL, FK → terminal | Terminal de cola |
| route_id | INT | NOT NULL, FK → route | Ruta solicitada |
| vehicle_id | INT | NOT NULL | Vehículo en cola |
| driver_id | INT | NOT NULL | Conductor asignado |
| side_code | VARCHAR(1) | | Lado de ruta (A/B) |
| entry_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Ingreso a cola |
| scheduled_time | TIMESTAMPTZ | | Hora programada (opcional) |
| queue_position | INT | | Posición en cola |
| entry_type | VARCHAR(20) | DEFAULT 'MANUAL' | MANUAL, AUTOMATIC, PRIORITY |
| status | VARCHAR(20) | DEFAULT 'WAITING' | WAITING, DISPATCHED, CANCELLED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **34. dispatch**

**Descripción:** Registro oficial de despachos autorizados. Captura momento exacto de salida, despachador que autorizó y validaciones pasadas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| dispatch_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| queue_id | BIGINT | FK → dispatch_queue | Cola de origen |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| schedule_detail_id | BIGINT | FK → dispatch_schedule_detail | Programación origen |
| route_id | INT | NOT NULL, FK → route | Ruta autorizada |
| vehicle_id | INT | NOT NULL | Vehículo despachado |
| driver_id | INT | NOT NULL | Conductor autorizado |
| terminal_id | INT | NOT NULL, FK → terminal | Terminal de salida |
| side_code | VARCHAR(1) | | Lado de ruta |
| scheduled_time | TIMESTAMPTZ | | Hora programada |
| actual_dispatch_time | TIMESTAMPTZ | NOT NULL | Hora real de salida |
| dispatched_by | BIGINT | NOT NULL, FK → user | Despachador que autorizó |
| dispatch_type | VARCHAR(20) | DEFAULT 'NORMAL' | NORMAL, EMERGENCY, REPLACEMENT |
| validations_passed | JSONB | | Validaciones aprobadas |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **35. dispatch_exception**

**Descripción:** Excepciones autorizadas durante despacho. Registra casos donde se permitió salida a pesar de restricciones menores con aprobación supervisor.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| exception_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| dispatch_id | BIGINT | NOT NULL, FK → dispatch | Despacho afectado |
| restriction_id | BIGINT | FK → operational_restriction | Restricción omitida |
| exception_type | VARCHAR(50) | NOT NULL | Tipo de excepción |
| reason | TEXT | NOT NULL | Justificación |
| authorized_by | BIGINT | NOT NULL, FK → user | Supervisor que autorizó |
| authorization_level | VARCHAR(20) | NOT NULL | DISPATCHER, SUPERVISOR, MANAGER |
| expires_at | TIMESTAMPTZ | | Vigencia de la excepción |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de autorización |

---

### **36. trip**

**Descripción:** Viajes ejecutados por vehículos. Representa cada servicio desde salida hasta retorno con eventos, producción y estado final.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| trip_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| dispatch_id | BIGINT | NOT NULL, FK → dispatch | Despacho origen |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| route_id | INT | NOT NULL, FK → route | Ruta recorrida |
| vehicle_id | INT | NOT NULL | Vehículo operado |
| driver_id | INT | NOT NULL | Conductor asignado |
| start_terminal_id | INT | NOT NULL, FK → terminal | Terminal de inicio |
| end_terminal_id | INT | FK → terminal | Terminal de fin |
| start_timestamp | TIMESTAMPTZ | NOT NULL | Inicio del viaje |
| end_timestamp | TIMESTAMPTZ | | Fin del viaje |
| planned_distance_km | DECIMAL(6,2) | | Distancia planificada |
| actual_distance_km | DECIMAL(6,2) | | Distancia real recorrida |
| planned_duration_minutes | INT | | Duración planificada |
| actual_duration_minutes | INT | | Duración real |
| status | VARCHAR(20) | DEFAULT 'IN_PROGRESS' | IN_PROGRESS, COMPLETED, CANCELLED |
| completion_percentage | INT | DEFAULT 0 | Porcentaje completado |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

**Particionada por:** start_timestamp (mensual)

---

### **38. incident**

**Descripción:** Incidencias operativas reportadas (averías, accidentes, bloqueos de vía, conflictos). Seguimiento hasta resolución con evidencias adjuntas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| incident_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| incident_type_id | INT | NOT NULL, FK → incident_type | Tipo de incidencia |
| trip_id | BIGINT | FK → trip | Viaje afectado (opcional) |
| vehicle_id | INT | NOT NULL | Vehículo involucrado |
| driver_id | INT | FK | Conductor involucrado |
| route_id | INT | FK → route | Ruta afectada |
| latitude | DECIMAL(10,8) | | Ubicación del incidente |
| longitude | DECIMAL(11,8) | | Ubicación del incidente |
| reported_by | BIGINT | NOT NULL, FK → user | Usuario que reportó |
| reported_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del reporte |
| description | TEXT | NOT NULL | Descripción detallada |
| severity | VARCHAR(20) | NOT NULL | LOW, MEDIUM, HIGH, CRITICAL |
| status | VARCHAR(20) | DEFAULT 'OPEN' | OPEN, IN_PROGRESS, RESOLVED, CLOSED |
| assigned_to | BIGINT | FK → user | Responsable asignado |
| resolved_at | TIMESTAMPTZ | | Fecha de resolución |
| resolution_notes | TEXT | | Notas de resolución |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **39. incident_type**

**Descripción:** Catálogo de tipos de incidencias con protocolos de respuesta. Define escalamiento y prioridad según gravedad.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| incident_type_id | SERIAL | PRIMARY KEY | Identificador único |
| code | VARCHAR(50) | UNIQUE, NOT NULL | Código (BREAKDOWN, ACCIDENT, BLOCKAGE) |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | Descripción del protocolo |
| default_severity | VARCHAR(20) | NOT NULL | Severidad por defecto |
| requires_immediate_response | BOOLEAN | DEFAULT false | Respuesta inmediata |
| escalation_minutes | INT | | Minutos para escalar |
| is_active | BOOLEAN | DEFAULT true | Tipo activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **40. alert**

**Descripción:** Alertas generadas automáticamente por sistema (exceso velocidad, desvío de ruta, documentos vencidos). Requieren atención de monitoreador.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| alert_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| alert_type_id | INT | NOT NULL, FK → alert_type | Tipo de alerta |
| vehicle_id | INT | FK | Vehículo afectado |
| driver_id | INT | FK | Conductor afectado |
| trip_id | BIGINT | FK → trip | Viaje asociado |
| severity | VARCHAR(20) | NOT NULL | INFO, WARNING, CRITICAL |
| message | TEXT | NOT NULL | Mensaje descriptivo |
| context_data | JSONB | | Datos adicionales |
| triggered_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp de activación |
| acknowledged_by | BIGINT | FK → user | Usuario que atendió |
| acknowledged_at | TIMESTAMPTZ | | Fecha de atención |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, ACKNOWLEDGED, RESOLVED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

**Particionada por:** triggered_at (semanal)

---

### **41. alert_type**

**Descripción:** Catálogo de tipos de alertas con reglas de activación. Define condiciones y umbrales para generación automática.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| alert_type_id | SERIAL | PRIMARY KEY | Identificador único |
| code | VARCHAR(50) | UNIQUE, NOT NULL | Código (SPEED_LIMIT, ROUTE_DEVIATION) |
| name | VARCHAR(100) | NOT NULL | Nombre de la alerta |
| description | TEXT | | Descripción de la condición |
| default_severity | VARCHAR(20) | NOT NULL | Severidad por defecto |
| is_enabled | BOOLEAN | DEFAULT true | Alerta habilitada |
| threshold_config | JSONB | | Configuración de umbrales |
| notification_channels | VARCHAR[] | | Canales de notificación |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

## SCHEMA: `core_finance`

Gestión financiera: tarifas, boletos, recaudo, liquidaciones y cálculo de producción.

---

### **42. fare**

**Descripción:** Tarifas vigentes por tipo de boleto. Define precios autorizados según categoría de pasajero y tipo de servicio.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| fare_id | SERIAL | PRIMARY KEY | Identificador único |
| ticket_type_id | INT | NOT NULL, FK → ticket_type | Tipo de boleto asociado |
| route_id | INT | FK → route | Ruta específica (opcional) |
| amount | DECIMAL(10,2) | NOT NULL | Monto de la tarifa |
| currency | VARCHAR(3) | DEFAULT 'PEN' | Código moneda (ISO 4217) |
| valid_from | DATE | NOT NULL | Inicio de vigencia |
| valid_until | DATE | | Fin de vigencia |
| is_active | BOOLEAN | DEFAULT true | Tarifa activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **43. ticket_type**

**Descripción:** Tipos de boletos disponibles (DIRECTO, URBANO, ESTUDIANTE, ESCOLAR). Catálogo de categorías tarifarias según normativa.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| ticket_type_id | SERIAL | PRIMARY KEY | Identificador único |
| code | VARCHAR(50) | UNIQUE, NOT NULL | Código (DIRECTO, URBANO, STUDENT) |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | Descripción detallada |
| requires_validation | BOOLEAN | DEFAULT false | Requiere validación especial |
| color | VARCHAR(7) | | Color para identificación |
| is_active | BOOLEAN | DEFAULT true | Tipo activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **44. ticket_inventory**

**Descripción:** Inventario de boletos físicos en almacén central. Control de stock por serie, talonario y estado (disponible, asignado, agotado).

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| inventory_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| ticket_type_id | INT | NOT NULL, FK → ticket_type | Tipo de boleto |
| series | VARCHAR(10) | NOT NULL | Serie del talonario |
| start_number | BIGINT | NOT NULL | Número inicial |
| end_number | BIGINT | NOT NULL | Número final |
| total_tickets | INT | NOT NULL | Total de boletos |
| available_tickets | INT | NOT NULL | Boletos disponibles |
| status | VARCHAR(20) | DEFAULT 'AVAILABLE' | AVAILABLE, ASSIGNED, EXHAUSTED |
| received_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de recepción |
| received_by | BIGINT | FK → user | Usuario que recibió |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

**Unique Constraint:** (series, start_number, end_number)

---

### **45. ticket_batch**

**Descripción:** Lotes de talonarios físicos. Agrupa múltiples rangos de numeración para facilitar control de entregas y distribución.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| batch_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| batch_code | VARCHAR(50) | UNIQUE, NOT NULL | Código del lote |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| ticket_type_id | INT | NOT NULL, FK → ticket_type | Tipo de boleto |
| total_booklets | INT | NOT NULL | Total de talonarios |
| total_tickets | INT | NOT NULL | Total de boletos |
| status | VARCHAR(20) | DEFAULT 'IN_STOCK' | IN_STOCK, DISTRIBUTED, DEPLETED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **46. ticket_batch_assignment**

**Descripción:** Salida de almacén hacia cajeros. Registra entrega de lotes de talonarios del almacén central a cajeros de terminal.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| assignment_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| batch_id | BIGINT | NOT NULL, FK → ticket_batch | Lote asignado |
| inventory_id | BIGINT | NOT NULL, FK → ticket_inventory | Inventario específico |
| assigned_to_user | BIGINT | NOT NULL, FK → user | Cajero receptor |
| terminal_id | INT | FK → terminal | Terminal destino |
| quantity_assigned | INT | NOT NULL | Cantidad asignada |
| assigned_by | BIGINT | NOT NULL, FK → user | Almacenero que entregó |
| assigned_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de asignación |
| received_at | TIMESTAMPTZ | | Fecha de recepción confirmada |
| document_number | VARCHAR(50) | | Guía de salida |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **47. ticket_supply**

**Descripción:** Suministro de talonarios de cajero a conductor antes de salida. Registra entrega de boletos físicos para venta en ruta.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| supply_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| assignment_id | BIGINT | NOT NULL, FK → ticket_batch_assignment | Asignación origen |
| driver_id | INT | NOT NULL | Conductor receptor |
| vehicle_id | INT | NOT NULL | Vehículo asignado |
| dispatch_id | BIGINT | FK → dispatch | Despacho asociado |
| series | VARCHAR(10) | NOT NULL | Serie del talonario |
| start_number | BIGINT | NOT NULL | Número inicial entregado |
| end_number | BIGINT | NOT NULL | Número final entregado |
| quantity_supplied | INT | NOT NULL | Cantidad entregada |
| supplied_by | BIGINT | NOT NULL, FK → user | Cajero que entregó |
| supplied_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de entrega |
| returned_at | TIMESTAMPTZ | | Fecha de devolución |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, RETURNED, SETTLED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### `ticket_supply_movement`

**Descripción:** Historial de movimientos de talonarios entre actores. Registra transferencias, entregas parciales y devoluciones.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| movement_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| supply_id | BIGINT | NOT NULL, FK → ticket_supply | Suministro origen |
| movement_type | VARCHAR(20) | NOT NULL | INITIAL_SUPPLY, PARTIAL_RETURN, TRANSFER, FULL_RETURN |
| from_actor_type | VARCHAR(20) | | CASHIER, DRIVER |
| from_actor_id | BIGINT | | ID del entregador |
| to_actor_type | VARCHAR(20) | NOT NULL | CASHIER, DRIVER |
| to_actor_id | BIGINT | NOT NULL | ID del receptor |
| from_vehicle_id | INT | FK → vehicle | Vehículo origen (si aplica) |
| to_vehicle_id | INT | FK → vehicle | Vehículo destino (si aplica) |
| series | VARCHAR(10) | NOT NULL | Serie del talonario |
| start_number | BIGINT | NOT NULL | Número inicial transferido |
| end_number | BIGINT | NOT NULL | Número final transferido |
| quantity | INT | NOT NULL | Cantidad transferida |
| reason | TEXT | | Motivo del movimiento |
| movement_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del movimiento |
| registered_by | BIGINT | FK → user | Usuario que registró |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **48. validator**

**Descripción:** Ticketeras/validadores electrónicos (máquinas expendedoras). Dispositivos instalados en vehículos para venta digital de boletos.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| validator_id | SERIAL | PRIMARY KEY | Identificador único |
| serial_number | VARCHAR(50) | UNIQUE, NOT NULL | Número de serie del dispositivo |
| model | VARCHAR(100) | | Modelo del validador |
| manufacturer | VARCHAR(100) | | Fabricante |
| firmware_version | VARCHAR(50) | | Versión de firmware |
| sim_card_number | VARCHAR(20) | | Número de SIM |
| last_sync_at | TIMESTAMPTZ | | Última sincronización |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, INACTIVE, MAINTENANCE |
| is_operational | BOOLEAN | DEFAULT true | Operativo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **49. validator_assignment**

**Descripción:** Asignación de validador a vehículo. Vincula ticketera electrónica con unidad vehicular para control de recaudo digital.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| assignment_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| validator_id | INT | NOT NULL, FK → validator | Validador asignado |
| vehicle_id | INT | NOT NULL | Vehículo receptor |
| assigned_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de instalación |
| assigned_by | BIGINT | FK → user | Usuario que instaló |
| removed_at | TIMESTAMPTZ | | Fecha de retiro |
| removed_by | BIGINT | FK → user | Usuario que retiró |
| is_active | BOOLEAN | DEFAULT true | Asignación vigente |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

**Unique Constraint:** validator_id (WHERE is_active = true)

---

### **50. trip_production**

**Descripción:** Producción por viaje (boletos vendidos y monto recaudado). Generado automáticamente por validador o registrado manualmente por conductor.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| production_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| trip_id | BIGINT | NOT NULL, FK → trip | Viaje asociado |
| validator_id | INT | FK → validator | Validador usado (si aplica) |
| supply_id | BIGINT | FK → ticket_supply | Suministro manual (si aplica) |
| ticket_type_id | INT | NOT NULL, FK → ticket_type | Tipo de boleto |
| quantity_sold | INT | NOT NULL | Boletos vendidos |
| unit_price | DECIMAL(10,2) | NOT NULL | Precio unitario |
| total_amount | DECIMAL(10,2) | NOT NULL | Monto total |
| start_ticket_number | BIGINT | | Número inicial (manual) |
| end_ticket_number | BIGINT | | Número final (manual) |
| recorded_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp de registro |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

**Particionada por:** recorded_at (mensual)

---

### **expense_type**

**Descripción:** Catálogo de tipos de gastos operativos permitidos. Define categorías y validaciones para gastos reportados por conductores.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| expense_type_id | SERIAL | PRIMARY KEY | Identificador único |
| code | VARCHAR(50) | UNIQUE, NOT NULL | Código (TOLL, FUEL, FINE, PARKING, MEAL, MAINTENANCE, OTHER) |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | Descripción detallada |
| requires_receipt | BOOLEAN | DEFAULT false | Requiere comprobante |
| max_amount_per_trip | DECIMAL(10,2) | | Monto máximo permitido por viaje |
| is_reimbursable | BOOLEAN | DEFAULT true | Reembolsable al conductor |
| is_active | BOOLEAN | DEFAULT true | Tipo activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **trip_expense**

**Descripción:** Gastos operativos reportados por conductor durante viaje. Se descuentan de la producción en liquidación final.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| expense_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| trip_id | BIGINT | NOT NULL, FK → trip | Viaje asociado |
| driver_id | INT | NOT NULL, FK → driver | Conductor que reportó |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo operado |
| expense_type_id | INT | NOT NULL, FK → expense_type | Tipo de gasto |
| amount | DECIMAL(10,2) | NOT NULL | Monto del gasto |
| description | TEXT | | Descripción del gasto |
| location | VARCHAR(255) | | Ubicación donde se realizó |
| receipt_number | VARCHAR(100) | | Número de comprobante |
| receipt_file_id | BIGINT | FK → file_storage | Foto del comprobante |
| reported_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de reporte |
| approved_by | BIGINT | FK → user | Jefe que aprobó |
| approved_at | TIMESTAMPTZ | | Fecha de aprobación |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, APPROVED, REJECTED |
| rejection_reason | TEXT | | Motivo de rechazo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |



---

### **51. partial_delivery**

**Descripción:** Entregas parciales de efectivo durante jornada. Conductor entrega efectivo al cajero después de cada vuelta sin cerrar caja.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| delivery_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| trip_id | BIGINT | FK → trip | Viaje asociado |
| driver_id | INT | NOT NULL | Conductor que entrega |
| vehicle_id | INT | NOT NULL | Vehículo operado |
| received_by | BIGINT | NOT NULL, FK → user | Cajero receptor |
| amount_delivered | DECIMAL(10,2) | NOT NULL | Efectivo entregado |
| expected_amount | DECIMAL(10,2) | | Producción esperada |
| difference_amount | DECIMAL(10,2) | | Diferencia (faltante/sobrante) |
| delivery_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Timestamp de entrega |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **52. cashier_box**

**Descripción:** Caja del cajero por turno. Control de efectivo recibido de conductores durante jornada laboral con apertura y cierre.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| box_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| cashier_user_id | BIGINT | NOT NULL, FK → user | Cajero responsable |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| terminal_id | INT | NOT NULL, FK → terminal | Terminal asignado |
| opening_amount | DECIMAL(10,2) | NOT NULL | Efectivo inicial |
| opened_at | TIMESTAMPTZ | DEFAULT NOW() | Apertura de caja |
| closed_at | TIMESTAMPTZ | | Cierre de caja |
| closing_amount | DECIMAL(10,2) | | Efectivo final |
| total_received | DECIMAL(10,2) | | Total recibido en turno |
| total_paid_out | DECIMAL(10,2) | | Total pagado (cambio, etc) |
| expected_amount | DECIMAL(10,2) | | Efectivo esperado |
| difference_amount | DECIMAL(10,2) | | Diferencia al cierre |
| status | VARCHAR(20) | DEFAULT 'OPEN' | OPEN, CLOSED, AUDITED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **53. cashier_box_movement**

**Descripción:** Movimientos de caja del cajero (entradas/salidas). Registra cada transacción de efectivo durante el turno.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| movement_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| box_id | BIGINT | NOT NULL, FK → cashier_box | Caja asociada |
| movement_type | VARCHAR(20) | NOT NULL | DELIVERY, PAYMENT, ADJUSTMENT |
| reference_type | VARCHAR(50) | | Tipo de referencia |
| reference_id | BIGINT | | ID de referencia |
| amount | DECIMAL(10,2) | NOT NULL | Monto del movimiento |
| description | TEXT | | Descripción |
| movement_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del movimiento |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **54. settlement**

**Descripción:** Liquidación final a conductor al término de jornada. Cálculo de producción total menos gastos y pago neto resultante.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| settlement_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| driver_id | INT | NOT NULL | Conductor liquidado |
| vehicle_id | INT | NOT NULL | Vehículo operado |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| settlement_date | DATE | NOT NULL | Fecha de liquidación |
| total_production | DECIMAL(10,2) | NOT NULL | Producción total |
| total_expenses | DECIMAL(10,2) | DEFAULT 0 | Gastos totales |
| net_amount | DECIMAL(10,2) | NOT NULL | Monto neto a pagar |
| payment_method | VARCHAR(20) | | CASH, TRANSFER, CHECK |
| settled_by | BIGINT | NOT NULL, FK → user | Cajero que liquidó |
| settled_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de liquidación |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, PAID, DISPUTED |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **55. settlement_detail**

**Descripción:** Detalle de boletos vendidos en liquidación. Desglose por tipo de boleto, series y rangos para conciliar con producción.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| detail_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| settlement_id | BIGINT | NOT NULL, FK → settlement | Liquidación asociada |
| ticket_type_id | INT | NOT NULL, FK → ticket_type | Tipo de boleto |
| supply_id | BIGINT | FK → ticket_supply | Suministro origen |
| validator_id | INT | FK → validator | Validador usado |
| series | VARCHAR(10) | | Serie del talonario |
| start_number | BIGINT | | Número inicial vendido |
| end_number | BIGINT | | Número final vendido |
| quantity_sold | INT | NOT NULL | Cantidad vendida |
| unit_price | DECIMAL(10,2) | NOT NULL | Precio unitario |
| total_amount | DECIMAL(10,2) | NOT NULL | Subtotal |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **56. settlement_adjustment** (pendiente)

**Descripción:** Ajustes autorizados en liquidaciones por diferencias, errores o circunstancias especiales. Requiere autorización de jefe de liquidación.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| adjustment_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| settlement_id | BIGINT | NOT NULL, FK → settlement | Liquidación afectada |
| adjustment_type | VARCHAR(20) | NOT NULL | SHORTAGE, SURPLUS, ERROR, SPECIAL |
| amount | DECIMAL(10,2) | NOT NULL | Monto del ajuste |
| reason | TEXT | NOT NULL | Justificación |
| authorized_by | BIGINT | NOT NULL, FK → user | Jefe que autorizó |
| authorized_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de autorización |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **57. owner_settlement** (pendiente)

**Descripción:** Liquidación a propietario de vehículo después de descontar gastos administrativos. Cálculo final de utilidad por unidad.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| owner_settlement_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INT | NOT NULL | Vehículo liquidado |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| settlement_period_start | DATE | NOT NULL | Inicio período |
| settlement_period_end | DATE | NOT NULL | Fin período |
| total_production | DECIMAL(10,2) | NOT NULL | Producción total período |
| total_driver_payments | DECIMAL(10,2) | NOT NULL | Pagos a conductores |
| total_admin_expenses | DECIMAL(10,2) | NOT NULL | Gastos administrativos |
| net_owner_amount | DECIMAL(10,2) | NOT NULL | Monto neto propietario |
| payment_method | VARCHAR(20) | | CASH, TRANSFER, CHECK |
| settled_by | BIGINT | NOT NULL, FK → user | Jefe que liquidó |
| settled_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de liquidación |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, PAID, APPROVED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **58. administrative_expense** (pendiente)

**Descripción:** Gastos administrativos descontados en liquidación a propietario (combustible, mantenimiento, multas, seguros). Reduce utilidad neta.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| expense_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| owner_settlement_id | BIGINT | FK → owner_settlement | Liquidación asociada |
| vehicle_id | INT | NOT NULL | Vehículo afectado |
| expense_type | VARCHAR(50) | NOT NULL | FUEL, MAINTENANCE, FINE, INSURANCE |
| expense_date | DATE | NOT NULL | Fecha del gasto |
| amount | DECIMAL(10,2) | NOT NULL | Monto del gasto |
| description | TEXT | | Descripción detallada |
| document_number | VARCHAR(50) | | Número de comprobante |
| registered_by | BIGINT | NOT NULL, FK → user | Usuario que registró |
| approved_by | BIGINT | FK → user | Jefe que aprobó |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **59. payment**

**Descripción:** Registro de pagos efectuados a conductores y propietarios. Controla salida de efectivo con método, comprobante y conciliación bancaria.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| payment_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| payment_type | VARCHAR(20) | NOT NULL | DRIVER, OWNER |
| settlement_id | BIGINT | FK → settlement | Liquidación conductor |
| owner_settlement_id | BIGINT | FK → owner_settlement | Liquidación propietario |
| payee_id | BIGINT | NOT NULL | ID del beneficiario |
| amount | DECIMAL(10,2) | NOT NULL | Monto pagado |
| payment_method | VARCHAR(20) | NOT NULL | CASH, TRANSFER, CHECK |
| reference_number | VARCHAR(100) | | Número de referencia/cheque |
| bank_account | VARCHAR(50) | | Cuenta bancaria destino |
| paid_by | BIGINT | NOT NULL, FK → user | Cajero que pagó |
| paid_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de pago |
| status | VARCHAR(20) | DEFAULT 'COMPLETED' | COMPLETED, PENDING, CANCELLED |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **60. financial_report**

**Descripción:** Reportes financieros consolidados generados periódicamente. Resúmenes ejecutivos de ingresos, egresos y estado de cuentas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| report_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| report_type | VARCHAR(50) | NOT NULL | DAILY, WEEKLY, MONTHLY, CUSTOM |
| report_date | DATE | NOT NULL | Fecha del reporte |
| period_start | DATE | NOT NULL | Inicio del período |
| period_end | DATE | NOT NULL | Fin del período |
| total_production | DECIMAL(10,2) | | Producción total |
| total_expenses | DECIMAL(10,2) | | Gastos totales |
| total_driver_payments | DECIMAL(10,2) | | Pagos a conductores |
| total_owner_payments | DECIMAL(10,2) | | Pagos a propietarios |
| net_income | DECIMAL(10,2) | | Ingreso neto |
| report_data | JSONB | | Datos detallados del reporte |
| generated_by | BIGINT | NOT NULL, FK → user | Usuario generador |
| generated_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de generación |
| status | VARCHAR(20) | DEFAULT 'DRAFT' | DRAFT, APPROVED, PUBLISHED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

## SCHEMA: `fleet`

Gestión de flota vehicular, dispositivos GPS, beacons, mantenimiento y combustible.

---

### **61. vehicle**

**Descripción:** Registro maestro de unidades vehiculares. Inventario completo de buses con datos técnicos, operativos y estado actual.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| vehicle_id | SERIAL | PRIMARY KEY | Identificador único |
| plate_number | VARCHAR(10) | UNIQUE, NOT NULL | Placa oficial del vehículo |
| internal_code | VARCHAR(20) | UNIQUE, NOT NULL | Código interno de la empresa |
| route_id | INT | FK → route | Ruta actualmente asignada |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| brand | VARCHAR(100) | | Marca del vehículo |
| model | VARCHAR(100) | | Modelo del vehículo |
| year | INT | | Año de fabricación |
| chassis_number | VARCHAR(50) | UNIQUE | Número de chasis/VIN |
| engine_number | VARCHAR(50) | | Número de motor |
| fuel_type | VARCHAR(20) | | DIESEL, GNV, HYBRID, ELECTRIC |
| seating_capacity | INT | | Capacidad de asientos |
| standing_capacity | INT | | Capacidad de pie |
| color | VARCHAR(50) | | Color del vehículo |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, INACTIVE, MAINTENANCE, RETIRED |
| acquisition_date | DATE | | Fecha de adquisición |
| is_operational | BOOLEAN | DEFAULT true | Vehículo operativo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **62. vehicle_document**

**Descripción:** Documentos obligatorios de vehículos (SOAT, revisión técnica, tarjeta de propiedad, póliza). Control de vigencia con alertas automáticas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| vehicle_document_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo asociado |
| document_type_id | INT | NOT NULL, FK → document_type | Tipo de documento |
| document_number | VARCHAR(100) | | Número del documento |
| issuing_entity | VARCHAR(255) | | Entidad emisora |
| issue_date | DATE | | Fecha de emisión |
| expiry_date | DATE | | Fecha de vencimiento |
| file_id | BIGINT | FK → file_storage | Archivo adjunto |
| status | VARCHAR(20) | DEFAULT 'VALID' | VALID, EXPIRED, PENDING, REJECTED |
| verified_by | BIGINT | FK → user | Usuario que verificó |
| verified_at | TIMESTAMPTZ | | Fecha de verificación |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **63. vehicle_owner**

**Descripción:** Propietarios de vehículos. Una unidad puede tener múltiples propietarios con porcentajes de participación definidos.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| vehicle_owner_id | SERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL | ID de la persona (propietario) |
| tax_id | VARCHAR(20) | | RUC/DNI del propietario |
| full_name | VARCHAR(255) | NOT NULL | Nombre completo |
| email | VARCHAR(255) | | Correo electrónico |
| phone | VARCHAR(50) | | Teléfono de contacto |
| address | TEXT | | Dirección |
| bank_account | VARCHAR(50) | | Cuenta para liquidaciones |
| is_active | BOOLEAN | DEFAULT true | Propietario activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **64. vehicle_owner_share**

**Descripción:** Porcentajes de participación de cada propietario en vehículos. Define distribución de utilidades en liquidaciones.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| share_id | SERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo compartido |
| vehicle_owner_id | INT | NOT NULL, FK → vehicle_owner | Propietario |
| ownership_percentage | DECIMAL(5,2) | NOT NULL | Porcentaje de propiedad (0.00-100.00) |
| valid_from | DATE | NOT NULL | Inicio de vigencia |
| valid_until | DATE | | Fin de vigencia |
| is_active | BOOLEAN | DEFAULT true | Participación activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

**Check Constraint:** ownership_percentage BETWEEN 0 AND 100

---

### **65. vehicle_assignment**

**Descripción:** Asignación histórica de conductores a vehículos. Permite rastrear quién operó cada unidad en qué período.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| assignment_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo asignado |
| driver_id | INT | NOT NULL | Conductor asignado |
| assigned_at | TIMESTAMPTZ | DEFAULT NOW() | Inicio de asignación |
| unassigned_at | TIMESTAMPTZ | | Fin de asignación |
| assignment_type | VARCHAR(20) | DEFAULT 'REGULAR' | REGULAR, TEMPORARY, REPLACEMENT |
| assigned_by | BIGINT | NOT NULL, FK → user | Usuario que asignó |
| unassigned_by | BIGINT | FK → user | Usuario que desasignó |
| notes | TEXT | | Observaciones |
| is_active | BOOLEAN | DEFAULT true | Asignación vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **66. gps_device**

**Descripción:** Dispositivos GPS instalados en vehículos (trackers dedicados o tablets Android). Control de equipos y comunicación.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| gps_device_id | SERIAL | PRIMARY KEY | Identificador único |
| device_id | VARCHAR(50) | UNIQUE, NOT NULL | ID único del dispositivo |
| device_type | VARCHAR(20) | NOT NULL | TRACKER_GPS, ANDROID_ID, IMEI |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| imei | VARCHAR(20) | UNIQUE | IMEI del dispositivo |
| serial_number | VARCHAR(50) | | Número de serie |
| model | VARCHAR(100) | | Modelo del dispositivo |
| manufacturer | VARCHAR(100) | | Fabricante |
| sim_card_number | VARCHAR(20) | | Número de SIM |
| sim_provider | VARCHAR(50) | | Proveedor de SIM |
| firmware_version | VARCHAR(50) | | Versión de firmware |
| vehicle_id | INT | FK → vehicle | Vehículo instalado |
| posting_interval_seconds | INT | DEFAULT 8 | Intervalo de transmisión |
| last_communication_at | TIMESTAMPTZ | | Última transmisión |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, INACTIVE, ERROR, MAINTENANCE |
| is_operational | BOOLEAN | DEFAULT true | Dispositivo operativo |
| installed_at | TIMESTAMPTZ | | Fecha de instalación |
| installed_by | BIGINT | FK → user | Usuario que instaló |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **67. beacon** (optional)

**Descripción:** Beacons BLE (Bluetooth Low Energy) para identificación segura de vehículos. Evita suplantación en eventos GPS.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| beacon_id | SERIAL | PRIMARY KEY | Identificador único |
| mac_address | VARCHAR(17) | UNIQUE, NOT NULL | Dirección MAC del beacon |
| uuid | VARCHAR(36) | | UUID del beacon (iBeacon) |
| major | INT | | Major value (iBeacon) |
| minor | INT | | Minor value (iBeacon) |
| model | VARCHAR(100) | | Modelo del beacon |
| manufacturer | VARCHAR(100) | | Fabricante |
| battery_level | INT | | Nivel de batería (%) |
| last_battery_check | TIMESTAMPTZ | | Última verificación batería |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, INACTIVE, LOW_BATTERY |
| is_operational | BOOLEAN | DEFAULT true | Beacon operativo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **68. beacon_pairing_request** (optional)

**Descripción:** Solicitudes de emparejamiento beacon-vehículo desde tablets. Requiere verificación de identidad del solicitante antes de aprobar.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| pairing_request_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo solicitante |
| beacon_mac_address | VARCHAR(17) | NOT NULL | MAC del beacon escaneado |
| beacon_name | VARCHAR(100) | | Nombre BLE advertised |
| rssi | INT | | Señal RSSI al momento |
| requested_by_type | VARCHAR(20) | NOT NULL | DRIVER, MAINTENANCE, FIELD_TECH, UNKNOWN |
| requested_by_name | VARCHAR(100) | | Nombre en texto libre |
| requested_by_user_id | BIGINT | FK → user | Usuario si registrado |
| requester_voice_text | TEXT | | Transcripción voz a texto |
| requester_photo_url | VARCHAR(500) | | URL foto temporal |
| photo_expires_at | TIMESTAMPTZ | | Expiración foto (7 días) |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, APPROVED, REJECTED |
| reviewed_by | BIGINT | FK → user | Monitoreador que revisó |
| reviewed_at | TIMESTAMPTZ | | Fecha de revisión |
| rejection_reason | TEXT | | Motivo de rechazo |
| verification_method | VARCHAR(20) | | RTC_CALL, IN_PERSON, NONE |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de solicitud |

---

### **69. vehicle_beacon** (optional)

**Descripción:** Beacon actualmente emparejado con cada vehículo. Solo se aceptan eventos GPS si coincide MAC del beacon registrado.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| vehicle_beacon_id | SERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INT | UNIQUE, NOT NULL, FK → vehicle | Vehículo asociado |
| beacon_id | INT | FK → beacon | Beacon emparejado |
| beacon_mac_address | VARCHAR(17) | NOT NULL | MAC del beacon activo |
| paired_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de emparejamiento |
| paired_by_request_id | BIGINT | FK → beacon_pairing_request | Solicitud origen |
| last_seen_at | TIMESTAMPTZ | | Última señal BLE recibida |
| is_active | BOOLEAN | DEFAULT true | Emparejamiento activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **70. maintenance_type**

**Descripción:** Catálogo de tipos de mantenimiento (preventivo, correctivo, inspección técnica). Define periodicidad y criticidad.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| maintenance_type_id | SERIAL | PRIMARY KEY | Identificador único |
| code | VARCHAR(50) | UNIQUE, NOT NULL | Código (PREVENTIVE, CORRECTIVE, INSPECTION) |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | Descripción detallada |
| is_scheduled | BOOLEAN | DEFAULT false | Requiere programación |
| default_interval_km | INT | | Kilometraje entre servicios |
| default_interval_days | INT | | Días entre servicios |
| is_critical | BOOLEAN | DEFAULT false | Mantenimiento crítico |
| is_active | BOOLEAN | DEFAULT true | Tipo activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **71. maintenance_schedule**

**Descripción:** Plan de mantenimiento programado por vehículo. Define calendario de servicios preventivos según uso y tiempo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| schedule_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo planificado |
| maintenance_type_id | INT | NOT NULL, FK → maintenance_type | Tipo de mantenimiento |
| scheduled_date | DATE | NOT NULL | Fecha programada |
| scheduled_km | INT | | Kilometraje programado |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, COMPLETED, OVERDUE, CANCELLED |
| created_by | BIGINT | NOT NULL, FK → user | Usuario que programó |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **72. maintenance_record**

**Descripción:** Registro histórico de mantenimientos ejecutados. Documenta trabajos realizados, costos, piezas y responsables.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| maintenance_record_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo atendido |
| schedule_id | BIGINT | FK → maintenance_schedule | Programación origen |
| maintenance_type_id | INT | NOT NULL, FK → maintenance_type | Tipo de mantenimiento |
| maintenance_date | DATE | NOT NULL | Fecha de ejecución |
| odometer_reading | INT | | Lectura de odómetro |
| description | TEXT | NOT NULL | Descripción del trabajo |
| parts_replaced | TEXT | | Piezas reemplazadas |
| labor_cost | DECIMAL(10,2) | | Costo de mano de obra |
| parts_cost | DECIMAL(10,2) | | Costo de repuestos |
| total_cost | DECIMAL(10,2) | | Costo total |
| workshop | VARCHAR(255) | | Taller que ejecutó |
| technician_name | VARCHAR(255) | | Nombre del técnico |
| invoice_number | VARCHAR(100) | | Número de factura |
| next_service_km | INT | | Próximo servicio (km) |
| next_service_date | DATE | | Próximo servicio (fecha) |
| registered_by | BIGINT | NOT NULL, FK → user | Usuario que registró |
| approved_by | BIGINT | FK → user | Usuario que aprobó |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **73. fuel_load**

**Descripción:** Registro de cargas de combustible por vehículo. Control de consumo, rendimiento y costos de combustible.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| fuel_load_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo cargado |
| driver_id | INT | FK | Conductor responsable |
| load_date | DATE | NOT NULL | Fecha de carga |
| load_time | TIME | | Hora de carga |
| fuel_type | VARCHAR(20) | NOT NULL | DIESEL, GNV, GASOLINE |
| quantity_liters | DECIMAL(8,2) | NOT NULL | Cantidad en litros |
| quantity_gallons | DECIMAL(8,2) | | Cantidad en galones (GNV) |
| unit_price | DECIMAL(8,2) | NOT NULL | Precio por unidad |
| total_cost | DECIMAL(10,2) | NOT NULL | Costo total |
| odometer_reading | INT | | Lectura de odómetro |
| station_name | VARCHAR(255) | | Nombre del grifo |
| invoice_number | VARCHAR(100) | | Número de comprobante |
| payment_method | VARCHAR(20) | | CASH, CARD, ACCOUNT |
| registered_by | BIGINT | NOT NULL, FK → user | Usuario que registró |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **74. gps_raw_event**

**Descripción:** Eventos GPS brutos recibidos de dispositivos. Almacena todas las transmisiones sin filtrar para auditoría y análisis posterior.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| raw_event_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| gps_device_id | INT | NOT NULL, FK → gps_device | Dispositivo emisor |
| vehicle_id | INT | FK → vehicle | Vehículo asociado |
| beacon_mac_address | VARCHAR(17) | | MAC del beacon detectado |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud GPS |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud GPS |
| altitude | DECIMAL(8,2) | | Altitud en metros |
| speed_kmh | DECIMAL(5,2) | | Velocidad en km/h |
| heading | DECIMAL(5,2) | | Rumbo en grados (0-360) |
| accuracy_meters | DECIMAL(6,2) | | Precisión en metros |
| satellites | INT | | Número de satélites |
| gps_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp GPS del evento |
| server_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Timestamp recepción servidor |
| battery_level | INT | | Nivel batería dispositivo |
| raw_data | JSONB | | Datos completos originales |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de almacenamiento |

**Particionada por:** gps_timestamp (diaria o semanal)

---

### **75. gps_processed_location** (opcional, utiliza stop_events, checkpoint_events) (pendiente)

**Descripción:** Ubicaciones GPS procesadas y validadas. Eventos filtrados, geocodificados y enriquecidos con contexto operativo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| processed_location_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| raw_event_id | BIGINT | FK → gps_raw_event | Evento GPS origen |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo localizado |
| trip_id | BIGINT | FK → trip | Viaje asociado |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud procesada |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud procesada |
| speed_kmh | DECIMAL(5,2) | | Velocidad procesada |
| heading | DECIMAL(5,2) | | Rumbo procesado |
| location_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp del punto |
| is_inside_route | BOOLEAN | | Dentro de geocerca ruta |
| nearest_stop_id | INT | FK → stop | Paradero más cercano |
| distance_to_stop_meters | INT | | Distancia a paradero |
| is_moving | BOOLEAN | | Vehículo en movimiento |
| idle_duration_seconds | INT | | Tiempo detenido |
| address | TEXT | | Dirección geocodificada |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de procesamiento |

**Particionada por:** location_timestamp (semanal)

---

## SCHEMA: `hr` 
- **Nota :** Ignorar algunas tablas superficiales para este alcance como las de pago de nóminas. Más si centrarse en loan, documents, porque pueden afectar la liquidación de una caja (modo básico) y despacho de una unidad.

Gestión de recursos humanos: personal, documentación, asistencia, nómina y capacitación.

---

### **76. person**

**Descripción:** Tabla base de personas en el sistema. Almacena datos personales compartidos entre conductores, inspectores y personal administrativo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| person_id | SERIAL | PRIMARY KEY | Identificador único |
| tax_id | VARCHAR(20) | UNIQUE, NOT NULL | DNI/RUC |
| first_name | VARCHAR(100) | NOT NULL | Nombre(s) |
| last_name | VARCHAR(100) | NOT NULL | Apellidos |
| full_name | VARCHAR(255) | NOT NULL | Nombre completo |
| gender | VARCHAR(1) | | M, F, O |
| birth_date | DATE | | Fecha de nacimiento |
| nationality | VARCHAR(50) | | Nacionalidad |
| marital_status | VARCHAR(20) | | SINGLE, MARRIED, DIVORCED, WIDOWED |
| blood_type | VARCHAR(5) | | Tipo de sangre |
| email | VARCHAR(255) | | Correo electrónico |
| phone_mobile | VARCHAR(20) | | Teléfono móvil |
| phone_home | VARCHAR(20) | | Teléfono fijo |
| emergency_contact_name | VARCHAR(255) | | Nombre contacto emergencia |
| emergency_contact_phone | VARCHAR(20) | | Teléfono emergencia |
| photo_url | VARCHAR(500) | | URL foto perfil |
| is_active | BOOLEAN | DEFAULT true | Persona activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **77. person_document**

**Descripción:** Documentos personales de cualquier persona (DNI, pasaporte, certificados). Extensible para diversos tipos según rol.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| person_document_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Persona asociada |
| document_type_id | INT | NOT NULL, FK → document_type | Tipo de documento |
| document_number | VARCHAR(100) | | Número del documento |
| issuing_entity | VARCHAR(255) | | Entidad emisora |
| issue_date | DATE | | Fecha de emisión |
| expiry_date | DATE | | Fecha de vencimiento |
| file_id | BIGINT | FK → file_storage | Archivo adjunto |
| status | VARCHAR(20) | DEFAULT 'VALID' | VALID, EXPIRED, PENDING, REJECTED |
| verified_by | BIGINT | FK → user | Usuario que verificó |
| verified_at | TIMESTAMPTZ | | Fecha de verificación |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **78. person_address**

**Descripción:** Direcciones de personas (domicilio, dirección laboral). Permite múltiples direcciones por persona con tipo diferenciado.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| address_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Persona asociada |
| address_type | VARCHAR(20) | NOT NULL | HOME, WORK, TEMPORARY |
| address_line1 | TEXT | NOT NULL | Dirección principal |
| address_line2 | TEXT | | Dirección adicional |
| district | VARCHAR(100) | | Distrito |
| city | VARCHAR(100) | | Ciudad |
| state | VARCHAR(100) | | Departamento/Región |
| postal_code | VARCHAR(20) | | Código postal |
| country | VARCHAR(50) | DEFAULT 'PE' | País (ISO 3166) |
| latitude | DECIMAL(10,8) | | Latitud |
| longitude | DECIMAL(11,8) | | Longitud |
| is_primary | BOOLEAN | DEFAULT false | Dirección principal |
| is_active | BOOLEAN | DEFAULT true | Dirección vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **79. person_contact**

**Descripción:** Contactos adicionales de personas. Permite registrar múltiples números telefónicos, emails y redes sociales.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| contact_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Persona asociada |
| contact_type | VARCHAR(20) | NOT NULL | PHONE, EMAIL, WHATSAPP, SOCIAL_MEDIA |
| contact_value | VARCHAR(255) | NOT NULL | Valor del contacto |
| label | VARCHAR(50) | | Etiqueta (personal, trabajo) |
| is_primary | BOOLEAN | DEFAULT false | Contacto principal |
| is_verified | BOOLEAN | DEFAULT false | Contacto verificado |
| is_active | BOOLEAN | DEFAULT true | Contacto vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **80. driver**

**Descripción:** Conductores autorizados. Extiende person con datos específicos del rol (licencia, estado operativo, restricciones).

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| driver_id | SERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | UNIQUE, NOT NULL, FK → person | Persona base |
| user_id | BIGINT | UNIQUE, FK → user | Usuario del sistema |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| driver_code | VARCHAR(20) | UNIQUE, NOT NULL | Código interno conductor |
| hire_date | DATE | | Fecha de contratación |
| termination_date | DATE | | Fecha de cese |
| employment_status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, SUSPENDED, TERMINATED |
| current_vehicle_id | INT | FK → vehicle | Vehículo actual |
| license_points | INT | DEFAULT 100 | Puntos de licencia (0-100) |
| total_trips | INT | DEFAULT 0 | Total de viajes realizados |
| total_km_driven | DECIMAL(12,2) | DEFAULT 0 | Kilómetros totales |
| rating_average | DECIMAL(3,2) | | Calificación promedio |
| is_available | BOOLEAN | DEFAULT true | Disponible para despacho |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **81. driver_license**

**Descripción:** Licencias de conducir de conductores. Historial completo de renovaciones y cambios de categoría.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| license_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| driver_id | INT | NOT NULL, FK → driver | Conductor titular |
| license_number | VARCHAR(20) | UNIQUE, NOT NULL | Número de licencia |
| license_class | VARCHAR(10) | NOT NULL | Clase (A-IIa, A-IIb, A-IIIa) |
| issue_date | DATE | NOT NULL | Fecha de emisión |
| expiry_date | DATE | NOT NULL | Fecha de vencimiento |
| issuing_authority | VARCHAR(100) | | Autoridad emisora |
| restrictions | TEXT | | Restricciones especiales |
| file_id | BIGINT | FK → file_storage | Archivo adjunto |
| status | VARCHAR(20) | DEFAULT 'VALID' | VALID, EXPIRED, SUSPENDED, REVOKED |
| is_current | BOOLEAN | DEFAULT true | Licencia vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **82. driver_infraction**

**Descripción:** Papeletas e infracciones de tránsito de conductores. Control de sanciones, puntos descontados y estado de pago.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| infraction_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| driver_id | INT | NOT NULL, FK → driver | Conductor infractor |
| vehicle_id | INT | FK → vehicle | Vehículo involucrado |
| infraction_code | VARCHAR(20) | | Código de infracción |
| infraction_date | DATE | NOT NULL | Fecha de infracción |
| infraction_type | VARCHAR(100) | NOT NULL | Tipo de falta |
| description | TEXT | | Descripción detallada |
| location | TEXT | | Lugar de infracción |
| authority | VARCHAR(100) | | Autoridad sancionadora |
| ticket_number | VARCHAR(50) | UNIQUE | Número de papeleta |
| fine_amount | DECIMAL(10,2) | | Monto de multa |
| points_deducted | INT | DEFAULT 0 | Puntos descontados |
| payment_status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, PAID, APPEALED, CANCELLED |
| paid_date | DATE | | Fecha de pago |
| paid_amount | DECIMAL(10,2) | | Monto pagado |
| payment_reference | VARCHAR(100) | | Referencia de pago |
| file_id | BIGINT | FK → file_storage | Archivo adjunto |
| registered_by | BIGINT | FK → user | Usuario que registró |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **83. inspector**

**Descripción:** Inspectores de campo. Personal autorizado para verificar cumplimiento operativo en ruta y terminal.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| inspector_id | SERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | UNIQUE, NOT NULL, FK → person | Persona base |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| user_id | BIGINT | UNIQUE, FK → user | Usuario del sistema |
| inspector_code | VARCHAR(20) | UNIQUE, NOT NULL | Código interno inspector |
| assigned_zone | VARCHAR(100) | | Zona asignada |
| hire_date | DATE | | Fecha de contratación |
| employment_status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, SUSPENDED, TERMINATED |
| has_vehicle | BOOLEAN | DEFAULT false | Tiene vehículo asignado |
| vehicle_plate | VARCHAR(10) | | Placa del vehículo |
| total_inspections | INT | DEFAULT 0 | Total de inspecciones |
| is_available | BOOLEAN | DEFAULT true | Disponible para asignación |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **84. personnel**

**Descripción:** Personal general (administrativos, mecánicos, cajeros, despachadores). Personal que no son conductores ni inspectores.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| personnel_id | SERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | UNIQUE, NOT NULL, FK → person | Persona base |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| user_id | BIGINT | UNIQUE, FK → user | Usuario del sistema |
| employee_code | VARCHAR(20) | UNIQUE, NOT NULL | Código interno empleado |
| job_title | VARCHAR(100) | NOT NULL | Cargo |
| department | VARCHAR(100) | | Departamento |
| hire_date | DATE | NOT NULL | Fecha de contratación |
| termination_date | DATE | | Fecha de cese |
| employment_type | VARCHAR(20) | | FULL_TIME, PART_TIME, CONTRACT |
| employment_status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, SUSPENDED, TERMINATED |
| base_salary | DECIMAL(10,2) | | Sueldo base |
| work_schedule | VARCHAR(50) | | Horario de trabajo |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **85. medical_exam**

**Descripción:** Exámenes psicosomáticos obligatorios para conductores. Control de salud física y mental según normativa.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| medical_exam_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| driver_id | INT | NOT NULL, FK → driver | Conductor examinado |
| exam_type | VARCHAR(50) | NOT NULL | PSYCHOSOMATIC, PHYSICAL, PSYCHOLOGICAL |
| exam_date | DATE | NOT NULL | Fecha del examen |
| expiry_date | DATE | NOT NULL | Fecha de vencimiento |
| medical_center | VARCHAR(255) | | Centro médico |
| doctor_name | VARCHAR(255) | | Nombre del médico |
| result | VARCHAR(20) | NOT NULL | APPROVED, REJECTED, CONDITIONAL |
| observations | TEXT | | Observaciones médicas |
| restrictions | TEXT | | Restricciones indicadas |
| certificate_number | VARCHAR(100) | | Número de certificado |
| file_id | BIGINT | FK → file_storage | Archivo adjunto |
| verified_by | BIGINT | FK → user | Usuario que verificó |
| verified_at | TIMESTAMPTZ | | Fecha de verificación |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **86. background_check**

**Descripción:** Antecedentes penales, policiales y de tránsito. Verificaciones obligatorias de conducta y récord legal.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| background_check_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Persona verificada |
| check_type | VARCHAR(50) | NOT NULL | CRIMINAL, POLICE, TRAFFIC, JUDICIAL |
| check_date | DATE | NOT NULL | Fecha de verificación |
| expiry_date | DATE | | Fecha de vencimiento |
| issuing_authority | VARCHAR(255) | NOT NULL | Autoridad emisora |
| certificate_number | VARCHAR(100) | | Número de certificado |
| result | VARCHAR(20) | NOT NULL | CLEAN, RECORDS_FOUND |
| records_detail | TEXT | | Detalle de antecedentes |
| file_id | BIGINT | FK → file_storage | Archivo adjunto |
| verified_by | BIGINT | FK → user | Usuario que verificó |
| verified_at | TIMESTAMPTZ | | Fecha de verificación |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **87. employment_contract**

**Descripción:** Contratos laborales de personal. Registro de términos contractuales, períodos y renovaciones.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| contract_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Persona contratada |
| contract_type | VARCHAR(20) | NOT NULL | INDEFINITE, FIXED_TERM, TRIAL |
| start_date | DATE | NOT NULL | Inicio del contrato |
| end_date | DATE | | Fin del contrato |
| position | VARCHAR(100) | NOT NULL | Cargo contratado |
| salary | DECIMAL(10,2) | NOT NULL | Salario acordado |
| salary_currency | VARCHAR(3) | DEFAULT 'PEN' | Moneda del salario |
| work_hours_per_week | INT | | Horas semanales |
| benefits | TEXT | | Beneficios incluidos |
| contract_terms | TEXT | | Términos especiales |
| file_id | BIGINT | FK → file_storage | Contrato escaneado |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, EXPIRED, TERMINATED |
| signed_by_employee | BOOLEAN | DEFAULT false | Firmado por empleado |
| signed_by_employer | BOOLEAN | DEFAULT false | Firmado por empleador |
| created_by | BIGINT | FK → user | Usuario que registró |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **88. attendance**

**Descripción:** Registro de asistencia diaria de personal. Control de entradas, salidas y horas trabajadas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| attendance_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Persona registrada |
| attendance_date | DATE | NOT NULL | Fecha de asistencia |
| check_in_time | TIME | | Hora de entrada |
| check_out_time | TIME | | Hora de salida |
| work_hours | DECIMAL(4,2) | | Horas trabajadas |
| overtime_hours | DECIMAL(4,2) | DEFAULT 0 | Horas extras |
| status | VARCHAR(20) | DEFAULT 'PRESENT' | PRESENT, ABSENT, LATE, EXCUSED |
| location | VARCHAR(100) | | Ubicación de marcación |
| device | VARCHAR(50) | | Dispositivo usado |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Unique Constraint:** (person_id, attendance_date)

---

### **89. absence**

**Descripción:** Ausencias y permisos de personal. Registro de licencias médicas, vacaciones, permisos personales.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| absence_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Persona ausente |
| absence_type | VARCHAR(20) | NOT NULL | SICK_LEAVE, VACATION, PERSONAL, UNPAID |
| start_date | DATE | NOT NULL | Inicio de ausencia |
| end_date | DATE | NOT NULL | Fin de ausencia |
| days_count | INT | NOT NULL | Días totales |
| reason | TEXT | | Motivo de ausencia |
| medical_certificate | BOOLEAN | DEFAULT false | Con certificado médico |
| file_id | BIGINT | FK → file_storage | Documento adjunto |
| requested_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de solicitud |
| approved_by | BIGINT | FK → user | Usuario que aprobó |
| approved_at | TIMESTAMPTZ | | Fecha de aprobación |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, APPROVED, REJECTED |
| rejection_reason | TEXT | | Motivo de rechazo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **90. vacation**

**Descripción:** Gestión de vacaciones del personal. Control de días acumulados, usados y saldo disponible.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| vacation_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Persona titular |
| accrual_year | INT | NOT NULL | Año de acumulación |
| days_accrued | INT | NOT NULL | Días acumulados |
| days_taken | INT | DEFAULT 0 | Días tomados |
| days_remaining | INT | NOT NULL | Días disponibles |
| start_date | DATE | | Inicio vacaciones programadas |
| end_date | DATE | | Fin vacaciones programadas |
| status | VARCHAR(20) | DEFAULT 'ACCRUED' | ACCRUED, SCHEDULED, IN_USE, COMPLETED |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

**Unique Constraint:** (person_id, accrual_year)

---

### **91. payroll_period**

**Descripción:** Períodos de nómina. Define ciclos de pago (semanal, quincenal, mensual) para procesamiento de planillas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| payroll_period_id | SERIAL | PRIMARY KEY | Identificador único |
| period_code | VARCHAR(20) | UNIQUE, NOT NULL | Código del período |
| period_type | VARCHAR(20) | NOT NULL | WEEKLY, BIWEEKLY, MONTHLY |
| start_date | DATE | NOT NULL | Inicio del período |
| end_date | DATE | NOT NULL | Fin del período |
| payment_date | DATE | NOT NULL | Fecha de pago |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| status | VARCHAR(20) | DEFAULT 'DRAFT' | DRAFT, PROCESSING, APPROVED, PAID |
| processed_by | BIGINT | FK → user | Usuario que procesó |
| processed_at | TIMESTAMPTZ | | Fecha de procesamiento |
| approved_by | BIGINT | FK → user | Usuario que aprobó |
| approved_at | TIMESTAMPTZ | | Fecha de aprobación |
| total_employees | INT | DEFAULT 0 | Total de empleados |
| total_amount | DECIMAL(12,2) | DEFAULT 0 | Monto total a pagar |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **92. payroll_record**

**Descripción:** Registros individuales de nómina por empleado. Cálculo de salario bruto, descuentos y neto a pagar.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| payroll_record_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| payroll_period_id | INT | NOT NULL, FK → payroll_period | Período de nómina |
| person_id | INT | NOT NULL, FK → person | Empleado pagado |
| company_id | INT | NOT NULL, FK → company | Empresa operadora |
| base_salary | DECIMAL(10,2) | NOT NULL | Salario base |
| gross_salary | DECIMAL(10,2) | NOT NULL | Salario bruto |
| total_deductions | DECIMAL(10,2) | DEFAULT 0 | Total descuentos |
| total_bonuses | DECIMAL(10,2) | DEFAULT 0 | Total bonificaciones |
| net_salary | DECIMAL(10,2) | NOT NULL | Salario neto |
| payment_method | VARCHAR(20) | | CASH, TRANSFER, CHECK |
| bank_account | VARCHAR(50) | | Cuenta bancaria |
| payment_reference | VARCHAR(100) | | Referencia de pago |
| days_worked | INT | | Días trabajados |
| hours_worked | DECIMAL(6,2) | | Horas trabajadas |
| overtime_hours | DECIMAL(6,2) | DEFAULT 0 | Horas extras |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, PAID, CANCELLED |
| paid_at | TIMESTAMPTZ | | Fecha de pago |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de cálculo |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **93. payroll_concept**

**Descripción:** Catálogo de conceptos de nómina (sueldos, bonos, descuentos, retenciones). Define tipos de movimientos en planilla.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| payroll_concept_id | SERIAL | PRIMARY KEY | Identificador único |
| code | VARCHAR(50) | UNIQUE, NOT NULL | Código del concepto |
| name | VARCHAR(100) | NOT NULL | Nombre del concepto |
| concept_type | VARCHAR(20) | NOT NULL | EARNING, DEDUCTION, BONUS, TAX |
| calculation_method | VARCHAR(20) | | FIXED, PERCENTAGE, FORMULA |
| default_amount | DECIMAL(10,2) | | Monto por defecto |
| default_percentage | DECIMAL(5,2) | | Porcentaje por defecto |
| is_taxable | BOOLEAN | DEFAULT false | Afecto a impuestos |
| affects_benefits | BOOLEAN | DEFAULT true | Afecta cálculo beneficios |
| is_active | BOOLEAN | DEFAULT true | Concepto activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **94. payroll_detail**

**Descripción:** Detalle de conceptos aplicados por empleado en cada período. Desglose completo de ingresos y descuentos.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| payroll_detail_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| payroll_record_id | BIGINT | NOT NULL, FK → payroll_record | Registro de nómina |
| payroll_concept_id | INT | NOT NULL, FK → payroll_concept | Concepto aplicado |
| quantity | DECIMAL(8,2) | DEFAULT 1 | Cantidad |
| unit_amount | DECIMAL(10,2) | | Monto unitario |
| total_amount | DECIMAL(10,2) | NOT NULL | Monto total |
| description | TEXT | | Descripción adicional |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **95. loan**

**Descripción:** Préstamos y anticipos otorgados a personal. Control de créditos con cronograma de cuotas y descuentos en planilla. También se usa para registrar saldos por liquidar de los viajes realizados por los conductores (este será impedimento de liquidar caja).

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| loan_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Empleado deudor |
| loan_type | VARCHAR(20) | NOT NULL | ADVANCE, LOAN, EMERGENCY |
| loan_amount | DECIMAL(10,2) | NOT NULL | Monto del préstamo |
| interest_rate | DECIMAL(5,2) | DEFAULT 0 | Tasa de interés (%) |
| total_amount | DECIMAL(10,2) | NOT NULL | Monto total a pagar |
| installments | INT | NOT NULL | Número de cuotas |
| installment_amount | DECIMAL(10,2) | NOT NULL | Monto por cuota |
| granted_date | DATE | NOT NULL | Fecha de otorgamiento |
| first_payment_date | DATE | NOT NULL | Primera cuota |
| granted_by | BIGINT | NOT NULL, FK → user | Usuario que aprobó |
| purpose | TEXT | | Motivo del préstamo |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, PAID, CANCELLED |
| paid_installments | INT | DEFAULT 0 | Cuotas pagadas |
| remaining_balance | DECIMAL(10,2) | NOT NULL | Saldo pendiente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **96. loan_installment** (ignorar)

**Descripción:** Cuotas de préstamos. Cronograma de pagos con control de estado y vinculación a descuentos en nómina.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| installment_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| loan_id | BIGINT | NOT NULL, FK → loan | Préstamo asociado |
| installment_number | INT | NOT NULL | Número de cuota |
| due_date | DATE | NOT NULL | Fecha de vencimiento |
| principal_amount | DECIMAL(10,2) | NOT NULL | Capital a pagar |
| interest_amount | DECIMAL(10,2) | DEFAULT 0 | Intereses |
| total_amount | DECIMAL(10,2) | NOT NULL | Total de cuota |
| paid_amount | DECIMAL(10,2) | DEFAULT 0 | Monto pagado |
| payment_date | DATE | | Fecha de pago |
| payroll_record_id | BIGINT | FK → payroll_record | Nómina donde se descontó |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, PAID, OVERDUE |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **97. training_program** (ignorar)

**Descripción:** Programas de capacitación disponibles. Cursos, talleres y entrenamientos para desarrollo del personal.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| training_program_id | SERIAL | PRIMARY KEY | Identificador único |
| program_code | VARCHAR(50) | UNIQUE, NOT NULL | Código del programa |
| program_name | VARCHAR(255) | NOT NULL | Nombre del programa |
| program_type | VARCHAR(50) | | COURSE, WORKSHOP, CERTIFICATION, SAFETY |
| description | TEXT | | Descripción detallada |
| duration_hours | INT | | Duración en horas |
| provider | VARCHAR(255) | | Proveedor/instructor |
| cost_per_person | DECIMAL(10,2) | | Costo por persona |
| max_participants | INT | | Capacidad máxima |
| is_mandatory | BOOLEAN | DEFAULT false | Capacitación obligatoria |
| is_active | BOOLEAN | DEFAULT true | Programa activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **98. training_attendance** (ignorar)

**Descripción:** Asistencia a capacitaciones. Registro de participación de empleados en programas de formación con resultados.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| training_attendance_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| training_program_id | INT | NOT NULL, FK → training_program | Programa cursado |
| person_id | INT | NOT NULL, FK → person | Participante |
| enrollment_date | DATE | NOT NULL | Fecha de inscripción |
| start_date | DATE | NOT NULL | Inicio del programa |
| end_date | DATE | | Fin del programa |
| attendance_percentage | DECIMAL(5,2) | | Porcentaje asistencia |
| completion_status | VARCHAR(20) | DEFAULT 'ENROLLED' | ENROLLED, IN_PROGRESS, COMPLETED, DROPPED |
| final_score | DECIMAL(5,2) | | Calificación final |
| passed | BOOLEAN | | Aprobó el programa |
| certificate_number | VARCHAR(100) | | Número de certificado |
| certificate_file_id | BIGINT | FK → file_storage | Certificado escaneado |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **99. biometric_fingerprint** (ignorar)

**Descripción:** Huellas dactilares para control de acceso. Almacena templates biométricos para autenticación física.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| fingerprint_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Persona registrada |
| finger_position | VARCHAR(20) | NOT NULL | LEFT_THUMB, RIGHT_INDEX, etc. |
| template_data | BYTEA | NOT NULL | Template biométrico |
| quality_score | INT | | Calidad de captura (0-100) |
| enrolled_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| enrolled_by | BIGINT | FK → user | Usuario que registró |
| device_id | VARCHAR(100) | | Dispositivo de captura |
| is_active | BOOLEAN | DEFAULT true | Huella activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

**Unique Constraint:** (person_id, finger_position)

---

### **100. access_card** (ignorar)

**Descripción:** Tarjetas de acceso físico. Control de tarjetas RFID/NFC para entrada a instalaciones y marcación.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| access_card_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| person_id | INT | NOT NULL, FK → person | Titular de la tarjeta |
| card_number | VARCHAR(50) | UNIQUE, NOT NULL | Número de tarjeta |
| card_type | VARCHAR(20) | NOT NULL | RFID, NFC, MAGNETIC |
| issued_date | DATE | NOT NULL | Fecha de emisión |
| expiry_date | DATE | | Fecha de vencimiento |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, BLOCKED, LOST, EXPIRED |
| issued_by | BIGINT | FK → user | Usuario que emitió |
| blocked_at | TIMESTAMPTZ | | Fecha de bloqueo |
| blocked_by | BIGINT | FK → user | Usuario que bloqueó |
| block_reason | TEXT | | Motivo de bloqueo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

## SCHEMA: `inspection` (futura versión)

Inspecciones de campo, verificación de cumplimiento operativo y generación de reportes.

---

### **101. field_inspection**

**Descripción:** Inspecciones de campo realizadas por inspectores. Registro maestro de cada inspección con contexto operativo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| field_inspection_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| inspector_id | INT | NOT NULL, FK → inspector | Inspector responsable |
| inspection_date | DATE | NOT NULL | Fecha de inspección |
| shift_start | TIME | NOT NULL | Inicio de turno |
| shift_end | TIME | | Fin de turno |
| assigned_zone | VARCHAR(100) | | Zona asignada |
| route_id | INT | FK → route | Ruta inspeccionada |
| inspection_type | VARCHAR(20) | NOT NULL | ROUTE, FREQUENCY, VEHICLE, INCIDENT |
| total_verifications | INT | DEFAULT 0 | Verificaciones realizadas |
| total_findings | INT | DEFAULT 0 | Hallazgos registrados |
| km_traveled | DECIMAL(6,2) | | Kilómetros recorridos |
| status | VARCHAR(20) | DEFAULT 'IN_PROGRESS' | IN_PROGRESS, COMPLETED, CANCELLED |
| completed_at | TIMESTAMPTZ | | Fecha de finalización |
| notes | TEXT | | Observaciones generales |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **102. route_verification**

**Descripción:** Verificaciones de cumplimiento de ruta. Registro de validación de recorridos autorizados y detección de desvíos.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| route_verification_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| field_inspection_id | BIGINT | NOT NULL, FK → field_inspection | Inspección asociada |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo verificado |
| driver_id | INT | FK → driver | Conductor verificado |
| trip_id | BIGINT | FK → trip | Viaje asociado |
| verification_location | VARCHAR(255) | NOT NULL | Punto de verificación |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud del punto |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud del punto |
| verification_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp de verificación |
| is_on_route | BOOLEAN | NOT NULL | Dentro de ruta autorizada |
| deviation_meters | INT | | Desviación en metros |
| compliance_percentage | DECIMAL(5,2) | | Porcentaje de cumplimiento |
| observations | TEXT | | Observaciones |
| photo_file_id | BIGINT | FK → file_storage | Foto adjunta |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **103. frequency_check**

**Descripción:** Control de cumplimiento de frecuencias en campo. Medición real de intervalos entre despachos en puntos críticos.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| frequency_check_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| field_inspection_id | BIGINT | NOT NULL, FK → field_inspection | Inspección asociada |
| route_id | INT | NOT NULL, FK → route | Ruta verificada |
| stop_id | INT | FK → stop | Paradero de verificación |
| checkpoint_id | INT | FK → checkpoint | Control verificado |
| check_location | VARCHAR(255) | NOT NULL | Ubicación del control |
| start_time | TIMESTAMPTZ | NOT NULL | Inicio del monitoreo |
| end_time | TIMESTAMPTZ | NOT NULL | Fin del monitoreo |
| duration_minutes | INT | NOT NULL | Duración del control |
| vehicles_counted | INT | NOT NULL | Vehículos contabilizados |
| min_interval_minutes | INT | | Intervalo mínimo observado |
| max_interval_minutes | INT | | Intervalo máximo observado |
| avg_interval_minutes | DECIMAL(5,2) | | Intervalo promedio |
| target_frequency_minutes | INT | | Frecuencia objetivo |
| compliance_percentage | DECIMAL(5,2) | | Porcentaje de cumplimiento |
| observations | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **104. vehicle_inspection**

**Descripción:** Inspección técnica y de seguridad de vehículos en campo. Verificación de condiciones operativas y cumplimiento normativo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| vehicle_inspection_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| field_inspection_id | BIGINT | NOT NULL, FK → field_inspection | Inspección asociada |
| vehicle_id | INT | NOT NULL, FK → vehicle | Vehículo inspeccionado |
| driver_id | INT | FK → driver | Conductor presente |
| inspection_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp inspección |
| location | VARCHAR(255) | | Ubicación inspección |
| latitude | DECIMAL(10,8) | | Latitud |
| longitude | DECIMAL(11,8) | | Longitud |
| overall_condition | VARCHAR(20) | NOT NULL | EXCELLENT, GOOD, FAIR, POOR |
| cleanliness_score | INT | | Limpieza (0-10) |
| mechanical_condition | VARCHAR(20) | | Estado mecánico |
| safety_equipment_complete | BOOLEAN | | Equipos completos |
| documents_valid | BOOLEAN | | Documentos vigentes |
| total_findings | INT | DEFAULT 0 | Hallazgos totales |
| critical_findings | INT | DEFAULT 0 | Hallazgos críticos |
| passed_inspection | BOOLEAN | | Aprobó inspección |
| restrictions_applied | BOOLEAN | DEFAULT false | Se aplicó restricción |
| observations | TEXT | | Observaciones generales |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **105. inspection_finding**

**Descripción:** Hallazgos y observaciones de inspecciones. Registro detallado de incumplimientos, deficiencias o irregularidades detectadas.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| inspection_finding_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| field_inspection_id | BIGINT | NOT NULL, FK → field_inspection | Inspección asociada |
| vehicle_inspection_id | BIGINT | FK → vehicle_inspection | Inspección vehículo |
| route_verification_id | BIGINT | FK → route_verification | Verificación ruta |
| finding_type | VARCHAR(50) | NOT NULL | Tipo de hallazgo |
| severity | VARCHAR(20) | NOT NULL | LOW, MEDIUM, HIGH, CRITICAL |
| category | VARCHAR(50) | | MECHANICAL, SAFETY, DOCUMENTATION, CLEANLINESS |
| description | TEXT | NOT NULL | Descripción detallada |
| requires_correction | BOOLEAN | DEFAULT true | Requiere corrección |
| correction_deadline | TIMESTAMPTZ | | Plazo de corrección |
| corrected_at | TIMESTAMPTZ | | Fecha de corrección |
| corrected_by | BIGINT | FK → user | Usuario que corrigió |
| verification_notes | TEXT | | Notas de verificación |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **106. inspection_evidence**

**Descripción:** Evidencias fotográficas y de video de inspecciones. Archivos adjuntos para sustentar hallazgos y observaciones.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| inspection_evidence_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| field_inspection_id | BIGINT | NOT NULL, FK → field_inspection | Inspección asociada |
| inspection_finding_id | BIGINT | FK → inspection_finding | Hallazgo documentado |
| evidence_type | VARCHAR(20) | NOT NULL | PHOTO, VIDEO, AUDIO, DOCUMENT |
| file_id | BIGINT | NOT NULL, FK → file_storage | Archivo adjunto |
| latitude | DECIMAL(10,8) | | Latitud de captura |
| longitude | DECIMAL(11,8) | | Longitud de captura |
| captured_at | TIMESTAMPTZ | NOT NULL | Timestamp de captura |
| description | TEXT | | Descripción de evidencia |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **107. inspection_report**

**Descripción:** Reportes consolidados de inspección por turno. Resumen ejecutivo de actividades, hallazgos y recomendaciones del inspector.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| inspection_report_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| field_inspection_id | BIGINT | UNIQUE, NOT NULL, FK → field_inspection | Inspección asociada |
| report_date | DATE | NOT NULL | Fecha del reporte |
| summary | TEXT | NOT NULL | Resumen ejecutivo |
| total_vehicles_inspected | INT | DEFAULT 0 | Vehículos inspeccionados |
| total_routes_verified | INT | DEFAULT 0 | Rutas verificadas |
| total_frequency_checks | INT | DEFAULT 0 | Controles de frecuencia |
| total_incidents_attended | INT | DEFAULT 0 | Incidentes atendidos |
| compliance_rate | DECIMAL(5,2) | | Tasa de cumplimiento |
| critical_findings_summary | TEXT | | Resumen hallazgos críticos |
| recommendations | TEXT | | Recomendaciones |
| attachments_count | INT | DEFAULT 0 | Total de adjuntos |
| submitted_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de envío |
| reviewed_by | BIGINT | FK → user | Jefe que revisó |
| reviewed_at | TIMESTAMPTZ | | Fecha de revisión |
| status | VARCHAR(20) | DEFAULT 'DRAFT' | DRAFT, SUBMITTED, REVIEWED, APPROVED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

## SCHEMA: `audit`

Auditoría avanzada, trazabilidad de cambios y gestión de datos históricos.

---

### **108. change_log**

**Descripción:** Registro detallado de cambios en entidades críticas. Captura estado anterior y posterior para auditoría completa.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| change_log_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| table_name | VARCHAR(100) | NOT NULL | Tabla afectada |
| record_id | BIGINT | NOT NULL | ID del registro |
| operation | VARCHAR(10) | NOT NULL | INSERT, UPDATE, DELETE |
| changed_by | BIGINT | FK → user | Usuario que modificó |
| changed_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del cambio |
| ip_address | INET | | IP de origen |
| old_values | JSONB | | Valores anteriores |
| new_values | JSONB | | Valores nuevos |
| changed_columns | TEXT[] | | Columnas modificadas |
| reason | TEXT | | Motivo del cambio |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Particionada por:** changed_at (mensual)

---

### **109. data_retention_policy**

**Descripción:** Políticas de retención de datos por tabla. Define períodos de conservación y estrategias de archivado.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| retention_policy_id | SERIAL | PRIMARY KEY | Identificador único |
| table_name | VARCHAR(100) | UNIQUE, NOT NULL | Tabla regulada |
| retention_period_days | INT | NOT NULL | Días de retención |
| archive_strategy | VARCHAR(20) | NOT NULL | ARCHIVE, DELETE, ANONYMIZE |
| is_active | BOOLEAN | DEFAULT true | Política activa |
| last_execution_at | TIMESTAMPTZ | | Última ejecución |
| next_execution_at | TIMESTAMPTZ | | Próxima ejecución |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **110. archived_data**

**Descripción:** Datos archivados que superaron período de retención. Almacenamiento histórico comprimido para consultas eventuales.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| archived_data_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| table_name | VARCHAR(100) | NOT NULL | Tabla de origen |
| record_id | BIGINT | NOT NULL | ID del registro original |
| archived_data | JSONB | NOT NULL | Datos completos archivados |
| archived_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de archivado |
| retention_policy_id | INT | FK → data_retention_policy | Política aplicada |
| can_be_deleted_after | DATE | | Fecha de eliminación permitida |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

**Particionada por:** archived_at (anual)

---

## FIN DEL DICCIONARIO - ESQUEMAS RESTANTES

**Total de tablas documentadas:** 50
- fleet: 15 tablas
- hr: 25 tablas  
- inspection: 7 tablas
- audit: 3 tablas

**RESUMEN GLOBAL DEL SISTEMA:**
- **identity:** 8 tablas
- **shared:** 10 tablas
- **core_operations:** 23 tablas
- **core_finance:** 19 tablas
- **fleet:** 15 tablas
- **hr:** 25 tablas
- **inspection:** 7 tablas
- **audit:** 3 tablas

**TOTAL GENERAL:** 110 tablas