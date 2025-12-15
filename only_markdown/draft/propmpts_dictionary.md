# PROMPT 1 (QUESTION)

### Schema: shared
Aclárame las siguientes preguntas sobre ese diccionario de datos de forma concisa :
- La tabla "company" albergará un único registro o varios. Ya que entiendo puede haber un concesionario (tiene un RUC) y N empresas operadoras q operen en cada ruta autorizada del concesionario. 
- La tabla "concession" no aportará sustancialmente al flujo operativo, administrativo ni financiero, cierto? Así q podría ser opcional para el cliente si decide llenarlo. Y en caso lo llene, este sería un histórico de todas las concesiones q vaya recibiendo ?
- La tabla "concessionaire" es también opcional al igual q "concession" debido a q no impacta significativamente en el resto del flujo? Ya que aún no tengo claro si todas las empresas operadoras se rigen a un concesionario (entiendo q en la teoría deberían pero en la práctica no estoy seguro)
- La tabla "authority" es solo meramente informatica y tampoco impactará en el flujo operativo, administrativo o financierto?
- La entidad "terminal" está siendo tomada como un punto operativo de la ruta pero no hay asociación (FK) con ninguna ruta, eso significa q se está considerando usar o emplear el mismo terminal para N rutas por si se diera el caso? Que sucedería si en la práctica dos empresas operativas  (RUTA 100, RUTA 101) del mismo concesionario o marca buscan personalizar el radio de ese terminal (geofence), el cambio afectaría a ambas empresas, esto podría repercutir en ambas el impacto en caso q también se equivoquen de configurar algo o no?
- La tabla "catalog" sirve para q el administrador de sistemas pueda colocar los menus de la plataforma web en el orden q desee? bríndame un ejemplo sencillo de 3 registros o en markdown su representación visual (corto)
- La tabla "configuration" q función cumplirá? Acaso la misma q catalog ?  bríndame un ejemplo sencillo de 3 registros o en markdown su representación visual (corto)
- El "notification_template" me parece muy bueno, dame un ejemplo de template (registros) de los siguientes tipos : EMAIL, SMS, PUSH, IN_APP. Considerando emplear variables y q el body sea corto y resumido.

# PROMPT 1 (ANSWER)

## Respuestas al Schema `shared`

### **1. Tabla `company`**
**Un único registro por BD.** Dado que es 1 BD por cliente, `company` tiene solo 1 fila representando a la empresa operadora. El modelo soporta 3 escenarios:
- **Escenario 1:** Empresa = Concesionario = Operador (RUC único)
- **Escenario 2:** Concesionario (RUC A) → Empresa Operadora (RUC B) → opera Ruta 101
- **Escenario 3:** Marca "El Rápido" → 3 empresas (RUC A, B, C) → cada una en BD separada

Cada empresa operadora tiene su propia BD con 1 registro en `company`.

---

### **2. Tabla `concession`**
**Correcto, es opcional.** No impacta flujos core (despacho, recaudo, RRHH). Sirve para:
- Cumplimiento normativo/regulatorio
- Reportes a ATU
- Auditorías externas

Sí, es histórico: múltiples filas si la empresa tiene varias concesiones o renovaciones.

---

### **3. Tabla `concessionaire`**
**Opcional también.** Solo relevante si `company` ≠ `concessionaire`. En la práctica:
- Empresas pequeñas: misma entidad → tabla vacía
- Consorcios: concesionario distinto → 1 registro

No afecta operaciones diarias.

---

### **4. Tabla `authority`**
**Correcta, solo referencial.** No impacta flujos operativos. Utilidad:
- Saber a quién reportar (ATU, Municipalidad)
- Datos de contacto para coordinaciones
- Opcional rellenarla

---

### **5. Tabla `terminal` sin FK a `route`**
**Intencional: 1 terminal → N rutas.** Ejemplo:
- Terminal "Av. Grau" usado por Ruta 100, 101, 102
- Geocerca única compartida entre todas

**Problema identificado correctamente:**
- Si Ruta 100 cambia radio de 50m → 80m, afecta a Ruta 101 también
- Solución: Crear tabla intermedia `route_terminal` con radio personalizado por ruta

**Ajuste recomendado:**
```sql
route_terminal (
  route_id, 
  terminal_id, 
  custom_geofence_radius_meters  -- override del radio base
)
```

---

### **6. Tabla `catalog`**
**No es para menús UI.** Es para listas dinámicas tipo enum. Ejemplo:

| catalog_id | category | code | name | display_order |
|------------|----------|------|------|---------------|
| 1 | vehicle_status | ACTIVE | Activo | 1 |
| 2 | vehicle_status | MAINTENANCE | En Mantenimiento | 2 |
| 3 | trip_status | IN_PROGRESS | En Curso | 1 |

**Uso:** Evita crear tabla por cada enum (estados, tipos, categorías).

---

### **7. Tabla `configuration`**
**Parámetros técnicos del sistema.** Ejemplo:

