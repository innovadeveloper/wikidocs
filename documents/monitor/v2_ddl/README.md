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

---

-- ============================================================================
-- REGISTROS DE EJEMPLO - SCHEMA: shared
-- Sistema de Gestión de Transporte - CITEC TRAN S.A.
-- Fecha: 17 Diciembre 2024
-- ============================================================================

-- ============================================================================
-- TABLA 1: company
-- Empresa operadora de transporte
-- ============================================================================

INSERT INTO shared.company (
    company_id,
    tax_id,
    legal_name,
    trade_name,
    address,
    phone,
    email,
    logo_url,
    is_active,
    created_at,
    updated_at
) VALUES
(
    1,
    '20123456789',
    'CONSORCIO DE TRANSPORTES INTEGRADO TRAN S.A.C.',
    'CITEC TRAN',
    'Av. Los Incas 1250, San Juan de Lurigancho, Lima',
    '+51 1 458-7890',
    'contacto@citectran.com',
    'https://storage.citectran.com/logos/citec_logo_2024.png',
    true,
    '2020-03-15 10:00:00-05',
    '2024-12-17 08:00:00-05'
);

-- ============================================================================
-- TABLA 2: authority
-- Autoridades reguladoras del transporte
-- ============================================================================

INSERT INTO shared.authority (
    authority_id,
    name,
    acronym,
    jurisdiction,
    contact_email,
    contact_phone,
    is_active,
    created_at
) VALUES
(
    1,
    'Autoridad de Transporte Urbano para Lima y Callao',
    'ATU',
    'Lima Metropolitana y Callao',
    'consultas@atu.gob.pe',
    '+51 1 615-6666',
    true,
    '2019-01-10 09:00:00-05'
),
(
    2,
    'Municipalidad Metropolitana de Lima',
    'MML',
    'Lima Metropolitana',
    'transportes@munlima.gob.pe',
    '+51 1 315-1515',
    true,
    '2019-01-10 09:00:00-05'
);

-- ============================================================================
-- TABLA 3: concession
-- Concesión otorgada por autoridad reguladora
-- ============================================================================

INSERT INTO shared.concession (
    concession_id,
    authority_id,
    concession_code,
    concession_name,
    grant_date,
    expiry_date,
    status,
    terms_document_url,
    created_at,
    updated_at
) VALUES
(
    1,
    1,
    'ATU-CONC-2021-047',
    'Concesión Corredor Azul - Zona Este',
    '2021-06-15',
    '2031-06-14',
    'ACTIVE',
    'https://storage.atu.gob.pe/concesiones/2021/047_terminos.pdf',
    '2021-06-15 10:30:00-05',
    '2024-12-17 08:00:00-05'
);

-- ============================================================================
-- TABLA 4: concessionaire
-- Concesionario titular de la concesión
-- ============================================================================

INSERT INTO shared.concessionaire (
    concessionaire_id,
    tax_id,
    legal_name,
    concession_id,
    is_active,
    created_at,
    updated_at
) VALUES
(
    1,
    '20123456789',
    'CONSORCIO DE TRANSPORTES INTEGRADO TRAN S.A.C.',
    1,
    true,
    '2021-06-15 11:00:00-05',
    '2024-12-17 08:00:00-05'
);

-- ============================================================================
-- TABLA 5: terminal
-- Terminales operativos por ruta
-- ============================================================================

INSERT INTO shared.terminal (
    terminal_id,
    route_id,
    company_id,
    name,
    code,
    side_code,
    latitude,
    longitude,
    geofence_radius_meters,
    address,
    has_infrastructure,
    is_active,
    created_at,
    updated_at
) VALUES
-- Terminal Lado A - Ruta 05
(
    1,
    1,
    1,
    'Terminal Canto Grande',
    'TCG-A',
    'A',
    -11.9847523,
    -76.9736845,
    150,
    'Av. Wiese 1450, San Juan de Lurigancho',
    true,
    true,
    '2021-07-01 09:00:00-05',
    '2024-12-17 08:00:00-05'
),
-- Terminal Lado B - Ruta 05
(
    2,
    1,
    1,
    'Terminal Plaza de Armas',
    'TPA-B',
    'B',
    -12.0464080,
    -77.0427930,
    120,
    'Jr. Carabaya s/n, Cercado de Lima',
    false,
    true,
    '2021-07-01 09:00:00-05',
    '2024-12-17 08:00:00-05'
);

-- ============================================================================
-- TABLA 6: catalog
-- Catálogo genérico tipo clave-valor
-- ============================================================================

INSERT INTO shared.catalog (
    catalog_id,
    category,
    code,
    name,
    description,
    display_order,
    is_active,
    created_at
) VALUES
-- Estados de Vehículos
(1, 'vehicle_status', 'OPERATIONAL', 'Operativo', 'Vehículo en servicio activo', 1, true, '2024-01-10 10:00:00-05'),
(2, 'vehicle_status', 'MAINTENANCE', 'Mantenimiento', 'Vehículo en taller', 2, true, '2024-01-10 10:00:00-05'),
(3, 'vehicle_status', 'OUT_OF_SERVICE', 'Fuera de Servicio', 'Vehículo no disponible', 3, true, '2024-01-10 10:00:00-05'),
(4, 'vehicle_status', 'RETIRED', 'Retirado', 'Vehículo dado de baja', 4, true, '2024-01-10 10:00:00-05'),

-- Estados de Viajes
(5, 'trip_status', 'SCHEDULED', 'Programado', 'Viaje aún no iniciado', 1, true, '2024-01-10 10:00:00-05'),
(6, 'trip_status', 'IN_PROGRESS', 'En Curso', 'Viaje en ejecución', 2, true, '2024-01-10 10:00:00-05'),
(7, 'trip_status', 'COMPLETED', 'Completado', 'Viaje finalizado exitosamente', 3, true, '2024-01-10 10:00:00-05'),
(8, 'trip_status', 'CANCELLED', 'Cancelado', 'Viaje anulado', 4, true, '2024-01-10 10:00:00-05'),

-- Tipos de Incidentes
(9, 'incident_type', 'ACCIDENT', 'Accidente', 'Colisión o siniestro vial', 1, true, '2024-01-10 10:00:00-05'),
(10, 'incident_type', 'BREAKDOWN', 'Avería', 'Falla mecánica', 2, true, '2024-01-10 10:00:00-05'),
(11, 'incident_type', 'TRAFFIC', 'Tráfico', 'Congestión vehicular', 3, true, '2024-01-10 10:00:00-05'),
(12, 'incident_type', 'PASSENGER_COMPLAINT', 'Queja Pasajero', 'Reclamo de usuario', 4, true, '2024-01-10 10:00:00-05'),

-- Severidad de Incidentes
(13, 'incident_severity', 'LOW', 'Baja', 'Impacto menor', 1, true, '2024-01-10 10:00:00-05'),
(14, 'incident_severity', 'MEDIUM', 'Media', 'Requiere atención', 2, true, '2024-01-10 10:00:00-05'),
(15, 'incident_severity', 'HIGH', 'Alta', 'Impacto significativo', 3, true, '2024-01-10 10:00:00-05'),
(16, 'incident_severity', 'CRITICAL', 'Crítica', 'Requiere acción inmediata', 4, true, '2024-01-10 10:00:00-05'),

