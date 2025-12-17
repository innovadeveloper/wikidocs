-- ============================================================================
-- REGISTROS DE EJEMPLO - SCHEMA: identity
-- Sistema de Gestión de Transporte - CITEC TRAN S.A.
-- Fecha: 17 Diciembre 2024
-- ============================================================================

-- ============================================================================
-- TABLA 1: user
-- Usuarios del sistema vinculados a LDAP/WSO2 IS
-- ============================================================================

INSERT INTO identity.user (
    user_id,
    external_id,
    username,
    email,
    full_name,
    is_active,
    last_login_at,
    created_at,
    updated_at
) VALUES 
-- Usuario 1: Gerente General
(
    1,
    'uid=cmendoza,ou=users,dc=citectran,dc=com',
    'cmendoza',
    'carlos.mendoza@citectran.com',
    'Carlos Alberto Mendoza Pérez',
    true,
    '2024-12-17 08:15:23-05',
    '2024-01-15 09:00:00-05',
    '2024-12-17 08:15:23-05'
),

-- Usuario 2: Gerente de Operaciones
(
    2,
    'uid=atorres,ou=users,dc=citectran,dc=com',
    'atorres',
    'ana.torres@citectran.com',
    'Ana María Torres Villanueva',
    true,
    '2024-12-17 07:45:10-05',
    '2024-01-15 09:30:00-05',
    '2024-12-17 07:45:10-05'
),

-- Usuario 3: Despachador
(
    3,
    'uid=lgarcia,ou=users,dc=citectran,dc=com',
    'lgarcia',
    'luis.garcia@citectran.com',
    'Luis Fernando García Ramos',
    true,
    '2024-12-17 06:00:05-05',
    '2024-02-01 10:00:00-05',
    '2024-12-17 06:00:05-05'
),

-- Usuario 4: Cajero Principal
(
    4,
    'uid=rvalverde,ou=users,dc=citectran,dc=com',
    'rvalverde',
    'rosa.valverde@citectran.com',
    'Rosa Elena Valverde Castillo',
    true,
    '2024-12-17 08:30:00-05',
    '2024-02-10 11:00:00-05',
    '2024-12-17 08:30:00-05'
),

-- Usuario 5: Conductor
(
    5,
    'uid=psanchez,ou=drivers,dc=citectran,dc=com',
    'psanchez',
    'pedro.sanchez@citectran.com',
    'Pedro José Sánchez López',
    true,
    '2024-12-17 05:45:00-05',
    '2024-03-01 14:00:00-05',
    '2024-12-17 05:45:00-05'
),

-- Usuario 6: Monitoreador GPS
(
    6,
    'uid=mrios,ou=users,dc=citectran,dc=com',
    'mrios',
    'miguel.rios@citectran.com',
    'Miguel Ángel Ríos Fernández',
    true,
    '2024-12-17 06:15:30-05',
    '2024-02-15 09:00:00-05',
    '2024-12-17 06:15:30-05'
);

-- ============================================================================
-- TABLA 2: user_company_access
-- Define acceso de usuarios a empresas
-- ============================================================================

INSERT INTO identity.user_company_access (
    user_company_access_id,
    user_id,
    company_id,
    granted_at,
    granted_by,
    is_active,
    created_at,
    updated_at
) VALUES
-- Acceso Usuario 1 (Gerente) a Empresa CITEC TRAN
(
    1,
    1,
    1,
    '2024-01-15 09:00:00-05',
    NULL, -- Auto-asignado en creación
    true,
    '2024-01-15 09:00:00-05',
    '2024-01-15 09:00:00-05'
),

-- Acceso Usuario 2 (Gerente Ops) a Empresa CITEC TRAN
(
    2,
    2,
    1,
    '2024-01-15 09:30:00-05',
    1, -- Otorgado por Gerente General
    true,
    '2024-01-15 09:30:00-05',
    '2024-01-15 09:30:00-05'
),

-- Acceso Usuario 3 (Despachador) a Empresa CITEC TRAN
(
    3,
    3,
    1,
    '2024-02-01 10:00:00-05',
    2, -- Otorgado por Gerente Operaciones
    true,
    '2024-02-01 10:00:00-05',
    '2024-02-01 10:00:00-05'
),