| config_key | config_value | data_type | description |
|------------|--------------|-----------|-------------|
| GPS_SYNC_INTERVAL_SECONDS | 30 | INTEGER | Intervalo transmisión GPS |
| MAX_SPEED_ALERT_KMH | 90 | INTEGER | Velocidad máxima antes de alerta |
| ENABLE_AUTOMATIC_DISPATCH | true | BOOLEAN | Despacho automático habilitado |

**Diferencia con `catalog`:**
- `catalog`: listas de valores (dropdowns)
- `configuration`: parámetros operativos del sistema

---

### **8. Tabla `notification_template`**

#### **EMAIL**
```
code: DOCUMENT_EXPIRING_EMAIL
subject: Documento por vencer - {{document_type}}
body: 
Estimado {{driver_name}},

Su {{document_type}} vence el {{expiry_date}}. 
Renuévelo antes de {{deadline_date}}.

Saludos,
Sistema de Transporte
```

#### **SMS**
```
code: DISPATCH_AUTHORIZED_SMS
body: 
{{driver_name}}, su despacho fue autorizado. 
Ruta {{route_code}} - Salida {{scheduled_time}}
```

#### **PUSH**
```
code: RESTRICTION_APPLIED_PUSH
body:
  Restricción aplicada
{{restriction_reason}}
Contacte a su supervisor.
```

#### **IN_APP**
```
code: PAYMENT_PROCESSED_INAPP
body:
  Liquidación procesada
Monto: S/ {{net_amount}}
Ref: {{settlement_id}}
```

**Variables disponibles:** definidas en columna `variables` (JSONB):
```json
["driver_name", "document_type", "expiry_date", "route_code", ...]
```

---

# PROMPT 2 (QUESTION)

Analicemos q cambios se deberían hacer considerando estas aclaraciones : 
- La tabla company debe poder permitir registrar N empresas operadoras q puedan estar asociadas a un mismo concesionario o marca, con esto se entiende q puedan haber los siguientes escenarios :
```md
CONCESIONARIO (Consorcio – RUC propio)
 └── RUTA 101
 │     ├── Empresa A (RUC A)
 └── RUTA 102
 │     └── Empresa B (RUC B)
```
```md
MARCA COMERCIAL: "EVIFASA"
└── Empresa A (RUC A) → Ruta 101
└── Empresa A (RUC A) → Ruta 102
└── Empresa A (RUC A) → Ruta 103
```
- Estaría bien q use los terminales como puntos compartidos entre N rutas o mejor debería tener un terminal propio para cada ruta y no compartirlo, ya q así de esa forma también me evito problemas por si la Ruta 101 y 102  q comparten el mismo terminal no haya problemas por si modifican la ubicación. O crees q este cambio al momento de registrar salidas de almacen puedan generar confusión por tener multiples terminales (de darse el caso) con el mismo nombre pero con ruta distinta cuando se quiera suministrar talonarios de boletos?


# PROMPT 2 (ANSWER)

## Impactos Estructurales y Soluciones

### **1. Tabla `company` → N empresas**

**Problema:** Modelo actual asume 1 BD = 1 empresa. Tus escenarios requieren múltiples empresas en misma BD.

**Solución: Arquitectura Multitenancy**

```sql
-- shared schema
company (
  company_id SERIAL PRIMARY KEY,
  tax_id VARCHAR(20) UNIQUE NOT NULL,  -- RUC único
  legal_name VARCHAR(255) NOT NULL,
  concessionaire_id INT FK → concessionaire,  -- opcional
  brand_name VARCHAR(255),  -- "EVIFASA"
  is_active BOOLEAN DEFAULT true
)

route (
  route_id SERIAL PRIMARY KEY,
  company_id INT NOT NULL FK → company,  -- CRÍTICO: FK obligatorio
  code VARCHAR(20) NOT NULL,
  ...
)
```

**Impacto en TODAS las tablas core:**
- Agregar `company_id` a: `vehicle`, `driver`, `dispatch`, `settlement`, `trip`, etc.
- Agregar índice: `CREATE INDEX idx_vehicle_company ON vehicle(company_id)`
- Row Level Security (RLS): usuarios solo ven su empresa

**Decisión arquitectónica:**
- **Opción A (Recomendada):** 1 BD = N empresas + RLS por company_id
- **Opción B:** Mantener 1 BD = 1 empresa (arquitectura actual)

Si eliges **Opción A**, necesitas:
1. `company_id` en ~40 tablas
2. Políticas RLS en PostgreSQL
3. Filtros por company_id en TODAS las queries

---

### **2. Terminales: ¿Compartidos o dedicados?**

**Análisis:**

| Criterio | Terminales Compartidos | Terminales Dedicados |
|----------|----------------------|---------------------|
| **Flexibilidad** |   Reutilización |   Duplicación |
| **Configuración** |   Cambio afecta N rutas |   Independiente |
| **UI Suministro** |   Confusión (mismo nombre) |   Claro por ruta |
| **Mantenimiento** |   Menos registros |   Más registros |

