# 🎫 RECAUDO DE BOLETOS FÍSICOS
## PROCESO DETALLADO - SISTEMA DE TRANSPORTE PÚBLICO

---

## 🎯 DESCRIPCIÓN GENERAL

El proceso de recaudo con **boletos físicos** involucra el manejo manual de talonarios de boletos pre-impresos, con control estricto de numeración correlativa y verificación física del stock. Este proceso requiere mayor control manual pero proporciona respaldo físico tangible de las transacciones.

**Características principales**:
- Control de inventario físico de boletos
- Numeración correlativa manual por rangos
- Verificación física de talonarios vendidos/restantes
- Proceso híbrido: Manual en ruta + Digital en sistema

---

## 📋 PROCEDIMIENTOS ESPECÍFICOS

### **🔑 Procedimientos Core**
- **`ProcAlmacenBoleto.sql`**: Gestión de stock de boletos físicos
- **`ProcCajaGestionConductor.sql`**: Control de caja para boletos manuales
- **`ProcRecaudo.sql`**: Recaudación con verificación física
- **`ProcBoletoTransaccion.sql`**: Registro de boletos físicos vendidos

### **⚙️ Procedimientos Auxiliares**
- **`ProcDevolucionBoleto.sql`**: Manejo de boletos devueltos
- **`ProcRecaudoJustificacion.sql`**: Justificación de diferencias en conteo
- **`ProcValidadorAnticipo.sql`**: Anticipos con boletos físicos

---

## 🏗️ ARQUITECTURA DEL PROCESO

### **📊 Estructura de Control**

```
TbAlmacenBoleto (Stock Principal)
├── NumSerie: Identificador del talonario (ej: "A")
├── NumInicio: Primer número del rango (ej: 001)
├── NumFin: Último número del rango (ej: 100)  
├── NumActual: Próximo boleto a vender
├── Disponible: Stock disponible actual
├── CodUnidad: Unidad asignada
├── CodPersona: Conductor responsable
└── CodEstado: 1=Disponible, 2=Agotado, 5=Anulado
```

### **🔢 Control de Numeración**
```sql
-- Ejemplo de asignación
Serie: "A"
NumInicio: 000001
NumFin: 000100
Boletos disponibles: A-000001, A-000002, ..., A-000100
```

---

## 🔄 FLUJO OPERATIVO DETALLADO

### **🌅 FASE 1: PREPARACIÓN Y ASIGNACIÓN**

#### **1.1 Asignación de Talonario**
```
ALMACENERO/CAJERO PRINCIPAL:
├── Ejecuta: ProcAlmacenBoleto @Indice=20 (Registrar Boletos Disponibles)
├── Parámetros:
│   ├── @CodUnidad: ID de la unidad
│   ├── @CodPersona: ID del conductor
│   ├── @NumSerie: "A", "B", "C", etc.
│   ├── @NumInicio: Primer boleto del talonario
│   ├── @NumFin: Último boleto del talonario
│   └── @PrecioArticulo: Valor unitario del boleto
└── Sistema registra asignación y actualiza stock
```

#### **1.2 Entrega Física**
```
PROCESO MANUAL:
├── Cajero entrega talonario físico al conductor
├── Conductor verifica:
│   ├── Serie y rango correcto
│   ├── Boletos en perfecto estado
│   └── Cantidad concordante con sistema
├── Firman acta de entrega (opcional)
└── Conductor asume responsabilidad del talonario
```

### **⏰ FASE 2: OPERACIÓN EN RUTA (SIN TICKETERA)**

#### **2.1 Inicio de Operación Manual**
```
CONDUCTOR (SIN SISTEMA DIGITAL):
├── NO puede abrir caja digital (sin validador/ticketera)
├── Inicia operación física únicamente:
│   ├── Verifica talonario asignado
│   ├── Confirma ruta y horario
│   ├── Prepara caja personal para efectivo
│   └── Inicia venta manual sin registro digital
└── Estado: OPERACIÓN_MANUAL_ACTIVA
```