-- Acceso Usuario 4 (Cajero) a Empresa CITEC TRAN
(
    4,
    4,
    1,
    '2024-02-10 11:00:00-05',
    1, -- Otorgado por Gerente General
    true,
    '2024-02-10 11:00:00-05',
    '2024-02-10 11:00:00-05'
),

-- Acceso Usuario 5 (Conductor) a Empresa CITEC TRAN
(
    5,
    5,
    1,
    '2024-03-01 14:00:00-05',
    2, -- Otorgado por Gerente Operaciones
    true,
    '2024-03-01 14:00:00-05',
    '2024-03-01 14:00:00-05'
),

-- Acceso Usuario 6 (Monitoreador) a Empresa CITEC TRAN
(
    6,
    6,
    1,
    '2024-02-15 09:00:00-05',
    2, -- Otorgado por Gerente Operaciones
    true,
    '2024-02-15 09:00:00-05',
    '2024-02-15 09:00:00-05'
);

-- ============================================================================
-- TABLA 3: user_session
-- Registro de sesiones activas
-- ============================================================================

INSERT INTO identity.user_session (
    session_id,
    user_id,
    token_jti,
    ip_address,
    user_agent,
    login_at,
    last_activity_at,
    logout_at,
    is_active,
    created_at
) VALUES
-- Sesión activa: Gerente General
(
    1,
    1,
    'jwt-cmendoza-20241217-081523-a7b3c9d2',
    '192.168.1.105',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0',
    '2024-12-17 08:15:23-05',
    '2024-12-17 09:30:45-05',
    NULL,
    true,
    '2024-12-17 08:15:23-05'
),

-- Sesión activa: Despachador (desde terminal)
(
    2,
    3,
    'jwt-lgarcia-20241217-060005-f4e8d1a6',
    '192.168.1.210',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120.0.0.0',
    '2024-12-17 06:00:05-05',
    '2024-12-17 09:28:12-05',
    NULL,
    true,
    '2024-12-17 06:00:05-05'
),

-- Sesión activa: Cajero Principal
(
    3,
    4,
    'jwt-rvalverde-20241217-083000-c9b2e7f3',
    '192.168.1.155',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0',
    '2024-12-17 08:30:00-05',
    '2024-12-17 09:25:30-05',
    NULL,
    true,
    '2024-12-17 08:30:00-05'
),

-- Sesión cerrada: Conductor (turno anterior)
(
    4,
    5,
    'jwt-psanchez-20241216-054500-d3a1f8e9',
    '192.168.1.220',
    'Mozilla/5.0 (Android 13; Mobile) AppleWebKit/537.36 Chrome/120.0.0.0',
    '2024-12-16 05:45:00-05',
    '2024-12-16 14:30:00-05',
    '2024-12-16 14:30:15-05',
    false,
    '2024-12-16 05:45:00-05'
),

-- Sesión activa: Monitoreador GPS
(
    5,
    6,
    'jwt-mrios-20241217-061530-b8c4e2d7',
    '192.168.1.175',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120.0.0.0',
    '2024-12-17 06:15:30-05',
    '2024-12-17 09:29:50-05',
    NULL,
    true,
    '2024-12-17 06:15:30-05'
);

-- ============================================================================
-- TABLA 4: permission
-- Catálogo de permisos del sistema
-- ============================================================================

INSERT INTO identity.permission (
    permission_id,
    module,
    resource,
    action,
    code,
    description,
    is_active,
    created_at
) VALUES
-- MÓDULO: OPERATIONS
(
    1,
    'operations',
    'dispatch',
    'create',
    'operations.dispatch.create',
    'Crear y autorizar despachos de unidades',
    true,
    '2024-01-10 10:00:00-05'
),
(
    2,
    'operations',
    'dispatch',
    'read',
    'operations.dispatch.read',
    'Visualizar información de despachos',
    true,
    '2024-01-10 10:00:00-05'
),
(
    3,
    'operations',
    'dispatch',
    'update',
    'operations.dispatch.update',
    'Modificar despachos existentes',
    true,
    '2024-01-10 10:00:00-05'
),
(
    4,
    'operations',
    'dispatch',
    'delete',
    'operations.dispatch.delete',
    'Anular despachos',
    true,
    '2024-01-10 10:00:00-05'
),
(
    5,
    'operations',
    'dispatch',
    'approve',
    'operations.dispatch.approve',
    'Aprobar excepciones de despacho',
    true,
    '2024-01-10 10:00:00-05'
),