-- Tipos de Día
(17, 'day_type', 'WEEKDAY', 'Día Laboral', 'Lunes a Viernes', 1, true, '2024-01-10 10:00:00-05'),
(18, 'day_type', 'SATURDAY', 'Sábado', 'Sábado', 2, true, '2024-01-10 10:00:00-05'),
(19, 'day_type', 'SUNDAY', 'Domingo', 'Domingo', 3, true, '2024-01-10 10:00:00-05'),
(20, 'day_type', 'HOLIDAY', 'Feriado', 'Día festivo', 4, true, '2024-01-10 10:00:00-05');

-- ============================================================================
-- TABLA 7: document_type
-- Tipos de documentos obligatorios para conductores
-- ============================================================================

INSERT INTO shared.document_type (
    document_type_id,
    code,
    name,
    description,
    is_mandatory,
    requires_expiry,
    alert_days_before,
    restriction_type,
    is_active,
    created_at
) VALUES
(
    1,
    'LICENSE_A2B',
    'Licencia de Conducir A2B',
    'Licencia categoría A-IIB o superior para transporte público',
    true,
    true,
    30,
    'CRITICAL',
    true,
    '2024-01-10 10:00:00-05'
),
(
    2,
    'DNI',
    'Documento Nacional de Identidad',
    'DNI vigente del conductor',
    true,
    true,
    90,
    'CRITICAL',
    true,
    '2024-01-10 10:00:00-05'
),
(
    3,
    'CRIMINAL_RECORD',
    'Certificado de Antecedentes Penales',
    'Antecedentes penales, judiciales y policiales',
    true,
    true,
    60,
    'CRITICAL',
    true,
    '2024-01-10 10:00:00-05'
),
(
    4,
    'MEDICAL_EXAM',
    'Examen Médico Ocupacional',
    'Evaluación médica para aptitud laboral',
    true,
    true,
    30,
    'CRITICAL',
    true,
    '2024-01-10 10:00:00-05'
),
(
    5,
    'PSYCHOTECHNICAL',
    'Examen Psicotécnico',
    'Evaluación psicológica para conductores',
    true,
    true,
    30,
    'CRITICAL',
    true,
    '2024-01-10 10:00:00-05'
),
(
    6,
    'TRAINING_CERT',
    'Certificado de Capacitación',
    'Curso de capacitación normativa vigente',
    true,
    true,
    60,
    'WARNING',
    true,
    '2024-01-10 10:00:00-05'
),
(
    7,
    'TRANSIT_EDUCATION',
    'Educación Vial',
    'Certificado conocimientos de tránsito',
    true,
    true,
    90,
    'WARNING',
    true,
    '2024-01-10 10:00:00-05'
);

-- ============================================================================
-- TABLA 8: configuration
-- Parámetros globales del sistema
-- ============================================================================

INSERT INTO shared.configuration (
    config_id,
    config_key,
    config_value,
    data_type,
    category,
    description,
    is_editable,
    updated_by,
    updated_at
) VALUES
(
    1,
    'dispatch.max_queue_time_minutes',
    '45',
    'INTEGER',
    'OPERATIONS',
    'Tiempo máximo de espera en cola de despacho',
    true,
    1,
    '2024-01-15 10:00:00-05'
),
(
    2,
    'driver.min_license_points',
    '75',
    'INTEGER',
    'OPERATIONS',
    'Puntos mínimos de licencia permitidos para despacho',
    true,
    1,
    '2024-01-15 10:00:00-05'
),
(
    3,
    'gps.tracking_interval_seconds',
    '30',
    'INTEGER',
    'SYSTEM',
    'Intervalo de actualización GPS',
    false,
    1,
    '2024-01-15 10:00:00-05'
),
(
    4,
    'finance.settlement_approval_required',
    'true',
    'BOOLEAN',
    'FINANCE',
    'Requiere aprobación supervisor para liquidaciones',
    true,
    1,
    '2024-01-15 10:00:00-05'
),
(
    5,
    'operations.geofence_terminal_radius_meters',
    '150',
    'INTEGER',
    'OPERATIONS',
    'Radio de geocerca predeterminado para terminales',
    true,
    1,
    '2024-01-15 10:00:00-05'
),
(
    6,
    'operations.max_off_route_minutes',
    '40',
    'INTEGER',
    'OPERATIONS',
    'Tiempo máximo permitido fuera de recorrido',
    true,
    1,
    '2024-01-15 10:00:00-05'
),
(
    7,
    'finance.ticket_stock_threshold_multiplier',
    '1.3',
    'STRING',
    'FINANCE',
    'Multiplicador para stock mínimo de boletos',
    true,
    1,
    '2024-01-15 10:00:00-05'
),
(
    8,
    'system.session_timeout_minutes',
    '480',
    'INTEGER',
    'SYSTEM',
    'Tiempo de inactividad antes de cerrar sesión',
    false,
    1,
    '2024-01-15 10:00:00-05'
),
(
    9,
    'operations.frequency_tolerance_minutes',
    '5',
    'INTEGER',
    'OPERATIONS',
    'Tolerancia en frecuencias programadas',
    true,
    2,
    '2024-02-10 11:00:00-05'
),
(
    10,
    'system.maintenance_mode',
    'false',
    'BOOLEAN',
    'SYSTEM',
    'Activa modo mantenimiento del sistema',
    true,
    1,
    '2024-01-15 10:00:00-05'
);

-- ============================================================================
-- TABLA 9: notification_template
-- Plantillas de notificaciones
-- ============================================================================

INSERT INTO shared.notification_template (
    template_id,
    code,
    name,
    channel,
    subject,
    body_template,
    variables,
    is_active,
    created_at,
    updated_at
) VALUES
(
    1,
    'DOCUMENT_EXPIRING',
    'Documento Próximo a Vencer',
    'EMAIL',
    'Alerta: Documento {{document_type}} próximo a vencer',
    'Estimado {{driver_name}},

Su {{document_type}} vencerá el {{expiry_date}}. Por favor, renuévelo antes de esta fecha para evitar restricciones operativas.

Días restantes: {{days_remaining}}
Fecha límite: {{expiry_date}}

Saludos,
Sistema CITEC TRAN',
    '{"driver_name": "string", "document_type": "string", "expiry_date": "date", "days_remaining": "integer"}'::jsonb,
    true,
    '2024-01-12 10:00:00-05',
    '2024-01-12 10:00:00-05'
),
(
    2,
    'DISPATCH_AUTHORIZED',
    'Despacho Autorizado',
    'SMS',
    NULL,
    'Conductor {{driver_name}}: Despacho autorizado. Unidad {{vehicle_code}}, Ruta {{route_code}}, Hora: {{departure_time}}. Buen viaje.',
    '{"driver_name": "string", "vehicle_code": "string", "route_code": "string", "departure_time": "time"}'::jsonb,
    true,
    '2024-01-12 10:15:00-05',
    '2024-01-12 10:15:00-05'
),
(
    3,
    'SETTLEMENT_PENDING',
    'Liquidación Pendiente',
    'IN_APP',
    NULL,
    'Tiene una liquidación pendiente de aprobación. Monto: S/ {{amount}}. ID: {{settlement_id}}',
    '{"amount": "decimal", "settlement_id": "integer"}'::jsonb,
    true,
    '2024-01-12 10:30:00-05',
    '2024-01-12 10:30:00-05'
),
(
    4,
    'INCIDENT_REPORTED',
    'Incidente Reportado',
    'EMAIL',
    'Nuevo Incidente: {{incident_type}}',
    'Se ha reportado un incidente:

Tipo: {{incident_type}}
Severidad: {{severity}}
Unidad: {{vehicle_code}}
Conductor: {{driver_name}}
Ubicación: {{location}}
Hora: {{incident_time}}

Descripción: {{description}}

Por favor, tome las acciones necesarias.

Sistema CITEC TRAN',
    '{"incident_type": "string", "severity": "string", "vehicle_code": "string", "driver_name": "string", "location": "string", "incident_time": "timestamp", "description": "string"}'::jsonb,
    true,
    '2024-01-12 10:45:00-05',
    '2024-01-12 10:45:00-05'
);