#### **2.2 Venta de Boletos en Ruta**
```
PROCESO MANUAL POR CADA PASAJERO:
├── Pasajero aborda y solicita boleto
├── Conductor determina tarifa según:
│   ├── Tipo de pasajero (adulto/estudiante/adulto mayor)
│   ├── Distancia del trayecto
│   └── Zona tarifaria
├── Conductor entrega boleto físico
├── Pasajero paga el monto correspondiente
├── Conductor guarda dinero en caja personal
└── OPCIONAL: Registra venta en dispositivo móvil
```

#### **2.3 Control Durante el Turno**
```
CONDUCTOR MANTIENE REGISTRO:
├── Boleto inicial entregado: A-000045
├── Boleto actual: A-000067  
├── Boletos vendidos: 67 - 45 = 22 boletos
├── Efectivo acumulado: 22 × $2.50 = $55.00
└── Boletos restantes: A-000068 hasta A-000100
```

### **🌇 FASE 3: CIERRE Y ENTREGA**

#### **3.1 Finalización Manual del Turno**
```
CONDUCTOR (PROCESO FÍSICO):
├── NO ejecuta cierre digital (sin validador/ticketera)
├── Finalización manual del turno:
│   ├── Cuenta efectivo total recaudado físicamente
│   ├── Identifica primer y último boleto vendido
│   ├── Calcula manualmente:
│   │   ├── Boletos vendidos = (Último - Primero) + 1
│   │   ├── Producción esperada = Boletos × Precio
│   │   └── Diferencia aproximada = Efectivo - Producción
│   └── Prepara entrega al cajero/recaudador
└── Estado: TURNO_FINALIZADO_MANUALMENTE
```

#### **3.2 Entrega al Cajero/Recaudador**
```
CONDUCTOR ENTREGA:
├── Efectivo total recaudado
├── Talonario con boletos restantes
├── Reporte manual (opcional):
│   ├── Primer boleto vendido: A-000045
│   ├── Último boleto vendido: A-000067
│   ├── Total boletos vendidos: 22
│   ├── Total efectivo: $55.00
│   └── Observaciones especiales
└── Firma de entrega
```

### **💰 FASE 4: RECEPCIÓN Y CREACIÓN DE CCU MANUAL**

#### **4.1 Proceso de Recepción y Registro Digital**
```sql
-- CAJERO CREA CCU MANUAL: ProcRecaudoV2 @Indice=20
CAJERO/RECAUDADOR:
├── Recibe entrega del conductor
├── VERIFICACIÓN FÍSICA:
│   ├── Cuenta efectivo entregado
│   ├── Verifica talonario restante
│   ├── Identifica boletos faltantes (vendidos)
│   └── Calcula producción por conteo físico
├── CREACIÓN DE CCU MANUAL:
│   ├── Cajero crea "Caja Conductor Usuario" en sistema
│   ├── Registra producción calculada físicamente
│   ├── Vincula a unidad y conductor (sin CodValidador)
│   └── Sistema usa TbRecaudoV2 (no TbLiquidacionValidador)
└── Compara: Efectivo vs Producción registrada manualmente
```

#### **4.2 Manejo de Diferencias**
```
SI HAY DIFERENCIA:
├── Faltante: Efectivo < Producción esperada
│   ├── Verifica conteo de boletos nuevamente
│   ├── Busca boletos perdidos/dañados
│   ├── Solicita explicación al conductor
│   └── Escalamiento si diferencia > límite
├── Sobrante: Efectivo > Producción esperada  
│   ├── Verifica si hay boletos no contabilizados
│   ├── Revisa cálculo de tarifas
│   └── Documenta origen del excedente
└── Registra diferencia para justificación posterior
```

### **⚖️ FASE 5: LIQUIDACIÓN (SIN VALIDADOR)**