**Solución Híbrida Recomendada:**

```sql
terminal (
  terminal_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(20) UNIQUE,  -- "TERMINAL-GRAU"
  latitude DECIMAL(10,8) NOT NULL,
  longitude DECIMAL(11,8) NOT NULL,
  -- Sin FK a route, compartible
)

route_terminal (
  route_terminal_id SERIAL PRIMARY KEY,
  route_id INT NOT NULL FK → route,
  terminal_id INT NOT NULL FK → terminal,
  side_code VARCHAR(1) NOT NULL,  -- 'A' o 'B'
  custom_geofence_radius_meters INT,  -- override opcional
  display_name VARCHAR(255),  -- "Terminal Grau - Ruta 101"
  is_active BOOLEAN DEFAULT true,
  UNIQUE(route_id, side_code)
)
```

**Beneficios:**
-   Terminal físico compartido (ubicación única)
-   Configuración independiente por ruta (radio, nombre display)
-   UI de suministro muestra: "Terminal Grau - Ruta 101" (sin confusión)
-   Cambiar radio en Ruta 101 NO afecta Ruta 102

**Ajustes necesarios:**
- `dispatch_queue.terminal_id` → `route_terminal_id`
- `dispatch.terminal_id` → `route_terminal_id`
- `trip.start_terminal_id` → `start_route_terminal_id`

---

## **Recomendación Final**

**Arquitectura sugerida:**
1. **Multitenancy:** `company_id` en tablas core + RLS
2. **Terminales híbridos:** Tabla intermedia `route_terminal`

**Script de migración necesario:**
- Agregar columna `company_id` a ~40 tablas
- Crear tabla `route_terminal`
- Refactorizar FKs de `terminal_id` → `route_terminal_id`

¿Procedo con el DDL actualizado incluyendo estos cambios?

---

# PROMPT 3 (QUESTION)
- Primero, mapeemos los cambios y sus razones detrás de ello, considero q si debería realizarse : "1 BD = N empresas + RLS por company_id". Estás considerando agregar el "company_id" a muchas tablas operativas y demás, porque estás considerando aplicar el RLS y eso ayudaría a q un usuario de una compañía q cubre la ruta "RUTA 100" , no pueda ver los datos de la ruta "RUTA 101"? Que sucedería si, si le permitiese por acuerdo a un cliente q algunos usuarios (cajeros o jefe de operaciones) puedan ver el estado de las demás rutas?
- Segundo, considero q los terminales deben ser independientes y no deben ser compartidos (ni siquiera como estilo híbrido), estos terminales pueden estar referenciados FK a una ruta en concreto y no a otros más.


# PROMPT 3 (QUESTION)
Perfecto, me agradó el middleware de "Validación con Redis" con su función "checkCompanyPermission()" para funciones de edición INSERT, UPDATE, DELETE y el mencionar q para las querys de PGSQL se agregue en cada "where" el atributo "company_id" para restringir alcances.
Y también me agradó la forma de procesar las lecturas (GET) considerando el alcance por empresas y permisos granulares como indicaste en "Endpoint que respeta permisos de lectura". Ahora tocó el momento de documentar como se vería la tabla con sus registros en pgsql y luego como con redis como CACHE se sincronice por un tiempo de "N" minutos para q las APIS a través de dos middleware puedan procesar las solicitudes (el lenguaje será java y el framework springboot) q entiendo podrían ser :
- MIDDLEWARE DE LECTURA
- MIDDLEWARE DE ESCRITURA 
Ambos verifican permisos granulares y si tienen acceso en determinada "company", pero se diferencian en q el middleware de lectura no detendrá el flujo con un 403 por si se quieren listar todas las liquidaciones pero tuviera acceso solo a una empresa y no a todas (caso de maría) se le retornaría la data q espera como si fueran TODAS y solo se rompería el flujo con un 403 por sino tuviera como mínimo un permiso de lectura de alguna "company" (en java se conoce como un "at least one" para q no rompa el flujo). Sin embargo, en el middleware de escritura siempre se realizará una acción por "company", así q ahí siempre deberá tener ese permiso de escritura en la "company" determinada . Documentemoslo a alto nivel explicando este flujo y si tienes alguna observación planteala

```sql
-- user_company_access
user_id | company_id
--------|------------
10      | 100          -- Juan
10      | 101
20      | 100          -- María
30      | 100          -- Carlos
30      | 101

-- user_permission
user_id | permission_code              | company_id
--------|------------------------------|------------
10      | operations.gps.read          | 100
10      | operations.gps.read          | 101
20      | finance.settlement.read      | 100
20      | finance.settlement.update    | 100
30      | finance.settlement.read      | 100
30      | finance.settlement.update    | 100
30      | finance.settlement.read      | 101
30      | finance.settlement.update    | 101

-- settlement (liquidaciones)
settlement_id | company_id | driver_id | net_amount
--------------|------------|-----------|------------
500           | 100        | 45        | 150.00
501           | 101        | 78        | 200.00
```