-- ============================================================================
-- TABLA 10: file_storage
-- Registro de archivos almacenados
-- ============================================================================

INSERT INTO shared.file_storage (
    file_id,
    file_name,
    file_path,
    file_url,
    file_size_bytes,
    mime_type,
    entity_type,
    entity_id,
    uploaded_by,
    expires_at,
    is_public,
    created_at
) VALUES
(
    1,
    'licencia_pedro_sanchez.pdf',
    'drivers/5/documents/license_2024.pdf',
    'https://storage.citectran.com/drivers/5/documents/license_2024.pdf',
    245678,
    'application/pdf',
    'driver_document',
    1,
    2,
    NULL,
    false,
    '2024-03-01 14:30:00-05'
),
(
    2,
    'logo_citec_2024.png',
    'company/logos/citec_logo_2024.png',
    'https://storage.citectran.com/logos/citec_logo_2024.png',
    89432,
    'image/png',
    'company',
    1,
    1,
    NULL,
    true,
    '2024-01-15 09:15:00-05'
),
(
    3,
    'antecedentes_pedro_sanchez.pdf',
    'drivers/5/documents/criminal_record_2024.pdf',
    'https://storage.citectran.com/drivers/5/documents/criminal_record_2024.pdf',
    156234,
    'application/pdf',
    'driver_document',
    2,
    2,
    NULL,
    false,
    '2024-03-01 14:45:00-05'
),
(
    4,
    'incidente_unidad_A101_foto1.jpg',
    'incidents/892/evidence/photo_1.jpg',
    'https://storage.citectran.com/incidents/892/evidence/photo_1.jpg',
    1245678,
    'image/jpeg',
    'incident_photo',
    892,
    3,
    NULL,
    false,
    '2024-12-16 14:25:00-05'
);

-- ============================================================================
-- FIN DE REGISTROS DE EJEMPLO - SCHEMA: shared
-- Total de registros insertados:
-- - company: 1 registro
-- - authority: 2 registros
-- - concession: 1 registro
-- - concessionaire: 1 registro
-- - terminal: 2 registros
-- - catalog: 20 registros
-- - document_type: 7 registros
-- - configuration: 10 registros
-- - notification_template: 4 registros
-- - file_storage: 4 registros
-- ============================================================================

-- ============================================================================
-- REGISTROS DE EJEMPLO - SCHEMA: core_operations
-- Sistema de Gestión de Transporte - TranCorp S.A.
-- Fecha: 17 Diciembre 2024
-- ============================================================================

-- ============================================================================
-- TABLA 1: route
-- ============================================================================

INSERT INTO core_operations.route (
    route_id,
    company_id,
    concession_id,
    code,
    name,
    route_type,
    color,
    is_bidirectional,
    total_distance_km,
    estimated_duration_minutes,
    is_active,
    created_at,
    updated_at
) VALUES
(
    1,
    1,
    1,
    'IM-05',
    'Canto Grande - Plaza de Armas',
    'LINEAR',
    '#FF6600',
    true,
    18.50,
    75,
    true,
    '2021-07-01 09:00:00-05',
    '2024-12-17 08:00:00-05'
);

-- ============================================================================
-- TABLA 2: route_polyline
-- ============================================================================

INSERT INTO core_operations.route_polyline (
    polyline_id,
    route_id,
    name,
    direction,
    coordinates_json,
    encoded_polyline,
    color,
    stroke_width,
    stroke_opacity,
    segment_distance_km,
    is_active,
    created_at,
    updated_at
) VALUES
(
    1,
    1,
    'Segmento Principal IDA',
    'IDA',
    '{"type":"LineString","coordinates":[[-76.9736845,-11.9847523],[-77.0427930,-12.0464080]]}'::jsonb,
    'r~kbB~rhhM|LhP~KdN',
    '#FF6600',
    5,
    0.80,
    18.50,
    true,
    '2021-07-01 10:00:00-05',
    '2024-12-17 08:00:00-05'
);

-- ============================================================================
-- TABLA 3: route_side
-- ============================================================================

INSERT INTO core_operations.route_side (
    route_side_id,
    route_id,
    side_code,
    terminal_id,
    direction_name,
    is_active,
    created_at
) VALUES
(1, 1, 'A', 1, 'IDA - Hacia Centro', true, '2021-07-01 10:30:00-05'),
(2, 1, 'B', 2, 'VUELTA - Hacia Periferia', true, '2021-07-01 10:30:00-05');

-- ============================================================================
-- TABLA 4: stop
-- ============================================================================

INSERT INTO core_operations.stop (
    stop_id,
    route_id,
    name,
    code,
    latitude,
    longitude,
    geofence_radius_meters,
    sequence_order,
    direction,
    stop_type,
    is_mandatory,
    is_active,
    created_at,
    updated_at
) VALUES
(1, 1, 'Terminal Canto Grande', 'PD-001', -11.9847523, -76.9736845, 100, 1, 'IDA', 'TERMINAL', true, true, '2021-07-01 11:00:00-05', '2024-12-17 08:00:00-05'),
(2, 1, 'Paradero Las Flores', 'PD-002', -12.0012345, -76.9856789, 50, 2, 'IDA', 'MAIN', false, true, '2021-07-01 11:00:00-05', '2024-12-17 08:00:00-05'),
(3, 1, 'Paradero Nicolás de Piérola', 'PD-003', -12.0234567, -77.0012345, 50, 3, 'IDA', 'INTERMEDIATE', false, true, '2021-07-01 11:00:00-05', '2024-12-17 08:00:00-05'),
(4, 1, 'Terminal Plaza de Armas', 'PD-004', -12.0464080, -77.0427930, 100, 4, 'IDA', 'TERMINAL', true, true, '2021-07-01 11:00:00-05', '2024-12-17 08:00:00-05');

-- ============================================================================
-- TABLA 5: checkpoint
-- ============================================================================

INSERT INTO core_operations.checkpoint (
    checkpoint_id,
    route_id,
    name,
    latitude,
    longitude,
    geofence_radius_meters,
    sequence_order,
    direction,
    min_time_minutes,
    max_time_minutes,
    is_critical,
    is_active,
    created_at,
    updated_at
) VALUES
(1, 1, 'Control Av. Próceres', -11.9956789, -76.9812345, 60, 1, 'IDA', 10, 20, false, true, '2021-07-10 09:00:00-05', '2024-12-17 08:00:00-05'),
(2, 1, 'Control Centro Histórico', -12.0445678, -77.0389012, 60, 2, 'IDA', 50, 75, true, true, '2021-07-10 09:00:00-05', '2024-12-17 08:00:00-05');

-- ============================================================================
-- Explicación entre stop y checkpoint
-- ============================================================================


**1. `checkpoint` vs `stop` (paraderos)**