#### **5.1 Preparación para Liquidación Manual**
```sql
-- SIN VALIDADOR: Usa ProcRecaudoV2 (NO ProcLiquidacionValidador)
LIQUIDADOR:
├── Sistema identifica unidad SIN validador (CodValidador = 0)
├── Utiliza proceso alternativo para boletos físicos:
│   ├── Consulta TbRecaudoV2 (no TbLiquidacionValidador)
│   ├── Recopila CCU manuales creados por cajero
│   ├── Total producción registrada manualmente
│   ├── Total efectivo recibido físicamente
│   ├── Diferencias identificadas en conteo
│   ├── Justificaciones aprobadas
│   ├── Devoluciones procesadas manualmente
│   └── Gastos operativos del conductor
├── Verifica consistencia entre físico y digital
└── Procede con liquidación usando ProcRecaudoGastoV2
```

#### **5.2 Cálculo de Liquidación**
```
FÓRMULA PARA BOLETOS FÍSICOS:
├── Producción Bruta = Boletos vendidos × Precio unitario
├── Ajustes:
│   ├── (-) Devoluciones registradas
│   ├── (-) Boletos dañados justificados
│   └── (+) Sobrantes explicados
├── Producción Neta = Producción Bruta + Ajustes
├── Deducciones:
│   ├── (-) Gastos operativos (combustible, peajes)
│   ├── (-) Honorarios del conductor
│   ├── (-) Anticipos entregados
│   └── (-) Retenciones configuradas
└── Neto a Entregar = Producción Neta - Deducciones
```

---

## 📊 CASOS DE USO ESPECÍFICOS

### **✅ CASO 1: Operación Normal Sin Diferencias**

```
DATOS DE ENTRADA:
├── Talonario asignado: A-001 a A-100 (100 boletos)
├── Precio unitario: $2.50
└── Conductor: Juan Pérez

DURANTE EL TURNO:
├── Primer boleto vendido: A-023
├── Último boleto vendido: A-078
├── Boletos vendidos: 078 - 023 + 1 = 56 boletos
└── Efectivo recaudado: $140.00

VERIFICACIÓN DEL CAJERO:
├── Talonario recibido: A-001 a A-022, A-079 a A-100 (44 boletos)
├── Boletos faltantes (vendidos): 100 - 44 = 56 boletos
├── Producción esperada: 56 × $2.50 = $140.00
├── Efectivo entregado: $140.00
└── Diferencia: $0.00 ✅ CUADRE PERFECTO

LIQUIDACIÓN:
├── Producción confirmada: $140.00
├── Gastos operativos: $25.00
├── Honorarios conductor: $35.00
├── Anticipos: $0.00
└── Neto a caja: $140.00 - $25.00 - $35.00 = $80.00
```

### **⚠️ CASO 2: Faltante por Boleto Perdido**

```
SITUACIÓN:
├── Durante el turno, conductor pierde 1 boleto físico
├── Boletos vendidos efectivamente: 55
├── Boletos faltantes del talonario: 56 (incluye el perdido)

VERIFICACIÓN:
├── Producción calculada por falta: 56 × $2.50 = $140.00
├── Efectivo real entregado: $137.50 (55 × $2.50)
├── Faltante detectado: $2.50
└── Conductor explica pérdida del boleto A-045

PROCESO DE JUSTIFICACIÓN:
├── Ejecuta: ProcRecaudoJustificacion @Indice=20
├── Parámetros:
│   ├── @CodRecaudo: ID del recaudo actual
│   ├── @CodMotivoJustificacion: 3 (Boleto perdido/dañado)
│   ├── @Monto: $2.50
│   └── @CodUsuarioAccion: ID del autorizador
└── Sistema registra justificación y acepta el faltante
```

### **🔄 CASO 3: Devolución de Boleto**

