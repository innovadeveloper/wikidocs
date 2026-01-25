# DICCIONARIO DE DATOS v4.0 - SCHEMA: identity

**VersiÃ³n:** 4.0  
**Fecha:** Enero 2026  
**Base de Datos:** PostgreSQL 14+  
**Arquitectura:** 1 BD por cliente (aislamiento total)  

---

## ÃNDICE - SCHEMA: identity (9 tablas)

```
1.  user                       -- Usuarios del sistema (LDAP/WSO2)
2.  user_company_access        -- Acceso de usuarios a empresas
3.  user_permission            -- Permisos granulares por usuario y empresa
4.  user_session               -- Sesiones activas y auditorÃ­a
5.  permission                 -- CatÃ¡logo de permisos del sistema
6.  permission_template        -- Plantillas reutilizables de permisos
7.  permission_template_detail -- Detalle de permisos en plantillas
8.  activity_log               -- AuditorÃ­a de acciones de usuarios
9.  login_attempt              -- Intentos de autenticaciÃ³n
```

---

## DESCRIPCIÃ“N DEL SCHEMA

**PropÃ³sito:** GestiÃ³n de identidad, autenticaciÃ³n, autorizaciÃ³n y auditorÃ­a de usuarios del sistema.

**IntegraciÃ³n:** 
- AutenticaciÃ³n delegada a LDAP/WSO2 Identity Server
- Permisos granulares por empresa y mÃ³dulo
- AuditorÃ­a completa de acciones

**CaracterÃ­sticas:**
- Multi-empresa: Un usuario puede acceder a mÃºltiples empresas
- Multi-sesiÃ³n: Soporte para sesiones concurrentes
- AuditorÃ­a: Log completo de acciones y accesos
- Seguridad: Control de fuerza bruta con login_attempt

---

## DEFINICIONES DE TABLAS

### **1. user**

**DescripciÃ³n:** Usuarios del sistema vinculados a LDAP/WSO2 IS. Almacena solo informaciÃ³n local necesaria para operaciÃ³n, la autenticaciÃ³n se delega completamente a WSO2.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| user_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico interno |
| external_id | VARCHAR(255) | UNIQUE, NOT NULL | LDAP DN o WSO2 subject |
| username | VARCHAR(100) | UNIQUE, NOT NULL | Nombre de usuario |
| email | VARCHAR(255) | UNIQUE, NOT NULL | Correo electrÃ³nico (cached desde LDAP) |
| full_name | VARCHAR(255) | | Nombre completo |
| is_active | BOOLEAN | DEFAULT true | Usuario activo en el sistema |
| last_login_at | TIMESTAMPTZ | | Ãšltimo acceso exitoso |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Ãndices:**
- `idx_user_external_id` ON (external_id)
- `idx_user_username` ON (username)
- `idx_user_email` ON (email)

**Notas:**
- `external_id` es el identificador del sistema de identidad externo (LDAP DN o WSO2 subject)
- La autenticaciÃ³n se realiza completamente en WSO2, no en esta tabla
- `email` y `full_name` se cachean para performance, se sincronizan periÃ³dicamente

---

### **2. user_company_access**

**DescripciÃ³n:** Define a quÃ© empresas tiene acceso cada usuario. Base para permisos granulares, permite que un usuario opere en mÃºltiples empresas simultÃ¡neamente.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| user_company_access_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| user_id | BIGINT | NOT NULL, FK â†’ user | Usuario |
| company_id | INT | NOT NULL, FK â†’ company | Empresa autorizada |
| is_primary | BOOLEAN | DEFAULT false | Empresa principal del usuario |
| granted_by | BIGINT | FK â†’ user | Usuario que otorgÃ³ acceso |
| granted_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de autorizaciÃ³n |
| is_active | BOOLEAN | DEFAULT true | Acceso activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Unique Constraint:** (user_id, company_id)

**Ãndices:**
- `idx_user_company_user` ON (user_id, is_active)
- `idx_user_company_company` ON (company_id, is_active)

**Notas:**
- Un usuario puede tener acceso a mÃºltiples empresas
- Solo una empresa puede ser marcada como `is_primary = true` por usuario
- Al desactivar acceso, cambiar `is_active = false` en lugar de eliminar registro

---

### **3. user_permission**

**DescripciÃ³n:** Permisos granulares por usuario y empresa. Modelo flexible que permite asignar permisos especÃ­ficos para cada contexto organizacional.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| user_permission_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| user_id | BIGINT | NOT NULL, FK â†’ user | Usuario |
| company_id | INT | NOT NULL, FK â†’ company | Empresa contexto |
| permission_id | INT | NOT NULL, FK â†’ permission | Permiso otorgado |
| granted_by | BIGINT | FK â†’ user | Usuario que otorgÃ³ |
| granted_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de otorgamiento |
| expires_at | TIMESTAMPTZ | | Fecha de expiraciÃ³n |
| is_active | BOOLEAN | DEFAULT true | Permiso activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Unique Constraint:** (user_id, company_id, permission_id)

**Ãndices:**
- `idx_user_perm_user_company` ON (user_id, company_id, is_active)
- `idx_user_perm_permission` ON (permission_id)

**Notas:**
- Permisos son contextuales a una empresa especÃ­fica
- `expires_at` permite permisos temporales (ej: acceso de auditor por 30 dÃ­as)
- Un usuario puede tener permisos diferentes en empresas diferentes

---

### **4. user_session**

**DescripciÃ³n:** Sesiones activas de usuarios. Rastrea accesos concurrentes, dispositivos y permite invalidar sesiones remotamente.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| session_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| user_id | BIGINT | NOT NULL, FK â†’ user | Usuario |
| token | VARCHAR(500) | UNIQUE, NOT NULL | Token de sesiÃ³n |
| ip_address | INET | | IP de acceso |
| user_agent | TEXT | | Navegador/dispositivo |
| started_at | TIMESTAMPTZ | DEFAULT NOW() | Inicio de sesiÃ³n |
| last_activity_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actividad |
| expires_at | TIMESTAMPTZ | NOT NULL | ExpiraciÃ³n |
| is_active | BOOLEAN | DEFAULT true | SesiÃ³n activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Ãndices:**
- `idx_session_token` ON (token) WHERE is_active = true
- `idx_session_user_active` ON (user_id, is_active)
- `idx_session_expires` ON (expires_at) WHERE is_active = true

**Notas:**
- `token` es el JWT o identificador de sesiÃ³n
- `last_activity_at` se actualiza en cada request para detectar sesiones inactivas
- Sesiones expiradas deben limpiarse periÃ³dicamente con job automÃ¡tico
- Permite detectar accesos concurrentes desde mÃºltiples dispositivos

---

### **5. permission**

**DescripciÃ³n:** CatÃ¡logo de permisos del sistema. Define acciones especÃ­ficas que pueden ser otorgadas a usuarios.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| permission_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| code | VARCHAR(100) | UNIQUE, NOT NULL | CÃ³digo Ãºnico |
| name | VARCHAR(100) | NOT NULL | Nombre descriptivo |
| description | TEXT | | DescripciÃ³n detallada |
| module | VARCHAR(50) | NOT NULL | MÃ³dulo (DISPATCH, GPS, FINANCE) |
| category | VARCHAR(50) | | CategorÃ­a |
| is_active | BOOLEAN | DEFAULT true | Permiso activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Ãndices:**
- `idx_permission_code` ON (code)
- `idx_permission_module` ON (module, is_active)

**Ejemplos de permisos:**
```sql
('dispatch.queue.view', 'Ver cola de despacho', 'DISPATCH', 'READ')
('dispatch.authorize', 'Autorizar despachos', 'DISPATCH', 'WRITE')
('gps.monitor.realtime', 'Monitoreo GPS tiempo real', 'GPS', 'READ')
('finance.settlement.approve', 'Aprobar liquidaciones', 'FINANCE', 'APPROVAL')
```

**Notas:**
- `code` sigue patrÃ³n: `module.resource.action`
- `module` permite filtrar permisos al asignar roles
- Nuevos permisos se agregan via migrations, no desde UI

---

### **6. permission_template**

**DescripciÃ³n:** Plantillas reutilizables de permisos. Agrupaciones predefinidas de permisos para roles tÃ­picos (despachador, supervisor, etc).

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| template_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| name | VARCHAR(100) | NOT NULL | Nombre de la plantilla |
| description | TEXT | | DescripciÃ³n |
| role_type | VARCHAR(50) | | DISPATCHER, SUPERVISOR, MANAGER |
| is_active | BOOLEAN | DEFAULT true | Plantilla activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Ejemplos de templates:**
```sql
('Despachador', 'Permisos estÃ¡ndar para despachador de terminal', 'DISPATCHER')
('Supervisor Terminal', 'Supervisor con permisos ampliados', 'SUPERVISOR')
('Jefe de Operaciones', 'Jefe con control total operativo', 'MANAGER')
```

**Notas:**
- Facilita asignaciÃ³n masiva de permisos
- Al aplicar template, se copian permisos de `permission_template_detail` a `user_permission`
- Templates se pueden actualizar sin afectar permisos ya otorgados

---

### **7. permission_template_detail**

**DescripciÃ³n:** Detalle de permisos incluidos en plantillas. RelaciÃ³n muchos a muchos entre templates y permissions.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| template_detail_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| template_id | INT | NOT NULL, FK â†’ permission_template | Plantilla |
| permission_id | INT | NOT NULL, FK â†’ permission | Permiso incluido |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de inclusiÃ³n |

**Unique Constraint:** (template_id, permission_id)

**Ãndices:**
- `idx_template_detail_template` ON (template_id)

**Notas:**
- Define la composiciÃ³n de cada template
- Al modificar template, solo afecta nuevas asignaciones
- Permite construir roles complejos por composiciÃ³n

---

### **8. activity_log**

**DescripciÃ³n:** AuditorÃ­a completa de acciones de usuarios en el sistema. Registra quÃ©, quiÃ©n, cuÃ¡ndo y desde dÃ³nde se realizÃ³ cada operaciÃ³n crÃ­tica.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| log_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| user_id | BIGINT | FK â†’ user | Usuario que ejecutÃ³ acciÃ³n |
| action | VARCHAR(100) | NOT NULL | AcciÃ³n realizada |
| resource_type | VARCHAR(100) | | Tipo de recurso afectado |
| resource_id | BIGINT | | ID del recurso afectado |
| ip_address | INET | | IP desde donde se ejecutÃ³ |
| user_agent | TEXT | | Navegador/dispositivo |
| changes | JSONB | | Datos antes/despuÃ©s (opcional) |
| status | VARCHAR(20) | | SUCCESS, FAILED, PARTIAL |
| error_message | TEXT | | Mensaje de error si aplica |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del evento |

**Ãndices:**
- `idx_activity_user_date` ON (user_id, created_at DESC)
- `idx_activity_resource` ON (resource_type, resource_id)
- `idx_activity_action` ON (action, created_at DESC)

**Particionada por:** created_at (mensual recomendado)

**Acciones tÃ­picas auditadas:**
```sql
'USER_LOGIN', 'USER_LOGOUT'
'DISPATCH_AUTHORIZE', 'DISPATCH_CANCEL'
'RESTRICTION_OVERRIDE', 'EXCEPTION_APPROVE'
'SETTLEMENT_CREATE', 'SETTLEMENT_APPROVE'
'PERMISSION_GRANT', 'PERMISSION_REVOKE'
```

**Ejemplo de changes (JSONB):**
```json
{
  "before": {"status": "PENDING", "amount": 150.00},
  "after": {"status": "APPROVED", "amount": 150.00},
  "fields_changed": ["status"]
}
```

**Notas:**
- Inmutable: nunca se elimina, solo se archiva
- `changes` es opcional, solo para operaciones crÃ­ticas
- RetenciÃ³n: 7 aÃ±os segÃºn normativa peruana

---

### **9. login_attempt**

**DescripciÃ³n:** Registro de intentos de autenticaciÃ³n (exitosos y fallidos) para detectar patrones de acceso no autorizados y bloquear ataques de fuerza bruta.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| attempt_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| username | VARCHAR(100) | NOT NULL | Usuario intentado |
| ip_address | INET | NOT NULL | IP de origen |
| user_agent | TEXT | | Navegador/dispositivo |
| success | BOOLEAN | NOT NULL | Intento exitoso |
| failure_reason | VARCHAR(100) | | RazÃ³n del fallo |
| attempted_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del intento |

**Ãndices:**
- `idx_login_username_date` ON (username, attempted_at DESC)
- `idx_login_ip_date` ON (ip_address, attempted_at DESC)
- `idx_login_failed` ON (success, attempted_at DESC) WHERE success = false

**Particionada por:** attempted_at (mensual)

**Failure reasons:**
```
'INVALID_CREDENTIALS'    -- Usuario/contraseÃ±a incorrecta
'ACCOUNT_LOCKED'         -- Cuenta bloqueada por intentos fallidos
'ACCOUNT_DISABLED'       -- Cuenta desactivada en sistema
'IP_BLOCKED'             -- IP bloqueada por actividad sospechosa
'MFA_REQUIRED'           -- Requiere segundo factor
'MFA_FAILED'             -- Segundo factor incorrecto
```

**Reglas de bloqueo (ejemplo):**
- 5 intentos fallidos en 15 minutos â†’ Bloqueo de cuenta por 30 minutos
- 10 intentos fallidos en 1 hora â†’ Bloqueo de IP por 24 horas
- Implementado en capa de aplicaciÃ³n, no en BD

**Notas:**
- Registra TODOS los intentos, exitosos y fallidos
- Base para detectar ataques de fuerza bruta
- RetenciÃ³n: 90 dÃ­as, luego archivado

---

## RELACIONES ENTRE TABLAS

```
user
â”œâ”€â†’ user_company_access (1:N)
â”‚   â””â”€â†’ company
â”œâ”€â†’ user_permission (1:N)
â”‚   â”œâ”€â†’ company
â”‚   â””â”€â†’ permission
â”œâ”€â†’ user_session (1:N)
â””â”€â†’ activity_log (1:N)

permission
â”œâ”€â†’ user_permission (1:N)
â””â”€â†’ permission_template_detail (1:N)
    â””â”€â†’ permission_template (N:1)
```

---

## CASOS DE USO PRINCIPALES

### **CU-1: AutenticaciÃ³n de Usuario**
1. Usuario intenta login â†’ WSO2 valida credenciales
2. Si exitoso: Crea registro en `user_session`
3. Si fallido: Registra en `login_attempt`
4. Verifica `user.is_active`
5. Retorna token de sesiÃ³n

### **CU-2: VerificaciÃ³n de Permisos**
1. Request llega con token de sesiÃ³n
2. Valida sesiÃ³n en `user_session`
3. Obtiene `company_id` del contexto
4. Verifica permiso en `user_permission` para (user_id, company_id, permission_id)
5. Registra acciÃ³n en `activity_log` si es crÃ­tica

### **CU-3: AsignaciÃ³n de Rol (Template)**
1. Admin selecciona usuario y template
2. Lee permisos de `permission_template_detail`
3. Crea registros en `user_permission` para cada permiso
4. Audita en `activity_log`

### **CU-4: Cambio de Empresa Activa**
1. Usuario selecciona empresa del menÃº
2. Verifica acceso en `user_company_access`
3. Actualiza contexto de sesiÃ³n
4. Carga permisos de `user_permission` para nueva empresa

---

## CONSIDERACIONES DE SEGURIDAD

1. **Passwords:** NUNCA se almacenan en esta BD, siempre en WSO2/LDAP
2. **Tokens:** Se almacenan hasheados en `user_session.token`
3. **AuditorÃ­a:** Todas las operaciones de permisos se registran en `activity_log`
4. **Sesiones:** ExpiraciÃ³n automÃ¡tica configurable (default: 8 horas)
5. **Multi-empresa:** Permisos aislados por empresa, sin cross-contamination

---

## DATOS SEMILLA REQUERIDOS

### **Permisos bÃ¡sicos (permission):**
```sql
-- MÃ³dulo DISPATCH
INSERT INTO identity.permission VALUES 
('dispatch.queue.view', 'Ver cola de despacho', 'DISPATCH'),
('dispatch.authorize', 'Autorizar despacho', 'DISPATCH'),
('dispatch.cancel', 'Cancelar despacho', 'DISPATCH');

-- MÃ³dulo GPS
INSERT INTO identity.permission VALUES
('gps.monitor.realtime', 'Monitoreo GPS tiempo real', 'GPS'),
('gps.alert.respond', 'Responder alertas GPS', 'GPS');

-- MÃ³dulo FINANCE
INSERT INTO identity.permission VALUES
('finance.settlement.create', 'Crear liquidaciÃ³n', 'FINANCE'),
('finance.settlement.approve', 'Aprobar liquidaciÃ³n', 'FINANCE');
```

### **Templates bÃ¡sicos (permission_template):**
```sql
INSERT INTO identity.permission_template VALUES
('Despachador', 'Permisos estÃ¡ndar despachador', 'DISPATCHER'),
('Supervisor Terminal', 'Supervisor operativo', 'SUPERVISOR'),
('Admin Sistema', 'Administrador completo', 'ADMIN');
```

---

## MANTENIMIENTO

### **Jobs periÃ³dicos:**
1. **Limpieza de sesiones expiradas:** Diario a las 02:00 AM
   ```sql
   DELETE FROM identity.user_session 
   WHERE expires_at < NOW() - INTERVAL '7 days';
   ```

2. **Archivado de activity_log:** Mensual
   ```sql
   -- Mover registros > 90 dÃ­as a tabla de archivo
   INSERT INTO identity.activity_log_archive
   SELECT * FROM identity.activity_log
   WHERE created_at < NOW() - INTERVAL '90 days';
   ```

3. **Archivado de login_attempt:** Mensual
   ```sql
   DELETE FROM identity.login_attempt
   WHERE attempted_at < NOW() - INTERVAL '90 days';
   ```

---

**Fin del Diccionario - Schema: identity**

**Total de tablas:** 9  
**Estado:** âœ… Completo y validado
# DICCIONARIO DE DATOS v4.0 - SCHEMA: shared

**VersiÃ³n:** 4.0  
**Fecha:** Enero 2026  
**Base de Datos:** PostgreSQL 14+  
**Arquitectura:** 1 BD por cliente (aislamiento total)  

---

## ÃNDICE - SCHEMA: shared (10 tablas)

```
10. company                    -- Empresas de transporte
11. authority                  -- Autoridades reguladoras del transporte
12. concession                 -- Concesiones otorgadas
13. concessionaire             -- Empresas concesionarias
14. terminal                   -- Terminales de transporte
15. catalog                    -- CatÃ¡logos generales del sistema
16. document_type              -- Tipos de documentos del sistema
17. configuration              -- ParÃ¡metros de configuraciÃ³n
18. notification_template      -- Plantillas de notificaciones
19. file_storage               -- Archivos adjuntos del sistema
```

---

## DESCRIPCIÃ“N DEL SCHEMA

**PropÃ³sito:** CatÃ¡logos compartidos, configuraciÃ³n y entidades organizacionales base del sistema.

**CaracterÃ­sticas:**
- Datos maestros compartidos entre mÃ³dulos
- ConfiguraciÃ³n parametrizable sin redeployar
- Marco regulatorio y concesiones
- GestiÃ³n centralizada de archivos
- Plantillas de comunicaciones

**Alcance:**
- Una empresa por base de datos (multi-tenancy a nivel BD)
- ConfiguraciÃ³n global del sistema
- CatÃ¡logos reutilizables
- Infraestructura compartida

---

## DEFINICIONES DE TABLAS

### **10. company**

**DescripciÃ³n:** Empresa operadora de transporte (1 por base de datos). Representa al concesionario u operador que ejecuta las rutas autorizadas.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| company_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| tax_id | VARCHAR(20) | UNIQUE, NOT NULL | RUC de la empresa |
| legal_name | VARCHAR(255) | NOT NULL | RazÃ³n social completa |
| trade_name | VARCHAR(255) | | Nombre comercial |
| address | TEXT | | DirecciÃ³n legal |
| phone | VARCHAR(50) | | TelÃ©fono principal |
| email | VARCHAR(255) | | Email corporativo |
| logo_url | VARCHAR(500) | | URL del logo |
| is_active | BOOLEAN | DEFAULT true | Empresa activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Notas:**
- En arquitectura actual: 1 BD = 1 Company
- `tax_id` es el RUC de 11 dÃ­gitos (PerÃº)
- `trade_name` se usa en interfaces de usuario
- `logo_url` puede ser local (/static/logos/) o URL externa

---

### **11. authority**

**DescripciÃ³n:** Autoridades reguladoras del transporte (ATU, municipalidades). Entidad que otorga concesiones y supervisa cumplimiento normativo.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| authority_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| name | VARCHAR(255) | NOT NULL | Nombre de la autoridad |
| acronym | VARCHAR(20) | | Siglas (ATU, MML) |
| jurisdiction | VARCHAR(100) | | Ãmbito de jurisdicciÃ³n |
| contact_email | VARCHAR(255) | | Email de contacto |
| contact_phone | VARCHAR(50) | | TelÃ©fono de contacto |
| is_active | BOOLEAN | DEFAULT true | Autoridad vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Ejemplos:**
```sql
('Autoridad de Transporte Urbano', 'ATU', 'Lima Metropolitana')
('Municipalidad Metropolitana de Lima', 'MML', 'Lima')
('Municipalidad de San Juan de Lurigancho', 'MSJL', 'Distrito SJL')
```

---

### **12. concession**

**DescripciÃ³n:** ConcesiÃ³n otorgada por autoridad reguladora. Representa el marco legal bajo el cual opera la empresa en determinadas rutas.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| concession_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| authority_id | INT | NOT NULL, FK â†’ authority | Autoridad otorgante |
| concession_code | VARCHAR(50) | UNIQUE, NOT NULL | CÃ³digo oficial de concesiÃ³n |
| concession_name | VARCHAR(255) | NOT NULL | Nombre descriptivo |
| grant_date | DATE | NOT NULL | Fecha de otorgamiento |
| expiry_date | DATE | | Fecha de vencimiento |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, SUSPENDED, EXPIRED |
| terms_document_url | VARCHAR(500) | | URL del documento de tÃ©rminos |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Status values:**
- `ACTIVE`: ConcesiÃ³n vigente y operativa
- `SUSPENDED`: Suspendida temporalmente por autoridad
- `EXPIRED`: Vencida, requiere renovaciÃ³n

**Notas:**
- `concession_code` es el cÃ³digo oficial asignado por ATU
- `expiry_date` NULL = concesiÃ³n indefinida
- Alertas automÃ¡ticas 90 dÃ­as antes de expiraciÃ³n

---

### **13. concessionaire**

**DescripciÃ³n:** Concesionario titular de la concesiÃ³n. Puede ser la misma empresa operadora o un consorcio diferente que subcontrata operaciÃ³n.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| concessionaire_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| tax_id | VARCHAR(20) | UNIQUE, NOT NULL | RUC del concesionario |
| legal_name | VARCHAR(255) | NOT NULL | RazÃ³n social |
| concession_id | INT | FK â†’ concession | ConcesiÃ³n asociada |
| is_active | BOOLEAN | DEFAULT true | Concesionario activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Notas:**
- Permite modelar consorcios que operan mÃºltiples concesiones
- `tax_id` puede ser diferente de `company.tax_id` si hay subcontrataciÃ³n

---

### **14. terminal**

**DescripciÃ³n:** Terminales de transporte. Puntos de inicio/fin de rutas donde se realiza despacho y control operativo.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| terminal_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| code | VARCHAR(20) | NOT NULL | CÃ³digo del terminal |
| name | VARCHAR(255) | NOT NULL | Nombre del terminal |
| address | TEXT | | DirecciÃ³n fÃ­sica |
| latitude | DECIMAL(10,8) | | Latitud GPS |
| longitude | DECIMAL(11,8) | | Longitud GPS |
| geofence_radius_meters | INT | DEFAULT 100 | Radio de geocerca (metros) |
| terminal_type | VARCHAR(20) | | ORIGIN, DESTINATION, INTERMEDIATE |
| is_active | BOOLEAN | DEFAULT true | Terminal activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Unique Constraint:** (company_id, code)

**Terminal types:**
- `ORIGIN`: Terminal de inicio de ruta
- `DESTINATION`: Terminal de fin de ruta
- `INTERMEDIATE`: Terminal intermedio en ruta larga

**Notas:**
- `geofence_radius_meters` define el Ã¡rea donde se valida ingreso/salida
- Coordenadas GPS obligatorias para validaciÃ³n de ubicaciÃ³n
- Un terminal puede servir a mÃºltiples rutas

---

### **15. catalog**

**DescripciÃ³n:** CatÃ¡logo genÃ©rico tipo clave-valor para listas parametrizables (estados, tipos, categorÃ­as). Evita crear tablas para cada enumeraciÃ³n.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| catalog_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| category | VARCHAR(50) | NOT NULL | CategorÃ­a (vehicle_status, trip_status) |
| code | VARCHAR(50) | NOT NULL | CÃ³digo Ãºnico en categorÃ­a |
| name | VARCHAR(100) | NOT NULL | Nombre descriptivo |
| description | TEXT | | DescripciÃ³n detallada |
| display_order | INT | DEFAULT 0 | Orden de visualizaciÃ³n |
| is_active | BOOLEAN | DEFAULT true | Valor activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Unique Constraint:** (category, code)

**Ãndices:**
- `idx_catalog_category` ON (category, is_active)

**CategorÃ­as tÃ­picas:**
```sql
-- Estados de vehÃ­culo
('vehicle_status', 'OPERATIONAL', 'Operativo')
('vehicle_status', 'MAINTENANCE', 'En mantenimiento')
('vehicle_status', 'OUT_OF_SERVICE', 'Fuera de servicio')

-- Estados de viaje
('trip_status', 'SCHEDULED', 'Programado')
('trip_status', 'IN_PROGRESS', 'En curso')
('trip_status', 'COMPLETED', 'Completado')

-- Tipos de combustible
('fuel_type', 'DIESEL', 'Diesel')
('fuel_type', 'GNV', 'Gas Natural Vehicular')
('fuel_type', 'ELECTRIC', 'ElÃ©ctrico')
```

**Notas:**
- DiseÃ±ado para listas que cambian raramente
- `display_order` controla orden en dropdowns
- Nuevas categorÃ­as se agregan vÃ­a migrations

---

### **16. document_type**