-- MÓDULO: FINANCE
(
    6,
    'finance',
    'settlement',
    'create',
    'finance.settlement.create',
    'Crear liquidaciones de conductores',
    true,
    '2024-01-10 10:00:00-05'
),
(
    7,
    'finance',
    'settlement',
    'read',
    'finance.settlement.read',
    'Consultar liquidaciones',
    true,
    '2024-01-10 10:00:00-05'
),
(
    8,
    'finance',
    'settlement',
    'approve',
    'finance.settlement.approve',
    'Aprobar liquidaciones de conductores',
    true,
    '2024-01-10 10:00:00-05'
),
(
    9,
    'finance',
    'cash_collection',
    'create',
    'finance.cash_collection.create',
    'Registrar recaudación de efectivo',
    true,
    '2024-01-10 10:00:00-05'
),
(
    10,
    'finance',
    'cash_collection',
    'approve',
    'finance.cash_collection.approve',
    'Aprobar recaudación',
    true,
    '2024-01-10 10:00:00-05'
),

-- MÓDULO: HR
(
    11,
    'hr',
    'driver',
    'create',
    'hr.driver.create',
    'Registrar nuevos conductores',
    true,
    '2024-01-10 10:00:00-05'
),
(
    12,
    'hr',
    'driver',
    'read',
    'hr.driver.read',
    'Consultar información de conductores',
    true,
    '2024-01-10 10:00:00-05'
),
(
    13,
    'hr',
    'driver',
    'update',
    'hr.driver.update',
    'Actualizar datos de conductores',
    true,
    '2024-01-10 10:00:00-05'
),

-- MÓDULO: FLEET
(
    14,
    'fleet',
    'vehicle',
    'create',
    'fleet.vehicle.create',
    'Registrar nuevos vehículos',
    true,
    '2024-01-10 10:00:00-05'
),
(
    15,
    'fleet',
    'vehicle',
    'read',
    'fleet.vehicle.read',
    'Consultar información de vehículos',
    true,
    '2024-01-10 10:00:00-05'
),
(
    16,
    'fleet',
    'vehicle',
    'update',
    'fleet.vehicle.update',
    'Actualizar información de vehículos',
    true,
    '2024-01-10 10:00:00-05'
),

-- MÓDULO: MONITORING
(
    17,
    'operations',
    'gps_tracking',
    'read',
    'operations.gps_tracking.read',
    'Monitorear ubicación GPS de unidades',
    true,
    '2024-01-10 10:00:00-05'
),
(
    18,
    'operations',
    'trip',
    'read',
    'operations.trip.read',
    'Consultar viajes en curso',
    true,
    '2024-01-10 10:00:00-05'
),

-- MÓDULO: ADMIN
(
    19,
    'admin',
    'system',
    'configure',
    'admin.system.configure',
    'Configurar parámetros del sistema',
    true,
    '2024-01-10 10:00:00-05'
),
(
    20,
    'admin',
    'user',
    'manage',
    'admin.user.manage',
    'Administrar usuarios y permisos',
    true,
    '2024-01-10 10:00:00-05'
);

-- ============================================================================
-- TABLA 5: user_permission
-- Asignación de permisos a usuarios
-- ============================================================================

