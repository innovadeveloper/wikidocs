# Guía PostgreSQL: Composite Types y Funciones

## 1. CREACIÓN DE TIPOS COMPUESTOS

### Tipo básico
```sql
CREATE TYPE trip_info AS (
    trip_id BIGINT,
    route_code VARCHAR(20),
    departure_time TIMESTAMP,
    revenue NUMERIC(10,2)
);
```
**Tip:** Los composite types son estructuras reutilizables. Piensa en ellos como clases/DTOs que puedes usar en múltiples funciones.

---

### Tipo con arrays anidados
```sql
CREATE TYPE driver_stats AS (
    driver_id INT,
    driver_name VARCHAR(100),
    total_trips INT
);

CREATE TYPE route_performance AS (
    route_id INT,
    route_name VARCHAR(100),
    drivers driver_stats[],  -- Array de composite types
    compliance_rate NUMERIC(5,2)
);
```
**Tip:** Los arrays de tipos compuestos (`driver_stats[]`) permiten modelar relaciones uno-a-muchos directamente en el tipo de retorno.

---

### Tipo de respuesta unificada (patrón éxito/error)
```sql
CREATE TYPE api_response AS (
    success BOOLEAN,
    error_code VARCHAR(50),
    error_message TEXT,
    -- Datos opcionales (NULL si hay error)
    data_id INT,
    data_name VARCHAR(100)
);
```
**Tip:** Este patrón evita excepciones SQL. La función siempre retorna; el cliente verifica `success` para decidir si procesar datos o manejar error.

---

## 2. MODIFICACIÓN DE TIPOS

### Agregar atributo
```sql
ALTER TYPE trip_info 
ADD ATTRIBUTE vehicle_code VARCHAR(20);
```

### Renombrar tipo
```sql
ALTER TYPE trip_info 
RENAME TO trip_summary;
```

### Renombrar atributo
```sql
ALTER TYPE trip_info 
RENAME ATTRIBUTE revenue TO total_revenue;
```

### Eliminar atributo
```sql
ALTER TYPE trip_info 
DROP ATTRIBUTE IF EXISTS old_field CASCADE;
```
**Tip:** `CASCADE` elimina automáticamente las funciones que dependen del atributo. Verifica dependencias primero (ver sección 4).

---

### Cambiar tipo de dato (requiere recreación)
```sql
-- ❌ NO se puede alterar el tipo directamente
DROP TYPE IF EXISTS trip_info CASCADE;

CREATE TYPE trip_info AS (
    trip_id BIGINT,
    revenue NUMERIC(12,2)  -- cambiado de (10,2)
);
```
**Tip:** Guarda las definiciones de funciones dependientes antes del DROP usando `pg_get_functiondef()`, luego recréalas.

---

## 3. FUNCIONES CON TIPOS COMPUESTOS

### Función básica - retorno simple
```sql
CREATE OR REPLACE FUNCTION get_trip(p_trip_id BIGINT)
RETURNS trip_info
LANGUAGE plpgsql
AS $$
DECLARE
    v_trip trip_info;
BEGIN
    SELECT trip_id, route_code, departure_time, revenue
    INTO v_trip
    FROM trip
    WHERE trip_id = p_trip_id;
    
    RETURN v_trip;
END;
$$;
```
**Tip:** `RETURNS trip_info` retorna 1 registro. Para múltiples filas usa `RETURNS SETOF trip_info`.

---

### Función con manejo de errores
```sql
CREATE OR REPLACE FUNCTION get_route_safe(p_route_id INT)
RETURNS api_response
LANGUAGE plpgsql
AS $$
DECLARE
    v_response api_response;
BEGIN
    -- Validación
    IF NOT EXISTS(SELECT 1 FROM route WHERE route_id = p_route_id) THEN
        v_response.success := false;
        v_response.error_code := 'NOT_FOUND';
        v_response.error_message := 'Route ' || p_route_id || ' not found';
        RETURN v_response;
    END IF;
    
    -- Procesamiento normal
    BEGIN
        SELECT true, NULL, NULL, route_id, name
        INTO v_response
        FROM route
        WHERE route_id = p_route_id;
        
        RETURN v_response;
        
    EXCEPTION WHEN OTHERS THEN
        v_response.success := false;
        v_response.error_code := 'INTERNAL_ERROR';
        v_response.error_message := SQLERRM;
        RETURN v_response;
    END;
END;
$$;
```
**Tip:** El bloque `EXCEPTION WHEN OTHERS` captura errores inesperados sin abortar. `SQLERRM` contiene el mensaje de error de PostgreSQL.

