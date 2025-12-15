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
⚠️ Restricción aplicada
{{restriction_reason}}
Contacte a su supervisor.
```

#### **IN_APP**
```
code: PAYMENT_PROCESSED_INAPP
body:
✅ Liquidación procesada
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
| **Flexibilidad** | ✅ Reutilización | ❌ Duplicación |
| **Configuración** | ⚠️ Cambio afecta N rutas | ✅ Independiente |
| **UI Suministro** | ⚠️ Confusión (mismo nombre) | ✅ Claro por ruta |
| **Mantenimiento** | ✅ Menos registros | ❌ Más registros |

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
- ✅ Terminal físico compartido (ubicación única)
- ✅ Configuración independiente por ruta (radio, nombre display)
- ✅ UI de suministro muestra: "Terminal Grau - Ruta 101" (sin confusión)
- ✅ Cambiar radio en Ruta 101 NO afecta Ruta 102

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


# PROMPT 3 (ANSWER)



---

### Schema: core_operations