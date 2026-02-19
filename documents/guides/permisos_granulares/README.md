## 🎯 Análisis de tu dilema

**Tu preocupación es válida:** validar scopes granulares a nivel de endpoint crearía una explosión de APIs.

---

## Estrategia Recomendada: Validación en Capas

### **Capa 1: AOP - Rol + Permiso (obligatorio)**
```java
@PreAuthorize("hasPermission('ROUTE_VIEW')")
@GetMapping("/routes")
public List<Route> getRoutes(@RequestParam Long companyId) {
    // El scope se valida DENTRO del servicio
}
```

### **Capa 2: Service - Scope dinámico**
```java
@Service
public class RouteService {
    
    public List<Route> getRoutes(Long userId, Long companyId) {
        // 1. Obtener scopes del usuario desde cache/DB
        List<Long> allowedRouteIds = scopeService.getUserScopes(
            userId, 
            "ROUTE_VIEW", 
            companyId
        );
        
        // 2. Aplicar filtro dinámico
        if (allowedRouteIds.isEmpty()) {
            return Collections.emptyList();
        }
        
        if (allowedRouteIds.contains(null)) {
            // NULL = company-wide
            return routeRepository.findByCompanyId(companyId);
        }
        
        // Scope específico
        return routeRepository.findByIdInAndCompanyId(allowedRouteIds, companyId);
    }
}
```

---

##  Comparación de Estrategias

| Validación | ¿Dónde? | Ventaja | Desventaja |
|-----------|---------|---------|------------|
| **Solo Rol + Permiso** | AOP | Simple, pocos endpoints | Sin granularidad real |
| **Scope en endpoint** | AOP | Explícito | Explosión de endpoints |
| **Scope en servicio** ✅ | Service layer | Balance perfecto | Requiere disciplina |

---

##  Caso Real: Usuario Operador Ruta 501

```java
// ENDPOINT (solo valida permiso)
@PreAuthorize("hasPermission('DISPATCH_CREATE')")
@PostMapping("/dispatches")
public Dispatch createDispatch(@RequestBody DispatchRequest req) {
    return dispatchService.create(
        SecurityContext.getUserId(), 
        req
    );
}

// SERVICIO (valida scope)
public Dispatch create(Long userId, DispatchRequest req) {
    // Validar scope
    if (!scopeService.hasScope(
        userId, 
        "DISPATCH_CREATE", 
        "ROUTE", 
        req.getRouteId(), 
        req.getCompanyId()
    )) {
        throw new AccessDeniedException("No tiene acceso a esta ruta");
    }
    
    // Lógica de negocio...
}
```

---

##  Optimización: Cache de Permisos

```java
@Cacheable(value = "userScopes", key = "#userId + '_' + #permissionCode + '_' + #companyId")
public List<Long> getUserScopes(Long userId, String permissionCode, Long companyId) {
    return scopeRepository.findUserScopes(userId, permissionCode, companyId);
}
```

**TTL recomendado:** 15-30 minutos

---

##  Respuesta Directa a tu Pregunta

**¿Solo validar rol + permiso sin scopes?**

 **NO** - Perderías el valor principal del modelo que diseñaste

 **SÍ** - Valida rol + permiso en AOP, **scopes en capa de servicio**

---

##  Regla de Oro

```
AOP → "¿Puede HACER esta acción?"
Service → "¿Puede hacerla sobre ESTE recurso?"
```

¿Quieres que detalle la implementación del `ScopeService` o estrategias de cache?

---


##  Ejemplos Concretos - Validación en Capas

### **Escenario:**
- 3 empresas (Lima, Arequipa, Cusco)
- 5 rutas por empresa (501-505, 601-605, 701-705)
- Usuario con acceso a 2 rutas específicas por empresa

---

## 1️⃣ **SecurityContext (inyección de datos)**

```java
@Component
public class SecurityContextHolder {
    
    private static final ThreadLocal<SecuredAccessPayload> context = new ThreadLocal<>();
    
    public static void setContext(SecuredAccessPayload payload) {
        context.set(payload);
    }
    
    public static SecuredAccessPayload getContext() {
        return context.get();
    }
    
    public static void clear() {
        context.remove();
    }
}

@Data
@Builder
public class SecuredAccessPayload {
    private Long userId;
    private String username;
    private List<String> permissions;
    private Map<String, List<Long>> scopesByPermission; // "ROUTE_VIEW" -> [501, 502, 601, 602]
}
```