---

### Función con arrays de composite types
```sql
CREATE OR REPLACE FUNCTION get_route_with_drivers(p_route_id INT)
RETURNS route_performance
LANGUAGE plpgsql
AS $$
DECLARE
    v_result route_performance;
BEGIN
    SELECT 
        r.route_id,
        r.name,
        ARRAY(
            SELECT ROW(d.driver_id, d.full_name, COUNT(t.trip_id))::driver_stats
            FROM driver d
            JOIN trip t ON t.driver_id = d.driver_id
            WHERE t.route_id = p_route_id
            GROUP BY d.driver_id, d.full_name
        ),
        95.5
    INTO v_result
    FROM route r
    WHERE r.route_id = p_route_id;
    
    RETURN v_result;
END;
$$;
```
**Tip:** `ARRAY(SELECT ROW(...)::tipo)` construye arrays de composite types dinámicamente desde subqueries.

---

## 4. CONSULTAS DE AUDITORÍA

### Listar todos los composite types
```sql
SELECT 
    n.nspname AS schema,
    t.typname AS type_name,
    obj_description(t.oid, 'pg_type') AS description
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
WHERE t.typtype = 'c'
AND n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY n.nspname, t.typname;
```
**Tip:** Filtra por `t.typtype = 'c'` para obtener solo composite types (excluye tipos base, enums, etc.).

---

### Buscar tipos por nombre (flexible)
```sql
SELECT 
    n.nspname AS schema,
    t.typname AS type_name
FROM pg_type t
JOIN pg_namespace n ON n.oid = t.typnamespace
WHERE t.typtype = 'c'
AND (
    t.typname LIKE '%' || 'trip' || '%'  -- Reemplaza 'trip' con tu búsqueda
    OR '' = ''  -- Si búsqueda vacía, retorna todo
)
ORDER BY t.typname;
```
**Tip:** El patrón `OR '' = ''` hace que cuando el filtro esté vacío se retornen todos los registros.

---

### Ver estructura de un tipo
```sql
SELECT 
    a.attname AS column_name,
    pg_catalog.format_type(a.atttypid, a.atttypmod) AS data_type,
    a.attnum AS position
FROM pg_attribute a
JOIN pg_type t ON a.attrelid = t.typrelid
WHERE t.typname = 'route_performance'
AND a.attnum > 0
AND NOT a.attisdropped
ORDER BY a.attnum;
```
**Tip:** `attnum > 0` excluye atributos del sistema. `attisdropped` excluye columnas eliminadas pero aún presentes.

---

### Buscar funciones que usan un tipo
```sql
SELECT DISTINCT
    t.typname AS type_name,
    p.proname AS function_name,
    pg_get_function_result(p.oid) AS return_type,
    pg_get_function_arguments(p.oid) AS parameters
FROM pg_type t
JOIN pg_depend d ON d.refobjid = t.oid
JOIN pg_proc p ON p.oid = d.objid
WHERE t.typtype = 'c'
AND (
    t.typname LIKE '%' || 'route' || '%'
    OR '' = ''
);
```
**Tip:** Usa esta query ANTES de hacer `DROP TYPE CASCADE` para saber qué funciones se eliminarán.

---

### Ver funciones que retornan un tipo específico
```sql
SELECT 
    n.nspname || '.' || p.proname AS function_name,
    pg_get_function_result(p.oid) AS return_type
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE pg_get_function_result(p.oid) LIKE '%api_response%';
```

### Ver funciones que usan un tipo como parámetro
```sql
SELECT 
    n.nspname || '.' || p.proname AS function_name,
    pg_get_function_arguments(p.oid) AS parameters
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE pg_get_function_arguments(p.oid) LIKE '%api_response%';
```
**Tip:** Usa `LIKE` para buscar tipos tanto en retornos como en parámetros. Combina ambas queries con `UNION ALL` para búsqueda completa.

---

## 5. FUNCIÓN DE UTILIDAD PARA VERIFICAR USO

```sql
CREATE OR REPLACE FUNCTION check_type_usage(p_type_name TEXT)
RETURNS TABLE(
    usage_type TEXT,
    function_name TEXT,
    definition_preview TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    -- Como tipo de retorno
    SELECT 
        'RETURN_TYPE'::TEXT,
        n.nspname || '.' || p.proname,
        LEFT(pg_get_functiondef(p.oid), 100) || '...'
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    JOIN pg_type t ON t.oid = p.prorettype
    WHERE t.typname = p_type_name
    
    UNION ALL
    
    -- Como parámetro
    SELECT 
        'PARAMETER'::TEXT,
        n.nspname || '.' || p.proname,
        pg_get_function_arguments(p.oid)
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE pg_get_function_arguments(p.oid) LIKE '%' || p_type_name || '%';
END;
$$;

-- Uso
SELECT * FROM check_type_usage('api_response');
```
**Tip:** Esta función centraliza la búsqueda de dependencias. Úsala antes de modificar o eliminar tipos.