```
SITUACIÓN DURANTE EL TURNO:
├── Pasajero compra boleto A-045 por $2.50
├── Posteriormente solicita devolución (cambió de ruta)
├── Conductor autoriza devolución y entrega dinero
└── Marca boleto A-045 como "DEVUELTO"

PROCESO AL FINAL DEL TURNO:
├── Ejecuta: ProcDevolucionBoleto @Indice=20
├── Registra devolución:
│   ├── @CodSalida: ID de la salida actual
│   ├── @MontoDevolucion: $2.50
│   ├── @Lugar: "Paradero Central"
│   └── @Comentario: "Pasajero cambió de ruta"

AJUSTE EN RECAUDACIÓN:
├── Producción inicial: 56 × $2.50 = $140.00
├── Devolución registrada: -$2.50
├── Producción ajustada: $137.50
├── Efectivo entregado: $137.50
└── Resultado: CUADRE PERFECTO después del ajuste
```

### **📱 CASO 4: Proceso Híbrido (Físico + Digital)**

```
SITUACIÓN ESPECIAL:
├── Conductor inicia turno con validador electrónico
├── A mitad del turno, validador falla
├── Conductor solicita talonario físico de emergencia
└── Completa turno con boletos físicos

MANEJO DEL PROCESO:
├── PARTE DIGITAL:
│   ├── Transacciones registradas automáticamente
│   ├── Producción digital: $80.00
│   └── Efectivo correspondiente: $80.00
├── PARTE FÍSICA:
│   ├── Boletos físicos vendidos: 20
│   ├── Producción manual: $50.00
│   └── Efectivo manual: $50.00

CONSOLIDACIÓN:
├── Producción total: $80.00 + $50.00 = $130.00
├── Efectivo total: $80.00 + $50.00 = $130.00
├── Sistema combina ambas modalidades
└── Liquidación unificada al final del turno
```

---

## ⚙️ VALIDACIONES Y CONTROLES

### **🔍 Validaciones Pre-operación**
```sql
ANTES DE ASIGNAR TALONARIO:
├── Verificar disponibilidad de boletos en almacén
├── Validar que conductor no tenga talonario pendiente
├── Confirmar que unidad esté operativa
├── Revisar límites de crédito del conductor
└── Verificar horarios permitidos para la asignación
```

### **🔐 Controles Durante Operación**
```sql
DURANTE EL TURNO:
├── Monitor de tiempo máximo sin transacciones
├── Control de ubicación GPS dentro de la ruta
├── Validación de capacidad máxima de efectivo
├── Alerta por patrones inusuales de venta
└── Backup automático de datos locales
```

### **✅ Validaciones Post-operación**
```sql
AL RECIBIR LA RECAUDACIÓN:
├── ProcRecaudo valida:
│   ├── Producción no haya sido recaudada previamente
│   ├── Montos de dinero recaudo coincida con el número de serie de inicio y fin del talonario de boletos
│   ├── Conductor al final de su turno entrega talonario a liquidador
│   ├── Tiempo entre cierre y entrega sea razonable
│   ├── Conductor tenga autorización para la unidad
│   └── No haya alertas de seguridad pendientes
```

---

## 📈 MÉTRICAS ESPECÍFICAS

### **🎯 Indicadores de Boletos Físicos**
```
KPIs PRINCIPALES:
├── Precisión de Conteo = (Recaudaciones sin diferencia ÷ Total) × 100%
├── Tiempo Promedio de Verificación = Σ(Tiempo verificación) ÷ Operaciones
├── Pérdida por Boletos Dañados = Total justificado por daños ÷ Producción total
├── Eficiencia de Stock = Boletos utilizados ÷ Boletos asignados × 100%
└── Rotación de Talonarios = Talonarios completos ÷ Días operativos
```

### **📊 Análisis de Diferencias**
```
CATEGORIZACIÓN DE FALTANTES:
├── Boletos perdidos/dañados: X%
├── Errores de conteo: Y%  
├── Devoluciones no registradas: Z%
├── Diferencias de cambio: W%
└── Otros motivos: V%
```

---

## 🚨 MANEJO DE EXCEPCIONES

### **⚠️ Situaciones Críticas**