**DescripciÃ³n:** CatÃ¡logo de tipos de documentos del sistema (licencias, SOAT, certificados, etc.) segÃºn normativa ATU.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| document_type_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| code | VARCHAR(50) | UNIQUE, NOT NULL | CÃ³digo Ãºnico (LICENSE, DNI, SOAT) |
| name | VARCHAR(100) | NOT NULL | Nombre del documento |
| description | TEXT | | DescripciÃ³n detallada |
| is_mandatory | BOOLEAN | DEFAULT true | Documento obligatorio |
| requires_expiry | BOOLEAN | DEFAULT false | Tiene fecha de vencimiento |
| alert_days_before | INT | | DÃ­as de anticipaciÃ³n para alertar |
| restriction_type | VARCHAR(20) | | CRITICAL, WARNING, NONE |
| is_active | BOOLEAN | DEFAULT true | Tipo vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Restriction types:**
- `CRITICAL`: Bloquea despacho si estÃ¡ vencido
- `WARNING`: Alerta pero permite operar
- `NONE`: Solo informativo

**Documentos tÃ­picos de conductor:**
```sql
('LICENSE_A2B', 'Licencia A-IIB', true, true, 30, 'CRITICAL')
('DNI', 'DNI/Carnet de ExtranjerÃ­a', true, false, NULL, 'CRITICAL')
('MEDICAL_CERT', 'Certificado MÃ©dico', true, true, 15, 'CRITICAL')
('POLICE_CERT', 'Certificado Antecedentes Policiales', true, true, 30, 'WARNING')
```

**Documentos tÃ­picos de vehÃ­culo:**
```sql
('SOAT', 'SOAT', true, true, 15, 'CRITICAL')
('TECH_REVISION', 'RevisiÃ³n TÃ©cnica', true, true, 30, 'CRITICAL')
('PROPERTY_CARD', 'Tarjeta de Propiedad', true, false, NULL, 'CRITICAL')
('ROUTE_PERMIT', 'Permiso de Ruta ATU', true, true, 30, 'CRITICAL')
```

---

### **17. configuration**

**DescripciÃ³n:** ParÃ¡metros globales del sistema tipo clave-valor. Permite ajustar comportamiento sin redeployar cÃ³digo (intervalos, lÃ­mites, flags).

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| configuration_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| key | VARCHAR(100) | UNIQUE, NOT NULL | Clave de configuraciÃ³n |
| value | TEXT | NOT NULL | Valor (string, JSON) |
| data_type | VARCHAR(20) | NOT NULL | STRING, INTEGER, BOOLEAN, JSON |
| description | TEXT | | DescripciÃ³n del parÃ¡metro |
| is_editable | BOOLEAN | DEFAULT true | Permite ediciÃ³n por admin |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Configuraciones tÃ­picas:**
```sql
-- OperaciÃ³n
('dispatch.queue.max_wait_minutes', '30', 'INTEGER', 'Tiempo mÃ¡ximo en cola')
('gps.location.update_interval_seconds', '30', 'INTEGER', 'Intervalo de actualizaciÃ³n GPS')
('alert.speed.max_urban_kmh', '60', 'INTEGER', 'Velocidad mÃ¡xima urbana')

-- Recaudo
('finance.settlement.tolerance_percentage', '2.0', 'STRING', 'Tolerancia diferencias')
('finance.cashier.session_timeout_hours', '8', 'INTEGER', 'Timeout sesiÃ³n cajero')

-- Sistema
('system.maintenance_mode', 'false', 'BOOLEAN', 'Modo mantenimiento')
('system.backup.retention_days', '30', 'INTEGER', 'DÃ­as retenciÃ³n backups')
```

**Notas:**
- `data_type` ayuda a validar/parsear valores
- `is_editable = false` para configuraciones crÃ­ticas
- Cambios requieren auditorÃ­a en `activity_log`

---

### **18. notification_template**

**DescripciÃ³n:** Plantillas de notificaciones para emails, SMS y push. Soporta variables dinÃ¡micas para personalizaciÃ³n.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| template_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| code | VARCHAR(50) | UNIQUE, NOT NULL | CÃ³digo Ãºnico |
| name | VARCHAR(100) | NOT NULL | Nombre descriptivo |
| notification_type | VARCHAR(20) | NOT NULL | EMAIL, SMS, PUSH |
| subject | VARCHAR(255) | | Asunto (para email) |
| body_template | TEXT | NOT NULL | Cuerpo con variables {{var}} |
| variables | TEXT[] | | Lista de variables disponibles |
| is_active | BOOLEAN | DEFAULT true | Plantilla activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Ejemplos de templates:**
```sql
-- Email de documento prÃ³ximo a vencer
code: 'DOCUMENT_EXPIRY_WARNING'
subject: 'Documento {{document_name}} prÃ³ximo a vencer'
body_template: 'Estimado {{driver_name}}, su {{document_name}} vence el {{expiry_date}}. RenuÃ©velo antes de {{deadline_date}} para evitar restricciones.'
variables: ['driver_name', 'document_name', 'expiry_date', 'deadline_date']

-- SMS de despacho autorizado
code: 'DISPATCH_AUTHORIZED'
body_template: 'Despacho autorizado. Unidad {{vehicle_code}} a ruta {{route_code}} a las {{departure_time}}. Buen viaje!'
variables: ['vehicle_code', 'route_code', 'departure_time']

-- Push de alerta GPS
code: 'GPS_ALERT_CRITICAL'
body_template: 'ALERTA: {{alert_type}} en unidad {{vehicle_code}}. UbicaciÃ³n: {{location}}. Responder inmediatamente.'
variables: ['alert_type', 'vehicle_code', 'location']
```

**Sintaxis de variables:**
- Variables encerradas en `{{variable_name}}`
- Reemplazo en tiempo de envÃ­o
- Variables no reemplazadas quedan como texto literal

---

### **19. file_storage**

**DescripciÃ³n:** Archivos adjuntos del sistema (documentos, fotos, evidencias). Referencia a almacenamiento en S3/local.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| file_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| original_filename | VARCHAR(255) | NOT NULL | Nombre original |
| stored_filename | VARCHAR(255) | NOT NULL | Nombre en storage |
| file_path | VARCHAR(500) | NOT NULL | Ruta completa |
| file_size_bytes | BIGINT | NOT NULL | TamaÃ±o en bytes |
| mime_type | VARCHAR(100) | | Tipo MIME |
| storage_type | VARCHAR(20) | DEFAULT 'LOCAL' | LOCAL, S3, AZURE |
| uploaded_by | BIGINT | FK â†’ user | Usuario que subiÃ³ |
| uploaded_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de subida |
| is_public | BOOLEAN | DEFAULT false | Acceso pÃºblico |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Ãndices:**
- `idx_file_storage_uploaded_by` ON (uploaded_by)
- `idx_file_storage_uploaded_at` ON (uploaded_at DESC)

**Storage types:**
- `LOCAL`: Almacenamiento en servidor local (/uploads/)
- `S3`: Amazon S3 bucket
- `AZURE`: Azure Blob Storage

**Tipos de archivos tÃ­picos:**
```
Documentos:
- application/pdf (licencias, permisos)
- image/jpeg, image/png (fotos de documentos)

Evidencias:
- image/jpeg (fotos de incidentes)
- video/mp4 (videos de cÃ¡maras)

Logos:
- image/png (logos de empresa)
```

**Notas:**
- `stored_filename` es UUID para evitar colisiones
- `file_path` incluye subdirectorios organizacionales
- Archivos nunca se eliminan fÃ­sicamente, solo se marcan como inactivos
- `is_public = true` para logos y recursos pÃºblicos

---

## RELACIONES ENTRE TABLAS

```
company (raÃ­z de tenant)
â”œâ”€â†’ terminal (1:N)
â”œâ”€â†’ user_company_access (1:N) [schema identity]
â””â”€â†’ route (1:N) [schema core_operations]

authority
â”œâ”€â†’ concession (1:N)

concession
â”œâ”€â†’ concessionaire (1:N)

file_storage
â””â”€â†’ user (uploaded_by) [schema identity]
```

---

## DATOS SEMILLA REQUERIDOS

### **Autoridades:**
```sql
INSERT INTO shared.authority (name, acronym, jurisdiction) VALUES
('Autoridad de Transporte Urbano', 'ATU', 'Lima Metropolitana'),
('Municipalidad Metropolitana de Lima', 'MML', 'Lima');
```

### **Tipos de documentos (conductor):**
```sql
INSERT INTO shared.document_type VALUES
('LICENSE_A2B', 'Licencia A-IIB', 'Licencia profesional conductor', true, true, 30, 'CRITICAL'),
('DNI', 'DNI', 'Documento identidad', true, false, NULL, 'CRITICAL'),
('MEDICAL_CERT', 'Certificado MÃ©dico', 'Aptitud mÃ©dica', true, true, 15, 'CRITICAL'),
('POLICE_CERT', 'Antecedentes Policiales', 'Certificado judicial', true, true, 30, 'WARNING');
```

### **Tipos de documentos (vehÃ­culo):**
```sql
INSERT INTO shared.document_type VALUES
('SOAT', 'SOAT', 'Seguro obligatorio', true, true, 15, 'CRITICAL'),
('TECH_REVISION', 'RevisiÃ³n TÃ©cnica', 'InspecciÃ³n tÃ©cnica vehicular', true, true, 30, 'CRITICAL'),
('ROUTE_PERMIT', 'Permiso de Ruta ATU', 'AutorizaciÃ³n de ruta', true, true, 30, 'CRITICAL');
```

### **CatÃ¡logos bÃ¡sicos:**
```sql
-- Estados de vehÃ­culo
INSERT INTO shared.catalog (category, code, name, display_order) VALUES
('vehicle_status', 'OPERATIONAL', 'Operativo', 1),
('vehicle_status', 'MAINTENANCE', 'En mantenimiento', 2),
('vehicle_status', 'OUT_OF_SERVICE', 'Fuera de servicio', 3);

-- Tipos de combustible
INSERT INTO shared.catalog (category, code, name) VALUES
('fuel_type', 'DIESEL', 'Diesel'),
('fuel_type', 'GNV', 'Gas Natural Vehicular'),
('fuel_type', 'ELECTRIC', 'ElÃ©ctrico');
```

### **Configuraciones iniciales:**
```sql
INSERT INTO shared.configuration (key, value, data_type, description) VALUES
('dispatch.queue.max_wait_minutes', '30', 'INTEGER', 'Tiempo mÃ¡ximo en cola'),
('gps.location.update_interval_seconds', '30', 'INTEGER', 'Intervalo GPS'),
('alert.speed.max_urban_kmh', '60', 'INTEGER', 'Velocidad mÃ¡xima urbana'),
('finance.settlement.tolerance_percentage', '2.0', 'STRING', 'Tolerancia diferencias'),
('system.maintenance_mode', 'false', 'BOOLEAN', 'Modo mantenimiento');
```

---

## MANTENIMIENTO

### **Jobs periÃ³dicos:**

1. **Limpieza de archivos huÃ©rfanos:**
   ```sql
   -- Identificar archivos sin referencias (mensual)
   SELECT file_id FROM shared.file_storage
   WHERE NOT EXISTS (
     SELECT 1 FROM driver_document WHERE file_id = file_storage.file_id
     UNION ALL
     SELECT 1 FROM vehicle_document WHERE file_id = file_storage.file_id
     UNION ALL
     SELECT 1 FROM incident WHERE evidence_file_ids @> ARRAY[file_storage.file_id]
   );
   ```

2. **Alertas de concesiÃ³n prÃ³xima a vencer:**
   ```sql
   -- Diario a las 08:00 AM
   SELECT * FROM shared.concession
   WHERE expiry_date <= CURRENT_DATE + INTERVAL '90 days'
   AND status = 'ACTIVE';
   ```

3. **ValidaciÃ³n de configuraciones:**
   ```sql
   -- Semanal: validar tipos de datos
   SELECT key, value, data_type
   FROM shared.configuration
   WHERE (data_type = 'INTEGER' AND value !~ '^[0-9]+$')
   OR (data_type = 'BOOLEAN' AND value NOT IN ('true', 'false'));
   ```

---

## CONSIDERACIONES

### **Multi-tenancy:**
- 1 BD = 1 Company (aislamiento total)
- `company_id` como FK en casi todas las entidades operativas
- No hay data sharing entre empresas

### **ConfiguraciÃ³n:**
- Cambios en `configuration` requieren restart de app para aplicar
- Cache de configuraciÃ³n en memoria con TTL de 5 minutos
- Valores crÃ­ticos (`is_editable = false`) no editables desde UI

### **Archivos:**
- LÃ­mite de tamaÃ±o: 10 MB por archivo (configurable)
- Formatos permitidos: PDF, JPG, PNG, MP4
- RetenciÃ³n: Indefinida, archivos nunca se eliminan fÃ­sicamente
- Almacenamiento: Local para MVP, S3 para producciÃ³n

---

**Fin del Diccionario - Schema: shared**

**Total de tablas:** 10  
**Estado:** âœ… Completo y validado
# DICCIONARIO DE DATOS v4.0 - SCHEMA: core_operations

**VersiÃ³n:** 4.0  
**Fecha:** Enero 2026  
**Base de Datos:** PostgreSQL 14+  
**Arquitectura:** 1 BD por cliente (aislamiento total)  

---

## ÃNDICE - SCHEMA: core_operations (36 tablas)

### **RUTAS Y SERVICIOS (5 tablas: 20-24)**
```
20. route                      -- Rutas autorizadas por ATU
21. route_polyline             -- GeometrÃ­a de visualizaciÃ³n (GeoJSON)
22. route_stop                 -- Paradas de ruta
23. route_control              -- Puntos de control obligatorios
24. route_schedule             -- Horarios programados por ruta
```

### **PROGRAMACIÃ“N Y DESPACHO (13 tablas: 25-37)**
```
25. service                    -- Servicios de transporte
26. schedule_format            -- âœ¨ NUEVO: Tipos de formato de programaciÃ³n
27. dispatch_schedule          -- ProgramaciÃ³n maestra de salidas
28. dispatch_schedule_shift    -- âœ¨ NUEVO: Turnos dentro de programaciÃ³n
29. dispatch_schedule_detail   -- Detalle de salidas programadas
30. dispatch_queue             -- Cola de despacho en tiempo real
31. dispatch                   -- Despachos autorizados
32. dispatch_exception         -- Excepciones a restricciones
33. exception_type             -- âœ¨ NUEVO: CatÃ¡logo de tipos de excepciÃ³n
34. exception_monthly_summary  -- âœ¨ NUEVO: Resumen mensual de excepciones
35. operational_restriction    -- Restricciones operativas activas
36. restriction_type           -- Tipos de restricciones
37. restriction_daily_summary  -- âœ¨ NUEVO: Resumen diario de restricciones
```

### **VIAJES Y TRACKING GPS (13 tablas: 38-50)**
```
38. trip                       -- Viajes realizados
39. trip_stop                  -- âœ¨ RESTAURADO: Paradas durante viaje
40. trip_event                 -- âœ¨ NUEVO: Eventos durante viaje
41. trip_passenger_count       -- Conteo de pasajeros
42. trip_location              -- Trackeo GPS del viaje
43. trip_speed_event           -- Eventos de velocidad
44. trip_compliance_matrix_cache -- âœ¨ NUEVO: Cache de matriz de cumplimiento
45. frequency_control          -- Control de frecuencias
46. route_compliance           -- Cumplimiento de ruta
47. alert_type                 -- Tipos de alertas GPS
48. alert                      -- Alertas GPS generadas
49. alert_communication_log    -- âœ¨ NUEVO: Comunicaciones durante alertas
50. alert_daily_summary        -- âœ¨ NUEVO: Resumen diario de alertas
```

### **INCIDENTES Y HORARIOS PÃšBLICOS (5 tablas: 51-55)**
```
51. incident                   -- Incidentes operativos
52. incident_type              -- CatÃ¡logo de tipos de incidente
53. schedule_change_log        -- AuditorÃ­a de cambios de programaciÃ³n
54. timetable                  -- Horarios publicados (ATU)
55. timetable_exception        -- Excepciones de horarios
```

---

## DEFINICION DE TABLAS

## SCHEMA: `core_operations`

GestiÃ³n completa de operaciones de transporte: rutas, despachos, viajes, alertas y cumplimiento.

---

### **20. route**

**DescripciÃ³n:** Rutas de transporte autorizadas por ATU. Define origen, destino y puntos de control obligatorios.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| route_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| code | VARCHAR(20) | NOT NULL | CÃ³digo oficial de ruta |
| name | VARCHAR(255) | NOT NULL | Nombre descriptivo |
| route_type | VARCHAR(20) | | LINEAR, CIRCULAR |
| origin_terminal_id | INT | FK â†’ terminal | Terminal origen |
| destination_terminal_id | INT | FK â†’ terminal | Terminal destino |
| total_distance_km | DECIMAL(8,2) | | Distancia total |
| estimated_duration_minutes | INT | | DuraciÃ³n estimada |
| is_active | BOOLEAN | DEFAULT true | Ruta activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Unique Constraint:** (company_id, code)

---

### **21. route_polyline**

**DescripciÃ³n:** GeometrÃ­a de visualizaciÃ³n de rutas. PolilÃ­nea para renderizar trazado en mapas (IDA/VUELTA).

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| polyline_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| route_id | INT | NOT NULL, FK â†’ route | Ruta asociada |
| direction | VARCHAR(10) | NOT NULL | IDA, VUELTA |
| coordinates | JSONB | NOT NULL | Array de [lat, lon] |
| encoded_polyline | TEXT | | Polyline codificado (Google) |
| total_points | INT | | Total de coordenadas |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Unique Constraint:** (route_id, direction)

---

### **22. route_stop**

**DescripciÃ³n:** Paradas (paraderos) de ruta. Lista completa de puntos donde el vehÃ­culo puede detenerse.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| stop_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| route_id | INT | NOT NULL, FK â†’ route | Ruta asociada |
| stop_code | VARCHAR(20) | | CÃ³digo del paradero |
| name | VARCHAR(255) | NOT NULL | Nombre del paradero |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud GPS |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud GPS |
| sequence_number | INT | NOT NULL | Orden en la ruta |
| distance_from_origin_km | DECIMAL(8,2) | | Distancia desde origen |
| estimated_duration_minutes | INT | | Tiempo desde origen |
| is_control_point | BOOLEAN | DEFAULT false | Es punto de control ATU |
| geofence_radius_meters | INT | DEFAULT 50 | Radio de geocerca |
| is_active | BOOLEAN | DEFAULT true | Parada activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Unique Constraint:** (route_id, sequence_number)

---

### **23. route_control**

**DescripciÃ³n:** Puntos de control obligatorios de ruta segÃºn ATU. Subset de route_stop que requieren validaciÃ³n de cumplimiento.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| control_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| route_id | INT | NOT NULL, FK â†’ route | Ruta asociada |
| stop_id | INT | NOT NULL, FK â†’ route_stop | Parada que es control |
| sequence_number | INT | NOT NULL | Orden en controles |
| min_time_minutes | INT | NOT NULL | Tiempo mÃ­nimo desde origen |
| max_time_minutes | INT | NOT NULL | Tiempo mÃ¡ximo desde origen |
| tolerance_minutes | INT | DEFAULT 2 | Tolerancia (Â±) |
| is_mandatory | BOOLEAN | DEFAULT true | Control obligatorio |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Unique Constraint:** (route_id, stop_id)

---

### **24. route_schedule**

**DescripciÃ³n:** Horarios programados por ruta. Define frecuencias y horarios de operaciÃ³n por dÃ­a y franja horaria.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| schedule_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| route_id | INT | NOT NULL, FK â†’ route | Ruta asociada |
| day_of_week | INT | | DÃ­a de semana (0-6, NULL=todos) |
| start_time | TIME | NOT NULL | Hora inicio operaciÃ³n |
| end_time | TIME | NOT NULL | Hora fin operaciÃ³n |
| frequency_minutes | INT | NOT NULL | Frecuencia entre servicios |
| is_active | BOOLEAN | DEFAULT true | Horario activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

---

### **25. service**

**DescripciÃ³n:** Servicios de transporte. AgrupaciÃ³n lÃ³gica de viajes (puede representar un turno o dÃ­a de operaciÃ³n).

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| service_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| route_id | INT | NOT NULL, FK â†’ route | Ruta asignada |
| service_date | DATE | NOT NULL | Fecha del servicio |
| service_type | VARCHAR(20) | DEFAULT 'REGULAR' | REGULAR, SPECIAL, EXTRA |
| planned_trips | INT | DEFAULT 0 | Viajes planificados |
| completed_trips | INT | DEFAULT 0 | Viajes completados |
| status | VARCHAR(20) | DEFAULT 'PLANNED' | PLANNED, ACTIVE, COMPLETED, CANCELLED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

---

### **26. schedule_format** âœ¨ NUEVO

**DescripciÃ³n:** Tipos de formato de programaciÃ³n de servicios. Define esquemas predefinidos de operaciÃ³n (servicio completo, express, nocturno).

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| schedule_format_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| code | VARCHAR(10) | NOT NULL UNIQUE | CÃ³digo Ãºnico del formato (F7, F5) |
| name | VARCHAR(100) | NOT NULL | Nombre del formato |
| description | TEXT | | DescripciÃ³n detallada |
| source_type | VARCHAR(20) | NOT NULL | EXCEL, WEB_FORM, API |
| default_frequency_minutes | INT | | Frecuencia base en minutos |
| requires_approval | BOOLEAN | DEFAULT false | Requiere aprobaciÃ³n supervisor |
| is_active | BOOLEAN | DEFAULT true | Formato activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Nota:** `source_type` diferencia si la programaciÃ³n viene de Excel, formulario web o API.

---

### **27. dispatch_schedule**

**DescripciÃ³n:** ProgramaciÃ³n maestra de salidas elaborada por Analista de Operaciones. Define horarios planificados para dÃ­a siguiente segÃºn demanda.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| dispatch_schedule_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| route_id | INT | NOT NULL, FK â†’ route | Ruta programada |
| terminal_id | INT | NOT NULL, FK â†’ terminal | Terminal de salida |
| schedule_date | DATE | NOT NULL | Fecha programada |
| schedule_type | VARCHAR(20) | DEFAULT 'REGULAR' | REGULAR, SPECIAL, HOLIDAY |
| schedule_format_id | INT | FK â†’ schedule_format | Formato aplicado âœ¨ NUEVO |
| services_total | INT | DEFAULT 0 | Total servicios programados âœ¨ NUEVO |
| services_completed | INT | DEFAULT 0 | Servicios ejecutados âœ¨ NUEVO |
| compliance_rate_services | DECIMAL(5,2) | | % cumplimiento servicios âœ¨ NUEVO |
| trips_total | INT | DEFAULT 0 | Total viajes programados âœ¨ NUEVO |
| trips_completed | INT | DEFAULT 0 | Viajes ejecutados âœ¨ NUEVO |
| compliance_rate_trips | DECIMAL(5,2) | | % cumplimiento viajes âœ¨ NUEVO |
| load_status | VARCHAR(20) | DEFAULT 'EMPTY' | EMPTY, PARTIAL, FULL âœ¨ NUEVO |
| created_by | BIGINT | NOT NULL, FK â†’ user | Analista creador |
| approved_by | BIGINT | FK â†’ user | Jefe que aprobÃ³ |
| status | VARCHAR(20) | DEFAULT 'DRAFT' | DRAFT, APPROVED, ACTIVE, CANCELLED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Notas:**
- `services_total` vs `trips_total`: Un servicio puede tener mÃºltiples viajes (IDA + VUELTA)
- `load_status`: Indica si se cargÃ³ data completa al sistema

---

### **28. dispatch_schedule_shift** âœ¨ NUEVO

**DescripciÃ³n:** Desglose de programaciÃ³n por turno del dÃ­a (maÃ±ana, tarde, noche). Permite analizar cumplimiento por franja horaria.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| schedule_shift_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| dispatch_schedule_id | BIGINT | NOT NULL, FK â†’ dispatch_schedule | ProgramaciÃ³n maestra |
| shift_type | VARCHAR(20) | NOT NULL | MORNING, AFTERNOON, EVENING, NIGHT, DAWN |
| shift_name | VARCHAR(50) | NOT NULL | Nombre del turno (ej: "MaÃ±ana") |
| shift_start_time | TIME | NOT NULL | Hora inicio del turno |
| shift_end_time | TIME | NOT NULL | Hora fin del turno |
| vehicles_assigned | INT | DEFAULT 0 | Unidades asignadas |
| drivers_assigned | INT | DEFAULT 0 | Conductores asignados |
| services_scheduled | INT | DEFAULT 0 | Servicios programados |
| services_completed | INT | DEFAULT 0 | Servicios ejecutados |
| trips_scheduled | INT | DEFAULT 0 | Viajes programados |
| trips_completed | INT | DEFAULT 0 | Viajes ejecutados |
| compliance_rate_services | DECIMAL(5,2) | | % cumplimiento servicios |
| compliance_rate_trips | DECIMAL(5,2) | | % cumplimiento viajes |
| notes | TEXT | | Observaciones del turno |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Unique Constraint:** (dispatch_schedule_id, shift_type)

**Uso:** 
- Al importar programaciÃ³n: estructura datos del Excel por turno
- Al generar despachos: muestra resumen y aplica lÃ³gica de turnos

---

### **29. dispatch_schedule_detail**

**DescripciÃ³n:** Detalle horario de cada salida programada. Lista completa de horarios con vehÃ­culo y conductor asignado idealmente.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| schedule_detail_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| dispatch_schedule_id | BIGINT | NOT NULL, FK â†’ dispatch_schedule | ProgramaciÃ³n maestra |
| scheduled_time | TIME | NOT NULL | Hora programada de salida |
| sequence_number | INT | NOT NULL | NÃºmero secuencial |
| vehicle_id | INT | FK â†’ vehicle | VehÃ­culo asignado (opcional) |
| driver_id | INT | FK â†’ driver | Conductor asignado (opcional) |
| side_code | VARCHAR(1) | | A o B (lado de ruta) |
| display_order | INT | DEFAULT 0 | Orden visualizaciÃ³n (drag & drop) âœ¨ NUEVO |
| is_backup | BOOLEAN | DEFAULT false | Unidad de retÃ©n âœ¨ NUEVO |
| auto_generated | BOOLEAN | DEFAULT false | Generado automÃ¡ticamente âœ¨ NUEVO |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Notas:**
- `is_backup=TRUE`: Unidad retÃ©n que entra si otra falla
- `display_order`: Permite reordenar en UI con drag & drop
- `auto_generated`: Marca si fue creado por algoritmo automÃ¡tico