### Funciones de utilidad de la sección 4 

Funciones de utilidad para gestionar los tipos compuestos.


```sql
-- 1. Listar todos los composite types
CREATE OR REPLACE FUNCTION list_composite_types(p_schema TEXT DEFAULT NULL)
RETURNS TABLE(
    schema_name TEXT,
    type_name TEXT,
    description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.nspname::TEXT,
        t.typname::TEXT,
        obj_description(t.oid, 'pg_type')::TEXT
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typtype = 'c'
    AND n.nspname NOT IN ('pg_catalog', 'information_schema')
    AND (p_schema IS NULL OR n.nspname = p_schema)
    ORDER BY n.nspname, t.typname;
END;
$$;

-- Uso:
-- SELECT * FROM list_composite_types();
-- SELECT * FROM list_composite_types('core_operations');


-- 2. Buscar tipos por nombre (flexible)
CREATE OR REPLACE FUNCTION search_types_by_name(p_search TEXT DEFAULT '')
RETURNS TABLE(
    schema_name TEXT,
    type_name TEXT,
    description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.nspname::TEXT,
        t.typname::TEXT,
        obj_description(t.oid, 'pg_type')::TEXT
    FROM pg_type t
    JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typtype = 'c'
    AND n.nspname NOT IN ('pg_catalog', 'information_schema')
    AND (p_search = '' OR t.typname ILIKE '%' || p_search || '%')
    ORDER BY t.typname;
END;
$$;

-- Uso:
-- SELECT * FROM search_types_by_name('trip');
-- SELECT * FROM search_types_by_name('');  -- retorna todos


-- 3. Ver estructura de un tipo
CREATE OR REPLACE FUNCTION describe_type(p_type_name TEXT)
RETURNS TABLE(
    column_name TEXT,
    data_type TEXT,
    position INT,
    is_array BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.attname::TEXT,
        pg_catalog.format_type(a.atttypid, a.atttypmod)::TEXT,
        a.attnum::INT,
        (pg_catalog.format_type(a.atttypid, a.atttypmod) LIKE '%[]')::BOOLEAN
    FROM pg_attribute a
    JOIN pg_type t ON a.attrelid = t.typrelid
    WHERE t.typname = p_type_name
    AND a.attnum > 0
    AND NOT a.attisdropped
    ORDER BY a.attnum;
END;
$$;

-- Uso:
-- SELECT * FROM describe_type('route_performance');


-- 4. Buscar funciones que usan un tipo (retorno o parámetro)
CREATE OR REPLACE FUNCTION find_functions_using_type(p_type_name TEXT)
RETURNS TABLE(
    usage_type TEXT,
    schema_name TEXT,
    function_name TEXT,
    return_type TEXT,
    parameters TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    -- Como tipo de retorno
    SELECT DISTINCT
        'RETURN_TYPE'::TEXT,
        n.nspname::TEXT,
        p.proname::TEXT,
        pg_get_function_result(p.oid)::TEXT,
        pg_get_function_arguments(p.oid)::TEXT
    FROM pg_type t
    JOIN pg_depend d ON d.refobjid = t.oid
    JOIN pg_proc p ON p.oid = d.objid
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE t.typtype = 'c'
    AND t.typname = p_type_name
    
    UNION ALL
    
    -- Como parámetro
    SELECT DISTINCT
        'PARAMETER'::TEXT,
        n.nspname::TEXT,
        p.proname::TEXT,
        pg_get_function_result(p.oid)::TEXT,
        pg_get_function_arguments(p.oid)::TEXT
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE pg_get_function_arguments(p.oid) ILIKE '%' || p_type_name || '%'
    
    ORDER BY usage_type, schema_name, function_name;
END;
$$;

-- Uso:
-- SELECT * FROM find_functions_using_type('api_response');


-- 5. Ver funciones que retornan un tipo específico
CREATE OR REPLACE FUNCTION find_functions_returning_type(p_type_name TEXT)
RETURNS TABLE(
    schema_name TEXT,
    function_name TEXT,
    return_type TEXT,
    parameters TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.nspname::TEXT,
        p.proname::TEXT,
        pg_get_function_result(p.oid)::TEXT,
        pg_get_function_arguments(p.oid)::TEXT
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE pg_get_function_result(p.oid) ILIKE '%' || p_type_name || '%'
    ORDER BY n.nspname, p.proname;
END;
$$;

-- Uso:
-- SELECT * FROM find_functions_returning_type('trip_info');


-- 6. Ver funciones que usan un tipo como parámetro
CREATE OR REPLACE FUNCTION find_functions_with_type_parameter(p_type_name TEXT)
RETURNS TABLE(
    schema_name TEXT,
    function_name TEXT,
    parameters TEXT,
    return_type TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.nspname::TEXT,
        p.proname::TEXT,
        pg_get_function_arguments(p.oid)::TEXT,
        pg_get_function_result(p.oid)::TEXT
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE pg_get_function_arguments(p.oid) ILIKE '%' || p_type_name || '%'
    ORDER BY n.nspname, p.proname;
END;
$$;

-- Uso:
-- SELECT * FROM find_functions_with_type_parameter('api_response');


-- BONUS: Función all-in-one para auditoría completa de un tipo
CREATE OR REPLACE FUNCTION audit_type(p_type_name TEXT)
RETURNS TABLE(
    section TEXT,
    detail TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Estructura del tipo
    RETURN QUERY
    SELECT 
        'STRUCTURE'::TEXT,
        a.attname || ' ' || pg_catalog.format_type(a.atttypid, a.atttypmod)
    FROM pg_attribute a
    JOIN pg_type t ON a.attrelid = t.typrelid
    WHERE t.typname = p_type_name
    AND a.attnum > 0
    AND NOT a.attisdropped
    ORDER BY a.attnum;
    
    -- Funciones que lo usan
    RETURN QUERY
    SELECT 
        'USED_IN'::TEXT,
        n.nspname || '.' || p.proname || '()'
    FROM pg_type t
    JOIN pg_depend d ON d.refobjid = t.oid
    JOIN pg_proc p ON p.oid = d.objid
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE t.typname = p_type_name;
END;
$$;

-- Uso:
-- SELECT * FROM audit_type('route_performance');
```