# PROMPT 4 (ANSWER)

# Arquitectura de Permisos Granulares - Spring Boot

## 0. Autenticación con permisos granulares y multiteniente

```sql
-- user_company_access
user_id | company_id
--------|------------
10      | 100          -- Juan
10      | 101
20      | 100          -- María
30      | 100          -- Carlos
30      | 101

-- user_permission
user_id | permission_code              | company_id
--------|------------------------------|------------
10      | operations.gps.read          | 100
10      | operations.gps.read          | 101
20      | finance.settlement.read      | 100
20      | finance.settlement.update    | 100
30      | finance.settlement.read      | 100
30      | finance.settlement.update    | 100
30      | finance.settlement.read      | 101
30      | finance.settlement.update    | 101

-- settlement (liquidaciones)
settlement_id | company_id | driver_id | net_amount
--------------|------------|-----------|------------
500           | 100        | 45        | 150.00
501           | 101        | 78        | 200.00
```

## 1. Modelo de Datos PostgreSQL

```sql
-- Tabla de acceso base (usuario puede ver empresas)
CREATE TABLE user_company_access (
  user_id BIGINT NOT NULL,
  company_id BIGINT NOT NULL,
  PRIMARY KEY (user_id, company_id)
);

-- Permisos granulares por empresa
CREATE TABLE user_permission (
  user_id BIGINT NOT NULL,
  company_id BIGINT NOT NULL,
  permission_code VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (user_id, company_id, permission_code),
  FOREIGN KEY (user_id, company_id) 
    REFERENCES user_company_access(user_id, company_id)
);

CREATE INDEX idx_user_permission_lookup 
  ON user_permission(user_id, permission_code);
```

**Datos de ejemplo:**
```sql
-- María (user_id=20): solo empresa 100, read + update
INSERT INTO user_company_access VALUES (20, 100);
INSERT INTO user_permission VALUES 
  (20, 100, 'finance.settlement.read'),
  (20, 100, 'finance.settlement.update');

-- Carlos (user_id=30): empresas 100 y 101, read + update en ambas
INSERT INTO user_company_access VALUES (30, 100), (30, 101);
INSERT INTO user_permission VALUES 
  (30, 100, 'finance.settlement.read'),
  (30, 100, 'finance.settlement.update'),
  (30, 101, 'finance.settlement.read'),
  (30, 101, 'finance.settlement.update');
```

---

## 2. Caché Redis - Estructura

```java
// Key pattern: "perms:{userId}"
// TTL: 10 minutos
// Valor JSON:
{
  "byCompany": {
    "100": ["finance.settlement.read", "finance.settlement.update"],
    "101": ["finance.settlement.read"]
  },
  "allPermissions": ["finance.settlement.read", "finance.settlement.update"]
}
```

**Servicio de caché:**
```java
@Service
public class PermissionCacheService {
    
    @Autowired
    private RedisTemplate<String, String> redis;
    
    @Autowired
    private PermissionRepository permRepo;
    
    public UserPermissions getPermissions(Long userId) {
        String key = "perms:" + userId;
        String cached = redis.opsForValue().get(key);
        
        if (cached != null) {
            return objectMapper.readValue(cached, UserPermissions.class);
        }
        
        // Query PostgreSQL
        List<PermissionEntity> perms = permRepo.findByUserId(userId);
        UserPermissions userPerms = mapToUserPermissions(perms);
        
        // Cache 10 minutos
        redis.opsForValue().set(key, 
            objectMapper.writeValueAsString(userPerms), 
            10, TimeUnit.MINUTES);
        
        return userPerms;
    }
    
    public void invalidate(Long userId) {
        redis.delete("perms:" + userId);
    }
}
```

---

## 3. Middleware de Lectura (Filter)

**Filosofía:** "At least one" - permite lectura si tiene acceso a *cualquier* empresa.

```java
@Component
@Order(1)
public class ReadPermissionFilter implements Filter {
    
    @Autowired
    private PermissionCacheService permCache;
    
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        
        // Solo aplica a GET requests
        if (!"GET".equals(request.getMethod())) {
            chain.doFilter(req, res);
            return;
        }
        
        Long userId = extractUserIdFromJWT(request);
        String requiredPermission = extractPermissionFromPath(request); 
        // Ej: /settlements → "finance.settlement.read"
        
        UserPermissions perms = permCache.getPermissions(userId);
        
        // Obtener empresas donde tiene el permiso
        Set<Long> readableCompanies = perms.getCompaniesWith(requiredPermission);
        
        if (readableCompanies.isEmpty()) {
            // Sin acceso a ninguna empresa → 403
            ((HttpServletResponse) res).sendError(403, 
                "No read access to any company");
            return;
        }
        
        // HttpServletRequest request soporta la inyección de atributos también
        // Inyectar scope en request para el controller
        request.setAttribute("readableCompanies", readableCompanies);
        chain.doFilter(req, res);
    }
}
```