---

## 2️⃣ **AOP - Validación de Permiso + Población de Contexto**

```java
@Aspect
@Component
public class PermissionAspect {
    
    @Autowired
    private PermissionService permissionService;
    
    @Around("@annotation(requiresPermission)")
    public Object checkPermission(ProceedingJoinPoint joinPoint, RequiresPermission requiresPermission) throws Throwable {
        String token = extractToken(); // del header
        String permissionCode = requiresPermission.value();
        
        // 1. Validar que tiene el permiso
        SecuredAccessPayload payload = permissionService.loadUserPermissions(token);
        
        if (!payload.getPermissions().contains(permissionCode)) {
            throw new AccessDeniedException("Missing permission: " + permissionCode);
        }
        
        // 2. Inyectar en ThreadLocal
        SecurityContextHolder.setContext(payload);
        
        try {
            return joinPoint.proceed();
        } finally {
            SecurityContextHolder.clear();
        }
    }
}

// Anotación custom
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface RequiresPermission {
    String value(); // código del permiso
}
```

---

## 3️⃣ **Caso A: Company-Wide (todas las rutas)**

```java
@RestController
@RequestMapping("/api/routes")
public class RouteController {
    
    @Autowired
    private RouteService routeService;
    
    @GetMapping
    @RequiresPermission("ROUTE_VIEW")
    public List<RouteDTO> getRoutes(@RequestParam Long companyId) {
        Long userId = SecurityContextHolder.getContext().getUserId();
        return routeService.getRoutes(userId, companyId);
    }
}

@Service
public class RouteService {
    
    @Autowired
    private RouteRepository routeRepository;
    
    public List<RouteDTO> getRoutes(Long userId, Long companyId) {
        Map<String, List<Long>> scopes = SecurityContextHolder.getContext().getScopesByPermission();
        List<Long> allowedRoutes = scopes.get("ROUTE_VIEW");
        
        // NULL en la lista = company-wide
        if (allowedRoutes.contains(null)) {
            return routeRepository.findByCompanyId(companyId);
        }
        
        // Filtrar por scope_id específico
        List<Long> filteredRoutes = allowedRoutes.stream()
            .filter(Objects::nonNull)
            .collect(Collectors.toList());
            
        if (filteredRoutes.isEmpty()) {
            throw new AccessDeniedException("No routes assigned");
        }
        
        return routeRepository.findByIdInAndCompanyId(filteredRoutes, companyId);
    }
}
```

---

## 4️⃣ **Caso B: Scopes Específicos (2 rutas por empresa)**

**Datos en BD:**
```sql
-- Usuario 3: OPERADOR_RUTA con acceso a rutas específicas
-- Lima: 501, 502
INSERT INTO role_permission_scope (role_permission_id, scope_type_id, scope_id, company_id)
VALUES (38, 1, 501, 1), (38, 1, 502, 1);

-- Arequipa: 601, 602  
INSERT INTO role_permission_scope (role_permission_id, scope_type_id, scope_id, company_id)
VALUES (38, 1, 601, 2), (38, 1, 602, 2);

-- Cusco: 701, 702
INSERT INTO role_permission_scope (role_permission_id, scope_type_id, scope_id, company_id)
VALUES (38, 1, 701, 3), (38, 1, 702, 3);
```

**Servicio:**
```java
public List<RouteDTO> getRoutes(Long userId, Long companyId) {
    Map<String, List<Long>> scopes = SecurityContextHolder.getContext().getScopesByPermission();
    List<Long> allowedRoutes = scopes.get("ROUTE_VIEW");
    
    // Filtrar por compañía actual
    List<Long> routesForCompany = allowedRoutes.stream()
        .filter(Objects::nonNull) // excluir company-wide
        .collect(Collectors.toList());
    
    if (routesForCompany.isEmpty()) {
        return Collections.emptyList();
    }
    
    // Query: WHERE route_id IN (501, 502) AND company_id = 1
    return routeRepository.findByIdInAndCompanyId(routesForCompany, companyId);
}
```