---

## 6. PROCESO SEGURO DE MODIFICACIÓN

```sql
-- 1. Verificar uso
SELECT * FROM check_type_usage('trip_info');

-- 2. Respaldar funciones dependientes
SELECT pg_get_functiondef(p.oid)
FROM pg_proc p
WHERE pg_get_function_result(p.oid) LIKE '%trip_info%';

-- 3. Eliminar tipo
DROP TYPE trip_info CASCADE;

-- 4. Recrear tipo modificado
CREATE TYPE trip_info AS (
    trip_id BIGINT,
    route_code VARCHAR(20),
    revenue NUMERIC(12,2)  -- modificado
);

-- 5. Recrear funciones desde respaldo
-- (pegar el código guardado en paso 2)
```
**Tip:** En producción, usa herramientas de migración como Flyway o Liquibase para versionar estos cambios.

---

## RESUMEN DE COMANDOS CLAVE

| Operación | Comando |
|-----------|---------|
| Crear tipo | `CREATE TYPE nombre AS (...)` |
| Agregar campo | `ALTER TYPE nombre ADD ATTRIBUTE campo tipo` |
| Renombrar tipo | `ALTER TYPE nombre RENAME TO nuevo_nombre` |
| Eliminar tipo | `DROP TYPE nombre CASCADE` |
| Ver tipos | `SELECT * FROM pg_type WHERE typtype = 'c'` |
| Ver estructura | `SELECT * FROM pg_attribute WHERE attrelid = tipo_oid` |
| Ver dependencias | `SELECT * FROM pg_depend WHERE refobjid = tipo_oid` |


---

Perfecto 👍 hagámoslo **más aterrizado aún**.
Te dejo **las mismas tablas**, pero ahora con una **columna extra: `Ejemplo de valor`**, para que literalmente veas *qué guardarías ahí* en un sistema real (tipo el tuyo: backend + identidad + operaciones).

---

##   Tipos Numéricos (con ejemplos)