---

### **30. dispatch_queue**

**DescripciÃ³n:** Cola de despacho en tiempo real. Unidades en espera ordenadas por llegada, prioridad o programaciÃ³n para autorizaciÃ³n del despachador.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| queue_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| terminal_id | INT | NOT NULL, FK â†’ terminal | Terminal de cola |
| route_id | INT | NOT NULL, FK â†’ route | Ruta solicitada |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo en cola |
| driver_id | INT | NOT NULL, FK â†’ driver | Conductor asignado |
| side_code | VARCHAR(1) | | Lado de ruta (A/B) |
| entry_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Ingreso a cola |
| scheduled_time | TIMESTAMPTZ | | Hora programada (opcional) |
| queue_position | INT | | PosiciÃ³n en cola |
| entry_type | VARCHAR(20) | DEFAULT 'MANUAL' | MANUAL, AUTOMATIC, PRIORITY |
| status | VARCHAR(20) | DEFAULT 'WAITING' | WAITING, DISPATCHED, CANCELLED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

---

### **31. dispatch**

**DescripciÃ³n:** Registro oficial de despachos autorizados. Captura momento exacto de salida, despachador que autorizÃ³ y validaciones pasadas.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| dispatch_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| queue_id | BIGINT | FK â†’ dispatch_queue | Cola de origen |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| schedule_detail_id | BIGINT | FK â†’ dispatch_schedule_detail | ProgramaciÃ³n origen |
| route_id | INT | NOT NULL, FK â†’ route | Ruta autorizada |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo despachado |
| driver_id | INT | NOT NULL, FK â†’ driver | Conductor autorizado |
| terminal_id | INT | NOT NULL, FK â†’ terminal | Terminal de salida |
| side_code | VARCHAR(1) | | Lado de ruta |
| scheduled_time | TIMESTAMPTZ | | Hora programada |
| actual_dispatch_time | TIMESTAMPTZ | NOT NULL | Hora real de salida |
| dispatched_by | BIGINT | NOT NULL, FK â†’ user | Despachador que autorizÃ³ |
| dispatch_type | VARCHAR(20) | DEFAULT 'NORMAL' | NORMAL, EMERGENCY, REPLACEMENT |
| validations_passed | JSONB | | Validaciones aprobadas |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **32. dispatch_exception**

**DescripciÃ³n:** Excepciones autorizadas durante despacho. Registra casos donde se permitiÃ³ salida a pesar de restricciones menores con aprobaciÃ³n supervisor.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| exception_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| exception_type_id | INT | FK â†’ exception_type | Tipo de excepciÃ³n âœ¨ NUEVO |
| restriction_id | BIGINT | FK â†’ operational_restriction | RestricciÃ³n origen |
| vehicle_id | INT | FK â†’ vehicle | VehÃ­culo exceptuado |
| driver_id | INT | FK â†’ driver | Conductor exceptuado |
| requested_by | BIGINT | NOT NULL, FK â†’ user | Despachador solicitante |
| requested_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de solicitud |
| acknowledged_at | TIMESTAMPTZ | | CuÃ¡ndo se tomÃ³ conocimiento âœ¨ NUEVO |
| approved_by | BIGINT | FK â†’ user | Supervisor que aprobÃ³ |
| approved_at | TIMESTAMPTZ | | Fecha de aprobaciÃ³n |
| valid_until | TIMESTAMPTZ | | Vigencia de excepciÃ³n |
| auto_expire_at | TIMESTAMPTZ | | ExpiraciÃ³n automÃ¡tica âœ¨ NUEVO |
| is_currently_active | BOOLEAN | DEFAULT false | ExcepciÃ³n vigente ahora âœ¨ NUEVO |
| duration_minutes | INT | | DuraciÃ³n total (minutos) âœ¨ NUEVO |
| reason | TEXT | NOT NULL | JustificaciÃ³n |
| documents_provided | JSONB | | Documentos adjuntos âœ¨ NUEVO |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, APPROVED, REJECTED, EXPIRED |
| resolution_notes | TEXT | | Notas de resoluciÃ³n |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Notas:**
- `documents_provided`: JSON con estructura `[{"type": "COMPROMISO", "file_id": 123}]`
- `auto_expire_at`: Calculado segÃºn configuraciÃ³n de `exception_type`

---

### **33. exception_type** âœ¨ NUEVO

**DescripciÃ³n:** CatÃ¡logo parametrizable de tipos de excepciÃ³n. Define reglas de vigencia, aprobadores y lÃ­mites de uso.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| exception_type_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| code | VARCHAR(50) | UNIQUE NOT NULL | CÃ³digo Ãºnico |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | DescripciÃ³n detallada |
| restriction_type_id | INT | FK â†’ restriction_type | RestricciÃ³n que origina |
| max_validity_type | VARCHAR(20) | NOT NULL | HOURS, DAYS, UNTIL_EXPIRY, SINGLE_USE |
| max_validity_value | INT | | Valor numÃ©rico (horas/dÃ­as) |
| allows_renewal | BOOLEAN | DEFAULT false | Permite renovaciÃ³n |
| required_approver_role | VARCHAR(50) | NOT NULL | Rol aprobador: SUPERVISOR, JEFE_OPERACIONES |
| requires_documentation | BOOLEAN | DEFAULT false | Requiere adjuntar documentos |
| documentation_types | TEXT[] | | Tipos de documentos requeridos |
| max_exceptions_per_period | INT | | LÃ­mite de excepciones |
| period_type | VARCHAR(20) | | DAY, WEEK, MONTH, YEAR |
| notify_to_roles | TEXT[] | | Roles a notificar |
| requires_audit | BOOLEAN | DEFAULT false | AuditorÃ­a obligatoria |
| is_active | BOOLEAN | DEFAULT true | Tipo activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Ejemplo de configuraciÃ³n:**
```sql
-- ExcepciÃ³n para SOAT prÃ³ximo a vencer
code: 'DOC_EXPIRING_SOAT'
max_validity_type: 'UNTIL_EXPIRY'  -- Vigente hasta que se renueve el doc
required_approver_role: 'SUPERVISOR'
requires_documentation: true
documentation_types: ['COMPROMISO_RENOVACION']
```

---

### **34. exception_monthly_summary** âœ¨ NUEVO

**DescripciÃ³n:** Resumen mensual agregado de excepciones por tipo. Generado por job mensual para reportes y anÃ¡lisis de tendencias.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| summary_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| summary_month | DATE | NOT NULL | Primer dÃ­a del mes |
| exception_type_id | INT | FK â†’ exception_type | Tipo de excepciÃ³n |
| total_requested | INT | DEFAULT 0 | Total solicitadas |
| total_approved | INT | DEFAULT 0 | Total aprobadas |
| total_rejected | INT | DEFAULT 0 | Total rechazadas |
| total_expired | INT | DEFAULT 0 | Total expiradas |
| avg_approval_time_minutes | INT | | Tiempo promedio aprobaciÃ³n |
| max_approval_time_minutes | INT | | Tiempo mÃ¡ximo aprobaciÃ³n |
| most_frequent_vehicle_id | INT | FK â†’ vehicle | VehÃ­culo mÃ¡s frecuente |
| most_frequent_driver_id | INT | FK â†’ driver | Conductor mÃ¡s frecuente |
| top_reasons | JSONB | | Top razones de solicitud |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Unique Constraint:** (summary_month, exception_type_id)

**GeneraciÃ³n:** Job ejecutado el dÃ­a 1 de cada mes a las 02:00 AM

---

### **35. operational_restriction**

**DescripciÃ³n:** Restricciones operativas activas. Bloqueos temporales por documentos vencidos, deudas, mantenimiento o situaciones especiales.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| restriction_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| restriction_type_id | INT | NOT NULL, FK â†’ restriction_type | Tipo de restricciÃ³n |
| company_id | INT | NOT NULL, FK â†’ company | Empresa |
| entity_type | VARCHAR(20) | NOT NULL | DRIVER, VEHICLE, TERMINAL |
| entity_id | INT | NOT NULL | ID de entidad afectada |
| severity | VARCHAR(20) | NOT NULL | CRITICAL, WARNING, INFO |
| reason | TEXT | NOT NULL | Motivo de la restricciÃ³n |
| applied_by | BIGINT | NOT NULL, FK â†’ user | Usuario que aplicÃ³ |
| applied_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de aplicaciÃ³n |
| expires_at | TIMESTAMPTZ | | Fecha de expiraciÃ³n |
| resolved_at | TIMESTAMPTZ | | Fecha de resoluciÃ³n |
| resolved_by | BIGINT | FK â†’ user | Usuario que resolviÃ³ |
| resolution_notes | TEXT | | Notas de resoluciÃ³n |
| is_active | BOOLEAN | DEFAULT true | RestricciÃ³n activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

---

### **36. restriction_type**

**DescripciÃ³n:** Tipos de restricciones. Define comportamiento y nivel de bloqueo para cada caso.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| restriction_type_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| code | VARCHAR(50) | UNIQUE, NOT NULL | CÃ³digo (DOC_EXPIRED, LOW_FUEL, DEBT) |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | DescripciÃ³n detallada |
| entity_type | VARCHAR(20) | | PERSON, VEHICLE, MANUAL, SYSTEM âœ¨ NUEVO |
| default_severity | VARCHAR(20) | NOT NULL | Severidad por defecto |
| blocks_dispatch | BOOLEAN | DEFAULT true | Bloquea despacho |
| requires_approval | BOOLEAN | DEFAULT false | Requiere autorizaciÃ³n supervisor |
| alert_days_before | INT | DEFAULT 15 | DÃ­as anticipaciÃ³n alerta âœ¨ NUEVO |
| display_order | INT | DEFAULT 0 | Orden visualizaciÃ³n âœ¨ NUEVO |
| category | VARCHAR(50) | | DOCUMENTS, FINANCIAL, OPERATIONAL, TECHNICAL âœ¨ NUEVO |
| is_active | BOOLEAN | DEFAULT true | Tipo activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Notas:**
- `entity_type`: Indica a quÃ© aplica (persona, vehÃ­culo, manual del sistema)
- `alert_days_before`: Genera alerta preventiva X dÃ­as antes de vencimiento

---

### **37. restriction_daily_summary** âœ¨ NUEVO

**DescripciÃ³n:** Resumen diario de restricciones activas. Generado por job nocturno para anÃ¡lisis de tendencias.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| summary_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| summary_date | DATE | NOT NULL UNIQUE | Fecha del resumen |
| critical_count | INT | DEFAULT 0 | Restricciones crÃ­ticas |
| warning_count | INT | DEFAULT 0 | Restricciones de advertencia |
| info_count | INT | DEFAULT 0 | Restricciones informativas |
| total_active | INT | DEFAULT 0 | Total activas |
| new_today | INT | DEFAULT 0 | Nuevas del dÃ­a |
| resolved_today | INT | DEFAULT 0 | Resueltas del dÃ­a |
| expired_today | INT | DEFAULT 0 | Expiradas del dÃ­a |
| person_restrictions | INT | DEFAULT 0 | Restricciones de personas |
| vehicle_restrictions | INT | DEFAULT 0 | Restricciones de vehÃ­culos |
| top_restriction_types | JSONB | | Top tipos de restricciÃ³n |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**GeneraciÃ³n:** Job nocturno (23:59 o 00:05)

---

### **38. trip**

**DescripciÃ³n:** Viajes realizados. Cada viaje representa un recorrido completo de una unidad desde origen hasta destino.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| trip_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| dispatch_id | BIGINT | FK â†’ dispatch | Despacho origen |
| route_id | INT | NOT NULL, FK â†’ route | Ruta ejecutada |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo utilizado |
| driver_id | INT | NOT NULL, FK â†’ driver | Conductor asignado |
| direction | VARCHAR(10) | NOT NULL | IDA, VUELTA |
| scheduled_start_time | TIMESTAMPTZ | | Hora programada inicio |
| actual_start_time | TIMESTAMPTZ | NOT NULL | Hora real inicio |
| scheduled_end_time | TIMESTAMPTZ | | Hora programada llegada |
| actual_end_time | TIMESTAMPTZ | | Hora real llegada |
| estimated_arrival | TIMESTAMPTZ | | Hora estimada llegada (viaje activo) |
| max_speed_kmh | INT | | Velocidad mÃ¡xima registrada âœ¨ NUEVO |
| avg_speed_kmh | INT | | Velocidad promedio âœ¨ NUEVO |
| total_distance_km | DECIMAL(8,2) | | Distancia total recorrida âœ¨ NUEVO |
| max_deviation_meters | INT | | DesviaciÃ³n mÃ¡xima de ruta âœ¨ NUEVO |
| compliance_score | DECIMAL(5,2) | | PuntuaciÃ³n cumplimiento (0-100) âœ¨ NUEVO |
| punctuality_score | DECIMAL(5,2) | | PuntuaciÃ³n puntualidad (0-100) âœ¨ NUEVO |
| active_alerts_count | INT | DEFAULT 0 | Contador alertas activas âœ¨ NUEVO |
| has_warnings | BOOLEAN | DEFAULT false | Tiene advertencias âœ¨ NUEVO |
| status | VARCHAR(20) | DEFAULT 'SCHEDULED' | SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Notas:**
- `compliance_score`: Calculado al finalizar viaje basado en checkpoints, adherencia ruta y velocidad
- `punctuality_score`: Basado en cumplimiento de horarios en puntos de control

**Particionada por:** actual_start_time (mensual recomendado)

---

### **39. trip_stop** âœ¨ RESTAURADO

**DescripciÃ³n:** Paradas durante viaje. Registra paso por cada paradero con hora programada vs real. Base para matriz de cumplimiento.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| trip_stop_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| trip_id | BIGINT | NOT NULL, FK â†’ trip | Viaje asociado |
| stop_id | INT | NOT NULL, FK â†’ route_stop | Paradero de la ruta |
| scheduled_arrival_time | TIMESTAMPTZ | | Hora programada de llegada |
| actual_arrival_time | TIMESTAMPTZ | | Hora real de llegada |
| arrival_delay_seconds | INT | | Diferencia: real - programado âœ¨ NUEVO |
| scheduled_departure_time | TIMESTAMPTZ | | Hora programada de salida |
| actual_departure_time | TIMESTAMPTZ | | Hora real de salida |
| compliance_status | VARCHAR(20) | | ON_TIME, EARLY, LATE, MISSED âœ¨ NUEVO |
| passengers_boarding | INT | | Pasajeros que subieron |
| passengers_alighting | INT | | Pasajeros que bajaron |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Unique Constraint:** (trip_id, stop_id)

**Notas:**
- `arrival_delay_seconds`: Positivo = retraso, Negativo = adelanto
- `compliance_status`:
  - `ON_TIME`: Â±2 minutos
  - `EARLY`: <-2 minutos
  - `LATE`: >2 minutos
  - `MISSED`: No pasÃ³ por el checkpoint

**Uso en Matriz de Cumplimiento:**
```sql
-- Consulta para matriz
SELECT 
    t.trip_id,
    ts.stop_id,
    ROUND(ts.arrival_delay_seconds::numeric / 60, 1) as diff_minutes,
    ts.compliance_status
FROM trip t
JOIN trip_stop ts ON t.trip_id = ts.trip_id
WHERE t.route_id = :route_id 
  AND DATE(t.actual_start_time) = :date
```

---

### **40. trip_event** âœ¨ NUEVO

**DescripciÃ³n:** Eventos relevantes durante viaje (alertas, paradas prolongadas, desvÃ­os). Fundamental para reproductor de viajes.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| trip_event_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| trip_id | BIGINT | NOT NULL, FK â†’ trip | Viaje asociado |
| event_type | VARCHAR(50) | NOT NULL | Tipo de evento |
| event_subtype | VARCHAR(50) | | Subtipo especÃ­fico |
| latitude | DECIMAL(10,8) | | Latitud del evento |
| longitude | DECIMAL(11,8) | | Longitud del evento |
| location_description | TEXT | | DescripciÃ³n de ubicaciÃ³n |
| occurred_at | TIMESTAMPTZ | NOT NULL | Timestamp del evento |
| duration_seconds | INT | | DuraciÃ³n del evento |
| severity | VARCHAR(20) | | INFO, WARNING, CRITICAL |
| event_data | JSONB | | Datos especÃ­ficos del evento |
| was_resolved | BOOLEAN | DEFAULT false | Evento resuelto |
| resolved_at | TIMESTAMPTZ | | CuÃ¡ndo se resolviÃ³ |
| resolution_notes | TEXT | | Notas de resoluciÃ³n |
| resolved_by | BIGINT | FK â†’ user | Usuario que resolviÃ³ |
| alert_id | BIGINT | FK â†’ alert | Alerta generada (si aplica) |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Valores de `event_type`:**
- `SPEED_EXCESS`: Exceso de velocidad
- `STOP_PROLONGED`: Parada prolongada
- `ROUTE_DEVIATION`: DesvÃ­o de ruta
- `CHECKPOINT_DELAY`: Retraso en checkpoint
- `GPS_SIGNAL_LOST`: PÃ©rdida de seÃ±al GPS
- `GEOFENCE_VIOLATED`: ViolaciÃ³n de geocerca
- `FUEL_LOW`: Combustible bajo
- `EMERGENCY_STOP`: Parada de emergencia
- `PASSENGER_INCIDENT`: Incidente con pasajero
- `MECHANICAL_ISSUE`: Problema mecÃ¡nico
- `COMMUNICATION_ATTEMPT`: Intento de comunicaciÃ³n

**Ejemplo `event_data`:**
```json
// SPEED_EXCESS
{"speed_kmh": 95, "limit_kmh": 60, "excess_kmh": 35}

// STOP_PROLONGED
{"stop_duration_seconds": 480, "location": "Paradero 20"}

// ROUTE_DEVIATION
{"deviation_meters": 250, "duration_seconds": 90}
```

---

### **41. trip_passenger_count**

**DescripciÃ³n:** Conteo de pasajeros por tramo. Permite anÃ¡lisis de demanda y ocupaciÃ³n.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| passenger_count_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| trip_id | BIGINT | NOT NULL, FK â†’ trip | Viaje asociado |
| stop_id | INT | FK â†’ route_stop | Parada de conteo |
| count_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp del conteo |
| passengers_on_board | INT | NOT NULL | Pasajeros a bordo |
| passengers_boarding | INT | DEFAULT 0 | Subieron en esta parada |
| passengers_alighting | INT | DEFAULT 0 | Bajaron en esta parada |
| capacity_percent | DECIMAL(5,2) | | % ocupaciÃ³n vs capacidad |
| count_method | VARCHAR(20) | | MANUAL, AUTOMATIC, ESTIMATED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **42. trip_location**

**DescripciÃ³n:** Trackeo GPS del viaje. Captura posiciones en tiempo real para seguimiento y anÃ¡lisis posterior.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| location_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| trip_id | BIGINT | NOT NULL, FK â†’ trip | Viaje asociado |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud GPS |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud GPS |
| altitude | INT | | Altitud (metros) |
| speed_kmh | INT | | Velocidad instantÃ¡nea |
| heading | INT | | Rumbo (0-360Â°) |
| accuracy_meters | INT | | PrecisiÃ³n GPS |
| recorded_at | TIMESTAMPTZ | NOT NULL | Timestamp captura |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Particionada por:** recorded_at (diaria recomendado)

**Ãndices:** (trip_id, recorded_at DESC)

---

### **43. trip_speed_event**

**DescripciÃ³n:** Eventos de velocidad durante viaje. Registro especÃ­fico de excesos o velocidades anÃ³malas.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| speed_event_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| trip_id | BIGINT | NOT NULL, FK â†’ trip | Viaje asociado |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud del evento |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud del evento |
| recorded_speed_kmh | INT | NOT NULL | Velocidad registrada |
| speed_limit_kmh | INT | NOT NULL | LÃ­mite permitido |
| excess_kmh | INT | NOT NULL | Exceso de velocidad |
| event_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp del evento |
| duration_seconds | INT | | DuraciÃ³n del exceso |
| severity | VARCHAR(20) | | LOW, MEDIUM, HIGH, CRITICAL |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **44. trip_compliance_matrix_cache** âœ¨ NUEVO

**DescripciÃ³n:** Cache pre-calculado de matriz de cumplimiento para rendering rÃ¡pido en UI. Evita consultas costosas en tiempo real.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| cache_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| route_id | INT | NOT NULL, FK â†’ route | Ruta del cache |
| schedule_date | DATE | NOT NULL | Fecha de la programaciÃ³n |
| total_trips | INT | DEFAULT 0 | Total de viajes |
| compliant_trips | INT | DEFAULT 0 | Viajes conformes |
| warning_trips | INT | DEFAULT 0 | Viajes con advertencia |
| critical_trips | INT | DEFAULT 0 | Viajes crÃ­ticos |
| avg_compliance_score | DECIMAL(5,2) | | PuntuaciÃ³n promedio |
| matrix_data | JSONB | NOT NULL | Matriz completa serializada |
| last_updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |
| cache_version | INT | DEFAULT 1 | VersiÃ³n del cache |
| is_stale | BOOLEAN | DEFAULT false | Cache desactualizado |

**Unique Constraint:** (route_id, schedule_date)

**Estructura de `matrix_data`:**
```json
{
  "route_id": 1045,
  "date": "2025-11-18",
  "control_points": [
    {"stop_id": 1, "code": "TER", "name": "Terminal SJL"},
    {"stop_id": 5, "code": "1Z", "name": "Paradero 1Z Huachipa"},
    {"stop_id": 12, "code": "9H", "name": "Paradero 9H Huachipa"}
  ],
  "trips": [
    {
      "trip_id": 542,
      "sequence": 87,
      "vehicle_code": "D0V-258",
      "driver_name": "Juan PÃ©rez",
      "scheduled_start": "09:47:00",
      "stops_data": [
        {"stop_id": 1, "diff_minutes": 0, "status": "ON_TIME"},
        {"stop_id": 5, "diff_minutes": -3, "status": "EARLY"},
        {"stop_id": 12, "diff_minutes": -2, "status": "EARLY"}
      ],
      "total_diff": -5,
      "overall_status": "ON_TIME"
    }
  ],
  "summary": {
    "on_time": 18,
    "early": 10,
    "late": 24
  }
}
```

**RegeneraciÃ³n:** Job cada 30 minutos o trigger al finalizar viajes

---

### **45. frequency_control**

**DescripciÃ³n:** Control de frecuencias entre despachos. Valida cumplimiento de intervalos mÃ­nimos segÃºn normativa ATU.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| frequency_control_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| route_id | INT | NOT NULL, FK â†’ route | Ruta controlada |
| terminal_id | INT | NOT NULL, FK â†’ terminal | Terminal de control |
| control_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp del control |
| previous_dispatch_time | TIMESTAMPTZ | | Despacho anterior |
| current_dispatch_time | TIMESTAMPTZ | NOT NULL | Despacho actual |
| interval_seconds | INT | NOT NULL | Intervalo entre despachos |
| expected_frequency_seconds | INT | NOT NULL | Frecuencia esperada |
| deviation_seconds | INT | | DesviaciÃ³n de frecuencia |
| is_compliant | BOOLEAN | NOT NULL | Cumple frecuencia |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **46. route_compliance**

**DescripciÃ³n:** Cumplimiento de ruta. Registro de adherencia al trazado autorizado por viaje.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| compliance_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| trip_id | BIGINT | NOT NULL, FK â†’ trip | Viaje evaluado |
| route_id | INT | NOT NULL, FK â†’ route | Ruta autorizada |
| total_points_captured | INT | NOT NULL | Puntos GPS capturados |
| points_on_route | INT | NOT NULL | Puntos dentro de ruta |
| compliance_percent | DECIMAL(5,2) | NOT NULL | % adherencia a ruta |
| max_deviation_meters | INT | | DesviaciÃ³n mÃ¡xima |
| total_deviations | INT | DEFAULT 0 | Total de desvÃ­os |
| deviation_duration_seconds | INT | | Tiempo fuera de ruta |
| is_compliant | BOOLEAN | NOT NULL | Cumple normativa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de evaluaciÃ³n |

---

### **47. alert_type**

**DescripciÃ³n:** Tipos de alertas GPS. CatÃ¡logo de condiciones monitoreadas automÃ¡ticamente.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| alert_type_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| code | VARCHAR(50) | UNIQUE, NOT NULL | CÃ³digo Ãºnico |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | DescripciÃ³n detallada |
| default_severity | VARCHAR(20) | NOT NULL | INFO, WARNING, CRITICAL |
| is_enabled | BOOLEAN | DEFAULT true | Tipo activo |
| threshold_config | JSONB | | ConfiguraciÃ³n de umbrales |
| notification_channels | TEXT[] | | Canales de notificaciÃ³n |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Ejemplo `threshold_config`:**
```json
// SPEED_LIMIT
{"threshold_kmh": 80, "duration_seconds": 30}

// ROUTE_DEVIATION
{"max_distance_meters": 200, "duration_minutes": 10}
```

---

### **48. alert**

**DescripciÃ³n:** Alertas GPS generadas automÃ¡ticamente. Notificaciones de eventos que requieren atenciÃ³n del monitoreador.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| alert_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| company_id | INT | NOT NULL, FK â†’ company | Empresa |
| alert_type_id | INT | NOT NULL, FK â†’ alert_type | Tipo de alerta |
| vehicle_id | INT | FK â†’ vehicle | VehÃ­culo involucrado |
| driver_id | INT | FK â†’ driver | Conductor involucrado |
| trip_id | BIGINT | FK â†’ trip | Viaje asociado |
| severity | VARCHAR(20) | NOT NULL | INFO, WARNING, CRITICAL |
| message | TEXT | NOT NULL | Mensaje de la alerta |
| context_data | JSONB | | Datos contextuales |
| triggered_at | TIMESTAMPTZ | NOT NULL | Timestamp generaciÃ³n |
| acknowledged_by | BIGINT | FK â†’ user | Usuario que reconociÃ³ |
| acknowledged_at | TIMESTAMPTZ | | Timestamp reconocimiento |
| muted_until | TIMESTAMPTZ | | Silenciada hasta âœ¨ NUEVO |
| in_progress_by | BIGINT | FK â†’ user | Usuario atendiendo âœ¨ NUEVO |
| in_progress_at | TIMESTAMPTZ | | Inicio de atenciÃ³n âœ¨ NUEVO |
| response_time_seconds | INT | | Tiempo de respuesta âœ¨ NUEVO |
| resolution_notes | TEXT | | Notas de resoluciÃ³n âœ¨ NUEVO |
| status | VARCHAR(20) | DEFAULT 'PENDING' | Estado de la alerta |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Valores de `status`:**
- `PENDING`: Sin atender
- `IN_PROGRESS`: En atenciÃ³n
- `ACKNOWLEDGED`: Reconocida
- `RESOLVED`: Resuelta
- `DISMISSED`: Descartada
- `ESCALATED`: Escalada a supervisor

