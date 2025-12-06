⏺ ORGANIGRAMA DE USUARIOS - SISTEMA TRANSPORTE URBANO (CORREGIDO)

  🏢 ESTRUCTURA ORGANIZACIONAL REAL

  flowchart TD
      %% Nivel Directivo
      A[👑 GERENTE GENERAL] --> B[💼 GERENTE OPERACIONES]
      A --> C[💰 GERENTE FINANCIERO]
      A --> D[👥 GERENTE RRHH]

      %% Nivel Operativo - Operaciones
      B --> F[🎯 JEFE OPERACIONES]
      F --> G[👮 SUPERVISOR TERMINAL]
      F --> H[🎛️ DESPACHADOR]
      F --> I[📡 MONITOREADOR GPS]
      F --> J[📊 ANALISTA OPERACIONES]

      %% Nivel Operativo - Flota
      B --> P[🚌 JEFE FLOTA]
      P --> Q[🚗 CONDUCTORES]
      P --> R[🎫 COBRADORES]
      P --> S[📍 INSPECTORES RUTA]
      P --> T[🛠️ COORDINADOR MANTENIMIENTO]
      T --> U[🔧 TÉCNICOS TALLER]

      %% Nivel Administrativo - RRHH
      D --> V[📋 JEFE RRHH]
      V --> W[👤 ANALISTA PERSONAL]
      V --> X[📑 ESPECIALISTA DOCUMENTOS]
      V --> Y[💵 ESPECIALISTA PLANILLAS]
      V --> Z[🎓 COORDINADOR CAPACITACIÓN]

      %% Nivel Administrativo - Finanzas
      C --> AA[💳 JEFE CONTABILIDAD]
      AA --> BB[🧾 CONTADOR GENERAL]
      AA --> CC[💰 CAJERO PRINCIPAL]
      AA --> DD[📈 ANALISTA FINANCIERO]
      AA --> EE[🔍 AUDITOR INTERNO]

      %% Nivel Externo/Terceros
      KK[🏛️ AUTORIDAD TRANSPORTE] -.-> A
      LL[🚔 POLICÍA TRÁNSITO] -.-> F
      MM[🏪 PROVEEDORES] -.-> C
      NN[🎫 USUARIOS PASAJEROS] -.-> Q

  ---
  👥 ROLES PRINCIPALES CORREGIDOS

  🚌 MÓDULO DESPACHO DE UNIDADES

  | Rol                     | Responsabilidad                                        | Nivel Acceso |
  |-------------------------|--------------------------------------------------------|--------------|
  | 🎛️ Despachador         | Autorizar despachos, gestionar cola (todos los turnos) | OPERATIVO    |
  | 👮 Supervisor Terminal  | Resolver excepciones, autorizar casos especiales       | SUPERVISOR   |
  | 📡 Monitoreador GPS     | Vigilar unidades en ruta, alertas tiempo real          | OPERATIVO    |
  | 📊 Analista Operaciones | Monitorear KPIs, optimizar frecuencias                 | ANALÍTICO    |
  | 🚗 Conductor            | Presentarse en cola, operar unidad                     | CAMPO        |

  ---
  📡 MONITOREADOR GPS - ROL CLAVE FALTANTE

  Responsabilidades del Monitoreador GPS

  ## Funciones Principales:
  - ✅ **Monitoreo tiempo real**: Vigilar posición de todas las unidades en operación
  - ✅ **Gestión de alertas**: Atender alertas automáticas (fuera de ruta, velocidad, paradas prolongadas)
  - ✅ **Comunicación directa**: Contactar conductores vía radio/celular para correcciones
  - ✅ **Coordinar emergencias**: Gestionar incidentes (averías, accidentes, bloqueos)
  - ✅ **Reporte de eventos**: Documentar irregularidades y situaciones operativas
  - ✅ **Apoyo al despachador**: Informar sobre unidades próximas a terminal

  ## Herramientas que usa:
  - Dashboard GPS tiempo real
  - Sistema de alertas automáticas
  - Radio comunicación con conductores
  - Panel de control de rutas
  - Reportes de incidencias

  ## Horario:
  - Turno completo (12-14 horas) o por turnos rotativos
  - Cobertura 365 días al año durante horario operativo

  Interacción con otros roles:

  graph LR
      A[📡 Monitoreador GPS] --> B[🎛️ Despachador]
      A --> C[👮 Supervisor Terminal]
      A --> D[🚗 Conductores en Ruta]
      A --> E[📍 Inspectores Ruta]
      A --> F[🛠️ Coord. Mantenimiento]

      B --> A
      C --> A
      D --> A

      classDef monitor fill:#7b1fa2,color:#fff
      classDef operativo fill:#1976d2,color:#fff
      classDef campo fill:#388e3c,color:#fff

      class A monitor
      class B,C,E,F operativo
      class D campo