**Diferencias clave:**

| Aspecto | `stop` (paradero) | `checkpoint` (control de paso) |
|---------|-------------------|--------------------------------|
| **Propósito** | Subir/bajar pasajeros | Validar cumplimiento de tiempo |
| **Parada obligatoria** | Sí (si hay pasajeros) | No (solo monitoreo GPS) |
| **Validación** | Presencia en geocerca | Tiempo entre checkpoints |
| **Uso operativo** | Despacho, itinerario | Detectar retrasos/adelantos |

**Ejemplo:**
```
Ruta 100: Terminal A → ... → Terminal B (45 min)

Paraderos (stops): 20 paradas donde suben/bajan pasajeros
Checkpoints: 3 puntos de control intermedios
  - Km 5: debe pasar entre min 8-12 desde salida
  - Km 15: debe pasar entre min 20-25
  - Km 30: debe pasar entre min 35-40
```

**Conclusión:** Sí se usan paraderos en despacho. Checkpoints son adicionales para control de tiempos, **no reemplazan paraderos**.

-- ============================================================================
-- TABLA 6: speed_zone
-- ============================================================================

INSERT INTO core_operations.speed_zone (
    speed_zone_id,
    route_id,
    name,
    zone_type,
    coordinates_json,
    max_speed_kmh,
    alert_threshold_kmh,
    is_active,
    created_at,
    updated_at
) VALUES
(
    1,
    1,
    'Zona Escolar I.E. San Juan',
    'SCHOOL',
    '{"type":"Polygon","coordinates":[[[-76.9756789,-11.9867890],[-76.9745678,-11.9867890],[-76.9745678,-11.9856789],[-76.9756789,-11.9856789],[-76.9756789,-11.9867890]]]}'::jsonb,
    30,
    35,
    true,
    '2021-08-01 10:00:00-05',
    '2024-12-17 08:00:00-05'
);

-- ============================================================================
-- TABLA 7: frequency_schedule
-- ============================================================================

INSERT INTO core_operations.frequency_schedule (
    frequency_schedule_id,
    route_id,
    day_type,
    time_start,
    time_end,
    target_frequency_minutes,
    min_frequency_minutes,
    max_frequency_minutes,
    required_vehicles,
    is_active,
    created_at,
    updated_at
) VALUES
(1, 1, 'WEEKDAY', '06:00:00', '09:00:00', 8, 6, 10, 15, true, '2024-01-15 10:00:00-05', '2024-12-17 08:00:00-05'),
(2, 1, 'WEEKDAY', '09:00:00', '17:00:00', 12, 10, 15, 10, true, '2024-01-15 10:00:00-05', '2024-12-17 08:00:00-05'),
(3, 1, 'WEEKDAY', '17:00:00', '21:00:00', 8, 6, 10, 15, true, '2024-01-15 10:00:00-05', '2024-12-17 08:00:00-05'),
(4, 1, 'SATURDAY', '06:00:00', '22:00:00', 15, 12, 20, 8, true, '2024-01-15 10:00:00-05', '2024-12-17 08:00:00-05');

-- ============================================================================
-- TABLA 8: restriction_type
-- ============================================================================

INSERT INTO core_operations.restriction_type (
    restriction_type_id,
    code,
    name,
    description,
    default_severity,
    blocks_dispatch,
    requires_approval,
    is_active,
    created_at
) VALUES
(1, 'DOC_EXPIRED', 'Documento Vencido', 'Licencia u otro documento obligatorio vencido', 'CRITICAL', true, true, true, '2024-01-10 10:00:00-05'),
(2, 'LOW_LICENSE_POINTS', 'Puntos de Licencia Bajos', 'Puntos de licencia por debajo del mínimo', 'CRITICAL', true, true, true, '2024-01-10 10:00:00-05'),
(3, 'MAINTENANCE_DUE', 'Mantenimiento Pendiente', 'Vehículo requiere mantenimiento programado', 'WARNING', false, false, true, '2024-01-10 10:00:00-05'),
(4, 'DEBT_PENDING', 'Deuda Pendiente', 'Conductor con deuda por liquidar', 'WARNING', false, true, true, '2024-01-10 10:00:00-05');

-- ============================================================================
-- TABLA 9: operational_restriction
-- ============================================================================

INSERT INTO core_operations.operational_restriction (
    restriction_id,
    restriction_type_id,
    company_id,
    entity_type,
    entity_id,
    severity,
    reason,
    applied_by,
    applied_at,
    expires_at,
    resolved_at,
    resolved_by,
    resolution_notes,
    is_active
) VALUES
(
    1,
    1,
    1,
    'DRIVER',
    5,
    'CRITICAL',
    'Licencia de conducir vencida desde 2024-11-30',
    2,
    '2024-12-01 08:00:00-05',
    NULL,
    '2024-12-15 14:30:00-05',
    2,
    'Licencia renovada, nueva vigencia hasta 2029-12-14',
    false
);

-- ============================================================================
-- TABLA 10: dispatch_schedule
-- ============================================================================

INSERT INTO core_operations.dispatch_schedule (
    dispatch_schedule_id,
    company_id,
    route_id,
    terminal_id,
    schedule_date,
    schedule_type,
    created_by,
    approved_by,
    status,
    created_at,
    updated_at
) VALUES
(
    1,
    1,
    1,
    1,
    '2024-12-17',
    'REGULAR',
    2,
    2,
    'ACTIVE',
    '2024-12-16 18:00:00-05',
    '2024-12-16 20:30:00-05'
);

-- ============================================================================
-- TABLA 11: dispatch_schedule_detail
-- ============================================================================

INSERT INTO core_operations.dispatch_schedule_detail (
    schedule_detail_id,
    dispatch_schedule_id,
    scheduled_time,
    sequence_number,
    vehicle_id,
    driver_id,
    side_code,
    notes,
    created_at
) VALUES
(1, 1, '06:00:00', 1, 1, 5, 'A', 'Primera salida del día', '2024-12-16 18:00:00-05'),
(2, 1, '06:08:00', 2, 2, 6, 'A', NULL, '2024-12-16 18:00:00-05'),
(3, 1, '06:16:00', 3, 3, 7, 'A', NULL, '2024-12-16 18:00:00-05'),
(4, 1, '06:24:00', 4, 4, 8, 'A', NULL, '2024-12-16 18:00:00-05');

-- ============================================================================
-- TABLA 12: dispatch_queue
-- ============================================================================

INSERT INTO core_operations.dispatch_queue (
    queue_id,
    company_id,
    terminal_id,
    route_id,
    vehicle_id,
    driver_id,
    side_code,
    entry_timestamp,
    scheduled_time,
    queue_position,
    entry_type,
    status,
    created_at,
    updated_at
) VALUES
(
    1,
    1,
    1,
    1,
    1,
    5,
    'A',
    '2024-12-17 05:45:00-05',
    '2024-12-17 06:00:00-05',
    1,
    'MANUAL',
    'DISPATCHED',
    '2024-12-17 05:45:00-05',
    '2024-12-17 06:00:30-05'
);

-- ============================================================================
-- TABLA 13: dispatch
-- ============================================================================