**Controller usa el scope:**
```java
@GetMapping("/settlements")
public List<Settlement> list(HttpServletRequest request) {
    @SuppressWarnings("unchecked")
    Set<Long> companies = (Set<Long>) request.getAttribute("readableCompanies");
    
    // Query automáticamente filtrado
    return settlementRepo.findByCompanyIdIn(companies);
}
```

**Query JPA:**
```java
@Query("SELECT s FROM Settlement s WHERE s.companyId IN :companies")
List<Settlement> findByCompanyIdIn(@Param("companies") Set<Long> companies);
```

---

## 4. Middleware de Escritura (Interceptor)

**Filosofía:** Validación estricta - requiere permiso en la empresa específica de la operación.

```java
@Component
public class WritePermissionInterceptor implements HandlerInterceptor {
    
    @Autowired
    private PermissionCacheService permCache;
    
    @Override
    public boolean preHandle(HttpServletRequest request, 
                            HttpServletResponse response, 
                            Object handler) throws Exception {
        
        String method = request.getMethod();
        if ("GET".equals(method)) {
            return true; // Skip para lecturas
        }
        
        Long userId = extractUserIdFromJWT(request);
        Long companyId = extractCompanyIdFromRequest(request); 
        // Del body/params
        
        if (companyId == null) {
            response.sendError(400, "company_id required");
            return false;
        }
        
        String permission = mapMethodToPermission(method, request.getRequestURI());
        // POST → "settlement.create"
        // PUT → "settlement.update"
        // DELETE → "settlement.delete"
        
        UserPermissions perms = permCache.getPermissions(userId);
        
        if (!perms.hasPermissionInCompany(permission, companyId)) {
            response.sendError(403, 
                String.format("No '%s' permission in company %d", 
                    permission, companyId));
            return false;
        }
        // HttpServletRequest request soporta la inyección de atributos también
        // request.setAttribute("readableCompanies", readableCompanies);

        
        return true;
    }
}
```

**Controller con validación implícita:**
```java
@PutMapping("/settlements/{id}")
public Settlement update(@PathVariable Long id, @RequestBody SettlementDTO dto) {
    // companyId viene en dto.companyId
    // El interceptor ya validó el permiso
    
    // Query con restricción adicional por seguridad
    Settlement settlement = settlementRepo
        .findByIdAndCompanyId(id, dto.getCompanyId())
        .orElseThrow(() -> new NotFoundException());
    
    settlement.setStatus(dto.getStatus());
    return settlementRepo.save(settlement);
}
```

---

## 5. Flujo Completo - Ejemplos

### Caso 1: María lista liquidaciones (GET)
```
1. Request: GET /settlements
2. ReadPermissionFilter:
   - userId=20 → companies con "settlement.read" = [100]
   - Inyecta readableCompanies=[100]
3. Controller:
   - Query: WHERE company_id IN (100)
   - Response: [settlement_500]  
```

### Caso 2: María intenta actualizar settlement_501 (PUT)
```
1. Request: PUT /settlements/501 { companyId: 101 }
2. WritePermissionInterceptor:
   - userId=20, companyId=101, permission="settlement.update"
   - perms.byCompany[101] → null
   - Response: 403 Forbidden  
```

### Caso 3: Carlos actualiza settlement_500 (PUT)
```
1. Request: PUT /settlements/500 { companyId: 100 }
2. WritePermissionInterceptor:
   - userId=30, companyId=100, permission="settlement.update"
   - perms.byCompany[100].includes("settlement.update") → true
   - Permite continuar  
3. Controller:
   - Query: WHERE id=500 AND company_id=100
   - Update exitoso  
```

### Caso 4: Juan intenta listar liquidaciones (GET)
```
1. Request: GET /settlements
2. ReadPermissionFilter:
   - userId=10 → companies con "settlement.read" = []
   - Response: 403 "No read access"  
```

---

## 6. Observaciones Críticas

###   Extracción de company_id en escritura
```java
// Para POST/PUT con body JSON
Long companyId = objectMapper.readTree(request.getInputStream())
    .get("company_id").asLong();

// Para operaciones sobre recursos existentes (DELETE, PATCH)
Long companyId = settlementRepo.findById(id)
    .map(Settlement::getCompanyId)
    .orElse(null);
```

###   Queries siempre con company_id
```java
//   MALO - vulnerable
settlementRepo.findById(id);

//   BUENO - doble validación
settlementRepo.findByIdAndCompanyId(id, companyId);
```

###   Invalidación de caché
```java
@Transactional
public void updatePermissions(Long userId) {
    permissionRepo.save(...);
    permCache.invalidate(userId); // Crítico
}
```

###   Logging para auditoría
```java
log.info("Permission check: user={}, company={}, permission={}, result={}", 
    userId, companyId, permission, hasAccess);
```