#### **📋 Talonario Perdido Completamente**
```
PROTOCOLO DE EMERGENCIA:
├── Conductor reporta pérdida inmediata
├── Ejecuta: ProcAlmacenBoleto @Indice=21 (Registrar Anulación)
├── Se bloquea el rango completo en sistema
├── Investigación de seguridad obligatoria
├── Conductor asume responsabilidad económica del talonario
└── Asignación de nuevo talonario con numeración diferente
```

#### **🔢 Error en Numeración**
```
CORRECCIÓN DE NUMERACIÓN:
├── Detectar inconsistencia en secuencia
├── Verificar físicamente boletos disponibles
├── Ejecutar corrección en base de datos:
│   ├── Actualizar NumActual correcto
│   ├── Registrar motivo del ajuste
│   └── Auditoría de la corrección
├── Notificar a supervisión
└── Continuar operación con numeración corregida
```

#### **💰 Diferencia Significativa**
```
PROTOCOLO PARA FALTANTES > 5%:
├── Suspender liquidación automática
├── Escalamiento a Jefe de Liquidación
├── Investigación detallada:
│   ├── Revisión de registro de ventas
│   ├── Verificación de devoluciones
│   ├── Análisis de patrones históricos
│   └── Entrevista al conductor
├── Decisión sobre aceptación o rechazo
└── Documentación completa del caso
```

---

## 🔧 MANTENIMIENTO Y OPTIMIZACIÓN

### **📋 Rutinas de Mantenimiento**
```sql
DIARIAS:
├── Conciliación de stock físico vs digital
├── Verificación de talonarios no devueltos
├── Análisis de diferencias del día
└── Backup de transacciones críticas

SEMANALES:
├── Auditoría de numeración correlativa
├── Análisis de tendencias de faltantes  
├── Revisión de justificaciones aprobadas
└── Optimización de asignación de talonarios

MENSUALES:
├── Inventario físico completo de boletos
├── Análisis de pérdidas y mermas
├── Evaluación de eficiencia por conductor
└── Actualización de procedimientos según hallazgos
```

### **📈 Oportunidades de Mejora**
- **Digitalización gradual**: Migración hacia validadores electrónicos
- **Código de barras**: Implementación en boletos físicos para lectura automática
- **App móvil**: Registro digital de ventas manuales en tiempo real
- **RFID**: Chips en talonarios para control automático de stock

---

## 🎯 CONCLUSIONES

El proceso de **recaudo con boletos físicos** requiere:

### **✅ Fortalezas**
- Control tangible y verificable
- Respaldo físico de transacciones
- Funciona independiente de tecnología
- Proceso comprobable para auditorías

### **⚠️ Retos**
- Mayor tiempo de verificación
- Posibilidad de errores humanos
- Riesgo de pérdida de boletos
- Proceso intensivo en mano de obra

### **🎯 Factores Críticos de Éxito**
1. **Capacitación continua** del personal
2. **Controles estrictos** de numeración y stock
3. **Procesos claros** de justificación
4. **Supervisión efectiva** de diferencias
5. **Tecnología de apoyo** para optimizar verificación

---

## 🔄 DIFERENCIAS CLAVE: BOLETOS FÍSICOS vs ELECTRÓNICOS

### **📊 Tabla Comparativa de Procesos**

| **ASPECTO** | **BOLETOS FÍSICOS** | **BOLETOS ELECTRÓNICOS** |
|-------------|---------------------|--------------------------|
| **Apertura de Caja** | ❌ Conductor NO puede abrir caja digital | ✅ Conductor abre caja con validador |
| **Sistema Usado** | `ProcRecaudoV2` | `ProcLiquidacionValidador` |
| **Tabla Principal** | `TbRecaudoV2` | `TbLiquidacionValidador` |
| **CodValidador** | `= 0` (Sin validador) | `> 0` (Con validador activo) |
| **Registro de Ventas** | Manual por conductor → Digital por cajero | Automático en tiempo real |
| **Creación de CCU** | Cajero crea manualmente después | Sistema crea automáticamente |
| **Verificación** | Conteo físico de boletos | Reporte digital automático |
| **Control de Stock** | Talonarios físicos correlados | Control digital de transacciones |
| **Cierre de Caja** | ❌ Conductor NO puede cerrar caja digital | ✅ Conductor cierra caja digital |