INSERT INTO core_operations.dispatch (
    dispatch_id,
    queue_id,
    company_id,
    schedule_detail_id,
    route_id,
    vehicle_id,
    driver_id,
    terminal_id,
    side_code,
    scheduled_time,
    actual_dispatch_time,
    dispatched_by,
    dispatch_type,
    validations_passed,
    notes,
    created_at
) VALUES
(
    1,
    1,
    1,
    1,
    1,
    1,
    5,
    1,
    'A',
    '2024-12-17 06:00:00-05',
    '2024-12-17 06:00:30-05',
    3,
    'NORMAL',
    '{"documents_valid": true, "license_points": 98, "vehicle_operational": true, "ticket_stock_sufficient": true}'::jsonb,
    NULL,
    '2024-12-17 06:00:30-05'
);

-- ============================================================================
-- TABLA 14: trip
-- ============================================================================

INSERT INTO core_operations.trip (
    trip_id,
    dispatch_id,
    company_id,
    route_id,
    vehicle_id,
    driver_id,
    start_terminal_id,
    end_terminal_id,
    start_timestamp,
    end_timestamp,
    planned_distance_km,
    actual_distance_km,
    planned_duration_minutes,
    actual_duration_minutes,
    status,
    completion_percentage,
    created_at,
    updated_at
) VALUES
(
    1,
    1,
    1,
    1,
    1,
    5,
    1,
    2,
    '2024-12-17 06:00:30-05',
    '2024-12-17 07:18:45-05',
    18.50,
    18.75,
    75,
    78,
    'COMPLETED',
    100,
    '2024-12-17 06:00:30-05',
    '2024-12-17 07:18:45-05'
);

-- ============================================================================
-- TABLA 15: stop_event
-- ============================================================================

INSERT INTO core_operations.stop_event (
    stop_event_id,
    stop_id,
    vehicle_id,
    driver_id,
    trip_id,
    event_type,
    latitude,
    longitude,
    distance_to_stop_meters,
    passengers_boarded,
    passengers_alighted,
    dwell_time_seconds,
    is_on_schedule,
    schedule_deviation_seconds,
    event_timestamp,
    created_at
) VALUES
(1, 1, 1, 5, 1, 'DEPARTURE', -11.9847523, -76.9736845, 5, 0, 0, NULL, true, 0, '2024-12-17 06:00:30-05', '2024-12-17 06:00:31-05'),
(2, 2, 1, 5, 1, 'ARRIVAL', -12.0012345, -76.9856789, 8, 0, 0, NULL, true, 45, '2024-12-17 06:18:45-05', '2024-12-17 06:18:46-05'),
(3, 2, 1, 5, 1, 'DEPARTURE', -12.0012345, -76.9856789, 8, 12, 3, 45, true, 45, '2024-12-17 06:19:30-05', '2024-12-17 06:19:31-05'),
(4, 4, 1, 5, 1, 'ARRIVAL', -12.0464080, -77.0427930, 12, 0, 0, NULL, true, 180, '2024-12-17 07:18:00-05', '2024-12-17 07:18:01-05');

-- ============================================================================
-- TABLA 16: checkpoint_event
-- ============================================================================

INSERT INTO core_operations.checkpoint_event (
    checkpoint_event_id,
    checkpoint_id,
    vehicle_id,
    driver_id,
    trip_id,
    latitude,
    longitude,
    distance_to_checkpoint_meters,
    elapsed_time_minutes,
    expected_time_minutes,
    is_on_time,
    deviation_minutes,
    status,
    event_timestamp,
    created_at
) VALUES
(1, 1, 1, 5, 1, -11.9956789, -76.9812345, 15, 15, 15, true, 0, 'ON_TIME', '2024-12-17 06:15:30-05', '2024-12-17 06:15:31-05'),
(2, 2, 1, 5, 1, -12.0445678, -77.0389012, 22, 65, 62, true, 3, 'ON_TIME', '2024-12-17 07:05:30-05', '2024-12-17 07:05:31-05');

-- ============================================================================
-- TABLA 17: incident_type
-- ============================================================================

INSERT INTO core_operations.incident_type (
    incident_type_id,
    code,
    name,
    description,
    default_severity,
    requires_immediate_response,
    escalation_minutes,
    is_active,
    created_at
) VALUES
(1, 'BREAKDOWN', 'Avería Mecánica', 'Falla mecánica que impide operación', 'HIGH', true, 15, true, '2024-01-10 10:00:00-05'),
(2, 'ACCIDENT', 'Accidente de Tránsito', 'Colisión o siniestro vial', 'CRITICAL', true, 5, true, '2024-01-10 10:00:00-05'),
(3, 'TRAFFIC', 'Congestión Vehicular', 'Tráfico intenso causa retraso', 'MEDIUM', false, 30, true, '2024-01-10 10:00:00-05'),
(4, 'PASSENGER_COMPLAINT', 'Queja de Pasajero', 'Reclamo de usuario', 'LOW', false, 60, true, '2024-01-10 10:00:00-05');

-- ============================================================================
-- TABLA 18: incident
-- ============================================================================

INSERT INTO core_operations.incident (
    incident_id,
    company_id,
    incident_type_id,
    trip_id,
    vehicle_id,
    driver_id,
    route_id,
    latitude,
    longitude,
    reported_by,
    reported_at,
    description,
    severity,
    status,
    assigned_to,
    resolved_at,
    resolution_notes,
    created_at,
    updated_at
) VALUES
(
    1,
    1,
    3,
    1,
    1,
    5,
    1,
    -12.0234567,
    -77.0012345,
    5,
    '2024-12-17 06:45:00-05',
    'Tráfico intenso en Av. Nicolás de Piérola por evento político. Retraso estimado 15 minutos.',
    'MEDIUM',
    'RESOLVED',
    6,
    '2024-12-17 07:10:00-05',
    'Tráfico normalizado. Viaje completado con retraso menor.',
    '2024-12-17 06:45:00-05',
    '2024-12-17 07:10:00-05'
);

-- ============================================================================
-- TABLA 19: alert_type
-- ============================================================================

INSERT INTO core_operations.alert_type (
    alert_type_id,
    code,
    name,
    description,
    default_severity,
    is_enabled,
    threshold_config,
    notification_channels,
    created_at,
    updated_at
) VALUES
(1, 'SPEED_LIMIT', 'Exceso de Velocidad', 'Velocidad supera límite permitido', 'WARNING', true, '{"threshold_kmh": 80, "duration_seconds": 30}'::jsonb, ARRAY['IN_APP', 'SMS'], '2024-01-10 10:00:00-05', '2024-12-17 08:00:00-05'),
(2, 'ROUTE_DEVIATION', 'Desvío de Ruta', 'Unidad fuera del recorrido autorizado', 'CRITICAL', true, '{"max_distance_meters": 200, "duration_minutes": 10}'::jsonb, ARRAY['IN_APP', 'EMAIL'], '2024-01-10 10:00:00-05', '2024-12-17 08:00:00-05'),
(3, 'GPS_OFFLINE', 'GPS Desconectado', 'Dispositivo GPS sin señal', 'CRITICAL', true, '{"offline_minutes": 5}'::jsonb, ARRAY['IN_APP'], '2024-01-10 10:00:00-05', '2024-12-17 08:00:00-05'),
(4, 'DOCUMENT_EXPIRING', 'Documento por Vencer', 'Documento próximo a vencer', 'INFO', true, '{"days_before": 30}'::jsonb, ARRAY['EMAIL'], '2024-01-10 10:00:00-05', '2024-12-17 08:00:00-05');

-- ============================================================================
-- TABLA 20: alert
-- ============================================================================

