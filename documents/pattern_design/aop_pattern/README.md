# 📘 Guía Completa de AOP en Spring Boot

## 🎯 Tabla de Contenidos

1. [¿Qué es AOP?](#qué-es-aop)
2. [Componentes Fundamentales](#componentes-fundamentales)
3. [Proxificación en Spring AOP](#proxificación-en-spring-aop)
4. [Tipos de Pointcut Designators](#tipos-de-pointcut-designators)
5. [Tipos de Advice](#tipos-de-advice)
6. [Ejemplos Prácticos Completos](#ejemplos-prácticos-completos)
7. [Orden de Ejecución](#orden-de-ejecución)

---

## 🧩 ¿Qué es AOP?

**AOP (Aspect-Oriented Programming)** es un paradigma de programación que permite **separar concerns transversales** (cross-cutting concerns) de la lógica de negocio.

### Problemas que resuelve:

- ❌ Código duplicado en múltiples clases (logging, seguridad, transacciones)
- ❌ Lógica de negocio contaminada con código técnico
- ❌ Difícil mantenimiento de funcionalidad transversal

### Solución AOP:

- ✅ Centraliza funcionalidad transversal en **Aspects**
- ✅ Aplica automáticamente mediante **interceptación**
- ✅ Código de negocio limpio y enfocado

---

## 🏗️ Componentes Fundamentales

### Arquitectura Visual

```
┌─────────────────────────────────────────────────────────────────┐
│                        APLICACIÓN SPRING                         │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │              CLASES DE NEGOCIO (OOP)                   │    │
│  │                                                         │    │
│  │    @Service                @Controller                 │    │
│  │    UserService            VehicleController            │    │
│  │                                                         │    │
│  │    @Repository                                         │    │
│  │    UserRepository                                      │    │
│  └──────────────────────┬─────────────────────────────────┘    │
│                         │                                       │
│                         ▼                                       │
│         ┌───────────────────────────────────┐                  │
│         │    (1) JOIN POINT                 │                  │
│         │    Punto de ejecución donde       │                  │
│         │    un aspecto puede engancharse   │                  │
│         │                                    │                  │
│         │    Ejemplos:                      │                  │
│         │    • Ejecución de método          │                  │
│         │    • Llamada a constructor        │                  │
│         │    • Acceso a campo               │                  │
│         └────────────────┬──────────────────┘                  │
│                          │                                      │
│                          ▼                                      │
│         ┌───────────────────────────────────┐                  │
│         │    (2) POINTCUT                   │                  │
│         │    Expresión que SELECCIONA       │                  │
│         │    qué Join Points interceptar    │                  │
│         │                                    │                  │
│         │    Ejemplos:                      │                  │
│         │    • execution(* service.*.*(..)) │                  │
│         │    • @annotation(Transactional)   │                  │
│         │    • within(com.app.controller.*) │                  │
│         └────────────────┬──────────────────┘                  │
│                          │                                      │
│                          ▼                                      │
│         ┌───────────────────────────────────┐                  │
│         │    (3) ADVICE                     │                  │
│         │    Código que se ejecuta          │                  │
│         │    cuando Pointcut coincide       │                  │
│         │                                    │                  │
│         │    Tipos:                         │                  │
│         │    • @Before                      │                  │
│         │    • @After                       │                  │
│         │    • @Around                      │                  │
│         │    • @AfterReturning              │                  │
│         │    • @AfterThrowing               │                  │
│         └────────────────┬──────────────────┘                  │
│                          │                                      │
│                          ▼                                      │
│         ┌───────────────────────────────────┐                  │
│         │    (4) ASPECT                     │                  │
│         │    Clase que agrupa               │                  │
│         │    Pointcuts + Advices            │                  │
│         │                                    │                  │
│         │    @Aspect                        │                  │
│         │    @Component                     │                  │
│         │    public class SecurityAspect {} │                  │
│         └────────────────┬──────────────────┘                  │
│                          │                                      │
│                          ▼                                      │
│         ┌───────────────────────────────────┐                  │
│         │    (5) WEAVING                    │                  │
│         │    Proceso de aplicar aspectos    │                  │
│         │    al código objetivo             │                  │
│         │                                    │                  │
│         │    En Spring AOP:                 │                  │
│         │    • Runtime Weaving              │                  │
│         │    • Mediante PROXIES dinámicos   │                  │
│         └────────────────┬──────────────────┘                  │
│                          │                                      │
│                          ▼                                      │
│         ┌───────────────────────────────────┐                  │
│         │    APLICACIÓN FINAL               │                  │
│         │    (Lógica de Negocio + Aspectos) │                  │
│         │                                    │                  │
│         │    Proxies interceptan llamadas   │                  │
│         │    y ejecutan aspectos            │                  │
│         └───────────────────────────────────┘                  │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🔍 1. JOIN POINT

> **Punto específico** en la ejecución del programa donde un aspecto puede ser aplicado.

### Join Points disponibles en Java:

| Tipo | Descripción | Spring AOP |
|------|-------------|-----------|
| **Method Execution** | Ejecución de un método | ✅ SOPORTADO |
| **Method Call** | Llamada a un método | ❌ No soportado |
| **Constructor Execution** | Ejecución de constructor | ❌ No soportado |
| **Field Access** | Acceso a un campo | ❌ No soportado |
| **Exception Handler** | Manejo de excepción | ❌ No soportado |

⚠️ **Spring AOP solo soporta Method Execution como Join Point**

### Ejemplo de Join Points en código:

```java
@Service
public class VehicleService {
    
    // ⭐ JOIN POINT 1: Ejecución del método findById
    public Vehicle findById(String id) {
        return repository.findById(id);
    }
    
    // ⭐ JOIN POINT 2: Ejecución del método save
    public Vehicle save(Vehicle vehicle) {
        return repository.save(vehicle);
    }
    
    // ⭐ JOIN POINT 3: Ejecución del método delete
    public void delete(String id) {
        repository.deleteById(id);
    }
}
```

---

## 🎯 2. POINTCUT

> **Expresión que selecciona** qué Join Points serán interceptados.

### Sintaxis General:

```java
@Pointcut("designator(pattern)")
public void nombreDelPointcut() {}
```

### Ejemplo Visual:

```java
@Service
public class OrderService {
    
    public void createOrder() {}      // ✅ Seleccionado
    public void updateOrder() {}      // ✅ Seleccionado
    private void validate() {}        // ❌ No seleccionado (private)
}

@Aspect
@Component
public class LoggingAspect {
    
    // POINTCUT: Selecciona métodos públicos en OrderService
    @Pointcut("execution(public * com.app.service.OrderService.*(..))")
    public void orderServiceMethods() {}
}
```

---

## ⚙️ 3. ADVICE

> **Código que se ejecuta** cuando un Pointcut coincide con un Join Point.

### Tipos de Advice:

```
┌──────────────────────────────────────────────────────────┐
│                    MÉTODO OBJETIVO                        │
│                                                           │
│   @Before          ┌──────────────────┐                  │
│   ════════▶        │                  │                  │
│                    │  MÉTODO REAL     │                  │
│                    │  ejecutándose    │                  │
│   @AfterReturning  │                  │                  │
│   ◀════════        └──────────────────┘                  │
│                                                           │
│   @AfterThrowing   (si hay excepción)                    │
│   ◀════════                                               │
│                                                           │
│   @After           (siempre)                             │
│   ◀════════                                               │
│                                                           │
│   @Around          (rodea completamente)                 │
│   ════▶ antes + método + después ◀════                   │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

---

## 📦 4. ASPECT

> **Clase que modulariza** un concern transversal, agrupando Pointcuts y Advices.

### Estructura de un Aspect:

```java
@Aspect           // ← Marca la clase como Aspect
@Component        // ← Spring lo gestiona como bean
@Slf4j
public class SecurityAspect {
    
    // ========== DEPENDENCIAS ==========
    private final SecurityService securityService;
    
    public SecurityAspect(SecurityService securityService) {
        this.securityService = securityService;
    }
    
    // ========== POINTCUT ==========
    @Pointcut("@annotation(SecuredAccess)")
    public void securedMethods() {}
    
    // ========== ADVICE 1 ==========
    @Before("securedMethods()")
    public void validateAccess(JoinPoint joinPoint) {
        log.info("Validating access to: {}", joinPoint.getSignature());
    }
    
    // ========== ADVICE 2 ==========
    @Around("securedMethods() && @annotation(securedAccess)")
    public Object enforceAccess(
        ProceedingJoinPoint pjp, 
        SecuredAccess securedAccess
    ) throws Throwable {
        // Lógica de seguridad
        if (!securityService.hasPermission(securedAccess.permission())) {
            throw new AccessDeniedException("No permission");
        }
        
        return pjp.proceed();
    }
}
```

---

## 🔗 5. WEAVING

> **Proceso de enlazar** aspectos con el código objetivo.

### Tipos de Weaving:

```
┌─────────────────────────────────────────────────────────────┐
│                    TIPOS DE WEAVING                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. COMPILE-TIME WEAVING                                    │
│     ┌─────────────┐      ┌──────────┐                      │
│     │ .java files │──▶   │ AspectJ  │──▶ .class (tejido)   │
│     └─────────────┘      │ Compiler │                      │
│                          └──────────┘                      │
│     • Requiere AspectJ Compiler (ajc)                      │
│     • Bytecode modificado en compilación                   │
│     • Más rápido en runtime                                │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  2. LOAD-TIME WEAVING (LTW)                                 │
│     ┌─────────────┐      ┌──────────┐                      │
│     │ .class      │──▶   │   JVM    │──▶ clase modificada  │
│     │ files       │      │  Agent   │                      │
│     └─────────────┘      └──────────┘                      │
│     • Requiere Java Agent (-javaagent)                     │
│     • Modifica bytecode al cargar clase                    │
│     • Útil para código que no controlas                    │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  3. RUNTIME WEAVING (Spring AOP) ⭐                         │
│     ┌─────────────┐      ┌──────────┐                      │
│     │   Bean      │──▶   │  Spring  │──▶ Proxy dinámico    │
│     │ Original    │      │Container │                      │
│     └─────────────┘      └──────────┘                      │
│     • NO modifica bytecode                                 │
│     • Crea proxies dinámicos                               │
│     • Solo métodos públicos                                │
│     • ESTO USA SPRING BOOT                                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔄 Proxificación en Spring AOP

### ⚠️ Concepto Clave: Spring AOP NO modifica bytecode

Spring AOP funciona **creando proxies en runtime** que envuelven tus beans.

### ¿Cómo funciona?

```
TU CÓDIGO ORIGINAL:
┌──────────────────────┐
│  @Service            │
│  VehicleService {    │
│                      │
│    public Vehicle    │
│    findById(id) {    │
│      // lógica       │
│    }                 │
│  }                   │
└──────────────────────┘
           │
           │ Spring detecta @Aspect aplicable
           ▼
SPRING CREA PROXY:
┌──────────────────────────────────────┐
│  VehicleService$Proxy                │
│  implements VehicleService {         │
│                                       │
│    private VehicleService target;    │
│    private List<Aspect> aspects;     │
│                                       │
│    public Vehicle findById(id) {     │
│      // ANTES: ejecuta aspects       │
│      @Before advice                  │
│                                       │
│      // MÉTODO REAL                  │
│      result = target.findById(id);   │
│                                       │
│      // DESPUÉS: ejecuta aspects     │
│      @AfterReturning advice          │
│                                       │
│      return result;                  │
│    }                                  │
│  }                                    │
└──────────────────────────────────────┘
           │
           ▼
TU APLICACIÓN USA EL PROXY
(transparente, no lo notas)
```

### Tipos de Proxy en Spring

Spring puede crear dos tipos de proxies:

#### 1. **JDK Dynamic Proxy** (por defecto)

```java
// Tu clase implementa interfaz
public interface VehicleService {
    Vehicle findById(String id);
}

@Service
public class VehicleServiceImpl implements VehicleService {
    @Override
    public Vehicle findById(String id) {
        return repository.findById(id);
    }
}

// Spring crea: Proxy implements VehicleService
// ✅ Funciona
```

#### 2. **CGLIB Proxy** (si no hay interfaz)

```java
// Tu clase NO implementa interfaz
@Service
public class VehicleService {  // ← No interface
    public Vehicle findById(String id) {
        return repository.findById(id);
    }
}

// Spring crea: Proxy extends VehicleService
// ✅ Funciona
```

### 🎯 ¿Cuándo se Proxifica un Bean?

```java
┌─────────────────────────────────────────────────────────┐
│          CASOS DONDE SPRING CREA PROXY                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1️⃣ Bean afectado por un @Aspect personalizado         │
│                                                          │
│     @Service                                            │
│     public class OrderService {                         │
│       public void create() {}  ← Proxificado           │
│     }                                                    │
│                                                          │
│     @Aspect                                             │
│     public class LoggingAspect {                        │
│       @Before("execution(* OrderService.*(..))")       │
│       public void log() {}                              │
│     }                                                    │
│                                                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  2️⃣ Bean con anotaciones AOP de Spring                 │
│                                                          │
│     @Service                                            │
│     public class PaymentService {                       │
│                                                          │
│       @Transactional  ← Proxificado                    │
│       public void pay() {}                              │
│                                                          │
│       @Async          ← Proxificado                    │
│       public void notify() {}                           │
│                                                          │
│       @Cacheable      ← Proxificado                    │
│       public User getUser() {}                          │
│                                                          │
│       @Secured        ← Proxificado                    │
│       public void admin() {}                            │
│     }                                                    │
│                                                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  3️⃣ Bean con @EnableAspectJAutoProxy(proxyTargetClass) │
│                                                          │
│     @Configuration                                      │
│     @EnableAspectJAutoProxy(proxyTargetClass = true)   │
│     public class AppConfig {}                           │
│                                                          │
│     → Todos los beans serán CGLIB proxies              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### ⚠️ Limitaciones de Proxies

```java
@Service
public class UserService {
    
    @Transactional
    public void updateUser() {
        // ✅ Llamada externa: proxy intercepta
    }
    
    public void publicMethod() {
        // ❌ Llamada interna: NO pasa por proxy
        this.updateUser();  // @Transactional NO funciona
    }
    
    @Transactional
    private void privateMethod() {
        // ❌ Métodos privados: NO se proxifican
    }
}
```

**Solución:**

```java
@Service
public class UserService {
    
    @Autowired
    private UserService self;  // ← Inyecta el proxy
    
    public void publicMethod() {
        // ✅ Llamada a través del proxy
        self.updateUser();  // @Transactional SÍ funciona
    }
    
    @Transactional
    public void updateUser() {
        // lógica
    }
}
```

---

## 🎯 Tipos de Pointcut Designators

### Lista Completa (ordenada por uso)

| Designator | Descripción | Spring AOP | Ejemplo |
|------------|-------------|-----------|---------|
| `execution` | Ejecución de método | ✅ | `execution(* service.*.*(..))` |
| `@annotation` | Métodos con anotación | ✅ | `@annotation(Transactional)` |
| `within` | Dentro de tipo/paquete | ✅ | `within(com.app.service..*)` |
| `@within` | Clases con anotación | ✅ | `@within(Service)` |
| `this` | Tipo del proxy | ✅ | `this(UserService)` |
| `target` | Tipo del objeto real | ✅ | `target(UserServiceImpl)` |
| `@target` | Objeto con anotación | ✅ | `@target(Repository)` |
| `args` | Argumentos del método | ✅ | `args(String, int)` |
| `@args` | Argumentos con anotación | ✅ | `@args(Valid)` |
| `bean` | Nombre del bean Spring | ✅ | `bean(userService)` |

### Ejemplos Detallados:

#### 1. `execution` - El más usado

```java
// Sintaxis: execution([modificadores] tipo-retorno paquete.clase.método(parámetros))

// Todos los métodos públicos en service
@Pointcut("execution(public * com.app.service.*.*(..))")

// Métodos que retornan Vehicle en cualquier paquete
@Pointcut("execution(com.app.model.Vehicle *.*(..))")

// Métodos que empiezan con "find"
@Pointcut("execution(* find*(..))")

// Métodos con exactamente 2 parámetros
@Pointcut("execution(* *(*, *))")

// Métodos en service y subpaquetes
@Pointcut("execution(* com.app.service..*.*(..))")
```

#### 2. `@annotation` - Muy práctico

```java
// Métodos anotados con @Transactional
@Pointcut("@annotation(org.springframework.transaction.annotation.Transactional)")
public void transactionalMethods() {}

// Anotación personalizada
@Pointcut("@annotation(com.app.security.SecuredAccess)")
public void securedMethods() {}
```

#### 3. `within` - Por paquete o clase

```java
// Todos los métodos en paquete service
@Pointcut("within(com.app.service.*)")

// Todos los métodos en service y subpaquetes
@Pointcut("within(com.app.service..*)")

// Solo en clase específica
@Pointcut("within(com.app.service.UserService)")
```

#### 4. `@within` - Clases anotadas

```java
// Todos los métodos de clases anotadas con @Service
@Pointcut("@within(org.springframework.stereotype.Service)")

// Todos los métodos de clases anotadas con @RestController
@Pointcut("@within(org.springframework.web.bind.annotation.RestController)")
```

#### 5. `bean` - Por nombre de bean (específico de Spring)

```java
// Solo bean llamado "userService"
@Pointcut("bean(userService)")

// Todos los beans que terminan en "Service"
@Pointcut("bean(*Service)")

// Todos excepto "testService"
@Pointcut("bean(*) && !bean(testService)")
```

### Combinación de Pointcuts:

```java
@Aspect
@Component
public class CombinedAspect {
    
    // AND (&&)
    @Pointcut("execution(* com.app.service.*.*(..)) && @annotation(Transactional)")
    public void transactionalServiceMethods() {}
    
    // OR (||)
    @Pointcut("within(com.app.service..*) || within(com.app.controller..*)")
    public void serviceOrController() {}
    
    // NOT (!)
    @Pointcut("execution(* com.app.service.*.*(..)) && !execution(* com.app.service.*Test.*(..))")
    public void servicesExceptTests() {}
    
    // Reutilización
    @Pointcut("execution(* com.app.service.*.*(..))")
    public void serviceMethods() {}
    
    @Pointcut("@annotation(com.app.Logged)")
    public void loggedMethods() {}
    
    @Before("serviceMethods() && loggedMethods()")
    public void logServiceCalls() {
        // Solo servicios con @Logged
    }
}
```

---

## 📋 Tipos de Advice

### Tabla Comparativa

| Advice | Cuándo se ejecuta | Acceso a | Puede bloquear | Puede modificar retorno |
|--------|-------------------|----------|----------------|------------------------|
| `@Before` | ANTES del método | Args | ❌ | ❌ |
| `@After` | DESPUÉS (siempre) | - | ❌ | ❌ |
| `@AfterReturning` | DESPUÉS (si OK) | Args, Retorno | ❌ | ❌ |
| `@AfterThrowing` | DESPUÉS (si error) | Args, Excepción | ❌ | ❌ |
| `@Around` | ANTES y DESPUÉS | Args, Retorno | ✅ | ✅ |

### 1. `@Before`

```java
@Before("execution(* com.app.service.*.*(..))")
public void logBefore(JoinPoint joinPoint) {
    String methodName = joinPoint.getSignature().getName();
    Object[] args = joinPoint.getArgs();
    
    log.info("⏳ ANTES de ejecutar: {}", methodName);
    log.info("📥 Argumentos: {}", Arrays.toString(args));
}
```

**Uso típico:**
- Validación de parámetros
- Logging de entrada
- Verificación de permisos

**Limitaciones:**
- ❌ No puede prevenir ejecución del método
- ❌ No puede modificar argumentos (técnicamente sí, pero no recomendado)

### 2. `@After` (Finally)

```java
@After("execution(* com.app.service.*.*(..))")
public void cleanupAfter(JoinPoint joinPoint) {
    log.info("🧹 Limpieza después de: {}", joinPoint.getSignature().getName());
    // Liberar recursos, cerrar conexiones, etc.
}
```

**Uso típico:**
- Limpieza de recursos
- Cerrar conexiones
- Logging de finalización

**Características:**
- ✅ Se ejecuta SIEMPRE (éxito o error)
- ❌ No tiene acceso al retorno ni a la excepción

### 3. `@AfterReturning`

```java
@AfterReturning(
    pointcut = "execution(* com.app.service.*.*(..))",
    returning = "result"
)
public void logResult(JoinPoint joinPoint, Object result) {
    log.info("✅ {} retornó: {}", 
        joinPoint.getSignature().getName(), 
        result
    );
    
    // Auditoría del resultado
    auditService.logSuccess(result);
}
```

**Uso típico:**
- Auditoría de resultados exitosos
- Métricas de éxito
- Caché de resultados

**Limitaciones:**
- ❌ Solo se ejecuta si método termina sin error
- ❌ No puede modificar el retorno

### 4. `@AfterThrowing`

```java
@AfterThrowing(
    pointcut = "execution(* com.app.service.*.*(..))",
    throwing = "error"
)
public void logError(JoinPoint joinPoint, Exception error) {
    log.error("💥 ERROR en {}: {}", 
        joinPoint.getSignature().getName(),
        error.getMessage()
    );
    
    // Notificar a sistema de alertas
    alertService.sendAlert(error);
    
    // Auditoría de fallos
    auditService.logFailure(error);
}
```

**Uso típico:**
- Logging de errores
- Alertas automáticas
- Auditoría de fallos

**Características:**
- ✅ Acceso a la excepción lanzada
- ❌ No puede manejar la excepción (solo observa)

### 5. `@Around` - El más poderoso

```java
@Around("execution(* com.app.service.*.*(..))")
public Object measurePerformance(ProceedingJoinPoint pjp) throws Throwable {
    long start = System.currentTimeMillis();
    String methodName = pjp.getSignature().getName();
    
    log.info("⏱️  INICIANDO: {}", methodName);
    
    Object result;
    try {
        // ⭐ EJECUTAR MÉTODO ORIGINAL
        result = pjp.proceed();
        
        long duration = System.currentTimeMillis() - start;
        log.info("✅ {} completado en {}ms", methodName, duration);
        
        // Puedes modificar el resultado
        if (result instanceof String) {
            result = ((String) result).toUpperCase();
        }
        
    } catch (Throwable t) {
        log.error("💥 ERROR en {}: {}", methodName, t.getMessage());
        
        // Puedes manejar la excepción
        // O relanzarla
        throw t;
        
        // O retornar valor por defecto
        // return getDefaultValue();
    }
    
    return result;
}
```

**Capacidades únicas:**
- ✅ Ejecutar código antes Y después
- ✅ Modificar argumentos con `pjp.proceed(newArgs)`
- ✅ Modificar valor de retorno
- ✅ Manejar excepciones
- ✅ Prevenir ejecución del método
- ✅ Decidir si continuar o no

**Casos de uso:**
- Transacciones
- Seguridad
- Caché
- Retry logic
- Performance monitoring

### Ejemplo Avanzado - Modificar Argumentos:

```java
@Around("execution(* com.app.service.UserService.createUser(..))")
public Object sanitizeInput(ProceedingJoinPoint pjp) throws Throwable {
    Object[] args = pjp.getArgs();
    
    // Modificar argumentos
    if (args[0] instanceof User) {
        User user = (User) args[0];
        user.setEmail(user.getEmail().toLowerCase().trim());
        args[0] = user;
    }
    
    // Ejecutar con argumentos modificados
    return pjp.proceed(args);
}
```

---

## 🔄 Orden de Ejecución

### Cuando múltiples Advices aplican al mismo método:

```
MÉTODO OBJETIVO: saveUser(user)

┌─────────────────────────────────────────────────────────┐
│                                                          │
│  1. @Around INICIA (SecurityAspect)                     │
│     validatePermissions()                               │
│     │                                                    │
│     ├─▶ 2. @Before (LoggingAspect)                     │
│     │      logMethodEntry()                             │
│     │                                                    │
│     ├─▶ 3. @Around INICIA (TransactionAspect)          │
│     │      beginTransaction()                           │
│     │      │                                             │
│     │      ├─▶ 4. ⭐ MÉTODO ORIGINAL                    │
│     │      │      saveUser(user)                        │
│     │      │                                             │
│     │      ├─▶ 5. @AfterReturning (AuditAspect)        │
│     │      │      logSuccess()                          │
│     │      │                                             │
│     │      └─▶ 6. @After (CleanupAspect)               │
│     │             cleanup()                             │
│     │                                                    │
│     └─▶ 7. @Around TERMINA (TransactionAspect)         │
│            commitTransaction()                          │
│                                                          │
│  8. @Around TERMINA (SecurityAspect)                    │
│     clearSecurityContext()                              │
│                                                          │
└─────────────────────────────────────────────────────────┘

SI HAY EXCEPCIÓN:

┌─────────────────────────────────────────────────────────┐
│  1-4. Igual que arriba hasta el método                  │
│                                                          │
│  4. MÉTODO lanza excepción                              │
│     │                                                    │
│     ├─▶ 5. @AfterThrowing (ErrorHandlerAspect)         │
│     │      logError()                                   │
│     │                                                    │
│     ├─▶ 6. @After (CleanupAspect)                      │
│     │      cleanup()                                    │
│     │                                                    │
│     └─▶ 7. @Around catch (TransactionAspect)           │
│            rollbackTransaction()                        │
│                                                          │
│  8. @Around catch (SecurityAspect)                      │
│     handleSecurityError()                               │
└─────────────────────────────────────────────────────────┘
```

### Control de Orden con `@Order`:

```java
@Aspect
@Component
@Order(1)  // ← Ejecuta PRIMERO (menor número = mayor prioridad)
public class SecurityAspect {
    @Around("@annotation(SecuredAccess)")
    public Object validate(ProceedingJoinPoint pjp) throws Throwable {
        // Seguridad antes que todo
        return pjp.proceed();
    }
}

@Aspect
@Component
@Order(2)  // ← Ejecuta SEGUNDO
public class TransactionAspect {
    @Around("@annotation(Transactional)")
    public Object handleTransaction(ProceedingJoinPoint pjp) throws Throwable {
        // Transacción después de seguridad
        return pjp.proceed();
    }
}

@Aspect
@Component
@Order(3)  // ← Ejecuta TERCERO
public class LoggingAspect {
    @Before("execution(* com.app.service.*.*(..))")
    public void log() {
        // Logging al final
    }
}
```

---

## 💡 Ejemplos Prácticos Completos

### Ejemplo 1: Sistema de Seguridad con AOP

```java
// ========== ANOTACIÓN PERSONALIZADA ==========
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface SecuredAccess {
    String permission();
    String scope() default "";
}

// ========== ASPECT DE SEGURIDAD ==========
@Aspect
@Component
@Slf4j
@Order(1)  // Máxima prioridad
public class SecurityAspect {
    
    private final SecurityService securityService;
    
    @Around("@annotation(securedAccess)")
    public Object validateAccess(
        ProceedingJoinPoint pjp, 
        SecuredAccess securedAccess
    ) throws Throwable {
        
        // Obtener usuario del contexto
        String userId = SecurityContextHolder.getContext().getUserId();
        
        // Validar permiso
        boolean hasPermission = securityService.hasPermission(
            userId, 
            securedAccess.permission(),
            securedAccess.scope()
        );
        
        if (!hasPermission) {
            log.error("🚫 Usuario {} sin permiso {}", 
                userId, securedAccess.permission());
            throw new AccessDeniedException("Insufficient permissions");
        }
        
        log.info("✅ Usuario {} autorizado para {}", 
            userId, pjp.getSignature().getName());
        
        return pjp.proceed();
    }
}

// ========== USO EN CONTROLLER ==========
@RestController
public class VehicleController {
    
    @SecuredAccess(permission = "VEHICLE_READ", scope = "FLEET_1")
    @GetMapping("/vehicle/{id}")
    public Vehicle getVehicle(@PathVariable String id) {
        return vehicleService.findById(id);
    }
    
    @SecuredAccess(permission = "VEHICLE_WRITE", scope = "FLEET_1")
    @PostMapping("/vehicle")
    public Vehicle createVehicle(@RequestBody Vehicle vehicle) {
        return vehicleService.save(vehicle);
    }
}
```

### Ejemplo 2: Auditoría Automática

```java
// ========== ANOTACIÓN ==========
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Audited {
    String action();
    AuditLevel level() default AuditLevel.INFO;
}

enum AuditLevel {
    INFO, WARNING, CRITICAL
}

// ========== ASPECT ==========
@Aspect
@Component
@Order(10)  // Después de seguridad
public class AuditAspect {
    
    private final AuditService auditService;
    
    @AfterReturning(
        pointcut = "@annotation(audited)",
        returning = "result"
    )
    public void auditSuccess(JoinPoint jp, Audited audited, Object result) {
        String userId = SecurityContextHolder.getContext().getUserId();
        
        AuditEntry entry = AuditEntry.builder()
            .userId(userId)
            .action(audited.action())
            .level(audited.level())
            .methodName(jp.getSignature().getName())
            .arguments(Arrays.toString(jp.getArgs()))
            .result(result != null ? result.toString() : "void")
            .timestamp(LocalDateTime.now())
            .status("SUCCESS")
            .build();
        
        auditService.save(entry);
    }
    
    @AfterThrowing(
        pointcut = "@annotation(audited)",
        throwing = "error"
    )
    public void auditFailure(JoinPoint jp, Audited audited, Throwable error) {
        String userId = SecurityContextHolder.getContext().getUserId();
        
        AuditEntry entry = AuditEntry.builder()
            .userId(userId)
            .action(audited.action())
            .level(AuditLevel.CRITICAL)
            .methodName(jp.getSignature().getName())
            .arguments(Arrays.toString(jp.getArgs()))
            .errorMessage(error.getMessage())
            .timestamp(LocalDateTime.now())
            .status("FAILED")
            .build();
        
        auditService.save(entry);
    }
}

// ========== USO ==========
@Service
public class PaymentService {
    
    @Audited(action = "PAYMENT_PROCESSED", level = AuditLevel.CRITICAL)
    @Transactional
    public Payment processPayment(PaymentRequest request) {
        // Lógica de pago
        return payment;
    }
}
```

### Ejemplo 3: Rate Limiting

```java
// ========== ANOTACIÓN ==========
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RateLimited {
    int maxRequests() default 100;
    int windowSeconds() default 60;
}

// ========== ASPECT ==========
@Aspect
@Component
public class RateLimitAspect {
    
    private final RateLimiter rateLimiter;
    
    @Before("@annotation(rateLimited)")
    public void checkRateLimit(JoinPoint jp, RateLimited rateLimited) {
        String userId = SecurityContextHolder.getContext().getUserId();
        String methodName = jp.getSignature().getName();
        String key = userId + ":" + methodName;
        
        boolean allowed = rateLimiter.allowRequest(
            key,
            rateLimited.maxRequests(),
            rateLimited.windowSeconds()
        );
        
        if (!allowed) {
            throw new RateLimitExceededException(
                "Too many requests. Max: " + rateLimited.maxRequests() + 
                " per " + rateLimited.windowSeconds() + " seconds"
            );
        }
    }
}

// ========== USO ==========
@RestController
public class ApiController {
    
    @RateLimited(maxRequests = 10, windowSeconds = 60)
    @GetMapping("/expensive-operation")
    public Result expensiveOperation() {
        return service.performExpensiveOperation();
    }
}
```

### Ejemplo 4: Performance Monitoring

```java
@Aspect
@Component
@Slf4j
public class PerformanceAspect {
    
    private final MetricsService metricsService;
    
    @Around("execution(* com.app.service..*(..))")
    public Object measurePerformance(ProceedingJoinPoint pjp) throws Throwable {
        String methodName = pjp.getSignature().toShortString();
        
        long start = System.currentTimeMillis();
        log.debug("⏱️  Starting: {}", methodName);
        
        Object result;
        try {
            result = pjp.proceed();
            
            long duration = System.currentTimeMillis() - start;
            
            // Enviar métricas
            metricsService.recordMethodExecution(methodName, duration);
            
            // Alertar si es muy lento
            if (duration > 5000) {
                log.warn("⚠️  SLOW METHOD: {} took {}ms", methodName, duration);
                alertService.sendSlowMethodAlert(methodName, duration);
            } else {
                log.debug("✅ Completed: {} in {}ms", methodName, duration);
            }
            
            return result;
            
        } catch (Throwable t) {
            long duration = System.currentTimeMillis() - start;
            metricsService.recordMethodFailure(methodName, duration);
            throw t;
        }
    }
}
```

---

## 📚 Resumen Ejecutivo

### Conceptos Clave:

1. **JOIN POINT**: Punto en ejecución donde aspectos pueden aplicarse
2. **POINTCUT**: Expresión que selecciona qué join points interceptar
3. **ADVICE**: Código que se ejecuta cuando pointcut coincide
4. **ASPECT**: Clase que agrupa pointcuts y advices
5. **WEAVING**: Proceso de aplicar aspectos (en Spring: runtime con proxies)

### Spring AOP vs AspectJ:

| Característica | Spring AOP | AspectJ |
|----------------|-----------|---------|
| **Weaving** | Runtime (proxies) | Compile-time / Load-time |
| **Join Points** | Solo métodos públicos | Métodos, campos, constructores |
| **Performance** | Overhead de proxies | Más rápido (bytecode directo) |
| **Configuración** | Simple (@EnableAspectJAutoProxy) | Requiere compilador especial |
| **Uso típico** | ✅ Mayoría de casos | Solo si necesitas más poder |

### Mejores Prácticas:

✅ Usa `@Around` solo cuando necesites control total
✅ Prefiere advices específicos (`@Before`, `@After`) cuando sea posible
✅ Define pointcuts reutilizables con `@Pointcut`
✅ Usa `@Order` para controlar ejecución de múltiples aspectos
✅ Documenta bien los aspectos (afectan flujo de ejecución)
✅ Ten cuidado con llamadas internas (no pasan por proxy)