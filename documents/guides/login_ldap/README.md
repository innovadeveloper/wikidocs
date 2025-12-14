Excelente observación. Esto **NO** descarta WSO2 IS + LDAP. De hecho, es el escenario típico de RBAC flexible.

## **Arquitectura Recomendada**

**WSO2 IS + LDAP:** Autenticación + grupos organizacionales
**PostgreSQL local:** Autorización granular por módulo/función

### **Flujo:**
```
1. Login → WSO2 IS (LDAP)
2. Token JWT con claims básicos (user_id, email, groups)
3. Backend consulta PostgreSQL:
   - identity.user_permission (tabla local)
   - Permisos por usuario específico
   - NO solo por rol/grupo
```

## **Modelo de Permisos Sugerido**

```sql
-- identity schema

-- Usuario vinculado a LDAP/WSO2
CREATE TABLE user (
  user_id BIGSERIAL PRIMARY KEY,
  external_id VARCHAR(255) UNIQUE NOT NULL, -- LDAP DN o WSO2 subject
  email VARCHAR(255) UNIQUE NOT NULL,
  username VARCHAR(100) UNIQUE NOT NULL,
  is_active BOOLEAN DEFAULT true
);

-- Permisos granulares por módulo
CREATE TABLE permission (
  permission_id SERIAL PRIMARY KEY,
  module VARCHAR(50) NOT NULL, -- 'operations', 'finance', 'hr'
  resource VARCHAR(100) NOT NULL, -- 'dispatch', 'settlement', 'driver'
  action VARCHAR(50) NOT NULL, -- 'create', 'read', 'update', 'delete', 'approve'
  code VARCHAR(150) UNIQUE NOT NULL, -- 'operations.dispatch.create'
  description TEXT
);

-- Asignación directa a usuarios (NO a roles)
CREATE TABLE user_permission (
  user_id BIGINT REFERENCES user(user_id),
  permission_id INT REFERENCES permission(permission_id),
  granted_at TIMESTAMPTZ DEFAULT NOW(),
  granted_by BIGINT REFERENCES user(user_id),
  PRIMARY KEY (user_id, permission_id)
);

-- Opcional: Templates de permisos reutilizables
CREATE TABLE permission_template (
  template_id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL, -- 'Cajero Básico', 'Cajero + Despachador'
  description TEXT
);

CREATE TABLE permission_template_detail (
  template_id INT REFERENCES permission_template(template_id),
  permission_id INT REFERENCES permission(permission_id),
  PRIMARY KEY (template_id, permission_id)
);
```

## **Ventajas de este Enfoque**

✅ **Flexibilidad total:** Cada usuario tiene permisos únicos
✅ **WSO2 simplificado:** Solo autenticación, no gestión compleja de scopes
✅ **Auditoría granular:** Quién otorgó qué permiso y cuándo
✅ **Templates opcionales:** Facilita asignación masiva pero no obliga
✅ **Performance:** PostgreSQL es más rápido que WSO2 para queries complejos de autorización

## **WSO2 IS - Uso Mínimo**

Úsalo solo para:
- Autenticación (login/logout)
- SSO entre aplicaciones (si aplica)
- Gestión de passwords/MFA
- Claims básicos (email, name, orgUnit)

**NO** uses WSO2 scopes/policies para permisos funcionales detallados.

## **Implementación en Backend**

```javascript
// Middleware de autorización
async function checkPermission(userId, requiredPermission) {
  const hasPermission = await db.query(`
    SELECT EXISTS(
      SELECT 1 FROM identity.user_permission up
      JOIN identity.permission p ON up.permission_id = p.permission_id
      WHERE up.user_id = $1 AND p.code = $2
    )
  `, [userId, requiredPermission]);
  
  return hasPermission.rows[0].exists;
}

// Ejemplo de uso
if (!await checkPermission(userId, 'operations.dispatch.create')) {
  throw new ForbiddenError();
}
```

**Respuesta directa:** Mantén WSO2 IS + LDAP para autenticación, gestiona permisos granulares en PostgreSQL con asignación directa a usuarios.