INSERT INTO core_operations.alert (
    alert_id,
    company_id,
    alert_type_id,
    vehicle_id,
    driver_id,
    trip_id,
    severity,
    message,
    context_data,
    triggered_at,
    acknowledged_by,
    acknowledged_at,
    status,
    created_at
) VALUES
(
    1,
    1,
    1,
    1,
    5,
    1,
    'WARNING',
    'Vehículo A-101 excedió velocidad permitida: 85 km/h en zona de 80 km/h',
    '{"speed_kmh": 85, "limit_kmh": 80, "location": "Av. Próceres km 8", "duration_seconds": 45}'::jsonb,
    '2024-12-17 06:25:30-05',
    6,
    '2024-12-17 06:26:15-05',
    'ACKNOWLEDGED',
    '2024-12-17 06:25:30-05'
);

-- ============================================================================
-- FIN REGISTROS - SCHEMA: core_operations
-- Total: 20 tablas con datos realistas
-- ============================================================================

-- ============================================================================
-- REGISTROS DE EJEMPLO - SCHEMA: core_finance
-- Sistema de Gestión de Transporte - TranCorp S.A.
-- Fecha: 17 Diciembre 2024
-- ============================================================================

-- ============================================================================
-- TABLA 1: ticket_type
-- ============================================================================

INSERT INTO core_finance.ticket_type (
    ticket_type_id, code, name, description, requires_validation, color, is_active, created_at
) VALUES
(1, 'DIRECTO', 'Boleto Directo', 'Tarifa completa adulto', false, '#FF6600', true, '2024-01-10 10:00:00-05'),
(2, 'URBANO', 'Boleto Urbano', 'Tarifa estándar urbano', false, '#0066CC', true, '2024-01-10 10:00:00-05'),
(3, 'ESTUDIANTE', 'Boleto Estudiante', 'Tarifa reducida estudiante universitario', true, '#00CC66', true, '2024-01-10 10:00:00-05'),
(4, 'ESCOLAR', 'Boleto Escolar', 'Tarifa escolar primaria/secundaria', true, '#FFCC00', true, '2024-01-10 10:00:00-05');

-- ============================================================================
-- TABLA 2: fare
-- ============================================================================

INSERT INTO core_finance.fare (
    fare_id, ticket_type_id, route_id, amount, currency, valid_from, valid_until, is_active, created_at, updated_at
) VALUES
(1, 1, 1, 1.80, 'PEN', '2024-01-01', NULL, true, '2024-01-10 10:00:00-05', '2024-01-10 10:00:00-05'),
(2, 2, 1, 1.50, 'PEN', '2024-01-01', NULL, true, '2024-01-10 10:00:00-05', '2024-01-10 10:00:00-05'),
(3, 3, 1, 0.90, 'PEN', '2024-01-01', NULL, true, '2024-01-10 10:00:00-05', '2024-01-10 10:00:00-05'),
(4, 4, 1, 0.75, 'PEN', '2024-01-01', NULL, true, '2024-01-10 10:00:00-05', '2024-01-10 10:00:00-05');

-- ============================================================================
-- TABLA 3: ticket_batch
-- ============================================================================

INSERT INTO core_finance.ticket_batch (
    batch_id, batch_code, company_id, ticket_type_id, total_booklets, total_tickets, status, created_at, updated_at
) VALUES
(1, 'LOTE-2024-001', 1, 1, 50, 5000, 'DISTRIBUTED', '2024-01-15 09:00:00-05', '2024-02-10 11:00:00-05'),
(2, 'LOTE-2024-002', 1, 2, 100, 10000, 'IN_STOCK', '2024-02-01 10:00:00-05', '2024-02-01 10:00:00-05');

-- ============================================================================
-- TABLA 4: ticket_inventory
-- ============================================================================

INSERT INTO core_finance.ticket_inventory (
    inventory_id, company_id, ticket_type_id, series, start_number, end_number, total_tickets, available_tickets, status, received_at, received_by, created_at, updated_at
) VALUES
(1, 1, 1, 'A', 000001, 000100, 100, 0, 'EXHAUSTED', '2024-01-15 09:00:00-05', 4, '2024-01-15 09:00:00-05', '2024-03-10 16:00:00-05'),
(2, 1, 1, 'A', 000101, 000200, 100, 45, 'ASSIGNED', '2024-01-15 09:00:00-05', 4, '2024-01-15 09:00:00-05', '2024-12-17 06:00:00-05'),
(3, 1, 2, 'B', 000001, 000100, 100, 100, 'AVAILABLE', '2024-02-01 10:00:00-05', 4, '2024-02-01 10:00:00-05', '2024-02-01 10:00:00-05');

-- ============================================================================
-- TABLA 5: ticket_batch_assignment
-- ============================================================================

INSERT INTO core_finance.ticket_batch_assignment (
    assignment_id, batch_id, inventory_id, assigned_to_user, terminal_id, quantity_assigned, assigned_by, assigned_at, received_at, document_number, notes, created_at
) VALUES
(1, 1, 2, 4, 1, 100, 1, '2024-02-10 11:00:00-05', '2024-02-10 11:30:00-05', 'GSA-2024-0045', 'Entrega a cajero terminal A', '2024-02-10 11:00:00-05');

-- ============================================================================
-- TABLA 6: ticket_supply
-- ============================================================================

INSERT INTO core_finance.ticket_supply (
    supply_id, assignment_id, driver_id, vehicle_id, dispatch_id, series, start_number, end_number, quantity_supplied, supplied_by, supplied_at, returned_at, status, created_at
) VALUES
(1, 1, 5, 1, 1, 'A', 000101, 000150, 50, 4, '2024-12-17 05:50:00-05', '2024-12-17 15:30:00-05', 'SETTLED', '2024-12-17 05:50:00-05');

-- ============================================================================
-- TABLA 7: ticket_supply_movement
-- ============================================================================

INSERT INTO core_finance.ticket_supply_movement (
    movement_id, supply_id, movement_type, from_actor_type, from_actor_id, to_actor_type, to_actor_id, from_vehicle_id, to_vehicle_id, series, start_number, end_number, quantity, reason, movement_timestamp, registered_by, created_at
) VALUES
(1, 1, 'INITIAL_SUPPLY', 'CASHIER', 4, 'DRIVER', 5, NULL, 1, 'A', 000101, 000150, 50, 'Suministro inicial para turno mañana', '2024-12-17 05:50:00-05', 4, '2024-12-17 05:50:00-05'),
(2, 1, 'FULL_RETURN', 'DRIVER', 5, 'CASHIER', 4, 1, NULL, 'A', 000126, 000150, 25, 'Devolución boletos no vendidos', '2024-12-17 15:30:00-05', 4, '2024-12-17 15:30:00-05');

-- ============================================================================
-- TABLA 8: validator
-- ============================================================================

INSERT INTO core_finance.validator (
    validator_id, serial_number, model, manufacturer, firmware_version, sim_card_number, last_sync_at, status, is_operational, created_at, updated_at
) VALUES
(1, 'VAL-2023-0458', 'TK-500', 'Transtech Systems', 'v2.4.1', '51987654321', '2024-12-17 07:00:00-05', 'ACTIVE', true, '2023-06-15 10:00:00-05', '2024-12-17 07:00:00-05'),
(2, 'VAL-2023-0459', 'TK-500', 'Transtech Systems', 'v2.4.1', '51987654322', '2024-12-17 06:45:00-05', 'ACTIVE', true, '2023-06-15 10:00:00-05', '2024-12-17 06:45:00-05');