---




### Schema: core_operations

# PROMPT 5 (QUESTION)

Que sentido tiene la tabla checkpoint : 
Campo	Tipo	Restricciones	Descripción
checkpoint_id	SERIAL	PRIMARY KEY	Identificador único
route_id	INT	NOT NULL, FK → route	Ruta asociada
name	VARCHAR(255)	NOT NULL	Nombre del control
latitude	DECIMAL(10,8)	NOT NULL	Latitud GPS
longitude	DECIMAL(11,8)	NOT NULL	Longitud GPS
geofence_radius_meters	INT	DEFAULT 50	Radio de detección
sequence_order	INT	NOT NULL	Orden en recorrido
direction	VARCHAR(20)		IDA, VUELTA, BOTH
min_time_minutes	INT		Tiempo mínimo esperado
max_time_minutes	INT		Tiempo máximo esperado
is_critical	BOOLEAN	DEFAULT false	Control crítico
is_active	BOOLEAN	DEFAULT true	Control operativo
created_at	TIMESTAMPTZ	DEFAULT NOW()	Fecha de creación
updated_at	TIMESTAMPTZ	DEFAULT NOW()	Última actualización

Acaso no va usarse en cada despacho de una unidad , los paraderos programados ? 

---
La tabla route side servirá para identificar el lado del recorrido en el q se encuentra la unidad ? (util si es lineal, si es circular no tanto) ya q sin esta tabla no podría identificar el lado del recorrido de la unidad, cierto?

21. route_side (Revisar si es necesario)
Descripción: Lados de ruta (Lado A / Lado B) para rutas lineales. Define terminal de origen/destino por dirección de recorrido.

Campo	Tipo	Restricciones	Descripción
route_side_id	SERIAL	PRIMARY KEY	Identificador único
route_id	INT	NOT NULL, FK → route	Ruta asociada
side_code	VARCHAR(1)	NOT NULL	A, B
terminal_id	INT	NOT NULL, FK → terminal	Terminal del lado
direction_name	VARCHAR(100)		Nombre dirección (IDA, VUELTA)
is_active	BOOLEAN	DEFAULT true	Lado operativo
created_at	TIMESTAMPTZ	DEFAULT NOW()	Fecha de creación

---

Un geofence es el punto de coordenada q luego se convertirá en paradero o q diferencia hay entre "geofence" y "stop"

# PROMPT 5 (ANSWER)

## Aclaraciones Estructurales

### **1. `checkpoint` vs `stop` (paraderos)**

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

---

### **2. `route_side` - ¿Necesaria?**

**Análisis:**

**Caso Ruta Lineal:**
- Terminal A (Ate) ↔ Terminal B (Callao)
- IDA: A→B, VUELTA: B→A
- Despacho indica: "Salida desde Terminal A, lado A"

**Sin `route_side`:**
```sql
dispatch (
  terminal_id INT,  -- ¿Terminal A o B?
  direction VARCHAR  -- ¿IDA o VUELTA?
)
```

**Con `route_side`:**
```sql
route_side (
  route_id=100, side_code='A', terminal_id=Terminal_Ate, direction_name='IDA'
  route_id=100, side_code='B', terminal_id=Terminal_Callao, direction_name='VUELTA'
)

dispatch (
  route_side_id INT  -- implícitamente indica terminal + dirección
)
```

**Recomendación:** **Eliminar `route_side`**, simplificar:

```sql
-- terminal ya tiene side_code
terminal (
  route_id INT,
  side_code VARCHAR(1),  -- 'A' o 'B'
  ...
)

-- dispatch referencia directamente
dispatch (
  terminal_id INT,  -- implica route_id + side_code
  ...
)
```

**Beneficio:** 1 tabla menos, mismo resultado.

---

### **3. `geofence` vs `stop`**

**Relación:**

```
geofence (geometría base)
   ↓ es usado por
stop, checkpoint, terminal, speed_zone
```

**Diferencias:**

| Tabla | Propósito | Geometría |
|-------|-----------|-----------|
| `geofence` | Área geográfica genérica | Polígono, círculo, corredor |
| `stop` | Paradero específico + geofence | Círculo (radio fijo) |

**Modelo simplificado (recomendado):**

**Opción A - Sin tabla `geofence` separada:**
```sql
stop (
  stop_id, route_id, latitude, longitude, 
  geofence_radius_meters  -- geometría propia
)

checkpoint (
  checkpoint_id, route_id, latitude, longitude,
  geofence_radius_meters  -- geometría propia
)
```

**Opción B - Con `geofence` compartida:**
```sql
geofence (
  geofence_id, geometry_json, geofence_type
)

stop (
  stop_id, route_id, geofence_id  -- referencia compartida
)
```

**Recomendación:** **Opción A** (sin `geofence` separada). Paraderos y checkpoints tienen geometría simple (círculos), no necesitan tabla genérica.