**Particionada por:** triggered_at (mensual)

---

### **49. alert_communication_log** âœ¨ NUEVO

**DescripciÃ³n:** Registro de comunicaciones durante gestiÃ³n de alertas. Documenta llamadas, mensajes TTS, radios enviados durante atenciÃ³n.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| communication_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| alert_id | BIGINT | NOT NULL, FK â†’ alert | Alerta asociada |
| communication_type | VARCHAR(30) | NOT NULL | Tipo de comunicaciÃ³n |
| initiated_by | BIGINT | FK â†’ user | Usuario que inicia |
| recipient_type | VARCHAR(20) | | DRIVER, SUPERVISOR, MANAGER, DISPATCHER |
| recipient_id | BIGINT | | ID del destinatario |
| message_content | TEXT | | Contenido del mensaje |
| response_received | BOOLEAN | DEFAULT false | Se recibiÃ³ respuesta |
| response_content | TEXT | | Contenido de la respuesta |
| response_time_seconds | INT | | Tiempo de respuesta |
| communication_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Timestamp envÃ­o |
| response_timestamp | TIMESTAMPTZ | | Timestamp respuesta |
| was_successful | BOOLEAN | DEFAULT true | ComunicaciÃ³n exitosa |
| failure_reason | TEXT | | RazÃ³n de fallo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Valores de `communication_type`:**
- `PHONE_CALL`: Llamada telefÃ³nica
- `TTS_MESSAGE`: Mensaje text-to-speech
- `RADIO`: ComunicaciÃ³n por radio
- `SMS`: Mensaje de texto
- `PUSH_NOTIFICATION`: NotificaciÃ³n push
- `EMAIL`: Correo electrÃ³nico

**Proceso de uso:**
1. Monitoreador hace clic en "Llamar conductor"
2. Sistema registra comunicaciÃ³n con `initiated_by` y `communication_timestamp`
3. Si conductor responde, actualiza `response_received=true`, `response_content`, `response_timestamp`
4. UI muestra en historial: "14:42:30 - Llamada telefÃ³nica âœ“ Respondida (30s)"

---

### **50. alert_daily_summary** âœ¨ NUEVO

**DescripciÃ³n:** Resumen diario agregado de alertas por tipo. Generado por job nocturno para anÃ¡lisis y reportes.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| summary_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| summary_date | DATE | NOT NULL | Fecha del resumen |
| alert_type_id | INT | FK â†’ alert_type | Tipo de alerta |
| total_alerts | INT | DEFAULT 0 | Total de alertas |
| critical_alerts | INT | DEFAULT 0 | Alertas crÃ­ticas |
| warning_alerts | INT | DEFAULT 0 | Alertas de advertencia |
| info_alerts | INT | DEFAULT 0 | Alertas informativas |
| avg_response_time_seconds | INT | | Tiempo promedio respuesta |
| max_response_time_seconds | INT | | Tiempo mÃ¡ximo respuesta |
| min_response_time_seconds | INT | | Tiempo mÃ­nimo respuesta |
| alerts_by_hour | JSONB | | DistribuciÃ³n por hora |
| top_vehicles | JSONB | | Top vehÃ­culos con alertas |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Unique Constraint:** (summary_date, alert_type_id)

**Estructura `alerts_by_hour`:**
```json
{
  "0": 5,   // 00:00-00:59
  "1": 3,   // 01:00-01:59
  ...
  "23": 8   // 23:00-23:59
}
```

**GeneraciÃ³n:** Job nocturno similar a `restriction_daily_summary`

---

### **51-60. Otros mÃ³dulos de core_operations**

(Tablas de incidentes, quejas, horarios publicados - sin cambios respecto a versiÃ³n anterior)

---


### **51. incident**

**DescripciÃ³n:** Incidentes operativos reportados durante operaciÃ³n (averÃ­as, accidentes, bloqueos de vÃ­a, conflictos). Seguimiento completo desde reporte hasta resoluciÃ³n con evidencias fotogrÃ¡ficas adjuntas.

**Casos de uso relacionados:**
- CU-CON-007: Reportar Incidencias en Ruta (Conductor)
- CU-INS-004: Atender Incidencias en Ruta (Inspector)
- CU-DES-007: Gestionar Incidencias (Despachador)
- CU-MON-005: Responder a Alertas GPS (Monitoreador)

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| incident_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| incident_type_id | INT | NOT NULL, FK â†’ incident_type | Tipo de incidencia |
| trip_id | BIGINT | FK â†’ trip | Viaje afectado (opcional) |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo involucrado |
| driver_id | INT | FK â†’ driver | Conductor involucrado |
| route_id | INT | FK â†’ route | Ruta afectada |
| latitude | DECIMAL(10,8) | | UbicaciÃ³n del incidente |
| longitude | DECIMAL(11,8) | | UbicaciÃ³n del incidente |
| location_description | VARCHAR(255) | | DescripciÃ³n de ubicaciÃ³n (ej: "Av. Principal paradero 8") |
| reported_by | BIGINT | NOT NULL, FK â†’ user | Usuario que reportÃ³ |
| reported_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del reporte |
| incident_date | DATE | NOT NULL | Fecha del incidente |
| incident_time | TIME | NOT NULL | Hora del incidente |
| description | TEXT | NOT NULL | DescripciÃ³n detallada |
| severity | VARCHAR(20) | NOT NULL | LOW, MEDIUM, HIGH, CRITICAL |
| status | VARCHAR(20) | DEFAULT 'OPEN' | OPEN, IN_PROGRESS, RESOLVED, CLOSED |
| passengers_affected | INT | DEFAULT 0 | NÃºmero de pasajeros afectados |
| service_disrupted | BOOLEAN | DEFAULT false | Servicio interrumpido |
| estimated_delay_minutes | INT | | Retraso estimado |
| assigned_to | BIGINT | FK â†’ user | Responsable asignado |
| acknowledged_at | TIMESTAMPTZ | | Fecha de reconocimiento |
| acknowledged_by | BIGINT | FK â†’ user | Usuario que reconociÃ³ |
| resolved_at | TIMESTAMPTZ | | Fecha de resoluciÃ³n |
| resolved_by | BIGINT | FK â†’ user | Usuario que resolviÃ³ |
| resolution_type | VARCHAR(20) | | FIXED, ESCALATED, CLOSED, WORKAROUND |
| resolution_notes | TEXT | | Notas de resoluciÃ³n |
| action_taken | TEXT | | AcciÃ³n correctiva tomada |
| root_cause | TEXT | | Causa raÃ­z identificada |
| preventive_measures | TEXT | | Medidas preventivas recomendadas |
| follow_up_required | BOOLEAN | DEFAULT false | Requiere seguimiento |
| follow_up_date | DATE | | Fecha de seguimiento |
| cost_impact | DECIMAL(10,2) | | Impacto econÃ³mico estimado |
| evidence_file_ids | BIGINT[] | | Array de IDs de archivos adjuntos (fotos, videos) |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Ãndices:**
- `idx_incident_company_date` ON (company_id, incident_date DESC)
- `idx_incident_status` ON (status) WHERE status != 'CLOSED'
- `idx_incident_vehicle` ON (vehicle_id, incident_date DESC)
- `idx_incident_severity` ON (severity) WHERE severity IN ('HIGH', 'CRITICAL')

**Particionada por:** incident_date (mensual recomendado para alto volumen)

**Notas de implementaciÃ³n:**
- El campo `evidence_file_ids` es un array que reemplaza la tabla `incident_photo`
- Permite adjuntar mÃºltiples fotos/videos desde app mÃ³vil
- La resoluciÃ³n se maneja en los campos dedicados, no requiere tabla separada
- Los estados permiten workflow: OPEN â†’ IN_PROGRESS â†’ RESOLVED â†’ CLOSED

**Validaciones:**
- `severity` debe escalarse automÃ¡ticamente si hay heridos (`passengers_affected > 0` con heridas)
- `status` solo puede cambiar a RESOLVED si hay `resolution_notes`
- `assigned_to` es obligatorio cuando `status` = 'IN_PROGRESS'

---

### **52. incident_type**

**DescripciÃ³n:** CatÃ¡logo de tipos de incidencias operativas con protocolos de respuesta predefinidos. Define severidad por defecto, tiempo de escalamiento y si requiere respuesta inmediata.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| incident_type_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| code | VARCHAR(50) | UNIQUE, NOT NULL | CÃ³digo Ãºnico (BREAKDOWN, ACCIDENT, TRAFFIC, BLOCKAGE) |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | DescripciÃ³n del protocolo de respuesta |
| category | VARCHAR(50) | | MECHANICAL, SAFETY, TRAFFIC, PASSENGER, WEATHER, SECURITY |
| default_severity | VARCHAR(20) | NOT NULL | Severidad por defecto: LOW, MEDIUM, HIGH, CRITICAL |
| requires_immediate_response | BOOLEAN | DEFAULT false | Respuesta inmediata obligatoria |
| escalation_minutes | INT | | Minutos antes de escalar automÃ¡ticamente |
| notify_roles | TEXT[] | | Roles a notificar automÃ¡ticamente |
| response_protocol | TEXT | | Protocolo de respuesta paso a paso |
| requires_photo_evidence | BOOLEAN | DEFAULT false | Requiere evidencia fotogrÃ¡fica |
| blocks_service | BOOLEAN | DEFAULT false | Bloquea servicio automÃ¡ticamente |
| is_active | BOOLEAN | DEFAULT true | Tipo activo |
| display_order | INT | DEFAULT 0 | Orden de visualizaciÃ³n |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Ãndices:**
- `idx_incident_type_code` ON (code)
- `idx_incident_type_active` ON (is_active) WHERE is_active = true

**Datos semilla tÃ­picos:**
```sql
-- Incidentes mecÃ¡nicos
('BREAKDOWN', 'AverÃ­a MecÃ¡nica', 'MECHANICAL', 'HIGH', true, 15)
('FLAT_TIRE', 'Llanta Pinchada', 'MECHANICAL', 'MEDIUM', false, 30)
('ENGINE_OVERHEAT', 'Motor Sobrecalentado', 'MECHANICAL', 'HIGH', true, 15)

-- Incidentes de seguridad
('ACCIDENT', 'Accidente de TrÃ¡nsito', 'SAFETY', 'CRITICAL', true, 5)
('PASSENGER_INJURY', 'Pasajero Herido', 'SAFETY', 'CRITICAL', true, 5)

-- Incidentes de trÃ¡fico
('TRAFFIC', 'CongestiÃ³n Vehicular', 'TRAFFIC', 'MEDIUM', false, 30)
('ROAD_BLOCKAGE', 'Bloqueo de VÃ­a', 'TRAFFIC', 'HIGH', false, 20)

-- Incidentes de pasajeros
('PASSENGER_COMPLAINT', 'Queja de Pasajero', 'PASSENGER', 'LOW', false, 60)
('PASSENGER_CONFLICT', 'Conflicto con Pasajero', 'PASSENGER', 'MEDIUM', false, 30)

-- Incidentes climÃ¡ticos
('HEAVY_RAIN', 'Lluvia Intensa', 'WEATHER', 'MEDIUM', false, NULL)
('FLOODING', 'InundaciÃ³n', 'WEATHER', 'HIGH', true, 15)
```

**Notas de implementaciÃ³n:**
- `escalation_minutes`: NULL = no escala automÃ¡ticamente
- `notify_roles`: array de roles a notificar (ej: ['SUPERVISOR', 'JEFE_OPERACIONES', 'GERENTE'])
- `requires_photo_evidence`: obliga a adjuntar foto al crear incidente de este tipo

---

### **53. schedule_change_log**

**DescripciÃ³n:** AuditorÃ­a completa de cambios en programaciÃ³n de despachos. Registra cada modificaciÃ³n con valores anteriores/nuevos, razÃ³n del cambio y usuario responsable. Fundamental para trazabilidad y anÃ¡lisis de ajustes operativos.

**Casos de uso relacionados:**
- CU-ANL-001: Elaborar ProgramaciÃ³n Diaria (cambios durante elaboraciÃ³n)
- CU-ANL-002: Ajustar ProgramaciÃ³n (modificaciones sobre la marcha)
- CU-JOP-002: Aprobar ProgramaciÃ³n (auditorÃ­a de cambios antes de aprobar)
- AuditorÃ­a interna y cumplimiento normativo

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| schedule_change_log_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| dispatch_schedule_id | BIGINT | NOT NULL, FK â†’ dispatch_schedule | ProgramaciÃ³n maestra afectada |
| schedule_detail_id | BIGINT | FK â†’ dispatch_schedule_detail | Detalle especÃ­fico modificado (si aplica) |
| change_type | VARCHAR(30) | NOT NULL | ADD, MODIFY, DELETE, REORDER, BULK_UPDATE |
| entity_affected | VARCHAR(50) | NOT NULL | SCHEDULE_MASTER, SCHEDULE_DETAIL, SHIFT, VEHICLE, DRIVER |
| field_changed | VARCHAR(100) | | Campo especÃ­fico modificado |
| old_value | TEXT | | Valor anterior (NULL para ADD) |
| new_value | TEXT | | Valor nuevo (NULL para DELETE) |
| change_reason | TEXT | NOT NULL | JustificaciÃ³n del cambio |
| change_category | VARCHAR(30) | | PLANNING, OPERATIONAL, EMERGENCY, CORRECTION |
| affected_count | INT | DEFAULT 1 | NÃºmero de registros afectados (para BULK_UPDATE) |
| changed_by | BIGINT | NOT NULL, FK â†’ user | Usuario que realizÃ³ cambio |
| changed_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del cambio |
| approved_by | BIGINT | FK â†’ user | Usuario que aprobÃ³ (si aplica) |
| approved_at | TIMESTAMPTZ | | Fecha de aprobaciÃ³n |
| approval_required | BOOLEAN | DEFAULT false | Requiere aprobaciÃ³n supervisor |
| approval_status | VARCHAR(20) | | PENDING, APPROVED, REJECTED |
| rejection_reason | TEXT | | Motivo de rechazo |
| ip_address | INET | | IP desde donde se hizo cambio |
| user_agent | TEXT | | Navegador/dispositivo |
| session_id | BIGINT | FK â†’ user_session | SesiÃ³n del usuario |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Ãndices:**
- `idx_schedule_log_schedule` ON (dispatch_schedule_id, changed_at DESC)
- `idx_schedule_log_user` ON (changed_by, changed_at DESC)
- `idx_schedule_log_date` ON (changed_at DESC)
- `idx_schedule_log_type` ON (change_type, change_category)

**Particionada por:** changed_at (mensual)

**Ejemplos de uso:**

**Ejemplo 1: Cambio de hora programada**
```sql
change_type: 'MODIFY'
entity_affected: 'SCHEDULE_DETAIL'
field_changed: 'scheduled_time'
old_value: '06:00:00'
new_value: '06:05:00'
change_reason: 'Ajuste por anÃ¡lisis de demanda - concentrar salidas'
change_category: 'PLANNING'
```

**Ejemplo 2: Cambio de vehÃ­culo en detalle**
```sql
change_type: 'MODIFY'
entity_affected: 'SCHEDULE_DETAIL'
field_changed: 'vehicle_id'
old_value: '245'
new_value: '312'
change_reason: 'VehÃ­culo 245 en mantenimiento preventivo'
change_category: 'OPERATIONAL'
```

**Ejemplo 3: EliminaciÃ³n de salida**
```sql
change_type: 'DELETE'
entity_affected: 'SCHEDULE_DETAIL'
old_value: '{"scheduled_time":"14:30","vehicle_id":145,"sequence":45}'
new_value: NULL
change_reason: 'Baja demanda en franja horaria segÃºn histÃ³rico'
change_category: 'PLANNING'
```

**Ejemplo 4: Reordenamiento masivo**
```sql
change_type: 'BULK_UPDATE'
entity_affected: 'SCHEDULE_DETAIL'
field_changed: 'display_order'
affected_count: 23
change_reason: 'OptimizaciÃ³n de secuencia por drag & drop'
change_category: 'PLANNING'
```

**Notas de implementaciÃ³n:**
- Los valores se almacenan como TEXT para flexibilidad (usar JSON si es estructura compleja)
- Para cambios masivos, un solo registro con `affected_count` > 1
- `approval_required` = true activa workflow de aprobaciÃ³n para cambios crÃ­ticos
- Los timestamps permiten reconstruir cronologÃ­a exacta de modificaciones

---

### **54. timetable**

**DescripciÃ³n:** Horarios pÃºblicos oficiales de rutas publicados para pasajeros y entregados a ATU. Diferente de `dispatch_schedule` (planificaciÃ³n interna operativa). Representa el compromiso pÃºblico de horarios y frecuencias que la empresa comunica a usuarios.

**PropÃ³sito:**
- Cumplimiento regulatorio (entrega a ATU)
- PublicaciÃ³n en web/app para pasajeros
- Compromiso pÃºblico de horarios
- Versiones histÃ³ricas para auditorÃ­a

**Diferencia con dispatch_schedule:**
- `dispatch_schedule`: PlanificaciÃ³n operativa interna detallada (puede cambiar diariamente)
- `timetable`: Horario PÃšBLICO comprometido (cambia menos frecuentemente)

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| timetable_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| route_id | INT | NOT NULL, FK â†’ route | Ruta asociada |
| timetable_type | VARCHAR(20) | NOT NULL | WEEKDAY, SATURDAY, SUNDAY, HOLIDAY |
| effective_date | DATE | NOT NULL | Fecha de inicio de vigencia |
| expiry_date | DATE | | Fecha de fin de vigencia |
| frequency_peak_minutes | INT | | Frecuencia en hora pico (minutos) |
| frequency_valley_minutes | INT | | Frecuencia en hora valle (minutos) |
| first_departure_time | TIME | NOT NULL | Primera salida del dÃ­a |
| last_departure_time | TIME | NOT NULL | Ãšltima salida del dÃ­a |
| total_daily_services | INT | | Total de servicios diarios |
| schedule_data | JSONB | NOT NULL | Datos detallados de horarios |
| notes | TEXT | | Observaciones para pasajeros |
| is_published | BOOLEAN | DEFAULT false | Publicado en web/app |
| published_at | TIMESTAMPTZ | | Fecha de publicaciÃ³n |
| published_by | BIGINT | FK â†’ user | Usuario que publicÃ³ |
| submitted_to_authority | BOOLEAN | DEFAULT false | Enviado a ATU |
| submitted_at | TIMESTAMPTZ | | Fecha de envÃ­o ATU |
| authority_approval_number | VARCHAR(100) | | NÃºmero de aprobaciÃ³n ATU |
| version | INT | DEFAULT 1 | VersiÃ³n del horario |
| status | VARCHAR(20) | DEFAULT 'DRAFT' | DRAFT, PUBLISHED, ARCHIVED, SUPERSEDED |
| created_by | BIGINT | NOT NULL, FK â†’ user | Usuario creador |
| approved_by | BIGINT | FK â†’ user | Jefe que aprobÃ³ |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Ãndices:**
- `idx_timetable_route_effective` ON (route_id, effective_date DESC)
- `idx_timetable_published` ON (is_published, status) WHERE is_published = true
- `idx_timetable_type` ON (timetable_type, route_id)

**Unique Constraint:** (route_id, timetable_type, effective_date) WHERE status != 'SUPERSEDED'

**Estructura de schedule_data (JSONB):**
```json
{
  "route_code": "05",
  "route_name": "San Juan de Lurigancho - Centro de Lima",
  "day_type": "WEEKDAY",
  "time_ranges": [
    {
      "period": "PEAK_MORNING",
      "start_time": "05:30",
      "end_time": "08:30",
      "frequency_minutes": 3,
      "estimated_services": 60
    },
    {
      "period": "VALLEY_MIDDAY",
      "start_time": "08:30",
      "end_time": "16:30",
      "frequency_minutes": 5,
      "estimated_services": 96
    },
    {
      "period": "PEAK_AFTERNOON",
      "start_time": "16:30",
      "end_time": "20:30",
      "frequency_minutes": 3,
      "estimated_services": 80
    },
    {
      "period": "VALLEY_NIGHT",
      "start_time": "20:30",
      "end_time": "22:00",
      "frequency_minutes": 8,
      "estimated_services": 12
    }
  ],
  "key_stops_times": [
    {
      "stop_name": "Terminal SJL",
      "first_departure": "05:30",
      "last_departure": "22:00"
    },
    {
      "stop_name": "Paradero Central",
      "estimated_first": "06:15",
      "estimated_last": "22:45"
    },
    {
      "stop_name": "Plaza de Armas",
      "estimated_first": "06:45",
      "estimated_last": "23:15"
    }
  ],
  "total_daily_services": 248,
  "operating_hours": "05:30 - 22:00",
  "special_notes": "Servicio regular lunes a viernes. Frecuencias pueden variar Â±2 minutos."
}
```

**Workflow tÃ­pico:**
1. Analista crea timetable basado en `dispatch_schedule` histÃ³rica exitosa
2. Jefe Operaciones aprueba
3. Se publica en web/app para pasajeros
4. Se envÃ­a a ATU para registro oficial
5. Se mantiene vigente hasta nueva versiÃ³n (versiÃ³n anterior â†’ status='SUPERSEDED')

**Notas de implementaciÃ³n:**
- Un timetable vigente por (route, type) a la vez
- Al crear nuevo timetable para misma ruta/tipo, el anterior pasa a SUPERSEDED
- `version` se incrementa automÃ¡ticamente para misma ruta/tipo
- Se genera desde dispatch_schedule consolidada, no se edita directamente

---

### **55. timetable_exception**

**DescripciÃ³n:** Excepciones y modificaciones temporales a horarios publicados por eventos especiales, feriados, emergencias o condiciones climÃ¡ticas. Permite comunicar a pasajeros cambios puntuales sin modificar el timetable principal.

**Casos de uso:**
- Feriados nacionales con horario especial
- Eventos masivos (partidos PerÃº, conciertos)
- Emergencias (protestas, cierres de vÃ­a)
- Condiciones climÃ¡ticas adversas
- Mantenimiento programado de vÃ­as

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| timetable_exception_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| timetable_id | BIGINT | NOT NULL, FK â†’ timetable | Horario base afectado |
| exception_date | DATE | NOT NULL | Fecha de la excepciÃ³n |
| exception_type | VARCHAR(30) | NOT NULL | HOLIDAY, SPECIAL_EVENT, EMERGENCY, WEATHER, MAINTENANCE |
| exception_name | VARCHAR(100) | NOT NULL | Nombre del evento (ej: "Navidad", "Partido PerÃº vs Chile") |
| description | TEXT | NOT NULL | DescripciÃ³n detallada para pasajeros |
| is_service_suspended | BOOLEAN | DEFAULT false | Servicio completamente suspendido |
| is_service_modified | BOOLEAN | DEFAULT false | Servicio con modificaciones |
| modified_schedule | JSONB | | Horarios alternativos si aplica |
| frequency_adjustment | VARCHAR(50) | | INCREASED, DECREASED, SAME (si aplica) |
| first_departure_time | TIME | | Primera salida modificada |
| last_departure_time | TIME | | Ãšltima salida modificada |
| affected_routes | INT[] | | Array de route_ids afectadas |
| communication_sent | BOOLEAN | DEFAULT false | NotificaciÃ³n enviada a pasajeros |
| communication_channels | TEXT[] | | Canales usados: WEB, APP, SMS, SOCIAL_MEDIA |
| communicated_at | TIMESTAMPTZ | | Fecha de comunicaciÃ³n |
| is_active | BOOLEAN | DEFAULT true | ExcepciÃ³n vigente |
| created_by | BIGINT | NOT NULL, FK â†’ user | Usuario creador |
| approved_by | BIGINT | FK â†’ user | Supervisor que aprobÃ³ |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Ãndices:**
- `idx_timetable_exception_date` ON (exception_date, is_active)
- `idx_timetable_exception_timetable` ON (timetable_id, exception_date)
- `idx_timetable_exception_type` ON (exception_type)

**Unique Constraint:** (timetable_id, exception_date) WHERE is_active = true


---




**Fin del Diccionario - Schema: core_operations**

**Total de tablas:** 36  
**Estado:** âœ… Ãndice completo - Referir a documento fuente para estructuras detalladas  
**Archivo fuente:** DICCIONARIO_DATOS_OPERATIONS.md

---

**PARA CONSULTAR ESTRUCTURAS DETALLADAS:**

Todas las definiciones completas de tablas estÃ¡n en:
- `DICCIONARIO_DATOS_OPERATIONS.md` lÃ­neas 543-1905
- Incluye: campos, tipos, restricciones, Ã­ndices, ejemplos, notas
# DICCIONARIO DE DATOS v4.0 - SCHEMA: core_finance
**Fecha:** Enero 2026  
**Base de Datos:** PostgreSQL 14+  
**Arquitectura:** 1 BD por cliente (aislamiento total)  
**Alcance:** GPS + Recaudo Manual (Boletos FÃ­sicos)

---

## ÃNDICE AJUSTADO v4.0

### **Schema: `core_finance`** (17 tablas)
```
61. fare                       -- Tarifas vigentes
62. ticket_type                -- Tipos de boletos
63. ticket_inventory           -- Inventario de boletos fÃ­sicos
64. ticket_batch               -- Lotes de talonarios
65. ticket_batch_assignment    -- Salida almacÃ©n â†’ cajeros
66. ticket_supply              -- Suministro cajero â†’ conductor
67. ticket_supply_movement     -- Movimientos de talonarios
68. validator                  -- Ticketeras/validadores (OPCIONAL)
69. validator_assignment       -- AsignaciÃ³n validador-vehÃ­culo (OPCIONAL)
70. trip_production            -- ProducciÃ³n por viaje
71. partial_delivery           -- Entregas parciales durante turno
72. cashier_box                -- Caja del cajero por turno
73. cashier_box_movement       -- Movimientos de caja
74. settlement                 -- LiquidaciÃ³n final a conductor
75. settlement_detail          -- Detalle de boletos liquidados
76. settlement_adjustment      -- Ajustes autorizados
77. payment                    -- Pagos efectuados
78. financial_report           -- Reportes consolidados
```