-- ============================================================================
-- TABLA 9: validator_assignment
-- ============================================================================

INSERT INTO core_finance.validator_assignment (
    assignment_id, validator_id, vehicle_id, assigned_at, assigned_by, removed_at, removed_by, is_active, notes, created_at
) VALUES
(1, 1, 1, '2023-07-01 09:00:00-05', 2, NULL, NULL, true, 'Instalación permanente', '2023-07-01 09:00:00-05');

-- ============================================================================
-- TABLA 10: trip_production
-- ============================================================================

INSERT INTO core_finance.trip_production (
    production_id, trip_id, validator_id, supply_id, ticket_type_id, quantity_sold, unit_price, total_amount, start_ticket_number, end_ticket_number, recorded_at, created_at
) VALUES
(1, 1, NULL, 1, 1, 25, 1.80, 45.00, 000101, 000125, '2024-12-17 07:18:45-05', '2024-12-17 07:18:45-05');

-- ============================================================================
-- TABLA 11: expense_type
-- ============================================================================

INSERT INTO core_finance.expense_type (
    expense_type_id, code, name, description, requires_receipt, max_amount_per_trip, is_reimbursable, is_active, created_at
) VALUES
(1, 'TOLL', 'Peaje', 'Pago de peaje en ruta', true, 10.00, true, true, '2024-01-10 10:00:00-05'),
(2, 'FUEL', 'Combustible', 'Compra de combustible', true, 50.00, true, true, '2024-01-10 10:00:00-05'),
(3, 'FINE', 'Multa', 'Papeleta de tránsito', true, 200.00, false, true, '2024-01-10 10:00:00-05'),
(4, 'PARKING', 'Estacionamiento', 'Pago de estacionamiento', false, 5.00, true, true, '2024-01-10 10:00:00-05'),
(5, 'MEAL', 'Alimentación', 'Almuerzo o refrigerio', false, 15.00, true, true, '2024-01-10 10:00:00-05');

-- ============================================================================
-- TABLA 12: trip_expense
-- ============================================================================

INSERT INTO core_finance.trip_expense (
    expense_id, trip_id, driver_id, vehicle_id, expense_type_id, amount, description, location, receipt_number, receipt_file_id, reported_at, approved_by, approved_at, status, rejection_reason, created_at
) VALUES
(1, 1, 5, 1, 4, 3.00, 'Estacionamiento durante almuerzo', 'Centro de Lima', NULL, NULL, '2024-12-17 13:30:00-05', 4, '2024-12-17 14:00:00-05', 'APPROVED', NULL, '2024-12-17 13:30:00-05');

-- ============================================================================
-- TABLA 13: partial_delivery
-- ============================================================================

INSERT INTO core_finance.partial_delivery (
    delivery_id, trip_id, driver_id, vehicle_id, received_by, amount_delivered, expected_amount, difference_amount, delivery_timestamp, notes, created_at
) VALUES
(1, 1, 5, 1, 4, 42.00, 45.00, -3.00, '2024-12-17 07:30:00-05', 'Conductor reporta gasto de estacionamiento', '2024-12-17 07:30:00-05');

-- ============================================================================
-- TABLA 14: cashier_box
-- ============================================================================

INSERT INTO core_finance.cashier_box (
    box_id, cashier_user_id, company_id, terminal_id, opening_amount, opened_at, closed_at, closing_amount, total_received, total_paid_out, expected_amount, difference_amount, status, created_at, updated_at
) VALUES
(1, 4, 1, 1, 100.00, '2024-12-17 05:00:00-05', '2024-12-17 16:00:00-05', 1642.00, 1550.00, 8.00, 1542.00, 0.00, 'CLOSED', '2024-12-17 05:00:00-05', '2024-12-17 16:00:00-05');

-- ============================================================================
-- TABLA 15: cashier_box_movement
-- ============================================================================

INSERT INTO core_finance.cashier_box_movement (
    movement_id, box_id, movement_type, reference_type, reference_id, amount, description, movement_timestamp, created_at
) VALUES
(1, 1, 'DELIVERY', 'partial_delivery', 1, 42.00, 'Entrega parcial conductor Pedro Sánchez - Viaje #1', '2024-12-17 07:30:00-05', '2024-12-17 07:30:00-05'),
(2, 1, 'PAYMENT', 'trip_expense', 1, 3.00, 'Reembolso gasto estacionamiento', '2024-12-17 14:00:00-05', '2024-12-17 14:00:00-05');

-- ============================================================================
-- Explicación de tablas de recaudo para suministro manual
-- ============================================================================

**Escenario 1: Recaudo Manual (Boletos Físicos)**

**Jornada del conductor:**

1. **Suministro inicial** (08:00)
   ```sql
   ticket_supply: supply_id=100, driver_id=10, series='A', 
   start=1, end=100, status='ACTIVE'
   ```

2. **Viaje 1** (08:30 - 09:15)
   ```sql
   trip: trip_id=500, driver_id=10, vehicle_id=25
   trip_production: trip_id=500, supply_id=100, 
   start_ticket=1, end_ticket=35, quantity=35, total=S/87.50
   ```

3. **Entrega parcial 1** (09:20 en terminal)
   ```sql
   partial_delivery: trip_id=500, driver_id=10, 
   amount_delivered=S/87.50, received_by=cajero_id
   
   cashier_box: box_id=10 (ya abierto)
   total_received += S/87.50
   ```

4. **Viaje 2** (09:30 - 10:15)
   ```sql
   trip_production: trip_id=501, supply_id=100,
   start_ticket=36, end_ticket=70, quantity=35, total=S/87.50
   ```

5. **Entrega parcial 2** (10:20)
   ```sql
   partial_delivery: trip_id=501, amount_delivered=S/87.00
   difference_amount=-S/0.50 (faltante)
   
   cashier_box: total_received += S/87.00
   ```

6. **Fin de turno** (14:00)
   - Conductor vendió: A-001 a A-070 (70 boletos)
   - Devuelve: A-071 a A-100 (30 sin usar)
   ```sql
   ticket_supply: status='RETURNED', returned_at=NOW()
   ```

---

**Estrategias de Manejo (Saldo por pagar de un viaje)**

**Opción A: Bloquear liquidación hasta cuadre**
```sql
-- Validación antes de crear settlement
total_production = S/174.50
total_delivered = S/174.00  -- falta S/0.50

IF total_delivered < total_production THEN
  RAISE ERROR 'Debe entregar S/0.50 faltante antes de liquidar'
END IF;
```
**Pros:** Fuerza cuadre inmediato  
**Contras:** Conductor no puede irse hasta pagar

---

**Opción C: Liquidar con deuda registrada**
```sql
settlement:
  net_amount = S/174.50  -- sin descontar

payment:
  amount = S/174.00  -- pago parcial

hr.loan:
  loan_type = 'SHORTAGE'
  amount = S/0.50
  installments = 1
```
**Pros:** Conductor puede irse, deuda rastreada  
**Contras:** Requiere seguimiento de cobro

---

**`cashier_box_movement` - Propósito**

**Trazabilidad detallada de cada transacción en la caja del cajero.**

**Tipos de movimientos:**

**1. DELIVERY (entrada)**
```sql
movement_type='DELIVERY', 
reference_type='partial_delivery',
reference_id=delivery_id,
amount=S/87.50  -- positivo
```