INSERT INTO identity.user_permission (
    user_permission_id,
    user_id,
    company_id,
    permission_id,
    granted_at,
    granted_by,
    expires_at,
    is_active,
    created_at
) VALUES
-- PERMISOS GERENTE GENERAL (Usuario 1) - Todos los permisos
(1, 1, 1, 1, '2024-01-15 09:00:00-05', NULL, NULL, true, '2024-01-15 09:00:00-05'),
(2, 1, 1, 2, '2024-01-15 09:00:00-05', NULL, NULL, true, '2024-01-15 09:00:00-05'),
(3, 1, 1, 5, '2024-01-15 09:00:00-05', NULL, NULL, true, '2024-01-15 09:00:00-05'),
(4, 1, 1, 8, '2024-01-15 09:00:00-05', NULL, NULL, true, '2024-01-15 09:00:00-05'),
(5, 1, 1, 10, '2024-01-15 09:00:00-05', NULL, NULL, true, '2024-01-15 09:00:00-05'),
(6, 1, 1, 19, '2024-01-15 09:00:00-05', NULL, NULL, true, '2024-01-15 09:00:00-05'),
(7, 1, 1, 20, '2024-01-15 09:00:00-05', NULL, NULL, true, '2024-01-15 09:00:00-05'),

-- PERMISOS GERENTE OPERACIONES (Usuario 2)
(8, 2, 1, 1, '2024-01-15 09:30:00-05', 1, NULL, true, '2024-01-15 09:30:00-05'),
(9, 2, 1, 2, '2024-01-15 09:30:00-05', 1, NULL, true, '2024-01-15 09:30:00-05'),
(10, 2, 1, 3, '2024-01-15 09:30:00-05', 1, NULL, true, '2024-01-15 09:30:00-05'),
(11, 2, 1, 4, '2024-01-15 09:30:00-05', 1, NULL, true, '2024-01-15 09:30:00-05'),
(12, 2, 1, 5, '2024-01-15 09:30:00-05', 1, NULL, true, '2024-01-15 09:30:00-05'),
(13, 2, 1, 17, '2024-01-15 09:30:00-05', 1, NULL, true, '2024-01-15 09:30:00-05'),
(14, 2, 1, 18, '2024-01-15 09:30:00-05', 1, NULL, true, '2024-01-15 09:30:00-05'),

-- PERMISOS DESPACHADOR (Usuario 3)
(15, 3, 1, 1, '2024-02-01 10:00:00-05', 2, NULL, true, '2024-02-01 10:00:00-05'),
(16, 3, 1, 2, '2024-02-01 10:00:00-05', 2, NULL, true, '2024-02-01 10:00:00-05'),
(17, 3, 1, 3, '2024-02-01 10:00:00-05', 2, NULL, true, '2024-02-01 10:00:00-05'),
(18, 3, 1, 18, '2024-02-01 10:00:00-05', 2, NULL, true, '2024-02-01 10:00:00-05'),

-- PERMISOS CAJERO PRINCIPAL (Usuario 4)
(19, 4, 1, 6, '2024-02-10 11:00:00-05', 1, NULL, true, '2024-02-10 11:00:00-05'),
(20, 4, 1, 7, '2024-02-10 11:00:00-05', 1, NULL, true, '2024-02-10 11:00:00-05'),
(21, 4, 1, 8, '2024-02-10 11:00:00-05', 1, NULL, true, '2024-02-10 11:00:00-05'),
(22, 4, 1, 9, '2024-02-10 11:00:00-05', 1, NULL, true, '2024-02-10 11:00:00-05'),
(23, 4, 1, 10, '2024-02-10 11:00:00-05', 1, NULL, true, '2024-02-10 11:00:00-05'),

-- PERMISOS CONDUCTOR (Usuario 5) - Solo lectura
(24, 5, 1, 2, '2024-03-01 14:00:00-05', 2, NULL, true, '2024-03-01 14:00:00-05'),
(25, 5, 1, 7, '2024-03-01 14:00:00-05', 2, NULL, true, '2024-03-01 14:00:00-05'),
(26, 5, 1, 18, '2024-03-01 14:00:00-05', 2, NULL, true, '2024-03-01 14:00:00-05'),

-- PERMISOS MONITOREADOR GPS (Usuario 6)
(27, 6, 1, 2, '2024-02-15 09:00:00-05', 2, NULL, true, '2024-02-15 09:00:00-05'),
(28, 6, 1, 17, '2024-02-15 09:00:00-05', 2, NULL, true, '2024-02-15 09:00:00-05'),
(29, 6, 1, 18, '2024-02-15 09:00:00-05', 2, NULL, true, '2024-02-15 09:00:00-05');