**NOTAS:**
- Tablas 68-69 (validator*): OPCIONALES - Solo si planeas ticketeras despuÃ©s
- Tablas 61-78: Suficientes para operaciÃ³n GPS + Recaudo Manual
- Se eliminaron 14 tablas innecesarias del Ã­ndice original

---

## DEFINICIONES COMPLETAS

### **61. fare**

**DescripciÃ³n:** Tarifas vigentes por tipo de boleto. Define precios autorizados segÃºn categorÃ­a de pasajero y tipo de servicio.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| fare_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| ticket_type_id | INT | NOT NULL, FK â†’ ticket_type | Tipo de boleto asociado |
| route_id | INT | FK â†’ route | Ruta especÃ­fica (opcional) |
| amount | DECIMAL(10,2) | NOT NULL | Monto de la tarifa |
| currency | VARCHAR(3) | DEFAULT 'PEN' | CÃ³digo moneda (ISO 4217) |
| valid_from | DATE | NOT NULL | Inicio de vigencia |
| valid_until | DATE | | Fin de vigencia |
| is_active | BOOLEAN | DEFAULT true | Tarifa activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

---

### **62. ticket_type**

**DescripciÃ³n:** Tipos de boletos disponibles (DIRECTO, URBANO, ESTUDIANTE, ESCOLAR). CatÃ¡logo de categorÃ­as tarifarias segÃºn normativa.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| ticket_type_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| code | VARCHAR(50) | UNIQUE, NOT NULL | CÃ³digo (DIRECTO, URBANO, STUDENT) |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | DescripciÃ³n detallada |
| requires_validation | BOOLEAN | DEFAULT false | Requiere validaciÃ³n especial |
| color | VARCHAR(7) | | Color para identificaciÃ³n |
| is_active | BOOLEAN | DEFAULT true | Tipo activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

---

### **63. ticket_inventory**

**DescripciÃ³n:** Inventario de boletos fÃ­sicos en almacÃ©n central. Control de stock por serie, talonario y estado (disponible, asignado, agotado).

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| inventory_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| ticket_type_id | INT | NOT NULL, FK â†’ ticket_type | Tipo de boleto |
| series | VARCHAR(10) | NOT NULL | Serie del talonario |
| start_number | BIGINT | NOT NULL | NÃºmero inicial |
| end_number | BIGINT | NOT NULL | NÃºmero final |
| total_tickets | INT | NOT NULL | Total de boletos |
| available_tickets | INT | NOT NULL | Boletos disponibles |
| status | VARCHAR(20) | DEFAULT 'AVAILABLE' | AVAILABLE, ASSIGNED, EXHAUSTED |
| received_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de recepciÃ³n |
| received_by | BIGINT | FK â†’ user | Usuario que recibiÃ³ |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Unique Constraint:** (series, start_number, end_number)

---

### **64. ticket_batch**

**DescripciÃ³n:** Lotes de talonarios fÃ­sicos. Agrupa mÃºltiples rangos de numeraciÃ³n para facilitar control de entregas y distribuciÃ³n.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| batch_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| batch_code | VARCHAR(50) | UNIQUE, NOT NULL | CÃ³digo del lote |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| ticket_type_id | INT | NOT NULL, FK â†’ ticket_type | Tipo de boleto |
| total_booklets | INT | NOT NULL | Total de talonarios |
| total_tickets | INT | NOT NULL | Total de boletos |
| status | VARCHAR(20) | DEFAULT 'IN_STOCK' | IN_STOCK, DISTRIBUTED, DEPLETED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

---

### **65. ticket_batch_assignment**

**DescripciÃ³n:** Salida de almacÃ©n hacia cajeros. Registra entrega de lotes de talonarios del almacÃ©n central a cajeros de terminal.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| assignment_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| batch_id | BIGINT | NOT NULL, FK â†’ ticket_batch | Lote asignado |
| inventory_id | BIGINT | NOT NULL, FK â†’ ticket_inventory | Inventario especÃ­fico |
| assigned_to_user | BIGINT | NOT NULL, FK â†’ user | Cajero receptor |
| terminal_id | INT | FK â†’ terminal | Terminal destino |
| quantity_assigned | INT | NOT NULL | Cantidad asignada |
| assigned_by | BIGINT | NOT NULL, FK â†’ user | Almacenero que entregÃ³ |
| assigned_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de asignaciÃ³n |
| received_at | TIMESTAMPTZ | | Fecha de recepciÃ³n confirmada |
| document_number | VARCHAR(50) | | GuÃ­a de salida |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

---

### **66. ticket_supply**

**DescripciÃ³n:** Suministro de talonarios de cajero a conductor antes de salida. Registra entrega de boletos fÃ­sicos para venta en ruta.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| supply_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| assignment_id | BIGINT | NOT NULL, FK â†’ ticket_batch_assignment | AsignaciÃ³n origen |
| driver_id | INT | NOT NULL, FK â†’ driver | Conductor receptor |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo asignado |
| dispatch_id | BIGINT | FK â†’ dispatch | Despacho asociado |
| series | VARCHAR(10) | NOT NULL | Serie del talonario |
| start_number | BIGINT | NOT NULL | NÃºmero inicial entregado |
| end_number | BIGINT | NOT NULL | NÃºmero final entregado |
| quantity_supplied | INT | NOT NULL | Cantidad entregada |
| supplied_by | BIGINT | NOT NULL, FK â†’ user | Cajero que entregÃ³ |
| supplied_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de entrega |
| returned_at | TIMESTAMPTZ | | Fecha de devoluciÃ³n |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, RETURNED, SETTLED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

---

### **67. ticket_supply_movement**

**DescripciÃ³n:** Historial de movimientos de talonarios entre actores. Registra transferencias, entregas parciales y devoluciones.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| movement_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| supply_id | BIGINT | NOT NULL, FK â†’ ticket_supply | Suministro origen |
| movement_type | VARCHAR(20) | NOT NULL | INITIAL_SUPPLY, PARTIAL_RETURN, TRANSFER, FULL_RETURN |
| from_actor_type | VARCHAR(20) | | CASHIER, DRIVER |
| from_actor_id | BIGINT | | ID del entregador |
| to_actor_type | VARCHAR(20) | NOT NULL | CASHIER, DRIVER |
| to_actor_id | BIGINT | NOT NULL | ID del receptor |
| from_vehicle_id | INT | FK â†’ vehicle | VehÃ­culo origen (si aplica) |
| to_vehicle_id | INT | FK â†’ vehicle | VehÃ­culo destino (si aplica) |
| series | VARCHAR(10) | NOT NULL | Serie del talonario |
| start_number | BIGINT | NOT NULL | NÃºmero inicial transferido |
| end_number | BIGINT | NOT NULL | NÃºmero final transferido |
| quantity | INT | NOT NULL | Cantidad transferida |
| reason | TEXT | | Motivo del movimiento |
| movement_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del movimiento |
| registered_by | BIGINT | FK â†’ user | Usuario que registrÃ³ |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **68. validator** (OPCIONAL)

**DescripciÃ³n:** Ticketeras/validadores electrÃ³nicos (mÃ¡quinas expendedoras). Dispositivos instalados en vehÃ­culos para venta digital de boletos.

**NOTA:** Esta tabla es OPCIONAL. Solo necesaria si planeas implementar ticketeras/validadores despuÃ©s del MVP.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| validator_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| serial_number | VARCHAR(50) | UNIQUE, NOT NULL | NÃºmero de serie del dispositivo |
| model | VARCHAR(100) | | Modelo del validador |
| manufacturer | VARCHAR(100) | | Fabricante |
| firmware_version | VARCHAR(50) | | VersiÃ³n de firmware |
| sim_card_number | VARCHAR(20) | | NÃºmero de SIM |
| last_sync_at | TIMESTAMPTZ | | Ãšltima sincronizaciÃ³n |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, INACTIVE, MAINTENANCE |
| is_operational | BOOLEAN | DEFAULT true | Operativo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

---

### **69. validator_assignment** (OPCIONAL)

**DescripciÃ³n:** AsignaciÃ³n de validador a vehÃ­culo. Vincula ticketera electrÃ³nica con unidad vehicular para control de recaudo digital.

**NOTA:** Esta tabla es OPCIONAL. Solo necesaria si usas la tabla `validator`.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| assignment_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| validator_id | INT | NOT NULL, FK â†’ validator | Validador asignado |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo receptor |
| assigned_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de instalaciÃ³n |
| assigned_by | BIGINT | FK â†’ user | Usuario que instalÃ³ |
| removed_at | TIMESTAMPTZ | | Fecha de retiro |
| removed_by | BIGINT | FK â†’ user | Usuario que retirÃ³ |
| is_active | BOOLEAN | DEFAULT true | AsignaciÃ³n vigente |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Unique Constraint:** validator_id (WHERE is_active = true)

---

### **70. trip_production**

**DescripciÃ³n:** ProducciÃ³n por viaje (boletos vendidos y monto recaudado). Generado automÃ¡ticamente por validador o registrado manualmente por conductor.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| production_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| trip_id | BIGINT | NOT NULL, FK â†’ trip | Viaje asociado |
| validator_id | INT | FK â†’ validator | Validador usado (si aplica) |
| supply_id | BIGINT | FK â†’ ticket_supply | Suministro manual (si aplica) |
| ticket_type_id | INT | NOT NULL, FK â†’ ticket_type | Tipo de boleto |
| quantity_sold | INT | NOT NULL | Boletos vendidos |
| unit_price | DECIMAL(10,2) | NOT NULL | Precio unitario |
| total_amount | DECIMAL(10,2) | NOT NULL | Monto total |
| start_ticket_number | BIGINT | | NÃºmero inicial (manual) |
| end_ticket_number | BIGINT | | NÃºmero final (manual) |
| recorded_at | TIMESTAMPTZ | DEFAULT NOW() | Timestamp de registro |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Particionada por:** recorded_at (mensual)

**Notas:**
- `validator_id = NULL` y `supply_id != NULL` â†’ Recaudo manual (boletos fÃ­sicos)
- `validator_id != NULL` y `supply_id = NULL` â†’ Recaudo electrÃ³nico (ticketera)

---

### **71. partial_delivery**

**DescripciÃ³n:** Entregas parciales de efectivo durante jornada. Conductor entrega efectivo al cajero despuÃ©s de cada vuelta sin cerrar caja.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| delivery_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| trip_id | BIGINT | FK â†’ trip | Viaje asociado |
| driver_id | INT | NOT NULL, FK â†’ driver | Conductor que entrega |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo operado |
| received_by | BIGINT | NOT NULL, FK â†’ user | Cajero receptor |
| amount_delivered | DECIMAL(10,2) | NOT NULL | Efectivo entregado |
| expected_amount | DECIMAL(10,2) | | ProducciÃ³n esperada |
| difference_amount | DECIMAL(10,2) | | Diferencia (faltante/sobrante) |
| delivery_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Timestamp de entrega |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **72. cashier_box**

**DescripciÃ³n:** Caja del cajero por turno. Control de efectivo recibido de conductores durante jornada laboral con apertura y cierre.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| box_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| cashier_user_id | BIGINT | NOT NULL, FK â†’ user | Cajero responsable |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| terminal_id | INT | NOT NULL, FK â†’ terminal | Terminal asignado |
| opening_amount | DECIMAL(10,2) | NOT NULL | Efectivo inicial |
| opened_at | TIMESTAMPTZ | DEFAULT NOW() | Apertura de caja |
| closed_at | TIMESTAMPTZ | | Cierre de caja |
| closing_amount | DECIMAL(10,2) | | Efectivo final |
| total_received | DECIMAL(10,2) | | Total recibido en turno |
| total_paid_out | DECIMAL(10,2) | | Total pagado (cambio, etc) |
| expected_amount | DECIMAL(10,2) | | Efectivo esperado |
| difference_amount | DECIMAL(10,2) | | Diferencia al cierre |
| status | VARCHAR(20) | DEFAULT 'OPEN' | OPEN, CLOSED, AUDITED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

---

### **73. cashier_box_movement**

**DescripciÃ³n:** Movimientos de caja del cajero (entradas/salidas). Registra cada transacciÃ³n de efectivo durante el turno.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| movement_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| box_id | BIGINT | NOT NULL, FK â†’ cashier_box | Caja asociada |
| movement_type | VARCHAR(20) | NOT NULL | DELIVERY, PAYMENT, ADJUSTMENT |
| reference_type | VARCHAR(50) | | Tipo de referencia |
| reference_id | BIGINT | | ID de referencia |
| amount | DECIMAL(10,2) | NOT NULL | Monto del movimiento |
| description | TEXT | | DescripciÃ³n |
| movement_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Timestamp del movimiento |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Notas sobre movement_type:**
- `DELIVERY`: Entrada por entrega parcial de conductor
- `PAYMENT`: Salida por liquidaciÃ³n/pago
- `ADJUSTMENT`: Correcciones autorizadas

---

### **74. settlement**

**DescripciÃ³n:** LiquidaciÃ³n final a conductor al tÃ©rmino de jornada. CÃ¡lculo de producciÃ³n total menos gastos y pago neto resultante.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| settlement_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| driver_id | INT | NOT NULL, FK â†’ driver | Conductor liquidado |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo operado |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| settlement_date | DATE | NOT NULL | Fecha de liquidaciÃ³n |
| total_production | DECIMAL(10,2) | NOT NULL | ProducciÃ³n total |
| total_expenses | DECIMAL(10,2) | DEFAULT 0 | Gastos totales |
| net_amount | DECIMAL(10,2) | NOT NULL | Monto neto a pagar |
| payment_method | VARCHAR(20) | | CASH, TRANSFER, CHECK |
| settled_by | BIGINT | NOT NULL, FK â†’ user | Cajero que liquidÃ³ |
| settled_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de liquidaciÃ³n |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, PAID, DISPUTED |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

---

### **75. settlement_detail**

**DescripciÃ³n:** Detalle de boletos vendidos en liquidaciÃ³n. Desglose por tipo de boleto, series y rangos para conciliar con producciÃ³n.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| detail_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| settlement_id | BIGINT | NOT NULL, FK â†’ settlement | LiquidaciÃ³n asociada |
| ticket_type_id | INT | NOT NULL, FK â†’ ticket_type | Tipo de boleto |
| supply_id | BIGINT | FK â†’ ticket_supply | Suministro origen |
| validator_id | INT | FK â†’ validator | Validador usado |
| series | VARCHAR(10) | | Serie del talonario |
| start_number | BIGINT | | NÃºmero inicial vendido |
| end_number | BIGINT | | NÃºmero final vendido |
| quantity_sold | INT | NOT NULL | Cantidad vendida |
| unit_price | DECIMAL(10,2) | NOT NULL | Precio unitario |
| total_amount | DECIMAL(10,2) | NOT NULL | Subtotal |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Ejemplo de uso (recaudo manual):**
```sql
-- Conductor reporta: VendÃ­ boletos Serie A, del 045 al 084
INSERT INTO settlement_detail VALUES (
  series = 'A',
  start_number = 45,
  end_number = 84,
  quantity_sold = 40,  -- Calculado: (84 - 45) + 1
  unit_price = 2.50,
  total_amount = 100.00  -- Calculado: 40 Ã— 2.50
);
```

---

### **76. settlement_adjustment**

**DescripciÃ³n:** Ajustes autorizados en liquidaciones por diferencias, errores o circunstancias especiales. Requiere autorizaciÃ³n de jefe de liquidaciÃ³n.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| adjustment_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| settlement_id | BIGINT | NOT NULL, FK â†’ settlement | LiquidaciÃ³n afectada |
| adjustment_type | VARCHAR(20) | NOT NULL | SHORTAGE, SURPLUS, ERROR, SPECIAL |
| amount | DECIMAL(10,2) | NOT NULL | Monto del ajuste |
| reason | TEXT | NOT NULL | JustificaciÃ³n |
| authorized_by | BIGINT | NOT NULL, FK â†’ user | Jefe que autorizÃ³ |
| authorized_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de autorizaciÃ³n |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Valores de adjustment_type:**
- `SHORTAGE`: Faltante de efectivo
- `SURPLUS`: Sobrante de efectivo
- `ERROR`: Error de registro/cÃ¡lculo
- `SPECIAL`: Circunstancia especial (boleto perdido, daÃ±ado, etc.)

---

### **77. payment**

**DescripciÃ³n:** Registro de pagos efectuados a conductores y propietarios. Controla salida de efectivo con mÃ©todo, comprobante y conciliaciÃ³n bancaria.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| payment_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| payment_type | VARCHAR(20) | NOT NULL | DRIVER, OWNER |
| settlement_id | BIGINT | FK â†’ settlement | LiquidaciÃ³n conductor |
| owner_settlement_id | BIGINT | FK â†’ owner_settlement | LiquidaciÃ³n propietario (OPCIONAL) |
| payee_id | BIGINT | NOT NULL | ID del beneficiario |
| amount | DECIMAL(10,2) | NOT NULL | Monto pagado |
| payment_method | VARCHAR(20) | NOT NULL | CASH, TRANSFER, CHECK |
| reference_number | VARCHAR(100) | | NÃºmero de referencia/cheque |
| bank_account | VARCHAR(50) | | Cuenta bancaria destino |
| paid_by | BIGINT | NOT NULL, FK â†’ user | Cajero que pagÃ³ |
| paid_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de pago |
| status | VARCHAR(20) | DEFAULT 'COMPLETED' | COMPLETED, PENDING, CANCELLED |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **78. financial_report**

**DescripciÃ³n:** Reportes financieros consolidados generados periÃ³dicamente. ResÃºmenes ejecutivos de ingresos, egresos y estado de cuentas.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| report_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| report_type | VARCHAR(50) | NOT NULL | DAILY, WEEKLY, MONTHLY, CUSTOM |
| report_date | DATE | NOT NULL | Fecha del reporte |
| period_start | DATE | NOT NULL | Inicio del perÃ­odo |
| period_end | DATE | NOT NULL | Fin del perÃ­odo |
| total_production | DECIMAL(10,2) | | ProducciÃ³n total |
| total_expenses | DECIMAL(10,2) | | Gastos totales |
| total_driver_payments | DECIMAL(10,2) | | Pagos a conductores |
| total_owner_payments | DECIMAL(10,2) | | Pagos a propietarios |
| net_income | DECIMAL(10,2) | | Ingreso neto |
| report_data | JSONB | | Datos detallados del reporte |
| generated_by | BIGINT | NOT NULL, FK â†’ user | Usuario generador |
| generated_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de generaciÃ³n |
| status | VARCHAR(20) | DEFAULT 'DRAFT' | DRAFT, APPROVED, PUBLISHED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Ejemplo de report_data (JSONB):**
```json
{
  "report_type": "DAILY",
  "date": "2024-12-17",
  "summary": {
    "total_trips": 248,
    "total_vehicles": 52,
    "total_drivers": 52,
    "total_tickets_sold": 12456,
    "total_production": 31140.00,
    "total_cash_collected": 31085.00,
    "total_discrepancies": -55.00
  },
  "by_route": [
    {
      "route_id": 1,
      "route_code": "05",
      "trips": 248,
      "production": 31140.00,
      "tickets_sold": 12456
    }
  ],
  "by_ticket_type": [
    {
      "ticket_type": "DIRECTO",
      "quantity": 10234,
      "amount": 25585.00
    },
    {
      "ticket_type": "URBANO",
      "quantity": 2222,
      "amount": 5555.00
    }
  ]
}
```

---

## TABLAS OPCIONALES NO INCLUIDAS

Las siguientes tablas estÃ¡n marcadas como "pendiente" en v3 y son opcionales segÃºn tu modelo de negocio:

### **owner_settlement** (NO incluida en Ã­ndice)
**DescripciÃ³n:** LiquidaciÃ³n a propietario de vehÃ­culo despuÃ©s de descontar gastos administrativos.  
**Â¿CuÃ¡ndo la necesitas?** Solo si tu modelo incluye liquidaciÃ³n a propietarios (algunos modelos solo pagan a conductores).

### **administrative_expense** (NO incluida en Ã­ndice)
**DescripciÃ³n:** Gastos administrativos descontados en liquidaciÃ³n a propietario.  
**Â¿CuÃ¡ndo la necesitas?** Solo si implementas `owner_settlement`.

---

## CHANGELOG v4.0

### âœ… Cambios aplicados:
- **Eliminadas 14 tablas innecesarias** del Ã­ndice v4 original
- **Reducido de 79 a 78 tablas** en core_finance
- **Ajustada numeraciÃ³n**: 61-78 (antes 61-79)
- **Marcadas como OPCIONALES**: validator, validator_assignment (68-69)
- **Enfocado en**: GPS + Recaudo Manual (MVP)

### âŒ Tablas eliminadas del Ã­ndice:
1. ticket_sale - Ventas transaccionales (no aplica a recaudo manual)
2. ticket_transaction - Transacciones digitales (no aplica sin validadores)
3. sale_batch - Cierres masivos (no en MVP)
4. settlement_discrepancy - Redundante con settlement.notes
5. cash_collection - Redundante con partial_delivery
6. cash_denomination - Detalle muy granular (no en MVP)
7. cash_transfer - MÃºltiples cajas (no en MVP)
8. cash_reconciliation - Cubierto en cashier_box
9. bank_deposit - Proceso contable posterior
10. invoice - No aplica a transporte pÃºblico
11. revenue_report - Redundante con financial_report
12. fare_evasion_report - Requiere hardware adicional
13. financial_closing - Proceso contable
14. accounting_export - IntegraciÃ³n futura

---

## FLUJO OPERATIVO TÃPICO

### 1. **PreparaciÃ³n Pre-Turno**
```sql
-- Almacenero entrega talonarios a cajero
INSERT INTO ticket_batch_assignment ...

-- Cajero entrega talonarios a conductor antes de despacho
INSERT INTO ticket_supply ...
```

### 2. **Durante OperaciÃ³n**
```sql
-- Conductor vende boletos fÃ­sicos (proceso manual)
-- Al finalizar vuelta, entrega efectivo parcialmente
INSERT INTO partial_delivery ...

-- Cajero registra movimiento en su caja
INSERT INTO cashier_box_movement ...
```

### 3. **Fin de Turno - LiquidaciÃ³n**
```sql
-- Conductor entrega: efectivo + talonario restante
-- Cajero calcula producciÃ³n por diferencia de rangos

-- Registra liquidaciÃ³n
INSERT INTO settlement ...
INSERT INTO settlement_detail (series='A', start=45, end=84, quantity=40) ...

-- Si hay diferencia, registra ajuste (con autorizaciÃ³n)
INSERT INTO settlement_adjustment ...

-- Realiza pago al conductor
INSERT INTO payment ...

-- Registra movimiento en caja
INSERT INTO cashier_box_movement (type='PAYMENT') ...
```

### 4. **Cierre de DÃ­a**
```sql
-- Cajero cierra su caja
UPDATE cashier_box SET closed_at=NOW(), status='CLOSED' ...

-- Sistema genera reporte consolidado
INSERT INTO financial_report ...
```

---

**Fin del Diccionario de Datos - core_finance v4.0**

**Estado:** âœ… Completo y ajustado al alcance MVP (GPS + Recaudo Manual)
# DICCIONARIO DE DATOS - SCHEMA: `fleet`
## Sistema de GestiÃ³n de Transporte con GPS

**VersiÃ³n:** 4.0 (Reorganizado)  
**Fecha:** 19/01/2026  
**Base de Datos:** PostgreSQL 14+  
**Schema:** `fleet`

---

## ðŸ“‘ ÃNDICE DE TABLAS

### TABLAS CORE (10)