---

## Resumen de Cambios

1. ✅ **Mantener `checkpoint`** - validación de tiempos
2. ❌ **Eliminar `route_side`** - redundante con `terminal.side_code`
3. ❌ **Eliminar `geofence` genérica** - geometrías simples en cada tabla


---


# PROMPT 6 (QUESTION)

hablemos de la tabla geofence, si estoy de acuerdo en q debería quitarla para solo usar stops y checkpoints con su propio atributo de coordenadas. sin embargo, analicemos las tablas q había diseñado tiempo atrás para ver si las quito o las reestructuramos : 


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

### **25. geofence**

**Descripción:** Geocercas del sistema (rutas, paraderos, terminales, zonas prohibidas). Define áreas geográficas para validaciones automáticas en tiempo real.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| geofence_id | SERIAL | PRIMARY KEY | Identificador único |
| geofence_type_id | INT | NOT NULL, FK → geofence_type | Tipo de geocerca |
| route_id | INT | FK → route | Ruta asociada (opcional) |
| name | VARCHAR(255) | NOT NULL | Nombre de la geocerca |
| description | TEXT | | Descripción detallada |
| geometry_type | VARCHAR(20) | NOT NULL | CIRCLE, POLYGON, CORRIDOR |
| coordinates_json | JSONB | NOT NULL | Definición geométrica |
| radius_meters | INT | | Radio (para CIRCLE) |
| buffer_meters | INT | | Ancho corredor (para CORRIDOR) |
| is_active | BOOLEAN | DEFAULT true | Geocerca activa |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Última actualización |

---

### **26. geofence_type**

**Descripción:** Catálogo de tipos de geocercas con comportamiento esperado. Define qué eventos se generan al entrar/salir de cada tipo.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| geofence_type_id | SERIAL | PRIMARY KEY | Identificador único |
| code | VARCHAR(50) | UNIQUE, NOT NULL | Código (ROUTE, STOP, TERMINAL, FORBIDDEN) |
| name | VARCHAR(100) | NOT NULL | Nombre del tipo |
| description | TEXT | | Descripción del comportamiento |
| trigger_on_entry | BOOLEAN | DEFAULT true | Generar evento al entrar |
| trigger_on_exit | BOOLEAN | DEFAULT true | Generar evento al salir |
| alert_severity | VARCHAR(20) | | INFO, WARNING, CRITICAL |
| is_active | BOOLEAN | DEFAULT true | Tipo activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

---

### **27. geofence_event**

**Descripción:** Eventos de entrada/salida de geocercas detectados por GPS. Registra timestamp, ubicación y duración de permanencia en cada área.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| event_id | BIGSERIAL | PRIMARY KEY | Identificador único |
| geofence_id | INT | NOT NULL, FK → geofence | Geocerca afectada |
| vehicle_id | INT | NOT NULL | Vehículo que generó evento |
| trip_id | BIGINT | FK → trip | Viaje asociado (opcional) |
| event_type | VARCHAR(20) | NOT NULL | ENTRY, EXIT |
| latitude | DECIMAL(10,8) | NOT NULL | Latitud del evento |
| longitude | DECIMAL(11,8) | NOT NULL | Longitud del evento |
| speed_kmh | DECIMAL(5,2) | | Velocidad al momento |
| event_timestamp | TIMESTAMPTZ | NOT NULL | Timestamp del evento |
| duration_seconds | INT | | Duración dentro (para EXIT) |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de registro |

**Particionada por:** event_timestamp (mensual)

# PROMPT 6 (ANSWER)

Propuesta de Reestructuración
Eliminar:

❌ geofence (genérica innecesaria)
❌ geofence_type (redundante)
❌ geofence_event (reemplazar por eventos específicos)

Mantener y ajustar:

✅ stop (paraderos con geometría propia)
✅ checkpoint (controles de tiempo)
✅ speed_zone (zonas de velocidad)


## Diccionario de Datos - Eventos Específicos

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

**Particionada por:** event_timestamp (mensual)

**Índices:**
```sql
CREATE INDEX idx_stop_event_stop ON stop_event(stop_id);
CREATE INDEX idx_stop_event_vehicle ON stop_event(vehicle_id);
CREATE INDEX idx_stop_event_trip ON stop_event(trip_id);
CREATE INDEX idx_stop_event_timestamp ON stop_event(event_timestamp);
```

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

**Particionada por:** event_timestamp (mensual)

**Índices:**
```sql
CREATE INDEX idx_checkpoint_event_checkpoint ON checkpoint_event(checkpoint_id);
CREATE INDEX idx_checkpoint_event_vehicle ON checkpoint_event(vehicle_id);
CREATE INDEX idx_checkpoint_event_trip ON checkpoint_event(trip_id);
CREATE INDEX idx_checkpoint_event_timestamp ON checkpoint_event(event_timestamp);
```

---

## Sobre `speed_zone_violation` vs `alert`