---

## 5️⃣ **Caso C: Crear Despacho (validación específica)**

```java
@PostMapping("/dispatches")
@RequiresPermission("DISPATCH_CREATE")
public DispatchDTO createDispatch(@RequestBody CreateDispatchRequest request) {
    return dispatchService.create(request);
}

@Service
public class DispatchService {
    
    public DispatchDTO create(CreateDispatchRequest request) {
        Map<String, List<Long>> scopes = SecurityContextHolder.getContext().getScopesByPermission();
        List<Long> allowedRoutes = scopes.get("DISPATCH_CREATE");
        
        // Validar que puede despachar en esta ruta específica
        if (!allowedRoutes.contains(null) && !allowedRoutes.contains(request.getRouteId())) {
            throw new AccessDeniedException("Cannot dispatch on route: " + request.getRouteId());
        }
        
        // Lógica de negocio...
        return dispatchRepository.save(dispatch);
    }
}
```

---


---

## 7️⃣ **Repository con Filtro Dinámico**

```java
@Repository
public interface RouteRepository extends JpaRepository<Route, Long> {
    
    List<Route> findByCompanyId(Long companyId);
    
    @Query("SELECT r FROM Route r WHERE r.id IN :routeIds AND r.companyId = :companyId")
    List<Route> findByIdInAndCompanyId(@Param("routeIds") List<Long> routeIds, 
                                        @Param("companyId") Long companyId);
}
```


---

##  Diagrama Mental

```
┌─────────────────────────────────────┐
│  REQUEST: GET /routes?companyId=1   │
└──────────────┬──────────────────────┘
               │
        ┌──────▼──────┐
        │  🛡️  AOP    │  ← P: ¿Tiene ROUTE_VIEW?
        │             │  ← A: Carga permisos+scopes
        │             │  → C: Guarda en ThreadLocal
        └──────┬──────┘
               │
        ┌──────▼──────┐
        │ 🎯 SERVICE  │  ← S: Lee scopes del contexto
        │             │  ← F: Decide: ¿NULL? → todas | sino → filtrar
        └──────┬──────┘
               │
        ┌──────▼──────┐
        │ 💾 REPO     │  ← Q: WHERE route_id IN (501,502) AND company_id=1
        └──────┬──────┘
               │
        ┌──────▼──────┐
        │  RESPONSE   │
        └─────────────┘
```

---

##  Analogía: Discoteca con VIP

```
🚪 PUERTA (AOP)
   ├─ Revisa tu entrada (permiso)
   ├─ Escanea tu pulsera VIP (scopes)
   └─ Te pone un brazalete (ThreadLocal)

🍸 DENTRO (Service)
   ├─ Lees tu brazalete
   └─ Decides: ¿VIP All-Access? → barra completa
              ¿VIP Sección A?   → solo esa zona

🍺 BARRA (Repository)
   └─ Te sirven lo que tu brazalete permite
```

---

## Checklist de Implementación

```
☐ AOP valida permiso existe
☐ AOP carga Map<String, List<Long>> scopes
☐ AOP guarda en ThreadLocal
☐ Service lee contexto
☐ Service aplica lógica:
  ├─ Si tiene NULL → company-wide
  └─ Si tiene IDs → filtrar por esos IDs
☐ Repository ejecuta query filtrada
☐ AOP limpia ThreadLocal (finally)
```

---

##  Regla de Oro en 3 Líneas

```java
// AOP: ¿Puede HACER?
if (!hasPermission("ROUTE_VIEW")) throw AccessDenied;

// Service: ¿Sobre QUÉ puede hacerlo?
if (!scopes.contains(routeId)) throw AccessDenied;

// Repo: Dame solo lo permitido
WHERE id IN (scopes) AND company_id = X
```

---

##  Tarjeta de Repaso

| Capa | Pregunta | Si falla |
|------|----------|----------|
| **AOP** | ¿Tienes el permiso? | 403 Forbidden |
| **Service** | ¿Sobre este recurso? | 403 Access Denied |
| **Repo** | Dame lo filtrado | Empty list |