**2. PAYMENT (salida)**
```sql
movement_type='PAYMENT',
reference_type='settlement',
reference_id=settlement_id,
amount=-S/174.00  -- negativo
```

**3. ADJUSTMENT (corrección)**
```sql
movement_type='ADJUSTMENT',
amount=S/5.00,
description='Corrección error de registro'
```

**Utilidad de cashier_box_movement:**

Auditoría completa del turno  
Reconciliación exacta (`SUM(amount)` debe = `closing_amount - opening_amount`)  
Detectar discrepancias  


-- ============================================================================
-- TABLA 16: settlement
-- ============================================================================

INSERT INTO core_finance.settlement (
    settlement_id, driver_id, vehicle_id, company_id, settlement_date, total_production, total_expenses, net_amount, payment_method, settled_by, settled_at, status, notes, created_at, updated_at
) VALUES
(1, 5, 1, 1, '2024-12-17', 45.00, 3.00, 42.00, 'CASH', 4, '2024-12-17 15:30:00-05', 'PAID', 'Liquidación normal, un viaje completado', '2024-12-17 15:30:00-05', '2024-12-17 15:35:00-05');

-- ============================================================================
-- TABLA 17: settlement_detail
-- ============================================================================

INSERT INTO core_finance.settlement_detail (
    detail_id, settlement_id, ticket_type_id, supply_id, validator_id, series, start_number, end_number, quantity_sold, unit_price, total_amount, created_at
) VALUES
(1, 1, 1, 1, NULL, 'A', 000101, 000125, 25, 1.80, 45.00, '2024-12-17 15:30:00-05');

-- ============================================================================
-- TABLA 18: settlement_adjustment
-- ============================================================================

INSERT INTO core_finance.settlement_adjustment (
    adjustment_id, settlement_id, adjustment_type, amount, reason, authorized_by, authorized_at, created_at
) VALUES
(1, 1, 'SHORTAGE', 0.00, 'Sin ajustes necesarios', 2, '2024-12-17 15:32:00-05', '2024-12-17 15:32:00-05');

-- ============================================================================
-- TABLA 19: payment
-- ============================================================================

INSERT INTO core_finance.payment (
    payment_id, payment_type, settlement_id, owner_settlement_id, payee_id, amount, payment_method, reference_number, bank_account, paid_by, paid_at, status, notes, created_at
) VALUES
(1, 'DRIVER', 1, NULL, 5, 42.00, 'CASH', NULL, NULL, 4, '2024-12-17 15:35:00-05', 'COMPLETED', 'Pago en efectivo', '2024-12-17 15:35:00-05');


-- ============================================================================
-- Explicación de tablas de liquidación con contexto de pago a conductor en caso hayan saldos
-- ============================================================================

**PROMPT 8 (QUESTION)**
Flujo de liquidación a conductor considerando el siguiente contexto : 
Contexto:
Conductor: Juan (driver_id=10, person_id=10)
Vehículo: BUS-025 (vehicle_id=25, owner_id=5)
Empresa paga conductores: semanal
 

**Viaje 1** (08:30-09:15)
```sql
trip_production: quantity=40, total=S/100.00

trip_expense:
  expense_id=1, expense_type_id=1 (TOLL)
  amount=S/5.00

partial_delivery:
  amount_delivered=S/95.00
  expected_amount=S/100.00
  difference_amount=S/0.00  -- S/100 - S/5 gasto = S/95 ✓
```

**Viaje 2** (09:30-10:15)
```sql
trip_production: quantity=30, total=S/75.00

trip_expense:
  expense_id=2, expense_type_id=2 (FUEL)
  amount=S/10.00

partial_delivery:
  amount_delivered=S/64.50
  expected_amount=S/75.00
  difference_amount=-S/0.50  -- S/75 - S/10 = S/65 esperado, entregó S/64.50 ❌
```

**Liquidación Detallada**

```sql
settlement:
  settlement_id: 200
  driver_id: 10
  vehicle_id: 25
  company_id: 100
  settlement_date: '2024-12-15'
  total_production: S/175.00
  total_expenses: S/15.00
  net_amount: S/160.00
  payment_method: NULL
  settled_by: 3  -- user_id cajero
  settled_at: '2024-12-15 14:30:00'
  status: 'PENDING'
  notes: 'Liquidación diaria con 2 viajes, faltante S/0.50 registrado como deuda'
  created_at: '2024-12-15 14:30:00'
  updated_at: '2024-12-15 14:30:00'
```

```sql
settlement_detail:
  detail_id: 1
  settlement_id: 200
  ticket_type_id: 1  -- DIRECTO
  supply_id: 100
  series: 'A'
  start_number: 1
  end_number: 70
  quantity_sold: 70
  unit_price: S/2.50
  total_amount: S/175.00
  created_at: '2024-12-15 14:30:00'
```

```sql
hr.loan:
  loan_id: 50
  person_id: 10
  loan_type: 'SHORTAGE'
  loan_amount: S/0.50
  interest_rate: 0.00
  total_amount: S/0.50
  installments: 1
  installment_amount: S/0.50
  granted_date: '2024-12-15'
  first_payment_date: '2024-12-22'
  granted_by: 3
  purpose: 'Faltante entrega parcial viaje 2, delivery_id=2'
  status: 'ACTIVE'
  paid_installments: 0
  remaining_balance: S/0.50
  created_at: '2024-12-15 14:30:00'
```

---

**Pago Detallado (20/12/2024)**

```sql
payment:
  payment_id: 300
  payment_type: 'DRIVER'
  settlement_id: 200
  owner_settlement_id: NULL
  payee_id: 10
  amount: S/159.50  -- S/160.00 - S/0.50 deuda
  payment_method: 'TRANSFER'
  reference_number: 'TRF-20241220-001'
  bank_account: '191-1234567890'
  paid_by: 3  -- user_id cajero
  paid_at: '2024-12-20 18:00:00'
  status: 'COMPLETED'
  notes: 'Pago semanal con descuento loan_id=50'
  created_at: '2024-12-20 18:00:00'
```

```sql
UPDATE settlement SET 
  status='PAID',
  updated_at='2024-12-20 18:00:00'
WHERE settlement_id=200;

UPDATE hr.loan SET
  status='PAID',
  paid_installments=1,
  remaining_balance=0.00,
  updated_at='2024-12-20 18:00:00'
WHERE loan_id=50;
```


-- ============================================================================
-- TABLA 20: financial_report
-- ============================================================================

INSERT INTO core_finance.financial_report (
    report_id, report_type, report_date, period_start, period_end, total_production, total_expenses, total_driver_payments, total_owner_payments, net_income, report_data, generated_by, generated_at, status, created_at
) VALUES
(
    1,
    'DAILY',
    '2024-12-17',
    '2024-12-17',
    '2024-12-17',
    45.00,
    3.00,
    42.00,
    0.00,
    0.00,
    '{"trips_completed": 1, "vehicles_operated": 1, "drivers_active": 1, "average_production_per_trip": 45.00}'::jsonb,
    2,
    '2024-12-17 18:00:00-05',
    'APPROVED',
    '2024-12-17 18:00:00-05'
);

-- ============================================================================
-- FIN REGISTROS - SCHEMA: core_finance
-- Total: 20 tablas con flujo completo de recaudo y liquidación
-- ============================================================================