-- ============================================================================
-- TABLA 6: permission_template
-- Plantillas reutilizables de permisos
-- ============================================================================

INSERT INTO identity.permission_template (
    template_id,
    name,
    description,
    is_active,
    created_by,
    created_at,
    updated_at
) VALUES
-- Template 1: Despachador Estándar
(
    1,
    'Despachador Estándar',
    'Permisos básicos para despachadores: crear/modificar despachos, consultar viajes',
    true,
    1,
    '2024-01-12 10:00:00-05',
    '2024-01-12 10:00:00-05'
),

-- Template 2: Cajero Completo
(
    2,
    'Cajero Completo',
    'Permisos completos para cajeros: liquidaciones, recaudación, aprobaciones',
    true,
    1,
    '2024-01-12 10:15:00-05',
    '2024-01-12 10:15:00-05'
),

-- Template 3: Supervisor Operaciones
(
    3,
    'Supervisor Operaciones',
    'Permisos de supervisión: aprobar excepciones, monitoreo GPS, gestión despachos',
    true,
    1,
    '2024-01-12 10:30:00-05',
    '2024-01-12 10:30:00-05'
);

-- ============================================================================
-- TABLA 7: permission_template_detail
-- Detalle de permisos en cada plantilla
-- ============================================================================

INSERT INTO identity.permission_template_detail (
    template_detail_id,
    template_id,
    permission_id,
    created_at
) VALUES
-- TEMPLATE 1: Despachador Estándar
(1, 1, 1, '2024-01-12 10:00:00-05'),  -- dispatch.create
(2, 1, 2, '2024-01-12 10:00:00-05'),  -- dispatch.read
(3, 1, 3, '2024-01-12 10:00:00-05'),  -- dispatch.update
(4, 1, 18, '2024-01-12 10:00:00-05'), -- trip.read

-- TEMPLATE 2: Cajero Completo
(5, 2, 6, '2024-01-12 10:15:00-05'),  -- settlement.create
(6, 2, 7, '2024-01-12 10:15:00-05'),  -- settlement.read
(7, 2, 8, '2024-01-12 10:15:00-05'),  -- settlement.approve
(8, 2, 9, '2024-01-12 10:15:00-05'),  -- cash_collection.create
(9, 2, 10, '2024-01-12 10:15:00-05'), -- cash_collection.approve

-- TEMPLATE 3: Supervisor Operaciones
(10, 3, 1, '2024-01-12 10:30:00-05'),  -- dispatch.create
(11, 3, 2, '2024-01-12 10:30:00-05'),  -- dispatch.read
(12, 3, 3, '2024-01-12 10:30:00-05'),  -- dispatch.update
(13, 3, 4, '2024-01-12 10:30:00-05'),  -- dispatch.delete
(14, 3, 5, '2024-01-12 10:30:00-05'),  -- dispatch.approve
(15, 3, 17, '2024-01-12 10:30:00-05'), -- gps_tracking.read
(16, 3, 18, '2024-01-12 10:30:00-05'); -- trip.read

-- ============================================================================
-- TABLA 8: activity_log
-- Auditoría completa de acciones de usuarios
-- ============================================================================

INSERT INTO identity.activity_log (
    log_id,
    user_id,
    action,
    resource_type,
    resource_id,
    ip_address,
    user_agent,
    changes,
    status,
    error_message,
    created_at
) VALUES
-- Log 1: Despachador autoriza salida
(
    1,
    3,
    'DESPACHO_AUTORIZADO',
    'dispatch',
    1523,
    '192.168.1.210',
    'Mozilla/5.0 (X11; Linux x86_64) Chrome/120.0.0.0',
    '{"dispatch_id": 1523, "unit": "A-101", "driver": "Pedro Sánchez", "route": "RUTA-05", "scheduled_time": "2024-12-17 06:30:00", "actual_time": "2024-12-17 06:32:15"}'::jsonb,
    'SUCCESS',
    NULL,
    '2024-12-17 06:32:15-05'
),