**Tienes razón**, `alert` cubre ese caso. Pero considera:

**Opción A:** Solo `alert` con `context_data`:
```json
{
  "alert_type": "SPEED_VIOLATION",
  "speed_zone_id": 5,
  "recorded_speed": 95,
  "max_allowed": 60,
  "excess": 35,
  "location": {"lat": -12.0463, "lon": -77.0428}
}
```

**Opción B:** Tabla específica + referencia en `alert`:
- Ventaja: Queries analíticas más simples (agregaciones, historial)
- Desventaja: Más tablas

**Recomendación:** Mantener solo `alert` si no necesitas análisis detallado de velocidades. Si quieres reportes tipo "Top 10 zonas con más violaciones" o "Promedio de exceso de velocidad por conductor", considera tabla específica.


---

# PROMPT 7 (QUESTION)
háblame un poco de esta tabla , porque no la capto bien en como llenarla y usarla para validaciones de salidas :

operational_restriction
Descripción: Restricciones operativas aplicadas a conductores o vehículos. Bloquean despacho hasta resolución (documentos vencidos, deuda, mantenimiento).

Campo	Tipo	Restricciones	Descripción
restriction_id	BIGSERIAL	PRIMARY KEY	Identificador único
restriction_type_id	INT	NOT NULL, FK → restriction_type	Tipo de restricción
company_id	INT	NOT NULL, FK → company	Empresa operadora
entity_type	VARCHAR(20)	NOT NULL	DRIVER, VEHICLE
entity_id	BIGINT	NOT NULL	ID del conductor o vehículo
severity	VARCHAR(20)	NOT NULL	CRITICAL, WARNING, INFO
reason	TEXT	NOT NULL	Motivo de la restricción
applied_by	BIGINT	FK → user	Usuario que aplicó
applied_at	TIMESTAMPTZ	DEFAULT NOW()	Fecha de aplicación
expires_at	TIMESTAMPTZ		Vencimiento automático
resolved_at	TIMESTAMPTZ		Fecha de resolución
resolved_by	BIGINT	FK → user	Usuario que resolvió
resolution_notes	TEXT		Notas de resolución
is_active	BOOLEAN	DEFAULT true	Restricción vigente


# PROMPT 7 (ANSWER)

## `operational_restriction` - Explicación

### **Propósito**
Bloquear despacho de conductor/vehículo por problemas pendientes.

### **Flujo de Uso**

**1. Creación automática (sistema)**
```sql
-- Licencia vence en 5 días → restricción WARNING
INSERT INTO operational_restriction (
  restriction_type_id, company_id, entity_type, entity_id,
  severity, reason, applied_by
) VALUES (
  1, -- tipo: DOCUMENT_EXPIRING
  100, 
  'DRIVER', 
  45, -- driver_id
  'WARNING',
  'Licencia vence 10/12/2024',
  NULL  -- sistema automático
);

-- Licencia vencida → restricción CRITICAL
UPDATE operational_restriction SET severity = 'CRITICAL' 
WHERE entity_type = 'DRIVER' AND entity_id = 45;
```

**2. Creación manual (supervisor)**
```sql
-- Deuda pendiente
INSERT INTO operational_restriction VALUES (
  2, -- tipo: DEBT
  100,
  'DRIVER',
  45,
  'WARNING',
  'Deuda S/ 300 por multas',
  user_id_supervisor
);
```

**3. Validación en despacho**
```sql
-- Backend verifica antes de autorizar salida
SELECT COUNT(*) FROM operational_restriction 
WHERE entity_type = 'DRIVER' 
  AND entity_id = 45 
  AND severity = 'CRITICAL'
  AND is_active = true
  AND (expires_at IS NULL OR expires_at > NOW());

-- Si COUNT > 0 → Bloquear despacho
-- Si severity = WARNING → Permitir con autorización supervisor
```

**4. Resolución**
```sql
-- Conductor renovó licencia
UPDATE operational_restriction 
SET is_active = false,
    resolved_at = NOW(),
    resolved_by = user_id_rrhh,
    resolution_notes = 'Licencia renovada hasta 2027'
WHERE restriction_id = 123;
```

### **Casos de Uso**

| Tipo | Severity | Acción |
|------|----------|--------|
| Licencia vence en 7 días | WARNING | Despachar con alerta |
| Licencia vencida | CRITICAL | Bloquear despacho |
| SOAT vencido | CRITICAL | Bloquear vehículo |
| Deuda < S/ 500 | WARNING | Despachar con alerta |
| Deuda > S/ 500 | CRITICAL | Bloquear hasta pago |
| Mantenimiento pendiente | WARNING | Recordatorio |

### **Ventajas**
- ✅ Historial completo (quién aplicó/resolvió)
- ✅ Restricciones con expiración automática
- ✅ Múltiples restricciones simultáneas
- ✅ Auditoría de resoluciones

---

# PROMPT 8 (QUESTION)
# PROMPT 8 (ANSWER)