| Tipo               | Tamaño   | Descripción      | Uso típico      | Ejemplo de valor |
| ------------------ | -------- | ---------------- | --------------- | ---------------- |
| `SMALLINT`         | 2 bytes  | Entero corto     | Flags, estados  | `3`              |
| `INTEGER` / `INT`  | 4 bytes  | Entero estándar  | Contadores      | `1542`           |
| `BIGINT`           | 8 bytes  | Entero largo     | IDs grandes     | `9876543210`     |
| `SMALLSERIAL`      | 2 bytes  | Auto incremental | IDs pequeños    | `12`             |
| `SERIAL`           | 4 bytes  | Auto incremental | IDs comunes     | `10234`          |
| `BIGSERIAL`        | 8 bytes  | Auto incremental | IDs principales | `4500001`        |
| `DECIMAL(10,2)`    | variable | Precisión exacta | Dinero          | `1500.75`        |
| `NUMERIC(12,2)`    | variable | Precisión exacta | Pagos           | `123456.90`      |
| `REAL`             | 4 bytes  | Float            | Métricas        | `98.6`           |
| `DOUBLE PRECISION` | 8 bytes  | Float largo      | Cálculos        | `0.00034567`     |
| `MONEY`            | 8 bytes  | Moneda           | ❌ evitar        | `$1,250.50`      |

---

##   Tipos de Texto

| Tipo          | Descripción                        | Uso típico  | Ejemplo de valor                 |
| ------------- | ---------------------------------- | ----------- | -------------------------------- |
| `CHAR(2)`     | Texto fijo                         | País        | `'PE'`                           |
| `VARCHAR(50)` | Texto limitado                     | Username    | `'kbaltazar'`                    |
| `TEXT`        | Texto libre                        | Descripción | `'Usuario administrador global'` |
| `CITEXT`      | Texto sin distinción de mayúsculas | Email       | `'Admin@AutoGroup.pe'`           |

---

##   Tipos Fecha y Hora

| Tipo          | Descripción       | Uso típico   | Ejemplo de valor         |
| ------------- | ----------------- | ------------ | ------------------------ |
| `DATE`        | Fecha             | Registro     | `2026-02-07`             |
| `TIME`        | Hora              | Horario      | `08:30:00`               |
| `TIMESTAMP`   | Fecha-hora        | Logs locales | `2026-02-07 17:45:10`    |
| `TIMESTAMPTZ` | Fecha-hora con TZ | Auditoría    | `2026-02-07 17:45:10-05` |
| `INTERVAL`    | Duración          | SLA          | `2 days 3 hours`         |

---

##   Booleanos

| Tipo      | Uso   | Ejemplo de valor |
| --------- | ----- | ---------------- |
| `BOOLEAN` | Flags | `true` / `false` |

---

##   UUID y Binarios

| Tipo    | Uso              | Ejemplo de valor                       |
| ------- | ---------------- | -------------------------------------- |
| `UUID`  | IDs distribuidos | `e34c8b6b-ea8c-4d21-aa89-28ef635b3991` |
| `BYTEA` | Binarios         | `\x89504e47`                           |

  Ese UUID **calza perfecto con tu `scimid` de WSO2IS** 😉

---

##   JSON

| Tipo    | Uso              | Ejemplo de valor                        |
| ------- | ---------------- | --------------------------------------- |
| `JSON`  | Datos sin índice | `{"theme":"dark"}`                      |
| `JSONB` | Datos indexables | `{"roles":["ADMIN","OPS"],"lang":"es"}` |

---

##   ENUM

| Tipo   | Uso     | Ejemplo de valor |
| ------ | ------- | ---------------- |
| `ENUM` | Estados | `'ACTIVE'`       |

```sql
'ACTIVE'::user_status
```

---

##   Arreglos

| Tipo     | Uso              | Ejemplo de valor      |
| -------- | ---------------- | --------------------- |
| `INT[]`  | IDs relacionados | `{101,102,103}`       |
| `TEXT[]` | Roles            | `{'ADMIN','FINANCE'}` |


---

##   Tipos de Red

| Tipo      | Uso | Ejemplo de valor    |
| --------- | --- | ------------------- |
| `INET`    | IP  | `192.168.1.10`      |
| `CIDR`    | Red | `192.168.1.0/24`    |
| `MACADDR` | MAC | `08:00:2b:01:02:03` |

---


##   Definidos por Usuario (como los tuyos 👀)

| Tipo             | Uso          | Ejemplo                            |
| ---------------- | ------------ | ---------------------------------- |
| `COMPOSITE TYPE` | Reportes     | `(12,'Juan Perez',45,1200.50,4.7)` |
| `DOMAIN`         | Validaciones | `'admin.global'`                   |
| `CUSTOM TYPE`    | Métricas     | `(route_id, performance)`          |

---

### 🧠 Conexión directa con tu stack

* `UUID` → **scimid / external_id**
* `CITEXT` → username, email
* `JSONB` → atributos LDAP/SCIM extendidos
* `COMPOSITE TYPE` → reportes como `route_performance`
* `NUMERIC` → caja, liquidaciones