**VehÃ­culos y Propiedad**
1. [vehicle](#1-vehicle) - VehÃ­culos de la flota
2. [vehicle_owner](#2-vehicle_owner) - Propietarios de vehÃ­culos
3. [vehicle_owner_share](#3-vehicle_owner_share) - ParticipaciÃ³n en vehÃ­culos
4. [vehicle_document](#4-vehicle_document) - Documentos obligatorios
5. [vehicle_assignment](#5-vehicle_assignment) - AsignaciÃ³n conductor-vehÃ­culo

**GPS y Tracking**
6. [gps_device](#6-gps_device) - Dispositivos GPS
7. [gps_raw_event](#7-gps_raw_event) - Eventos GPS brutos

**Mantenimiento y Combustible**
8. [maintenance_type](#8-maintenance_type) - Tipos de mantenimiento
9. [maintenance_record](#9-maintenance_record) - Historial de mantenimientos
10. [fuel_load](#10-fuel_load) - Cargas de combustible

### TABLAS OPCIONALES (3)

**Anti-SuplantaciÃ³n GPS (Fase 2)**
11. [beacon](#11-beacon) - Beacons BLE
12. [beacon_pairing_request](#12-beacon_pairing_request) - Solicitudes de emparejamiento
13. [vehicle_beacon](#13-vehicle_beacon) - Beacon activo por vehÃ­culo

---

## ðŸ“‹ DEFINICIONES DE TABLAS

---

## 1. vehicle

**DescripciÃ³n:** Registro maestro de unidades vehiculares. Inventario completo de buses con datos tÃ©cnicos, operativos y estado actual. Tabla central del mÃ³dulo de flota.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| vehicle_id | SERIAL | PRIMARY KEY | Identificador Ãºnico autogenerado |
| plate_number | VARCHAR(10) | UNIQUE, NOT NULL | Placa oficial del vehÃ­culo (ej: ABC-123) |
| internal_code | VARCHAR(20) | UNIQUE, NOT NULL | CÃ³digo interno de la empresa (ej: BUS-001) |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora concesionaria |
| brand | VARCHAR(100) | | Marca del vehÃ­culo (ej: Mercedes-Benz, Volvo) |
| model | VARCHAR(100) | | Modelo del vehÃ­culo (ej: OF-1722, B270F) |
| year | INT | | AÃ±o de fabricaciÃ³n |
| chassis_number | VARCHAR(50) | UNIQUE | NÃºmero de chasis/VIN (Vehicle Identification Number) |
| engine_number | VARCHAR(50) | | NÃºmero de motor |
| fuel_type | VARCHAR(20) | | Tipo de combustible: DIESEL, GNV, HYBRID, ELECTRIC |
| seating_capacity | INT | | Capacidad de asientos |
| standing_capacity | INT | | Capacidad de pasajeros de pie |
| color | VARCHAR(50) | | Color principal del vehÃ­culo |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, INACTIVE, MAINTENANCE, RETIRED |
| acquisition_date | DATE | | Fecha de adquisiciÃ³n/ingreso a flota |
| is_operational | BOOLEAN | DEFAULT true | VehÃ­culo operativo para despacho |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro en sistema |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `company_id` â†’ `shared.company.company_id`
- **Es referenciado por:** vehicle_owner_share, vehicle_document, vehicle_assignment, gps_device, maintenance_record, fuel_load

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_vehicle_company ON fleet.vehicle(company_id);
CREATE INDEX idx_vehicle_status ON fleet.vehicle(status) WHERE is_operational = true;
CREATE INDEX idx_vehicle_plate ON fleet.vehicle(plate_number);
```

**Reglas de negocio:**
- Un vehÃ­culo solo puede tener status = 'ACTIVE' si is_operational = true
- Plate_number debe cumplir formato segÃºn paÃ­s (ej: AAA-111 para PerÃº)
- Debe tener al menos 1 propietario activo en vehicle_owner_share

**Ejemplo de datos:**
```sql
INSERT INTO fleet.vehicle (plate_number, internal_code, company_id, brand, model, 
                           year, fuel_type, seating_capacity, standing_capacity)
VALUES ('AQP-789', 'BUS-025', 1, 'Mercedes-Benz', 'OF-1722', 2018, 'DIESEL', 45, 30);
```

---

## 2. vehicle_owner

**DescripciÃ³n:** Propietarios de vehÃ­culos. Una persona puede ser propietaria de mÃºltiples vehÃ­culos. Los propietarios pueden ser operadores (manejan su propio bus) o inversionistas (contratan conductores).

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| vehicle_owner_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | NOT NULL, FK â†’ person | VÃ­nculo con tabla person (datos personales) |
| tax_id | VARCHAR(20) | | RUC/DNI del propietario (duplicado por performance) |
| full_name | VARCHAR(255) | NOT NULL | Nombre completo (duplicado por performance) |
| email | VARCHAR(255) | | Correo electrÃ³nico para notificaciones |
| phone | VARCHAR(50) | | TelÃ©fono de contacto |
| address | TEXT | | DirecciÃ³n fÃ­sica |
| bank_account | VARCHAR(50) | | Cuenta bancaria para liquidaciones |
| is_active | BOOLEAN | DEFAULT true | Propietario activo en el sistema |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`
- **Es referenciado por:** vehicle_owner_share, driver (hired_by_owner_id, owner_id)

**Reglas de negocio:**
- Un propietario puede tener mÃºltiples vehÃ­culos (relaciÃ³n N:M vÃ­a vehicle_owner_share)
- bank_account es REQUERIDO para recibir liquidaciones
- Si person_id estÃ¡ vinculado a driver con employment_type='OWNER_OPERATOR', es conductor-propietario

**Ejemplo de datos:**
```sql
INSERT INTO fleet.vehicle_owner (person_id, tax_id, full_name, email, phone, bank_account)
VALUES (15, '10234567890', 'Juan Carlos PÃ©rez GarcÃ­a', 'jperez@email.com', 
        '987654321', '191-12345678-0-25');
```

---

## 3. vehicle_owner_share

**DescripciÃ³n:** Define los porcentajes de participaciÃ³n de cada propietario en vehÃ­culos compartidos. Permite modelar co-propiedad y distribuciÃ³n de utilidades en liquidaciones.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| share_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo compartido |
| vehicle_owner_id | INT | NOT NULL, FK â†’ vehicle_owner | Propietario participante |
| ownership_percentage | DECIMAL(5,2) | NOT NULL | Porcentaje de propiedad (0.00-100.00) |
| valid_from | DATE | NOT NULL | Fecha de inicio de vigencia |
| valid_until | DATE | | Fecha de fin de vigencia (NULL = indefinido) |
| is_active | BOOLEAN | DEFAULT true | ParticipaciÃ³n activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `vehicle_id` â†’ `fleet.vehicle.vehicle_id`
- `vehicle_owner_id` â†’ `fleet.vehicle_owner.vehicle_owner_id`

**Constraints:**
```sql
CHECK (ownership_percentage BETWEEN 0 AND 100)
UNIQUE (vehicle_id, vehicle_owner_id, valid_from)
```

**Reglas de negocio:**
- La suma de ownership_percentage para un vehicle_id activo debe ser exactamente 100.00
- Solo puede haber 1 registro activo (is_active=true) por combinaciÃ³n vehicle_id + vehicle_owner_id
- Al liquidar un viaje, el sistema distribuye utilidades segÃºn ownership_percentage

**Trigger recomendado:**
```sql
-- Validar que la suma de porcentajes activos = 100% por vehÃ­culo
CREATE TRIGGER trg_validate_ownership_sum ...
```

**Ejemplo de datos:**
```sql
-- VehÃ­culo con propietario Ãºnico (100%)
INSERT INTO fleet.vehicle_owner_share (vehicle_id, vehicle_owner_id, ownership_percentage, valid_from)
VALUES (25, 15, 100.00, '2024-01-01');

-- VehÃ­culo con dos propietarios (50% cada uno)
INSERT INTO fleet.vehicle_owner_share (vehicle_id, vehicle_owner_id, ownership_percentage, valid_from)
VALUES (26, 15, 50.00, '2024-01-01'),
       (26, 18, 50.00, '2024-01-01');
```

---

## 4. vehicle_document

**DescripciÃ³n:** Documentos obligatorios de vehÃ­culos con control de vigencia y alertas automÃ¡ticas. Bloquea despacho si documentos crÃ­ticos estÃ¡n vencidos.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| vehicle_document_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo asociado |
| document_type_id | INT | NOT NULL, FK â†’ document_type | Tipo de documento del catÃ¡logo |
| document_number | VARCHAR(100) | | NÃºmero del documento oficial |
| issuing_entity | VARCHAR(255) | | Entidad emisora del documento |
| issue_date | DATE | | Fecha de emisiÃ³n |
| expiry_date | DATE | | Fecha de vencimiento |
| file_id | BIGINT | FK â†’ file_storage | Archivo PDF/imagen escaneada |
| status | VARCHAR(20) | DEFAULT 'VALID' | VALID, EXPIRED, PENDING, REJECTED |
| verified_by | BIGINT | FK â†’ user | Usuario que verificÃ³ el documento |
| verified_at | TIMESTAMPTZ | | Timestamp de verificaciÃ³n |
| notes | TEXT | | Observaciones adicionales |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `vehicle_id` â†’ `fleet.vehicle.vehicle_id`
- `document_type_id` â†’ `shared.document_type.document_type_id`
- `file_id` â†’ `shared.file_storage.file_id`
- `verified_by` â†’ `shared.user.user_id`

**Tipos de documentos crÃ­ticos:**
- SOAT (Seguro Obligatorio de Accidentes de TrÃ¡nsito)
- REVISIÃ“N_TÃ‰CNICA (InspecciÃ³n tÃ©cnica vehicular)
- TARJETA_PROPIEDAD (TÃ­tulo de propiedad)
- CERTIFICADO_GNV (Si aplica para vehÃ­culos GNV)
- PÃ“LIZA_SEGURO (Seguro adicional)

**Reglas de negocio:**
- Status se actualiza automÃ¡ticamente a 'EXPIRED' cuando expiry_date < CURRENT_DATE
- Documentos con is_critical=true en document_type bloquean despacho si estÃ¡n vencidos
- Sistema debe alertar 30 dÃ­as antes del vencimiento

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_vehicle_doc_expiry ON fleet.vehicle_document(vehicle_id, expiry_date) 
WHERE status = 'VALID';
```

**Ejemplo de datos:**
```sql
INSERT INTO fleet.vehicle_document (vehicle_id, document_type_id, document_number, 
                                     issue_date, expiry_date, status)
VALUES (25, 5, 'SOAT-2024-123456', '2024-01-15', '2025-01-14', 'VALID');
```

---

## 5. vehicle_assignment

**DescripciÃ³n:** AsignaciÃ³n histÃ³rica de conductores a vehÃ­culos. Permite rastrear quiÃ©n operÃ³ cada unidad en quÃ© perÃ­odo. Soporta diferentes tipos de asignaciÃ³n.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| assignment_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo asignado |
| driver_id | INT | NOT NULL, FK â†’ driver | Conductor asignado |
| assigned_at | TIMESTAMPTZ | DEFAULT NOW() | Inicio de asignaciÃ³n |
| unassigned_at | TIMESTAMPTZ | | Fin de asignaciÃ³n (NULL = asignaciÃ³n activa) |
| assignment_type | VARCHAR(20) | DEFAULT 'REGULAR' | OWNER_OPERATOR, HIRED_DRIVER, TEMPORARY, REPLACEMENT |
| assigned_by | BIGINT | NOT NULL, FK â†’ user | Usuario que realizÃ³ la asignaciÃ³n |
| unassigned_by | BIGINT | FK â†’ user | Usuario que finalizÃ³ la asignaciÃ³n |
| notes | TEXT | | Observaciones sobre la asignaciÃ³n |
| is_active | BOOLEAN | DEFAULT true | AsignaciÃ³n vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Relaciones:**
- `vehicle_id` â†’ `fleet.vehicle.vehicle_id`
- `driver_id` â†’ `hr.driver.driver_id`
- `assigned_by` â†’ `shared.user.user_id`
- `unassigned_by` â†’ `shared.user.user_id`

**Reglas de negocio:**
- Solo puede haber 1 asignaciÃ³n activa (is_active=true, unassigned_at=NULL) por vehÃ­culo
- Cuando assignment_type='OWNER_OPERATOR', validar que driver.owner_id estÃ© vinculado al vehÃ­culo
- Al crear nueva asignaciÃ³n activa, cerrar automÃ¡ticamente la anterior (set unassigned_at)

**Constraint Ãºnico:**
```sql
CREATE UNIQUE INDEX idx_vehicle_assignment_active 
ON fleet.vehicle_assignment(vehicle_id) 
WHERE is_active = true AND unassigned_at IS NULL;
```

**Ejemplo de datos:**
```sql
-- Propietario-conductor operando su bus
INSERT INTO fleet.vehicle_assignment (vehicle_id, driver_id, assignment_type, assigned_by)
VALUES (25, 42, 'OWNER_OPERATOR', 3);

-- Conductor contratado
INSERT INTO fleet.vehicle_assignment (vehicle_id, driver_id, assignment_type, assigned_by)
VALUES (26, 45, 'HIRED_DRIVER', 3);
```

---

## 6. gps_device

**DescripciÃ³n:** Dispositivos GPS instalados en vehÃ­culos. Soporta trackers GPS dedicados y tablets Android con GPS. Control de conectividad y configuraciÃ³n de transmisiÃ³n.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| gps_device_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| device_id | VARCHAR(50) | UNIQUE, NOT NULL | IMEI o Android ID Ãºnico del dispositivo |
| device_type | VARCHAR(20) | NOT NULL | TRACKER_GPS, ANDROID_TABLET |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| imei | VARCHAR(20) | UNIQUE | IMEI del dispositivo (si aplica) |
| serial_number | VARCHAR(50) | | NÃºmero de serie del fabricante |
| model | VARCHAR(100) | | Modelo del dispositivo |
| manufacturer | VARCHAR(100) | | Fabricante (ej: Teltonika, Queclink) |
| sim_card_number | VARCHAR(20) | | NÃºmero de tarjeta SIM |
| sim_provider | VARCHAR(50) | | Proveedor de SIM (ej: Claro, Movistar) |
| firmware_version | VARCHAR(50) | | VersiÃ³n de firmware/app |
| vehicle_id | INT | FK â†’ vehicle | VehÃ­culo donde estÃ¡ instalado |
| posting_interval_seconds | INT | DEFAULT 30 | Intervalo de transmisiÃ³n GPS en segundos |
| last_communication_at | TIMESTAMPTZ | | Ãšltima transmisiÃ³n recibida |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, INACTIVE, ERROR, MAINTENANCE |
| is_operational | BOOLEAN | DEFAULT true | Dispositivo operativo |
| installed_at | TIMESTAMPTZ | | Fecha de instalaciÃ³n en vehÃ­culo |
| installed_by | BIGINT | FK â†’ user | Usuario que instalÃ³/configurÃ³ |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `company_id` â†’ `shared.company.company_id`
- `vehicle_id` â†’ `fleet.vehicle.vehicle_id`
- `installed_by` â†’ `shared.user.user_id`
- **Es referenciado por:** gps_raw_event

**Reglas de negocio:**
- Un vehÃ­culo solo puede tener 1 dispositivo GPS activo
- Si last_communication_at > 5 minutos, generar alerta GPS_OFFLINE
- posting_interval_seconds tÃ­pico: 30 seg en movimiento, 300 seg detenido
- Bloquea despacho si status != 'ACTIVE' o is_operational = false

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_gps_device_vehicle ON fleet.gps_device(vehicle_id) WHERE is_operational = true;
CREATE INDEX idx_gps_device_last_comm ON fleet.gps_device(last_communication_at);
```

**Ejemplo de datos:**
```sql
INSERT INTO fleet.gps_device (device_id, device_type, company_id, imei, vehicle_id, 
                               posting_interval_seconds)
VALUES ('865123456789012', 'TRACKER_GPS', 1, '865123456789012', 25, 30);
```

---

## 7. gps_raw_event

**DescripciÃ³n:** Eventos GPS brutos recibidos de dispositivos. Almacena todas las transmisiones sin filtrar para auditorÃ­a completa. Tabla particionada por performance.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| raw_event_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico autogenerado |
| gps_device_id | INT | NOT NULL, FK â†’ gps_device | Dispositivo emisor |
| vehicle_id | INT | FK â†’ vehicle | VehÃ­culo asociado (desnormalizado) |
| beacon_mac_address | VARCHAR(17) | | MAC del beacon BLE detectado (opcional) |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud GPS en grados decimales |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud GPS en grados decimales |
| altitude | DECIMAL(8,2) | | Altitud en metros sobre nivel del mar |
| speed_kmh | DECIMAL(5,2) | | Velocidad en km/h |
| heading | DECIMAL(5,2) | | Rumbo en grados (0-360) |
| accuracy_meters | DECIMAL(6,2) | | PrecisiÃ³n horizontal en metros |
| satellites | INT | | NÃºmero de satÃ©lites GPS en uso |
| gps_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp del evento segÃºn GPS |
| server_timestamp | TIMESTAMPTZ | DEFAULT NOW() | Timestamp de recepciÃ³n en servidor |
| battery_level | INT | | Nivel de baterÃ­a del dispositivo (%) |
| raw_data | JSONB | | Payload completo JSON original |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de almacenamiento |

**Relaciones:**
- `gps_device_id` â†’ `fleet.gps_device.gps_device_id`
- `vehicle_id` â†’ `fleet.vehicle.vehicle_id`

**Particionamiento:**
```sql
-- Particionada por gps_timestamp (rangos semanales)
CREATE TABLE fleet.gps_raw_event_2026_w03 PARTITION OF fleet.gps_raw_event
FOR VALUES FROM ('2026-01-13') TO ('2026-01-20');
```

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_gps_raw_vehicle_time ON fleet.gps_raw_event(vehicle_id, gps_timestamp DESC);
CREATE INDEX idx_gps_raw_device_time ON fleet.gps_raw_event(gps_device_id, gps_timestamp DESC);
```

**Reglas de negocio:**
- Eventos con accuracy_meters > 50 se marcan como baja precisiÃ³n
- Si speed_kmh > lÃ­mite de ruta, generar alerta SPEED_EXCESS
- raw_data contiene payload completo para debugging

**RetenciÃ³n de datos:**
- Datos activos: 90 dÃ­as en tabla principal
- Archivo histÃ³rico: > 90 dÃ­as migrar a cold storage

**Ejemplo de datos:**
```sql
INSERT INTO fleet.gps_raw_event (gps_device_id, vehicle_id, latitude, longitude, 
                                  speed_kmh, gps_timestamp)
VALUES (12, 25, -12.0464080, -77.0427930, 45.5, '2026-01-19 10:30:15-05');
```

---

## 8. maintenance_type

**DescripciÃ³n:** CatÃ¡logo de tipos de mantenimiento. Define clasificaciÃ³n, periodicidad y criticidad de cada tipo de servicio.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| maintenance_type_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| code | VARCHAR(50) | UNIQUE, NOT NULL | CÃ³digo Ãºnico (ej: PREVENTIVE, CORRECTIVE) |
| name | VARCHAR(100) | NOT NULL | Nombre descriptivo del tipo |
| description | TEXT | | DescripciÃ³n detallada |
| default_interval_km | INT | | Kilometraje por defecto entre servicios |
| default_interval_days | INT | | DÃ­as por defecto entre servicios |
| is_critical | BOOLEAN | DEFAULT false | Mantenimiento crÃ­tico (bloquea operaciÃ³n) |
| is_active | BOOLEAN | DEFAULT true | Tipo activo en el sistema |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Relaciones:**
- **Es referenciado por:** maintenance_record

**Tipos estÃ¡ndar:**
```sql
INSERT INTO fleet.maintenance_type (code, name, default_interval_km, is_critical) VALUES
('PREVENTIVE_5K', 'Mantenimiento Preventivo 5,000 km', 5000, false),
('PREVENTIVE_10K', 'Mantenimiento Preventivo 10,000 km', 10000, false),
('INSPECTION_ANNUAL', 'InspecciÃ³n TÃ©cnica Anual', NULL, true),
('CORRECTIVE', 'Mantenimiento Correctivo', NULL, false),
('EMERGENCY', 'ReparaciÃ³n de Emergencia', NULL, true);
```

**Reglas de negocio:**
- Tipos con is_critical=true pueden bloquear despacho si estÃ¡n vencidos
- default_interval_km y default_interval_days son sugerencias, no obligatorios

---

## 9. maintenance_record

**DescripciÃ³n:** Registro histÃ³rico de todos los mantenimientos ejecutados. Documenta trabajos realizados, costos, piezas y prÃ³ximos servicios.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| maintenance_record_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo atendido |
| maintenance_type_id | INT | NOT NULL, FK â†’ maintenance_type | Tipo de mantenimiento realizado |
| maintenance_date | DATE | NOT NULL | Fecha de ejecuciÃ³n del servicio |
| odometer_reading | INT | | Lectura del odÃ³metro en km |
| description | TEXT | NOT NULL | DescripciÃ³n detallada del trabajo |
| parts_replaced | TEXT | | Lista de piezas reemplazadas |
| labor_cost | DECIMAL(10,2) | | Costo de mano de obra |
| parts_cost | DECIMAL(10,2) | | Costo de repuestos |
| total_cost | DECIMAL(10,2) | | Costo total del servicio |
| workshop | VARCHAR(255) | | Taller que ejecutÃ³ el servicio |
| technician_name | VARCHAR(255) | | Nombre del tÃ©cnico responsable |
| invoice_number | VARCHAR(100) | | NÃºmero de factura/comprobante |
| next_service_km | INT | | PrÃ³ximo servicio en km |
| next_service_date | DATE | | PrÃ³xima fecha de servicio programada |
| registered_by | BIGINT | NOT NULL, FK â†’ user | Usuario que registrÃ³ |
| approved_by | BIGINT | FK â†’ user | Usuario que aprobÃ³ el gasto |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `vehicle_id` â†’ `fleet.vehicle.vehicle_id`
- `maintenance_type_id` â†’ `fleet.maintenance_type.maintenance_type_id`
- `registered_by` â†’ `shared.user.user_id`
- `approved_by` â†’ `shared.user.user_id`

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_maint_vehicle_date ON fleet.maintenance_record(vehicle_id, maintenance_date DESC);
CREATE INDEX idx_maint_next_service ON fleet.maintenance_record(vehicle_id, next_service_date) 
WHERE next_service_date IS NOT NULL;
```

**Reglas de negocio:**
- Si maintenance_type.is_critical=true y CURRENT_DATE > next_service_date, bloquear despacho
- parts_replaced puede contener lista separada por comas o JSON

**Ejemplo de datos:**
```sql
INSERT INTO fleet.maintenance_record (vehicle_id, maintenance_type_id, maintenance_date, 
                                       odometer_reading, description, total_cost, 
                                       next_service_km, registered_by)
VALUES (25, 2, '2026-01-15', 85000, 'Cambio de aceite y filtros', 450.00, 90000, 3);
```

---

## 10. fuel_load

**DescripciÃ³n:** Registro de todas las cargas de combustible por vehÃ­culo. Control de consumo, rendimiento y costos operativos de combustible.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| fuel_load_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo cargado |
| driver_id | INT | FK â†’ driver | Conductor responsable de la carga |
| load_date | DATE | NOT NULL | Fecha de la carga |
| load_time | TIME | | Hora de la carga |
| fuel_type | VARCHAR(20) | NOT NULL | Tipo: DIESEL, GNV, GASOLINE |
| quantity_liters | DECIMAL(8,2) | NOT NULL | Cantidad en litros (para lÃ­quidos) |
| quantity_gallons | DECIMAL(8,2) | | Cantidad en galones (para GNV) |
| unit_price | DECIMAL(8,2) | NOT NULL | Precio por litro/galÃ³n |
| total_cost | DECIMAL(10,2) | NOT NULL | Costo total de la carga |
| odometer_reading | INT | | Lectura del odÃ³metro en el momento |
| station_name | VARCHAR(255) | | Nombre del grifo/estaciÃ³n |
| invoice_number | VARCHAR(100) | | NÃºmero de factura/boleta |
| payment_method | VARCHAR(20) | | CASH, CARD, ACCOUNT, VOUCHER |
| registered_by | BIGINT | NOT NULL, FK â†’ user | Usuario que registrÃ³ |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro en sistema |

**Relaciones:**
- `vehicle_id` â†’ `fleet.vehicle.vehicle_id`
- `driver_id` â†’ `hr.driver.driver_id`
- `registered_by` â†’ `shared.user.user_id`

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_fuel_vehicle_date ON fleet.fuel_load(vehicle_id, load_date DESC);
CREATE INDEX idx_fuel_date_range ON fleet.fuel_load(load_date) 
WHERE load_date >= CURRENT_DATE - INTERVAL '30 days';
```

**CÃ¡lculos derivados:**
```sql
-- Rendimiento km/litro
SELECT vehicle_id, 
       AVG((next_odometer - odometer_reading) / quantity_liters) as avg_kmpl
FROM fuel_load ...
```

**Reglas de negocio:**
- Validar que fuel_type coincida con vehicle.fuel_type
- Calcular rendimiento promedio para alertar sobre consumo anormal
- odometer_reading debe ser mayor al registro anterior del mismo vehÃ­culo

**Ejemplo de datos:**
```sql
INSERT INTO fleet.fuel_load (vehicle_id, driver_id, load_date, load_time, fuel_type, 
                              quantity_liters, unit_price, total_cost, odometer_reading, 
                              station_name, registered_by)
VALUES (25, 42, '2026-01-19', '08:30:00', 'DIESEL', 60.00, 15.50, 930.00, 
        85245, 'Grifo PetroperÃº Centro', 3);
```

---

## 11. beacon

**DescripciÃ³n:** âšª **OPCIONAL - FASE 2** - Beacons BLE (Bluetooth Low Energy) para identificaciÃ³n segura de vehÃ­culos. Evita suplantaciÃ³n en eventos GPS.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| beacon_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| mac_address | VARCHAR(17) | UNIQUE, NOT NULL | DirecciÃ³n MAC del beacon (formato: AA:BB:CC:DD:EE:FF) |
| uuid | VARCHAR(36) | | UUID del beacon (iBeacon estÃ¡ndar) |
| major | INT | | Major value (iBeacon) |
| minor | INT | | Minor value (iBeacon) |
| model | VARCHAR(100) | | Modelo del beacon |
| manufacturer | VARCHAR(100) | | Fabricante (ej: Kontakt.io, Estimote) |
| battery_level | INT | | Nivel de baterÃ­a (0-100%) |
| last_battery_check | TIMESTAMPTZ | | Ãšltima verificaciÃ³n de baterÃ­a |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, INACTIVE, LOW_BATTERY, DAMAGED |
| is_operational | BOOLEAN | DEFAULT true | Beacon operativo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- **Es referenciado por:** vehicle_beacon

**Uso:** Anti-suplantaciÃ³n GPS. Solo se aceptan eventos GPS si el beacon_mac_address coincide con el registrado para el vehÃ­culo.

---

## 12. beacon_pairing_request

**DescripciÃ³n:** âšª **OPCIONAL - FASE 2** - Solicitudes de emparejamiento beacon-vehÃ­culo desde tablets. Requiere verificaciÃ³n de identidad antes de aprobar.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| pairing_request_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo solicitante |
| beacon_mac_address | VARCHAR(17) | NOT NULL | MAC del beacon escaneado |
| beacon_name | VARCHAR(100) | | Nombre BLE advertised |
| rssi | INT | | SeÃ±al RSSI al momento del escaneo |
| requested_by_type | VARCHAR(20) | NOT NULL | DRIVER, MAINTENANCE, FIELD_TECH, UNKNOWN |
| requested_by_name | VARCHAR(100) | | Nombre en texto libre |
| requested_by_user_id | BIGINT | FK â†’ user | Usuario si estÃ¡ registrado |
| requester_voice_text | TEXT | | TranscripciÃ³n de audio voz-a-texto |
| requester_photo_url | VARCHAR(500) | | URL foto temporal del solicitante |
| photo_expires_at | TIMESTAMPTZ | | ExpiraciÃ³n de foto (tÃ­p. 7 dÃ­as) |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, APPROVED, REJECTED |
| reviewed_by | BIGINT | FK â†’ user | Monitoreador que revisÃ³ |
| reviewed_at | TIMESTAMPTZ | | Fecha de revisiÃ³n |
| rejection_reason | TEXT | | Motivo de rechazo |
| verification_method | VARCHAR(20) | | RTC_CALL, IN_PERSON, PHOTO_ID, NONE |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de solicitud |

**Flujo:** Tablet escanea beacon â†’ Crea solicitud â†’ Monitoreador verifica identidad â†’ Aprueba/Rechaza â†’ Si aprueba, crea registro en vehicle_beacon

---

## 13. vehicle_beacon

**DescripciÃ³n:** âšª **OPCIONAL - FASE 2** - Beacon actualmente emparejado con cada vehÃ­culo. Solo se aceptan eventos GPS si coincide MAC del beacon registrado.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| vehicle_beacon_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| vehicle_id | INT | UNIQUE, NOT NULL, FK â†’ vehicle | VehÃ­culo asociado (1:1) |
| beacon_id | INT | FK â†’ beacon | Beacon emparejado del catÃ¡logo |
| beacon_mac_address | VARCHAR(17) | NOT NULL | MAC del beacon activo (desnormalizado) |
| paired_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de emparejamiento |
| paired_by_request_id | BIGINT | FK â†’ beacon_pairing_request | Solicitud que originÃ³ el emparejamiento |
| last_seen_at | TIMESTAMPTZ | | Ãšltima seÃ±al BLE recibida |
| is_active | BOOLEAN | DEFAULT true | Emparejamiento activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Reglas de negocio:**
- Solo 1 beacon activo por vehÃ­culo (constraint UNIQUE en vehicle_id)
- Eventos GPS con beacon_mac_address diferente se rechazan o alertan

---

## ðŸ“Š RESUMEN DEL SCHEMA

**Tablas Core:** 10 tablas esenciales  
**Tablas Opcionales:** 3 tablas (beacons fase 2)

**PropÃ³sito:** GestiÃ³n completa de flota vehicular para sistema GPS de transporte con:
- Control de propiedad (propietarios-conductores)
- Tracking GPS en tiempo real
- DocumentaciÃ³n vehicular con alertas
- Mantenimiento bÃ¡sico
- Control de combustible

**Siguiente paso:** Ver diccionario de schema `hr` (recursos humanos)
# DICCIONARIO DE DATOS - SCHEMA: `hr`
## Sistema de GestiÃ³n de Transporte con GPS

**VersiÃ³n:** 4.0 (Reorganizado)  
**Fecha:** 19/01/2026  
**Base de Datos:** PostgreSQL 14+  
**Schema:** `hr` (Human Resources)

---

## ðŸ“‘ ÃNDICE DE TABLAS

### TABLAS CORE (15)

**Base de Personas**
1. [person](#1-person) - Tabla base de personas
2. [person_document](#2-person_document) - Documentos personales
3. [person_address](#3-person_address) - Direcciones

**Conductores (Rol CrÃ­tico)**
4. [driver](#4-driver) - Conductores autorizados
5. [driver_license](#5-driver_license) - Licencias de conducir
6. [driver_infraction](#6-driver_infraction) - Infracciones de trÃ¡nsito
7. [medical_exam](#7-medical_exam) - ExÃ¡menes mÃ©dicos
8. [background_check](#8-background_check) - Antecedentes

**Personal Operativo y Administrativo**
9. [inspector](#9-inspector) - Inspectores de campo
10. [personnel](#10-personnel) - Personal administrativo

**Finanzas Personales**
11. [loan](#11-loan) - PrÃ©stamos y adelantos

**GestiÃ³n Laboral**
12. [attendance](#12-attendance) - Asistencia diaria
13. [absence](#13-absence) - Ausencias y permisos
14. [employment_contract](#14-employment_contract) - Contratos laborales
15. [payroll_record](#15-payroll_record) - NÃ³mina (solo empleados)

---

## ðŸ“‹ DEFINICIONES DE TABLAS

---

## 1. person

**DescripciÃ³n:** Tabla base universal de personas. Almacena datos personales compartidos entre conductores, inspectores, personal administrativo y propietarios. PatrÃ³n de herencia tabla Ãºnica.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| person_id | SERIAL | PRIMARY KEY | Identificador Ãºnico autogenerado |
| tax_id | VARCHAR(20) | UNIQUE, NOT NULL | DNI/RUC (PerÃº) o equivalente |
| first_name | VARCHAR(100) | NOT NULL | Nombre(s) |
| last_name | VARCHAR(100) | NOT NULL | Apellidos |
| full_name | VARCHAR(255) | NOT NULL | Nombre completo (computed o manual) |
| gender | VARCHAR(1) | | M (Masculino), F (Femenino), O (Otro) |
| birth_date | DATE | | Fecha de nacimiento |
| nationality | VARCHAR(50) | | Nacionalidad (ej: Peruana) |
| marital_status | VARCHAR(20) | | SINGLE, MARRIED, DIVORCED, WIDOWED |
| blood_type | VARCHAR(5) | | Tipo de sangre (A+, O-, etc.) |
| email | VARCHAR(255) | | Correo electrÃ³nico principal |
| phone_mobile | VARCHAR(20) | | TelÃ©fono mÃ³vil |
| phone_home | VARCHAR(20) | | TelÃ©fono fijo |
| emergency_contact_name | VARCHAR(255) | | Nombre de contacto de emergencia |
| emergency_contact_phone | VARCHAR(20) | | TelÃ©fono de contacto de emergencia |
| photo_url | VARCHAR(500) | | URL de foto de perfil |
| is_active | BOOLEAN | DEFAULT true | Persona activa en el sistema |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- **Es referenciado por:** driver, inspector, personnel, vehicle_owner, person_document, person_address, attendance, absence, employment_contract, loan, payroll_record

**Ãndices sugeridos:**
```sql
CREATE UNIQUE INDEX idx_person_tax_id ON hr.person(tax_id);
CREATE INDEX idx_person_full_name ON hr.person(full_name);
CREATE INDEX idx_person_active ON hr.person(is_active);
```

**Reglas de negocio:**
- tax_id debe ser vÃ¡lido segÃºn formato del paÃ­s (DNI: 8 dÃ­gitos, RUC: 11 dÃ­gitos en PerÃº)
- full_name debe concatenarse automÃ¡ticamente: `first_name || ' ' || last_name`
- email debe ser Ãºnico si se proporciona
- Una persona puede tener mÃºltiples roles: conductor + propietario, inspector + conductor, etc.

**Ejemplo de datos:**
```sql
INSERT INTO hr.person (tax_id, first_name, last_name, full_name, gender, 
                       birth_date, email, phone_mobile)
VALUES ('45678912', 'Juan Carlos', 'PÃ©rez GarcÃ­a', 'Juan Carlos PÃ©rez GarcÃ­a', 
        'M', '1985-03-15', 'jperez@email.com', '987654321');
```

---

## 2. person_document

**DescripciÃ³n:** Documentos personales de cualquier persona. Extensible para diversos tipos segÃºn rol (DNI, licencias, certificados, antecedentes). Control de vigencia con alertas.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| person_document_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | NOT NULL, FK â†’ person | Persona propietaria del documento |
| document_type_id | INT | NOT NULL, FK â†’ document_type | Tipo de documento del catÃ¡logo |
| document_number | VARCHAR(100) | | NÃºmero del documento oficial |
| issuing_entity | VARCHAR(255) | | Entidad que emitiÃ³ el documento |
| issue_date | DATE | | Fecha de emisiÃ³n |
| expiry_date | DATE | | Fecha de vencimiento |
| file_id | BIGINT | FK â†’ file_storage | Archivo PDF/imagen escaneada |
| status | VARCHAR(20) | DEFAULT 'VALID' | VALID, EXPIRED, PENDING, REJECTED |
| verified_by | BIGINT | FK â†’ user | Usuario que verificÃ³ el documento |
| verified_at | TIMESTAMPTZ | | Timestamp de verificaciÃ³n |
| notes | TEXT | | Observaciones adicionales |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`
- `document_type_id` â†’ `shared.document_type.document_type_id`
- `file_id` â†’ `shared.file_storage.file_id`
- `verified_by` â†’ `shared.user.user_id`

**Tipos de documentos comunes:**
```
DNI - Documento Nacional de Identidad
PASSPORT - Pasaporte
ANTECEDENTES_PENALES - Certificado de antecedentes penales
ANTECEDENTES_POLICIALES - Certificado de antecedentes policiales
ANTECEDENTES_TRÃNSITO - Certificado de antecedentes de trÃ¡nsito
DOMICILIO - Certificado de domicilio
```

**Reglas de negocio:**
- Status se actualiza automÃ¡ticamente a 'EXPIRED' cuando expiry_date < CURRENT_DATE
- Documentos crÃ­ticos vencidos pueden bloquear despacho o acceso
- Sistema debe alertar 30 dÃ­as antes del vencimiento

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_person_doc_person ON hr.person_document(person_id);
CREATE INDEX idx_person_doc_expiry ON hr.person_document(expiry_date) 
WHERE status = 'VALID';
```

**Ejemplo de datos:**
```sql
INSERT INTO hr.person_document (person_id, document_type_id, document_number, 
                                 issue_date, status)
VALUES (42, 1, '45678912', '2020-05-10', 'VALID');
```

---

## 3. person_address

**DescripciÃ³n:** Direcciones de personas (domicilio, direcciÃ³n laboral). Permite mÃºltiples direcciones por persona con tipo diferenciado.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| address_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | NOT NULL, FK â†’ person | Persona propietaria de la direcciÃ³n |
| address_type | VARCHAR(20) | NOT NULL | HOME, WORK, TEMPORARY |
| address_line1 | TEXT | NOT NULL | DirecciÃ³n principal |
| address_line2 | TEXT | | DirecciÃ³n adicional (depto, referencia) |
| district | VARCHAR(100) | | Distrito |
| city | VARCHAR(100) | | Ciudad |
| state | VARCHAR(100) | | Departamento/RegiÃ³n/Estado |
| postal_code | VARCHAR(20) | | CÃ³digo postal |
| country | VARCHAR(50) | DEFAULT 'PE' | PaÃ­s (cÃ³digo ISO 3166) |
| latitude | DECIMAL(10,8) | | Latitud para geolocalizaciÃ³n |
| longitude | DECIMAL(11,8) | | Longitud para geolocalizaciÃ³n |
| is_primary | BOOLEAN | DEFAULT false | DirecciÃ³n principal (solo 1 por persona) |
| is_active | BOOLEAN | DEFAULT true | DirecciÃ³n vigente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`

**Reglas de negocio:**
- Solo puede haber 1 direcciÃ³n con is_primary=true por person_id
- Al marcar una direcciÃ³n como principal, desmarcar las demÃ¡s automÃ¡ticamente

**Constraint Ãºnico:**
```sql
CREATE UNIQUE INDEX idx_person_address_primary 
ON hr.person_address(person_id) 
WHERE is_primary = true;
```

**Ejemplo de datos:**
```sql
INSERT INTO hr.person_address (person_id, address_type, address_line1, 
                                district, city, state, country, is_primary)
VALUES (42, 'HOME', 'Av. Ejercito 1234', 'Paucarpata', 'Arequipa', 
        'Arequipa', 'PE', true);
```

---

## 4. driver

**DescripciÃ³n:** Conductores autorizados para operar vehÃ­culos. Extiende person con datos especÃ­ficos del rol. Diferencia entre propietarios-conductores y conductores contratados.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| driver_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | UNIQUE, NOT NULL, FK â†’ person | VÃ­nculo a tabla base person |
| user_id | BIGINT | UNIQUE, FK â†’ user | Usuario para login en app mÃ³vil |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| driver_code | VARCHAR(20) | UNIQUE, NOT NULL | CÃ³digo interno del conductor |
| hire_date | DATE | | Fecha de contrataciÃ³n/inicio |
| termination_date | DATE | | Fecha de cese (NULL si activo) |
| employment_status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, SUSPENDED, TERMINATED |
| employment_type | VARCHAR(20) | NOT NULL | OWNER_OPERATOR, HIRED_DRIVER |
| owner_id | INT | FK â†’ vehicle_owner | Si es OWNER_OPERATOR, su registro de propietario |
| hired_by_owner_id | INT | FK â†’ vehicle_owner | Si es HIRED_DRIVER, propietario que lo contratÃ³ |
| current_vehicle_id | INT | FK â†’ vehicle | VehÃ­culo actualmente asignado |
| license_points | INT | DEFAULT 100 | Puntos de licencia vigentes (0-100) |
| total_trips | INT | DEFAULT 0 | Total de viajes realizados (contador) |
| total_km_driven | DECIMAL(12,2) | DEFAULT 0 | KilÃ³metros totales conducidos |
| rating_average | DECIMAL(3,2) | | CalificaciÃ³n promedio (1.00-5.00) |
| is_available | BOOLEAN | DEFAULT true | Disponible para despacho |
| notes | TEXT | | Observaciones sobre el conductor |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`
- `user_id` â†’ `shared.user.user_id`
- `company_id` â†’ `shared.company.company_id`
- `owner_id` â†’ `fleet.vehicle_owner.vehicle_owner_id`
- `hired_by_owner_id` â†’ `fleet.vehicle_owner.vehicle_owner_id`
- `current_vehicle_id` â†’ `fleet.vehicle.vehicle_id`
- **Es referenciado por:** driver_license, driver_infraction, medical_exam, vehicle_assignment, trip, fuel_load

**Valores de employment_type:**
```
OWNER_OPERATOR - Propietario que maneja su propio bus (owner_id debe estar lleno)
HIRED_DRIVER   - Conductor contratado por propietario (hired_by_owner_id debe estar lleno)
```

**Reglas de negocio:**
- Si employment_type='OWNER_OPERATOR', owner_id NO puede ser NULL
- Si employment_type='HIRED_DRIVER', hired_by_owner_id NO puede ser NULL
- license_points < 75 genera restricciÃ³n operativa (no puede despachar)
- is_available=false bloquea despacho automÃ¡ticamente
- Al terminar empleo, cerrar todas las asignaciones activas en vehicle_assignment

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_driver_company ON hr.driver(company_id);
CREATE INDEX idx_driver_status ON hr.driver(employment_status) WHERE is_available = true;
CREATE UNIQUE INDEX idx_driver_code ON hr.driver(driver_code);
```

**Ejemplo de datos:**
```sql
-- Propietario-conductor
INSERT INTO hr.driver (person_id, user_id, company_id, driver_code, 
                       employment_type, owner_id, hire_date)
VALUES (42, 105, 1, 'DRV-001', 'OWNER_OPERATOR', 15, '2020-01-01');

-- Conductor contratado
INSERT INTO hr.driver (person_id, user_id, company_id, driver_code, 
                       employment_type, hired_by_owner_id, hire_date)
VALUES (45, 108, 1, 'DRV-002', 'HIRED_DRIVER', 15, '2024-06-01');
```

---

## 5. driver_license

**DescripciÃ³n:** Licencias de conducir de conductores. Historial completo de renovaciones y cambios de categorÃ­a. Control de vigencia.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| license_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| driver_id | INT | NOT NULL, FK â†’ driver | Conductor titular de la licencia |
| license_number | VARCHAR(20) | UNIQUE, NOT NULL | NÃºmero Ãºnico de licencia |
| license_class | VARCHAR(10) | NOT NULL | Clase de licencia (A-IIa, A-IIb, A-IIIa, etc.) |
| issue_date | DATE | NOT NULL | Fecha de emisiÃ³n |
| expiry_date | DATE | NOT NULL | Fecha de vencimiento |
| issuing_authority | VARCHAR(100) | | Autoridad emisora (ej: MTC PerÃº) |
| restrictions | TEXT | | Restricciones especiales (ej: uso de lentes) |
| file_id | BIGINT | FK â†’ file_storage | Archivo PDF/imagen escaneada |
| status | VARCHAR(20) | DEFAULT 'VALID' | VALID, EXPIRED, SUSPENDED, REVOKED |
| is_current | BOOLEAN | DEFAULT true | Licencia vigente (solo 1 por conductor) |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `driver_id` â†’ `hr.driver.driver_id`
- `file_id` â†’ `shared.file_storage.file_id`

**Clases de licencia en PerÃº:**
```
A-I    - VehÃ­culos particulares
A-IIa  - Taxi
A-IIb  - Transporte pÃºblico urbano (buses urbanos)
A-IIIa - Transporte interprovincial
A-IIIb - Transporte internacional
A-IIIc - Transporte especial
```

**Reglas de negocio:**
- Solo puede haber 1 licencia con is_current=true por driver_id
- Al registrar nueva licencia, marcar anteriores como is_current=false
- Status se actualiza automÃ¡ticamente a 'EXPIRED' cuando expiry_date < CURRENT_DATE
- Licencia vencida o suspendida bloquea despacho

**Constraint Ãºnico:**
```sql
CREATE UNIQUE INDEX idx_driver_license_current 
ON hr.driver_license(driver_id) 
WHERE is_current = true;
```

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_license_expiry ON hr.driver_license(expiry_date) 
WHERE status = 'VALID';
```

**Ejemplo de datos:**
```sql
INSERT INTO hr.driver_license (driver_id, license_number, license_class, 
                                issue_date, expiry_date, issuing_authority)
VALUES (5, 'Q45678912', 'A-IIb', '2023-05-10', '2028-05-09', 'MTC PerÃº');
```

---

## 6. driver_infraction

**DescripciÃ³n:** Papeletas e infracciones de trÃ¡nsito de conductores. Control de sanciones, puntos descontados y estado de pago.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| infraction_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| driver_id | INT | NOT NULL, FK â†’ driver | Conductor infractor |
| vehicle_id | INT | FK â†’ vehicle | VehÃ­culo involucrado en la infracciÃ³n |
| infraction_code | VARCHAR(20) | | CÃ³digo oficial de la infracciÃ³n |
| infraction_date | DATE | NOT NULL | Fecha de la infracciÃ³n |
| infraction_type | VARCHAR(100) | NOT NULL | Tipo de falta (ej: exceso de velocidad) |
| description | TEXT | | DescripciÃ³n detallada de la infracciÃ³n |
| location | TEXT | | Lugar donde ocurriÃ³ |
| authority | VARCHAR(100) | | Autoridad sancionadora (PNP, SAT, etc.) |
| ticket_number | VARCHAR(50) | UNIQUE | NÃºmero de papeleta oficial |
| fine_amount | DECIMAL(10,2) | | Monto de la multa |
| points_deducted | INT | DEFAULT 0 | Puntos descontados de la licencia |
| payment_status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, PAID, APPEALED, CANCELLED |
| paid_date | DATE | | Fecha de pago |
| paid_amount | DECIMAL(10,2) | | Monto efectivamente pagado |
| payment_reference | VARCHAR(100) | | NÃºmero de comprobante de pago |
| file_id | BIGINT | FK â†’ file_storage | Foto de la papeleta |
| registered_by | BIGINT | FK â†’ user | Usuario que registrÃ³ |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `driver_id` â†’ `hr.driver.driver_id`
- `vehicle_id` â†’ `fleet.vehicle.vehicle_id`
- `file_id` â†’ `shared.file_storage.file_id`
- `registered_by` â†’ `shared.user.user_id`

**Reglas de negocio:**
- Al registrar infracciÃ³n, descontar points_deducted de driver.license_points automÃ¡ticamente
- Si driver.license_points < 75 despuÃ©s de descuento, generar restricciÃ³n operativa
- Infracciones graves (> 50 puntos) pueden suspender conductor automÃ¡ticamente

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_infraction_driver ON hr.driver_infraction(driver_id);
CREATE INDEX idx_infraction_payment ON hr.driver_infraction(payment_status);
```

**Ejemplo de datos:**
```sql
INSERT INTO hr.driver_infraction (driver_id, vehicle_id, infraction_code, 
                                   infraction_date, infraction_type, 
                                   fine_amount, points_deducted, ticket_number)
VALUES (5, 25, 'C-14', '2024-11-15', 'Exceso de velocidad', 450.00, 20, 
        'PNP-2024-123456');
```

---

## 7. medical_exam

**DescripciÃ³n:** ExÃ¡menes psicosomÃ¡ticos y mÃ©dicos obligatorios para conductores. Control de salud fÃ­sica y mental segÃºn normativa de transporte.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| medical_exam_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| driver_id | INT | NOT NULL, FK â†’ driver | Conductor examinado |
| exam_type | VARCHAR(50) | NOT NULL | PSYCHOSOMATIC, PHYSICAL, PSYCHOLOGICAL |
| exam_date | DATE | NOT NULL | Fecha del examen |
| expiry_date | DATE | NOT NULL | Fecha de vencimiento |
| medical_center | VARCHAR(255) | | Centro mÃ©dico donde se realizÃ³ |
| doctor_name | VARCHAR(255) | | Nombre del mÃ©dico responsable |
| result | VARCHAR(20) | NOT NULL | APPROVED, REJECTED, CONDITIONAL |
| observations | TEXT | | Observaciones mÃ©dicas |
| restrictions | TEXT | | Restricciones indicadas (ej: no conducir de noche) |
| certificate_number | VARCHAR(100) | | NÃºmero de certificado mÃ©dico |
| file_id | BIGINT | FK â†’ file_storage | Certificado escaneado |
| verified_by | BIGINT | FK â†’ user | Usuario que verificÃ³ |
| verified_at | TIMESTAMPTZ | | Fecha de verificaciÃ³n |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `driver_id` â†’ `hr.driver.driver_id`
- `file_id` â†’ `shared.file_storage.file_id`
- `verified_by` â†’ `shared.user.user_id`

**Tipos de examen:**
```
PSYCHOSOMATIC  - Examen psicosomÃ¡tico integral (obligatorio anual)
PHYSICAL       - Examen fÃ­sico general
PSYCHOLOGICAL  - EvaluaciÃ³n psicolÃ³gica
```

**Reglas de negocio:**
- Examen psicosomÃ¡tico vencido (expiry_date < CURRENT_DATE) bloquea despacho
- Result='REJECTED' suspende automÃ¡ticamente al conductor
- Result='CONDITIONAL' puede agregar restrictions especÃ­ficas
- Debe renovarse anualmente segÃºn normativa peruana

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_medical_driver ON hr.medical_exam(driver_id);
CREATE INDEX idx_medical_expiry ON hr.medical_exam(expiry_date) 
WHERE result = 'APPROVED';
```

**Ejemplo de datos:**
```sql
INSERT INTO hr.medical_exam (driver_id, exam_type, exam_date, expiry_date, 
                              medical_center, result, certificate_number)
VALUES (5, 'PSYCHOSOMATIC', '2024-01-10', '2025-01-09', 
        'Centro MÃ©dico San Juan', 'APPROVED', 'CERT-2024-001234');
```

---

## 8. background_check

**DescripciÃ³n:** Antecedentes penales, policiales y de trÃ¡nsito. Verificaciones obligatorias de conducta y rÃ©cord legal.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| background_check_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | NOT NULL, FK â†’ person | Persona verificada |
| check_type | VARCHAR(50) | NOT NULL | CRIMINAL, POLICE, TRAFFIC, JUDICIAL |
| check_date | DATE | NOT NULL | Fecha de verificaciÃ³n |
| expiry_date | DATE | | Fecha de vencimiento (si aplica) |
| issuing_authority | VARCHAR(255) | NOT NULL | Autoridad emisora (RENIEC, PNP, etc.) |
| certificate_number | VARCHAR(100) | | NÃºmero de certificado |
| result | VARCHAR(20) | NOT NULL | CLEAN, RECORDS_FOUND |
| records_detail | TEXT | | Detalle de antecedentes encontrados |
| file_id | BIGINT | FK â†’ file_storage | Certificado escaneado |
| verified_by | BIGINT | FK â†’ user | Usuario que verificÃ³ |
| verified_at | TIMESTAMPTZ | | Fecha de verificaciÃ³n |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`
- `file_id` â†’ `shared.file_storage.file_id`
- `verified_by` â†’ `shared.user.user_id`

**Tipos de verificaciÃ³n:**
```
CRIMINAL - Antecedentes penales
POLICE   - Antecedentes policiales
TRAFFIC  - Antecedentes de trÃ¡nsito
JUDICIAL - Antecedentes judiciales
```

**Reglas de negocio:**
- Certificados con result='RECORDS_FOUND' pueden requerir revisiÃ³n especial
- Antecedentes penales graves pueden descalificar al conductor
- Debe renovarse cada 6-12 meses segÃºn normativa

**Ejemplo de datos:**
```sql
INSERT INTO hr.background_check (person_id, check_type, check_date, 
                                  issuing_authority, result, certificate_number)
VALUES (42, 'CRIMINAL', '2024-01-05', 'RENIEC', 'CLEAN', 'AP-2024-123456');
```

---

## 9. inspector

**DescripciÃ³n:** Inspectores de campo. Personal autorizado para verificar cumplimiento operativo en ruta y terminal.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| inspector_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | UNIQUE, NOT NULL, FK â†’ person | VÃ­nculo a tabla base person |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| user_id | BIGINT | UNIQUE, FK â†’ user | Usuario para login en app |
| inspector_code | VARCHAR(20) | UNIQUE, NOT NULL | CÃ³digo interno del inspector |
| assigned_zone | VARCHAR(100) | | Zona geogrÃ¡fica asignada |
| hire_date | DATE | | Fecha de contrataciÃ³n |
| employment_status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, SUSPENDED, TERMINATED |
| has_vehicle | BOOLEAN | DEFAULT false | Tiene vehÃ­culo asignado para inspecciones |
| vehicle_plate | VARCHAR(10) | | Placa del vehÃ­culo (si has_vehicle=true) |
| total_inspections | INT | DEFAULT 0 | Total de inspecciones realizadas |
| is_available | BOOLEAN | DEFAULT true | Disponible para asignar inspecciones |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`
- `company_id` â†’ `shared.company.company_id`
- `user_id` â†’ `shared.user.user_id`
- **Es referenciado por:** field_inspection (schema inspection)

**Reglas de negocio:**
- is_available=false impide asignar nuevas inspecciones
- total_inspections se incrementa automÃ¡ticamente con cada field_inspection

**Ejemplo de datos:**
```sql
INSERT INTO hr.inspector (person_id, company_id, user_id, inspector_code, 
                          assigned_zone, hire_date)
VALUES (50, 1, 115, 'INSP-001', 'Zona Norte', '2022-03-01');
```

---

## 10. personnel

**DescripciÃ³n:** Personal general administrativo y operativo (cajeros, despachadores, mecÃ¡nicos, administrativos). Personal que no son conductores ni inspectores.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| personnel_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | UNIQUE, NOT NULL, FK â†’ person | VÃ­nculo a tabla base person |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| user_id | BIGINT | UNIQUE, FK â†’ user | Usuario para login en sistema |
| employee_code | VARCHAR(20) | UNIQUE, NOT NULL | CÃ³digo interno del empleado |
| job_title | VARCHAR(100) | NOT NULL | Cargo/puesto |
| department | VARCHAR(100) | | Departamento/Ã¡rea |
| hire_date | DATE | NOT NULL | Fecha de contrataciÃ³n |
| termination_date | DATE | | Fecha de cese |
| employment_type | VARCHAR(20) | | FULL_TIME, PART_TIME, CONTRACT |
| employment_status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, SUSPENDED, TERMINATED |
| base_salary | DECIMAL(10,2) | | Sueldo base mensual |
| work_schedule | VARCHAR(50) | | Horario de trabajo |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`
- `company_id` â†’ `shared.company.company_id`
- `user_id` â†’ `shared.user.user_id`

**Cargos tÃ­picos (job_title):**
```
DISPATCHER       - Despachador
CASHIER          - Cajero
MECHANIC         - MecÃ¡nico
ADMIN_ASSISTANT  - Asistente administrativo
MANAGER          - Gerente
ACCOUNTANT       - Contador
HR_STAFF         - Personal de RRHH
```

**Ejemplo de datos:**
```sql
INSERT INTO hr.personnel (person_id, company_id, user_id, employee_code, 
                          job_title, hire_date, base_salary)
VALUES (55, 1, 120, 'EMP-001', 'DISPATCHER', '2023-01-15', 1800.00);
```

---

## 11. loan

**DescripciÃ³n:** PrÃ©stamos, adelantos y saldos pendientes otorgados a personal. Control de crÃ©ditos con descuentos. **CRÃTICO:** Bloquea liquidaciÃ³n de caja si hay saldo pendiente.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| loan_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | NOT NULL, FK â†’ person | Empleado/conductor deudor |
| loan_type | VARCHAR(20) | NOT NULL | ADVANCE, LOAN, EMERGENCY, TRIP_SETTLEMENT_PENDING |
| loan_amount | DECIMAL(10,2) | NOT NULL | Monto original del prÃ©stamo |
| interest_rate | DECIMAL(5,2) | DEFAULT 0 | Tasa de interÃ©s (%) |
| total_amount | DECIMAL(10,2) | NOT NULL | Monto total a pagar (incluye interÃ©s) |
| installments | INT | NOT NULL | NÃºmero de cuotas |
| installment_amount | DECIMAL(10,2) | NOT NULL | Monto por cuota |
| granted_date | DATE | NOT NULL | Fecha de otorgamiento |
| first_payment_date | DATE | NOT NULL | Fecha de primera cuota |
| granted_by | BIGINT | NOT NULL, FK â†’ user | Usuario que aprobÃ³ |
| purpose | TEXT | | Motivo/propÃ³sito del prÃ©stamo |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, PAID, CANCELLED |
| paid_installments | INT | DEFAULT 0 | Cuotas pagadas |
| remaining_balance | DECIMAL(10,2) | NOT NULL | Saldo pendiente |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`
- `granted_by` â†’ `shared.user.user_id`

**Tipos de prÃ©stamo:**
```
ADVANCE                 - Adelanto de sueldo
LOAN                    - PrÃ©stamo formal
EMERGENCY               - PrÃ©stamo de emergencia
TRIP_SETTLEMENT_PENDING - Saldo de viaje sin liquidar (CRÃTICO)
```

**Reglas de negocio:**
- **CRÃTICO:** Si loan_type='TRIP_SETTLEMENT_PENDING' y remaining_balance > 0, BLOQUEAR liquidaciÃ³n de caja
- remaining_balance se actualiza al pagar cuotas: `total_amount - (paid_installments * installment_amount)`
- Status cambia a 'PAID' automÃ¡ticamente cuando remaining_balance = 0
- Descuentos de cuotas se registran en payroll_record para empleados

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_loan_person ON hr.loan(person_id);
CREATE INDEX idx_loan_status ON hr.loan(status) WHERE remaining_balance > 0;
CREATE INDEX idx_loan_settlement ON hr.loan(person_id, loan_type) 
WHERE loan_type = 'TRIP_SETTLEMENT_PENDING' AND status = 'ACTIVE';
```

**Ejemplo de datos:**
```sql
-- Adelanto de sueldo
INSERT INTO hr.loan (person_id, loan_type, loan_amount, total_amount, 
                     installments, installment_amount, granted_date, 
                     first_payment_date, granted_by, remaining_balance)
VALUES (42, 'ADVANCE', 1000.00, 1000.00, 2, 500.00, '2024-12-01', 
        '2025-01-01', 3, 1000.00);

-- Saldo de viaje pendiente (BLOQUEA LIQUIDACIÃ“N)
INSERT INTO hr.loan (person_id, loan_type, loan_amount, total_amount, 
                     installments, installment_amount, granted_date, 
                     first_payment_date, granted_by, remaining_balance)
VALUES (45, 'TRIP_SETTLEMENT_PENDING', 350.00, 350.00, 1, 350.00, 
        '2024-12-19', '2024-12-20', 3, 350.00);
```

---

## 12. attendance

**DescripciÃ³n:** Registro de asistencia diaria de personal. Control de entradas, salidas y horas trabajadas.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| attendance_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | NOT NULL, FK â†’ person | Persona registrada |
| attendance_date | DATE | NOT NULL | Fecha de asistencia |
| check_in_time | TIME | | Hora de entrada |
| check_out_time | TIME | | Hora de salida |
| work_hours | DECIMAL(4,2) | | Horas trabajadas calculadas |
| overtime_hours | DECIMAL(4,2) | DEFAULT 0 | Horas extras |
| status | VARCHAR(20) | DEFAULT 'PRESENT' | PRESENT, ABSENT, LATE, EXCUSED |
| location | VARCHAR(100) | | UbicaciÃ³n de marcaciÃ³n (terminal, oficina) |
| device | VARCHAR(50) | | Dispositivo usado (biomÃ©trico, app) |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`

**Constraint Ãºnico:**
```sql
CREATE UNIQUE INDEX idx_attendance_person_date 
ON hr.attendance(person_id, attendance_date);
```

**Reglas de negocio:**
- Solo 1 registro de asistencia por persona por dÃ­a
- work_hours se calcula: `check_out_time - check_in_time`
- overtime_hours se calcula si work_hours > jornada estÃ¡ndar (8 horas)

**Ejemplo de datos:**
```sql
INSERT INTO hr.attendance (person_id, attendance_date, check_in_time, 
                            check_out_time, work_hours, status)
VALUES (55, '2024-12-19', '08:00:00', '17:00:00', 9.00, 'PRESENT');
```

---

## 13. absence

**DescripciÃ³n:** Ausencias y permisos de personal. Registro de licencias mÃ©dicas, vacaciones y permisos personales.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| absence_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | NOT NULL, FK â†’ person | Persona ausente |
| absence_type | VARCHAR(20) | NOT NULL | SICK_LEAVE, VACATION, PERSONAL, UNPAID |
| start_date | DATE | NOT NULL | Fecha de inicio de ausencia |
| end_date | DATE | NOT NULL | Fecha de fin de ausencia |
| days_count | INT | NOT NULL | NÃºmero total de dÃ­as |
| reason | TEXT | | Motivo de la ausencia |
| medical_certificate | BOOLEAN | DEFAULT false | Tiene certificado mÃ©dico adjunto |
| file_id | BIGINT | FK â†’ file_storage | Documento adjunto (certificado, solicitud) |
| requested_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de solicitud |
| approved_by | BIGINT | FK â†’ user | Usuario que aprobÃ³ |
| approved_at | TIMESTAMPTZ | | Fecha de aprobaciÃ³n |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, APPROVED, REJECTED |
| rejection_reason | TEXT | | Motivo de rechazo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`
- `file_id` â†’ `shared.file_storage.file_id`
- `approved_by` â†’ `shared.user.user_id`

**Tipos de ausencia:**
```
SICK_LEAVE - Licencia mÃ©dica (requiere certificado)
VACATION   - Vacaciones programadas
PERSONAL   - Permiso personal
UNPAID     - Permiso sin goce de haber
```

**Reglas de negocio:**
- days_count se calcula: `end_date - start_date + 1`
- SICK_LEAVE con > 3 dÃ­as requiere medical_certificate=true
- Status='APPROVED' descuenta dÃ­as de banco de vacaciones si aplica

**Ejemplo de datos:**
```sql
INSERT INTO hr.absence (person_id, absence_type, start_date, end_date, 
                        days_count, reason, status)
VALUES (42, 'VACATION', '2024-12-25', '2024-12-31', 7, 
        'Vacaciones de fin de aÃ±o', 'APPROVED');
```

---

## 14. employment_contract

**DescripciÃ³n:** Contratos laborales de personal. Registro de tÃ©rminos contractuales, perÃ­odos y renovaciones.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| contract_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | NOT NULL, FK â†’ person | Persona contratada |
| contract_type | VARCHAR(20) | NOT NULL | INDEFINITE, FIXED_TERM, TRIAL, OWNER_OPERATOR |
| start_date | DATE | NOT NULL | Fecha de inicio del contrato |
| end_date | DATE | | Fecha de fin (NULL si indefinido) |
| position | VARCHAR(100) | NOT NULL | Cargo contratado |
| salary | DECIMAL(10,2) | NOT NULL | Salario mensual acordado |
| salary_currency | VARCHAR(3) | DEFAULT 'PEN' | Moneda del salario |
| work_hours_per_week | INT | | Horas semanales contratadas |
| benefits | TEXT | | Beneficios incluidos |
| contract_terms | TEXT | | TÃ©rminos especiales del contrato |
| file_id | BIGINT | FK â†’ file_storage | Contrato escaneado firmado |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, EXPIRED, TERMINATED |
| signed_by_employee | BOOLEAN | DEFAULT false | Firmado por empleado |
| signed_by_employer | BOOLEAN | DEFAULT false | Firmado por empleador |
| created_by | BIGINT | FK â†’ user | Usuario que registrÃ³ |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`
- `file_id` â†’ `shared.file_storage.file_id`
- `created_by` â†’ `shared.user.user_id`

**Tipos de contrato:**
```
INDEFINITE     - Contrato indefinido
FIXED_TERM     - Plazo fijo
TRIAL          - PerÃ­odo de prueba
OWNER_OPERATOR - Contrato de operador-propietario (no empleado)
```

**Reglas de negocio:**
- OWNER_OPERATOR no genera registros en payroll_record
- Status cambia a 'EXPIRED' automÃ¡ticamente cuando end_date < CURRENT_DATE
- Contrato debe estar firmado por ambas partes (signed_by_employee=true AND signed_by_employer=true)

**Ejemplo de datos:**
```sql
INSERT INTO hr.employment_contract (person_id, contract_type, start_date, 
                                     position, salary, created_by)
VALUES (55, 'INDEFINITE', '2023-01-15', 'Despachador', 1800.00, 3);
```

---

## 15. payroll_record

**DescripciÃ³n:** Registros de nÃ³mina por empleado. **Solo para empleados contratados**, NO para owner-operators. CÃ¡lculo de salario bruto, descuentos y neto.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| payroll_record_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| person_id | INT | NOT NULL, FK â†’ person | Empleado pagado |
| company_id | INT | NOT NULL, FK â†’ company | Empresa operadora |
| period_start | DATE | NOT NULL | Inicio del perÃ­odo de pago |
| period_end | DATE | NOT NULL | Fin del perÃ­odo de pago |
| payment_date | DATE | NOT NULL | Fecha de pago efectivo |
| base_salary | DECIMAL(10,2) | NOT NULL | Salario base del perÃ­odo |
| gross_salary | DECIMAL(10,2) | NOT NULL | Salario bruto (incluye bonos) |
| total_deductions | DECIMAL(10,2) | DEFAULT 0 | Total de descuentos (impuestos, prÃ©stamos) |
| total_bonuses | DECIMAL(10,2) | DEFAULT 0 | Total de bonificaciones |
| net_salary | DECIMAL(10,2) | NOT NULL | Salario neto a pagar |
| payment_method | VARCHAR(20) | | CASH, TRANSFER, CHECK |
| bank_account | VARCHAR(50) | | Cuenta bancaria del empleado |
| payment_reference | VARCHAR(100) | | NÃºmero de transferencia/cheque |
| days_worked | INT | | DÃ­as trabajados en el perÃ­odo |
| hours_worked | DECIMAL(6,2) | | Horas trabajadas |
| overtime_hours | DECIMAL(6,2) | DEFAULT 0 | Horas extras |
| status | VARCHAR(20) | DEFAULT 'PENDING' | PENDING, PAID, CANCELLED |
| paid_at | TIMESTAMPTZ | | Timestamp de pago efectivo |
| notes | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de cÃ¡lculo |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

**Relaciones:**
- `person_id` â†’ `hr.person.person_id`
- `company_id` â†’ `shared.company.company_id`

**Reglas de negocio:**
- **IMPORTANTE:** Solo para empleados (drivers con employment_type='HIRED_DRIVER', personnel, inspectors)
- **NO** generar registros para drivers con employment_type='OWNER_OPERATOR'
- net_salary = gross_salary - total_deductions
- gross_salary = base_salary + total_bonuses
- total_deductions incluye: impuestos, AFP/ONP, descuentos de prÃ©stamos (loan)

**CÃ¡lculo de descuentos:**
```sql
-- Incluir cuotas de prÃ©stamos activos
SELECT SUM(installment_amount) 
FROM hr.loan 
WHERE person_id = X AND status = 'ACTIVE' 
  AND first_payment_date <= period_end;
```

**Ãndices sugeridos:**
```sql
CREATE INDEX idx_payroll_person_period ON hr.payroll_record(person_id, period_start);
CREATE INDEX idx_payroll_payment_date ON hr.payroll_record(payment_date);
```

**Ejemplo de datos:**
```sql
INSERT INTO hr.payroll_record (person_id, company_id, period_start, period_end, 
                                payment_date, base_salary, gross_salary, 
                                total_deductions, net_salary, days_worked, status)
VALUES (55, 1, '2024-12-01', '2024-12-31', '2024-12-31', 1800.00, 1800.00, 
        350.00, 1450.00, 26, 'PENDING');
```

---

## ðŸ“Š RESUMEN DEL SCHEMA

**Total de Tablas:** 15 tablas core

**PropÃ³sito:** GestiÃ³n completa de recursos humanos para sistema GPS de transporte con:
- Base de personas unificada
- GestiÃ³n de conductores (propietarios y contratados)
- DocumentaciÃ³n y certificaciones
- Personal operativo y administrativo
- Control de prÃ©stamos (crÃ­tico para liquidaciÃ³n)
- NÃ³mina simplificada (solo empleados)

**Diferenciadores clave:**
- Soporta modelo propietario-conductor (owner-operator)
- Control de prÃ©stamos bloquea liquidaciÃ³n
- NÃ³mina solo para empleados, no owner-operators
- Validaciones pre-despacho (licencias, exÃ¡menes, antecedentes)

---

**Fin del Diccionario - Schema hr v4.0**
## SCHEMAS :

### **Schema: `inspection`**
```
102. field_inspection          -- Inspecciones de campo
103. route_verification        -- Verificaciones de ruta
104. vehicle_inspection        -- Inspecciones de vehÃ­culos
105. inspection_finding        -- Hallazgos de inspecciones
106. inspection_evidence       -- Evidencias fotogrÃ¡ficas
107. inspection_report         -- Reportes consolidados
```

### **Schema: `audit`**
```
108. change_log                -- Registro de cambios en entidades
109. data_retention_policy     -- PolÃ­ticas de retenciÃ³n
110. archived_data             -- Datos archivados histÃ³ricos
```

---

# EXPLAIN TABLES (V3)

## SCHEMA: `inspection` (futura versiÃ³n)

Inspecciones de campo, verificaciÃ³n de cumplimiento operativo y generaciÃ³n de reportes.

---

### **101. field_inspection**

**DescripciÃ³n:** Inspecciones de campo realizadas por inspectores. Registro maestro de cada inspecciÃ³n con contexto operativo.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| field_inspection_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| inspector_id | INT | NOT NULL, FK â†’ inspector | Inspector responsable |
| inspection_date | DATE | NOT NULL | Fecha de inspecciÃ³n |
| shift_start | TIME | NOT NULL | Inicio de turno |
| shift_end | TIME | | Fin de turno |
| assigned_zone | VARCHAR(100) | | Zona asignada |
| route_id | INT | FK â†’ route | Ruta inspeccionada |
| inspection_type | VARCHAR(20) | NOT NULL | ROUTE, FREQUENCY, VEHICLE, INCIDENT |
| total_verifications | INT | DEFAULT 0 | Verificaciones realizadas |
| total_findings | INT | DEFAULT 0 | Hallazgos registrados |
| km_traveled | DECIMAL(6,2) | | KilÃ³metros recorridos |
| status | VARCHAR(20) | DEFAULT 'IN_PROGRESS' | IN_PROGRESS, COMPLETED, CANCELLED |
| completed_at | TIMESTAMPTZ | | Fecha de finalizaciÃ³n |
| notes | TEXT | | Observaciones generales |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

---

### **102. route_verification**

**DescripciÃ³n:** Verificaciones de cumplimiento de ruta. Registro de validaciÃ³n de recorridos autorizados y detecciÃ³n de desvÃ­os.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| route_verification_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| field_inspection_id | BIGINT | NOT NULL, FK â†’ field_inspection | InspecciÃ³n asociada |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo verificado |
| driver_id | INT | FK â†’ driver | Conductor verificado |
| trip_id | BIGINT | FK â†’ trip | Viaje asociado |
| verification_location | VARCHAR(255) | NOT NULL | Punto de verificaciÃ³n |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud del punto |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud del punto |
| verification_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp de verificaciÃ³n |
| is_on_route | BOOLEAN | NOT NULL | Dentro de ruta autorizada |
| deviation_meters | INT | | DesviaciÃ³n en metros |
| compliance_percentage | DECIMAL(5,2) | | Porcentaje de cumplimiento |
| observations | TEXT | | Observaciones |
| photo_file_id | BIGINT | FK â†’ file_storage | Foto adjunta |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **103. frequency_check**

**DescripciÃ³n:** Control de cumplimiento de frecuencias en campo. MediciÃ³n real de intervalos entre despachos en puntos crÃ­ticos.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| frequency_check_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| field_inspection_id | BIGINT | NOT NULL, FK â†’ field_inspection | InspecciÃ³n asociada |
| route_id | INT | NOT NULL, FK â†’ route | Ruta verificada |
| stop_id | INT | FK â†’ stop | Paradero de verificaciÃ³n |
| checkpoint_id | INT | FK â†’ checkpoint | Control verificado |
| check_location | VARCHAR(255) | NOT NULL | UbicaciÃ³n del control |
| start_time | TIMESTAMPTZ | NOT NULL | Inicio del monitoreo |
| end_time | TIMESTAMPTZ | NOT NULL | Fin del monitoreo |
| duration_minutes | INT | NOT NULL | DuraciÃ³n del control |
| vehicles_counted | INT | NOT NULL | VehÃ­culos contabilizados |
| min_interval_minutes | INT | | Intervalo mÃ­nimo observado |
| max_interval_minutes | INT | | Intervalo mÃ¡ximo observado |
| avg_interval_minutes | DECIMAL(5,2) | | Intervalo promedio |
| target_frequency_minutes | INT | | Frecuencia objetivo |
| compliance_percentage | DECIMAL(5,2) | | Porcentaje de cumplimiento |
| observations | TEXT | | Observaciones |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **104. vehicle_inspection**

**DescripciÃ³n:** InspecciÃ³n tÃ©cnica y de seguridad de vehÃ­culos en campo. VerificaciÃ³n de condiciones operativas y cumplimiento normativo.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| vehicle_inspection_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| field_inspection_id | BIGINT | NOT NULL, FK â†’ field_inspection | InspecciÃ³n asociada |
| vehicle_id | INT | NOT NULL, FK â†’ vehicle | VehÃ­culo inspeccionado |
| driver_id | INT | FK â†’ driver | Conductor presente |
| inspection_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp inspecciÃ³n |
| location | VARCHAR(255) | | UbicaciÃ³n inspecciÃ³n |
| latitude | DECIMAL(10,8) | | Latitud |
| longitude | DECIMAL(11,8) | | Longitud |
| overall_condition | VARCHAR(20) | NOT NULL | EXCELLENT, GOOD, FAIR, POOR |
| cleanliness_score | INT | | Limpieza (0-10) |
| mechanical_condition | VARCHAR(20) | | Estado mecÃ¡nico |
| safety_equipment_complete | BOOLEAN | | Equipos completos |
| documents_valid | BOOLEAN | | Documentos vigentes |
| total_findings | INT | DEFAULT 0 | Hallazgos totales |
| critical_findings | INT | DEFAULT 0 | Hallazgos crÃ­ticos |
| passed_inspection | BOOLEAN | | AprobÃ³ inspecciÃ³n |
| restrictions_applied | BOOLEAN | DEFAULT false | Se aplicÃ³ restricciÃ³n |
| observations | TEXT | | Observaciones generales |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **105. inspection_finding**

**DescripciÃ³n:** Hallazgos y observaciones de inspecciones. Registro detallado de incumplimientos, deficiencias o irregularidades detectadas.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| inspection_finding_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| field_inspection_id | BIGINT | NOT NULL, FK â†’ field_inspection | InspecciÃ³n asociada |
| vehicle_inspection_id | BIGINT | FK â†’ vehicle_inspection | InspecciÃ³n vehÃ­culo |
| route_verification_id | BIGINT | FK â†’ route_verification | VerificaciÃ³n ruta |
| finding_type | VARCHAR(50) | NOT NULL | Tipo de hallazgo |
| severity | VARCHAR(20) | NOT NULL | LOW, MEDIUM, HIGH, CRITICAL |
| category | VARCHAR(50) | | MECHANICAL, SAFETY, DOCUMENTATION, CLEANLINESS |
| description | TEXT | NOT NULL | DescripciÃ³n detallada |
| requires_correction | BOOLEAN | DEFAULT true | Requiere correcciÃ³n |
| correction_deadline | TIMESTAMPTZ | | Plazo de correcciÃ³n |
| corrected_at | TIMESTAMPTZ | | Fecha de correcciÃ³n |
| corrected_by | BIGINT | FK â†’ user | Usuario que corrigiÃ³ |
| verification_notes | TEXT | | Notas de verificaciÃ³n |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **106. inspection_evidence**

**DescripciÃ³n:** Evidencias fotogrÃ¡ficas y de video de inspecciones. Archivos adjuntos para sustentar hallazgos y observaciones.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| inspection_evidence_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| field_inspection_id | BIGINT | NOT NULL, FK â†’ field_inspection | InspecciÃ³n asociada |
| inspection_finding_id | BIGINT | FK â†’ inspection_finding | Hallazgo documentado |
| evidence_type | VARCHAR(20) | NOT NULL | PHOTO, VIDEO, AUDIO, DOCUMENT |
| file_id | BIGINT | NOT NULL, FK â†’ file_storage | Archivo adjunto |
| latitude | DECIMAL(10,8) | | Latitud de captura |
| longitude | DECIMAL(11,8) | | Longitud de captura |
| captured_at | TIMESTAMPTZ | NOT NULL | Timestamp de captura |
| description | TEXT | | DescripciÃ³n de evidencia |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

---

### **107. inspection_report**

**DescripciÃ³n:** Reportes consolidados de inspecciÃ³n por turno. Resumen ejecutivo de actividades, hallazgos y recomendaciones del inspector.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| inspection_report_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| field_inspection_id | BIGINT | UNIQUE, NOT NULL, FK â†’ field_inspection | InspecciÃ³n asociada |
| report_date | DATE | NOT NULL | Fecha del reporte |
| summary | TEXT | NOT NULL | Resumen ejecutivo |
| total_vehicles_inspected | INT | DEFAULT 0 | VehÃ­culos inspeccionados |
| total_routes_verified | INT | DEFAULT 0 | Rutas verificadas |
| total_frequency_checks | INT | DEFAULT 0 | Controles de frecuencia |
| total_incidents_attended | INT | DEFAULT 0 | Incidentes atendidos |
| compliance_rate | DECIMAL(5,2) | | Tasa de cumplimiento |
| critical_findings_summary | TEXT | | Resumen hallazgos crÃ­ticos |
| recommendations | TEXT | | Recomendaciones |
| attachments_count | INT | DEFAULT 0 | Total de adjuntos |
| submitted_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de envÃ­o |
| reviewed_by | BIGINT | FK â†’ user | Jefe que revisÃ³ |
| reviewed_at | TIMESTAMPTZ | | Fecha de revisiÃ³n |
| status | VARCHAR(20) | DEFAULT 'DRAFT' | DRAFT, SUBMITTED, REVIEWED, APPROVED |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

---

## SCHEMA: `audit`

AuditorÃ­a avanzada, trazabilidad de cambios y gestiÃ³n de datos histÃ³ricos.

---

### **108. change_log**

**DescripciÃ³n:** Registro detallado de cambios en entidades crÃ­ticas. Captura estado anterior y posterior para auditorÃ­a completa.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| change_log_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| table_name | VARCHAR(100) | NOT NULL | Tabla afectada |
| record_id | BIGINT | NOT NULL | ID del registro |
| operation | VARCHAR(10) | NOT NULL | INSERT, UPDATE, DELETE |
| changed_by | BIGINT | FK â†’ user | Usuario que modificÃ³ |
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

**DescripciÃ³n:** PolÃ­ticas de retenciÃ³n de datos por tabla. Define perÃ­odos de conservaciÃ³n y estrategias de archivado.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| retention_policy_id | SERIAL | PRIMARY KEY | Identificador Ãºnico |
| table_name | VARCHAR(100) | UNIQUE, NOT NULL | Tabla regulada |
| retention_period_days | INT | NOT NULL | DÃ­as de retenciÃ³n |
| archive_strategy | VARCHAR(20) | NOT NULL | ARCHIVE, DELETE, ANONYMIZE |
| is_active | BOOLEAN | DEFAULT true | PolÃ­tica activa |
| last_execution_at | TIMESTAMPTZ | | Ãšltima ejecuciÃ³n |
| next_execution_at | TIMESTAMPTZ | | PrÃ³xima ejecuciÃ³n |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Ãšltima actualizaciÃ³n |

---

### **110. archived_data**

**DescripciÃ³n:** Datos archivados que superaron perÃ­odo de retenciÃ³n. Almacenamiento histÃ³rico comprimido para consultas eventuales.

| Campo | Tipo | Restricciones | DescripciÃ³n |
|-------|------|---------------|-------------|
| archived_data_id | BIGSERIAL | PRIMARY KEY | Identificador Ãºnico |
| table_name | VARCHAR(100) | NOT NULL | Tabla de origen |
| record_id | BIGINT | NOT NULL | ID del registro original |
| archived_data | JSONB | NOT NULL | Datos completos archivados |
| archived_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de archivado |
| retention_policy_id | INT | FK â†’ data_retention_policy | PolÃ­tica aplicada |
| can_be_deleted_after | DATE | | Fecha de eliminaciÃ³n permitida |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creaciÃ³n |

**Particionada por:** archived_at (anual)

---