### **🚨 PUNTO CRÍTICO: LIMITACIONES DEL CONDUCTOR SIN TICKETERA**

```
⚠️ RESTRICCIÓN FUNDAMENTAL:
├── Conductores con boletos físicos NO tienen acceso a ticketera/validador
├── Por lo tanto, NO pueden ejecutar:
│   ├── ProcCajaGestionConductor @Indice=21 (Apertura)
│   ├── ProcCajaGestionConductor @Indice=31 (Cierre)
│   └── Cualquier operación digital directa en el sistema
├── SOLUCIÓN: El cajero actúa como intermediario digital
│   ├── Crea CCU manualmente usando ProcRecaudoV2
│   ├── Registra la producción basada en conteo físico
│   ├── Vincula operación al conductor sin validador
│   └── Procesa liquidación usando flujo alternativo
```

### **🔄 FLUJO HÍBRIDO RECOMENDADO**

Para manejar la limitación donde el conductor no puede interactuar digitalmente con el sistema:

#### **📋 Fase 1: Preparación (CAJERO)**
```
CAJERO PRINCIPAL:
├── Asigna talonario físico al conductor
├── Registra asignación en ProcAlmacenBoleto
├── Entrega talonario físico sin activar caja digital
└── Conductor queda responsable solo del aspecto físico
```

#### **🚌 Fase 2: Operación (CONDUCTOR - PROCESO FÍSICO)**
```
CONDUCTOR (SIN ACCESO DIGITAL):
├── Opera únicamente con boletos físicos
├── Vende manualmente durante la ruta
├── Acumula efectivo en caja personal
├── Mantiene control básico de boletos vendidos
└── Al final entrega: Efectivo + Talonario restante
```

#### **💻 Fase 3: Digitalización (CAJERO - PROCESO HÍBRIDO)**
```
CAJERO/RECAUDADOR (INTERMEDIARIO DIGITAL):
├── Recibe entrega física del conductor
├── Verifica y cuenta físicamente:
│   ├── Efectivo entregado
│   ├── Boletos restantes en talonario
│   └── Calcula boletos vendidos por diferencia
├── CREA CCU MANUAL:
│   ├── Ejecuta: ProcRecaudoV2 @Indice=20
│   ├── Registra producción calculada
│   ├── Vincula a CodUnidad + CodPersona (conductor)
│   ├── CodValidador = 0 (sin validador)
│   └── Sistema usa TbRecaudoV2
├── Registra en sistema como si hubiera sido digital
└── Prepara datos para liquidación
```

#### **⚖️ Fase 4: Liquidación (LIQUIDADOR - PROCESO ALTERNATIVO)**
```
LIQUIDADOR:
├── Identifica unidad SIN validador (CodValidador = 0)
├── Ejecuta flujo alternativo:
│   ├── Consulta TbRecaudoV2 (no TbLiquidacionValidador)
│   ├── Procesa con ProcRecaudoGastoV2
│   ├── Utiliza datos creados por cajero
│   └── Aplica misma lógica de cálculo
├── Genera liquidación final
└── Entrega resultado al conductor
```

### **🎯 BENEFICIOS DE ESTE ENFOQUE**

✅ **Mantiene integridad del sistema**: Toda operación queda registrada digitalmente  
✅ **Conserva trazabilidad**: Auditoría completa disponible  
✅ **Flexibilidad operativa**: Funciona con/sin tecnología  
✅ **Control centralizado**: Cajero valida antes de registrar  
✅ **Liquidación uniforme**: Mismo proceso final independiente del método  

---

**Documento actualizado**: 2025-12-04  
**Versión**: 1.1  
**Cobertura**: Proceso completo de boletos físicos con solución a limitaciones digitales  
**Estado**: Listo para implementación operativa