-- Log 2: Cajero aprueba liquidación
(
    2,
    4,
    'LIQUIDACION_APROBADA',
    'settlement',
    892,
    '192.168.1.155',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0',
    '{"settlement_id": 892, "driver_id": 45, "amount": 1850.50, "approved_by": "Rosa Valverde", "approval_time": "2024-12-17 09:15:30"}'::jsonb,
    'SUCCESS',
    NULL,
    '2024-12-17 09:15:30-05'
),

-- Log 3: Gerente modifica permiso
(
    3,
    1,
    'PERMISO_MODIFICADO',
    'user_permission',
    15,
    '192.168.1.105',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0',
    '{"permission_id": 15, "user_id": 3, "old_permission": "dispatch.read", "new_permission": "dispatch.create", "modified_by": "Carlos Mendoza"}'::jsonb,
    'SUCCESS',
    NULL,
    '2024-12-17 08:45:22-05'
),

-- Log 4: Intento fallido de acceso
(
    4,
    5,
    'ACCESO_DENEGADO',
    'dispatch',
    NULL,
    '192.168.1.220',
    'Mozilla/5.0 (Android 13; Mobile) Chrome/120.0.0.0',
    '{"attempted_action": "dispatch.approve", "user": "Pedro Sánchez", "reason": "insufficient_permissions"}'::jsonb,
    'FAILED',
    'Usuario no tiene permiso para aprobar despachos',
    '2024-12-17 07:15:45-05'
);

-- ============================================================================
-- TABLA 9: login_attempt
-- Registro de intentos de autenticación
-- ============================================================================

INSERT INTO identity.login_attempt (
    login_attempt_id,
    username,
    email,
    ip_address,
    user_agent,
    attempt_time,
    success,
    failure_reason,
    user_id,
    created_at
) VALUES
-- Intento exitoso: Gerente General
(
    1,
    'cmendoza',
    'carlos.mendoza@citectran.com',
    '192.168.1.105',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0',
    '2024-12-17 08:15:23-05',
    true,
    NULL,
    1,
    '2024-12-17 08:15:23-05'
),

-- Intento exitoso: Despachador
(
    2,
    'lgarcia',
    'luis.garcia@citectran.com',
    '192.168.1.210',
    'Mozilla/5.0 (X11; Linux x86_64) Chrome/120.0.0.0',
    '2024-12-17 06:00:05-05',
    true,
    NULL,
    3,
    '2024-12-17 06:00:05-05'
),

-- Intento fallido: Contraseña incorrecta
(
    3,
    'mrios',
    'miguel.rios@citectran.com',
    '192.168.1.175',
    'Mozilla/5.0 (X11; Linux x86_64) Chrome/120.0.0.0',
    '2024-12-17 06:14:30-05',
    false,
    'INVALID_PASSWORD',
    NULL,
    '2024-12-17 06:14:30-05'
),

-- Intento exitoso tras corrección: Monitoreador
(
    4,
    'mrios',
    'miguel.rios@citectran.com',
    '192.168.1.175',
    'Mozilla/5.0 (X11; Linux x86_64) Chrome/120.0.0.0',
    '2024-12-17 06:15:30-05',
    true,
    NULL,
    6,
    '2024-12-17 06:15:30-05'
),

-- Intento fallido: Usuario inexistente
(
    5,
    'jhacker',
    'hacker@malicious.com',
    '203.45.67.89',
    'curl/7.68.0',
    '2024-12-17 03:22:15-05',
    false,
    'USER_NOT_FOUND',
    NULL,
    '2024-12-17 03:22:15-05'
),

-- Intento exitoso: Cajero Principal
(
    6,
    'rvalverde',
    'rosa.valverde@citectran.com',
    '192.168.1.155',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0',
    '2024-12-17 08:30:00-05',
    true,
    NULL,
    4,
    '2024-12-17 08:30:00-05'
);

-- ============================================================================
-- FIN DE REGISTROS DE EJEMPLO - SCHEMA: identity
-- Total de registros insertados:
-- - user: 6 registros
-- - user_company_access: 6 registros
-- - user_session: 5 registros
-- - permission: 20 registros
-- - user_permission: 29 registros
-- - permission_template: 3 registros
-- - permission_template_detail: 16 registros
-- - activity_log: 4 registros
-- - login_attempt: 6 registros
-- ============================================================================