**Clave:** AOP = puerta de entrada, Service = validación granular.

---


##  Clases Java para parsear el JSON

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserPermissionsCache {
    private Long userId;
    private String username;
    private Integer tenantId;
    private Map<String, Map<String, List<Long>>> permissions; // permissionCode -> companyId -> scopeIds
}

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AllUsersPermissions {
    private Map<String, UserPermissionsCache> users; // userId como String -> datos del usuario
}
```

##  Parser

```java
@Service
public class PermissionCacheService {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @Autowired
    private ObjectMapper objectMapper;
    
    public AllUsersPermissions loadAllPermissions() {
        String json = jdbcTemplate.queryForObject(
            "SELECT api.export_all_user_permissions()::text",
            String.class
        );
        
        JsonNode root = objectMapper.readTree(json);
        Map<String, UserPermissionsCache> users = new HashMap<>();
        
        root.fields().forEachRemaining(entry -> {
            String userId = entry.getKey();
            JsonNode userData = entry.getValue();
            
            users.put(userId, UserPermissionsCache.builder()
                .userId(userData.get("userId").asLong())
                .username(userData.get("username").asText())
                .tenantId(userData.get("tenantId").asInt())
                .permissions(parsePermissions(userData.get("permissions")))
                .build()
            );
        });
        
        return AllUsersPermissions.builder().users(users).build();
    }
    
    private Map<String, Map<String, List<Long>>> parsePermissions(JsonNode permissionsNode) {
        Map<String, Map<String, List<Long>>> result = new HashMap<>();
        
        permissionsNode.fields().forEachRemaining(permEntry -> {
            String permCode = permEntry.getKey();
            JsonNode companies = permEntry.getValue();
            
            Map<String, List<Long>> companyScopes = new HashMap<>();
            companies.fields().forEachRemaining(companyEntry -> {
                String companyId = companyEntry.getKey();
                List<Long> scopeIds = new ArrayList<>();
                
                companyEntry.getValue().forEach(scope -> {
                    scopeIds.add(scope.isNull() ? null : scope.asLong());
                });
                
                companyScopes.put(companyId, scopeIds);
            });
            
            result.put(permCode, companyScopes);
        });
        
        return result;
    }
    
    public UserPermissionsCache getUserPermissions(Long userId) {
        AllUsersPermissions all = loadAllPermissions(); // cache this
        return all.getUsers().get(userId.toString());
    }
}
```

##  Uso en SecurityContext

```java
@Component
public class PermissionAspect {
    
    @Autowired
    private PermissionCacheService cacheService;
    
    @Around("@annotation(requiresPermission)")
    public Object checkPermission(ProceedingJoinPoint joinPoint, RequiresPermission requiresPermission) throws Throwable {
        Long userId = extractUserId();
        String permCode = requiresPermission.value();
        
        UserPermissionsCache userPerms = cacheService.getUserPermissions(userId);
        
        if (!userPerms.getPermissions().containsKey(permCode)) {
            throw new AccessDeniedException("Missing permission: " + permCode);
        }
        
        SecurityContextHolder.setContext(SecuredAccessPayload.builder()
            .userId(userId)
            .username(userPerms.getUsername())
            .scopesByPermission(userPerms.getPermissions())
            .build()
        );
        
        try {
            return joinPoint.proceed();
        } finally {
            SecurityContextHolder.clear();
        }
    }
}
```

##  Validación en Service

```java
public List<RouteDTO> getRoutes(Long companyId) {
    Map<String, Map<String, List<Long>>> scopes = 
        SecurityContextHolder.getContext().getScopesByPermission();
    
    Map<String, List<Long>> routeScopes = scopes.get("ROUTE_VIEW");
    List<Long> allowedRoutes = routeScopes.get(companyId.toString());
    
    if (allowedRoutes == null || allowedRoutes.isEmpty()) {
        throw new AccessDeniedException("No access to company");
    }
    
    if (allowedRoutes.contains(null)) {
        return routeRepository.findByCompanyId(companyId);
    }
    
    return routeRepository.findByIdInAndCompanyId(
        allowedRoutes.stream().filter(Objects::nonNull).collect(Collectors.toList()),
        companyId
    );
}
```