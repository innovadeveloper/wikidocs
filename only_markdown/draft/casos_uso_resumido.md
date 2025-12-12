
# 📌 **Síntesis de Casos de Uso – Módulo Administrativo RRHH**

## **PROVEEDOR DE SISTEMAS**

**CU-PRS-001: Configurar Dispositivo GPS en Unidad**
Registra e integra un GPS a una unidad, configurando IMEI, SIM, parámetros de transmisión, pruebas y envío obligatorio a la ATU.

## **ADMINISTRADOR DE SISTEMAS**

**CU-ADM-001:** *Crear Usuario del Sistema*
Permite registrar un nuevo usuario del sistema asignando perfil, sucursal y credenciales temporales.

**CU-ADM-002:** *Asignar Permisos por Perfil*
Configura o ajusta permisos de acceso por cada perfil de usuario, aplicándose de forma inmediata.

**CU-ADM-003:** *Gestionar Claves de Acceso*
Permite resetear claves, desbloquear cuentas o aplicar políticas de expiración según el caso.

**CU-ADM-004:** *Consultar Usuarios Conectados*
Muestra en tiempo real todos los usuarios activos, sesiones abiertas, IP y permite cerrar sesiones remotas.

**CU-ADM-005:** *Desactivar Usuario*
Permite suspender o desactivar permanentemente un usuario, cerrando sesiones y manteniendo historial.

**CU-ADM-006:** *Auditar Actividad de Usuarios*
Consulta logs de acciones realizadas por cada usuario, permitiendo detectar eventos anómalos o sospechosos.

**CU-ADM-007:** *Configurar Parámetros del Sistema*
Gestiona parámetros técnicos globales como vigencia de claves, tiempo de sesión, backups y retención de logs.

---

## **JEFE RRHH**

1. **CU-JRH-001 – Aprobar Contratación de Conductores**
   *Actor:* Jefe RRHH.
   *Síntesis:* Revisa expediente del candidato y aprueba o rechaza su contratación.

2. **CU-JRH-004 – Autorizar Cambios Salariales**
   *Actor:* Jefe RRHH.
   *Síntesis:* Evalúa y aprueba solicitudes de ajuste salarial.

3. **CU-JRH-007 – Generar Reportes Gerenciales de RRHH**
   *Actor:* Jefe RRHH.
   *Síntesis:* Configura y genera reportes ejecutivos sobre el área de RRHH.

---

## **ANALISTA PERSONAL**

4. **CU-ANP-001 – Registrar Nuevo Conductor**
   *Actor:* Analista Personal.
   *Síntesis:* Registra datos y documentos de un nuevo postulante a conductor.

5. **CU-ANP-003 – Actualizar Expedientes de Personal**
   *Actor:* Analista Personal.
   *Síntesis:* Edita información del expediente del personal y mantiene historial.

6. **CU-ANP-008 – Administrar Vacaciones y Permisos**
   *Actor:* Analista Personal.
   *Síntesis:* Registra, evalúa y aprueba permisos o vacaciones del personal.

7. **CU-ANP-009: Registrar Personal General**
   *Actor:* Analista Personal.
   *Síntesis:* Registra inspectores, ayudantes, administrativos o mecánicos con datos personales, laborales y documentos básicos.


---

## **ESPECIALISTA DOCUMENTOS**

7. **CU-ESD-001 – Verificar Documentación Conductor**
   *Actor:* Especialista Documentos.
   *Síntesis:* Revisa y valida los 14 documentos obligatorios del conductor.

8. **CU-ESD-002 – Gestionar Renovación Documentos**
   *Actor:* Especialista Documentos.
   *Síntesis:* Gestiona avisos, recepción y validación de documentos por vencer.

9. **CU-ESD-003 – Archivar Documentación Personal**
   *Actor:* Especialista Documentos.
   *Síntesis:* Digitaliza, clasifica y archiva documentos en el expediente.

10. **CU-ESD-004 – Validar Certificados Médicos**
    *Actor:* Especialista Documentos.
    *Síntesis:* Valida autenticidad y resultados de exámenes psicosomáticos.

11. **CU-ESD-005 – Controlar Antecedentes Penales**
    *Actor:* Especialista Documentos.
    *Síntesis:* Verifica antecedentes policiales, penales y de tránsito.

12. **CU-ESD-006 – Gestionar Documentos de Identidad**
    *Actor:* Especialista Documentos.
    *Síntesis:* Valida DNI/carnet mediante OCR y consulta RENIEC/Migraciones.

13. **CU-ESD-007 – Notificar Vencimientos**
    *Actor:* Especialista Documentos.
    *Síntesis:* Envía notificaciones a conductores por documentos próximos a vencer.

14. **CU-ESD-008 – Coordinar con Autoridades**
    *Actor:* Especialista Documentos.
    *Síntesis:* Gestiona trámites ante autoridades (MTC, PNP, Salud, Migraciones).

15. **CU-ESD-009: Configurar Reglas de Restricción Documental**
    *Actor:* Especialista Documentos.
    *Síntesis:* Define umbrales de alerta y reglas de bloqueo para licencias, SOAT, revisión técnica, etc., activando notificaciones y sugerencias automáticas de restricción.

---

## **ESPECIALISTA PLANILLAS**

15. **CU-ESP-001 – Calcular Liquidación Conductor**
    *Actor:* Especialista Planillas.
    *Síntesis:* Calcula pago del día según producción y gastos del conductor.

16. **CU-ESP-002 – Generar Reportes Nómina**
    *Actor:* Especialista Planillas.
    *Síntesis:* Genera reportes detallados de nómina y costos laborales.

17. **CU-ESP-004 – Generar Comprobantes de Pago**
    *Actor:* Especialista Planillas.
    *Síntesis:* Emite comprobantes PDF por liquidaciones procesadas.

18. **CU-ESP-005 – Calcular Prestaciones Sociales**
    *Actor:* Especialista Planillas.
    *Síntesis:* Calcula CTS, gratificaciones y vacaciones acumuladas.

19. **CU-ESP-006 – Administrar Préstamos y Anticipos**
    *Actor:* Especialista Planillas.
    *Síntesis:* Registra, aprueba y genera cronograma de préstamos o anticipos.

20. **CU-ESP-007 – Procesar Liquidaciones Finales**
    *Actor:* Especialista Planillas.
    *Síntesis:* Calcula compensaciones finales por salida del conductor.

---

## **COORDINADOR CAPACITACIÓN**

21. **CU-COC-007 – Mantener Registro de Capacitaciones**
    *Actor:* Coordinador de Capacitación.
    *Síntesis:* Registra asistencia, notas y certificados de capacitaciones.

---

## **SISTEMA (Automatizaciones RRHH)**

22. **CU-SIS-RH01 – Gestionar Expedientes Digitales**
    *Actor:* Sistema.
    *Síntesis:* Actualiza y organiza automáticamente expedientes y copias de respaldo.

23. **CU-SIS-RH02 – Generar Alertas de Vencimientos**
    *Actor:* Sistema.
    *Síntesis:* Detecta documentos próximos a vencer y genera alertas.

24. **CU-SIS-RH03 – Calcular Nómina Automáticamente**
    *Actor:* Sistema.
    *Síntesis:* Procesa automáticamente el cálculo de nómina mensual.

25. **CU-SIS-RH04 – Validar Documentación Digital**
    *Actor:* Sistema.
    *Síntesis:* Verifica automáticamente documentos mediante APIs gubernamentales.

26. **CU-SIS-RH05 – Generar Reportes de RRHH**
    *Actor:* Sistema.
    *Síntesis:* Genera y envía reportes automáticos de indicadores de RRHH.

27. **CU-SIS-RH06 – Controlar Acceso por Perfiles**
    *Actor:* Sistema.
    *Síntesis:* Autoriza o bloquea funciones según el perfil del usuario.

28. **CU-SIS-RH07 – Sincronizar con Entidades Externas**
    *Actor:* Sistema.
    *Síntesis:* Intercambia datos con APIs externas (RENIEC, MTC, PNP, etc.).

29. **CU-SIS-RH08 – Gestionar Workflow de Aprobaciones**
    *Actor:* Sistema.
    *Síntesis:* Ejecuta automáticamente los flujos de aprobación configurados.

---

# **Síntesis de Casos de Uso – DESPACHO (OPERACIONES)**

## JEFE OPERACIONES
- **CU-JOP-001: Planificar Operación Diaria** - Define estrategia, asigna recursos y establece metas de producción
- **CU-JOP-002: Supervisar Cumplimiento de Frecuencias** - Monitorea intervalos de despacho establecidos
- **CU-JOP-003: Coordinar con Gerencia** - Reporta estado operativo y escala decisiones
- **CU-JOP-004: Gestionar Recursos Operativos** - Asigna personal, unidades y equipos
- **CU-JOP-005: Evaluar Performance del Equipo** - Analiza indicadores de productividad
- **CU-JOP-006: Configurar Geocercas y Alertas** - Configura geocercas y alertas de la ruta
- **CU-JOP-007: Gestionar Restricciones Operativas** - Registra restricciones a conductores o unidades
- **CU-JOP-008: Diseñar Ruta Operativa** - Diseño de ruta operativa
- **CU-JOP-009: Registrar Nueva Unidad** - Registra una nueva unidad vehicular con datos técnicos, operativos y documentación, quedando lista para configuración GPS y propietario.
- **CU-JOP-010: Enlazar Unidad a Propietario** - Asocia una unidad a uno o varios propietarios, define porcentajes de participación y habilita acceso móvil de consulta al propietario.
- **CU-JOP-011: Aplicar Restricciones por Documentación** - Aplica restricciones preventivas o críticas a conductores según alertas automáticas por documentos vencidos o próximos a vencer.



## ANALISTA OPERACIONES
- **CU-ANL-001: Crear Programación de Salidas** - Elabora cronograma de despachos del día siguiente
- **CU-ANL-002: Optimizar Frecuencias por Horario** - Ajusta intervalos según demanda histórica
- **CU-ANL-003: Analizar Cumplimiento Operativo** - Genera reportes programado vs ejecutado
- **CU-ANL-004: Identificar Cuellos de Botella** - Detecta puntos críticos operativos
- **CU-ANL-005: Proponer Mejoras Operativas** - Sugiere cambios basados en análisis
- **CU-ANL-006: Configurar Parámetros del Sistema** - Ajusta tiempos, frecuencias y reglas


## SUPERVISOR TERMINAL
- **CU-SUP-001: Resolver Excepciones Escaladas** - Autoriza/rechaza casos que exceden autoridad del despachador
- **CU-SUP-002: Monitorear KPIs en Tiempo Real** - Supervisa indicadores críticos durante turno
- **CU-SUP-003: Gestionar Personal del Turno** - Controla asistencia, reemplazos y disciplina
- **CU-SUP-004: Coordinar con Autoridades Externas** - Comunica con ATU, Policía, Municipio
- **CU-SUP-005: Autorizar Despachos Especiales** - Aprueba salidas fuera de programación
- **CU-SUP-006: Gestionar Incidencias Críticas** - Coordina respuesta ante emergencias
- **CU-SUP-007: Generar Reporte de Turno** - Documenta eventos y decisiones del turno

## DESPACHADOR
- **CU-DES-001: Consultar Cola de Despacho** - Visualiza lista de unidades en espera ordenadas
- **CU-DES-002: Autorizar Despacho Normal** - Aprueba salida de unidades que cumplen requisitos
- **CU-DES-003: Gestionar Excepciones Menores** - Evalúa restricciones leves (documentos próximos a vencer, stock bajo)
- **CU-DES-004: Ejecutar Programación Predefinida** - Sigue cronograma del analista
- **CU-DES-005: Despachar por Criterio Propio** - Decide orden según experiencia operativa
- **CU-DES-006: Reorganizar Cola por Prioridades** - Modifica orden por necesidades urgentes
- **CU-DES-007: Registrar Incidencias en Terminal** - Documenta eventos que afectan operación
- **CU-DES-008: Comunicarse con Conductores** - Informa cambios o resuelve consultas
- **CU-DES-009: Controlar Cumplimiento de Horarios** - Verifica despachos según frecuencias
- **CU-DES-010: Escalar Casos Complejos** - Deriva al supervisor situaciones que exceden su autoridad

## MONITOREADOR GPS
- **CU-MON-001: Monitorear Flota en Tiempo Real** - Supervisa posición y estado de unidades
- **CU-MON-002: Gestionar Alertas Automáticas** - Atiende notificaciones de desviaciones, velocidad, paradas
- **CU-MON-003: Comunicarse con Conductores** - Contacta por radio, app o teléfono
- **CU-MON-004: Validar Cumplimiento de Rutas** - Verifica seguimiento de recorridos autorizados
- **CU-MON-005: Rastrear Unidades Perdidas** - Localiza vehículos con GPS inactivo
- **CU-MON-006: Generar Reportes de Tracking** - Documenta recorridos, alertas y comunicaciones
- **CU-MON-007: Coordinar Respuesta a Emergencias** - Gestiona apoyo ante accidentes o averías

## CONDUCTOR
- **CU-CON-001: Ingresar a Cola de Despacho** - Se posiciona en terminal y espera autorización
- **CU-CON-002: Recibir Autorización de Despacho** - Confirma autorización e inicia servicio
- **CU-CON-003: Vender Boletos con Ticketera** - Opera máquina expendedora
- **CU-CON-004: Vender Boletos Manualmente** - Expende boletos físicos sin ticketera
- **CU-CON-005: Registrar Producción de Viaje** - Reporta ingresos y boletos vendidos
- **CU-CON-006: Cumplir Recorrido Autorizado** - Sigue ruta respetando paraderos y horarios
- **CU-CON-007: Reportar Incidencias en Ruta** - Comunica averías, accidentes, bloqueos
- **CU-CON-008: Liquidar Producción Diaria** - Entrega recaudación y rinde cuentas
- **CU-CON-009: Consultar Estado Personal** - Revisa documentos, puntos de licencia y alertas

---
# LISTA COMPLETA DE CASOS DE USO - MÓDULO RECAUDO

## JEFE CONTABILIDAD

**CU-JCO-001**: Planificar Recaudo Diario  
Establece metas de ingresos y coordina procesos de cobranza del día.

**CU-JCO-002**: Supervisar Liquidaciones  
Controla que todas las unidades liquiden correctamente su producción diaria.

**CU-JCO-003**: Autorizar Ajustes de Producción  
Aprueba correcciones en liquidaciones por diferencias o incidencias.

**CU-JCO-004**: Generar Reportes Financieros  
Consolida ingresos diarios, semanales y mensuales para gerencia.

**CU-JCO-005**: Controlar Cumplimiento Tributario  
Supervisa emisión de comprobantes y cumplimiento fiscal.

**CU-JCO-006**: Gestionar Cuentas por Cobrar  
Administra deudas pendientes de conductores o terceros.

## CONTADOR GENERAL

**CU-CON-001**: Registrar Ingresos Diarios  
Contabiliza todos los ingresos por venta de boletos y servicios.

**CU-CON-002**: Conciliar Caja vs Producción  
Verifica que el efectivo recaudado coincida con boletos reportados.

**CU-CON-003**: Procesar Diferencias de Caja  
Investiga y documenta faltantes o sobrantes en liquidaciones.

**CU-CON-004**: Generar Estados Financieros  
Elabora balances y estados de resultados operativos.

**CU-CON-005**: Controlar Inventario de Boletos  
Administra stock de boletos físicos y digitales.

**CU-CON-006**: Calcular Impuestos y Tasas  
Determina obligaciones tributarias sobre ingresos operativos.

**CU-CON-007**: Archivar Documentación  
Organiza y resguarda comprobantes, liquidaciones y reportes.

## CAJERO PRINCIPAL (Recaudador/Liquidador)

**CU-CAJ-001**: Abrir Caja de Recaudo  
Inicia caja para recibir entregas parciales durante el día de operación.

**CU-CAJ-002**: Recibir Entregas Parciales de Conductores  
Registra efectivo después de cada vuelta del conductor durante el día.

**CU-CAJ-003**: Contar y Verificar Efectivo Parcial  
Valida montos entregados vs producción del sistema por vuelta.

**CU-CAJ-004**: Comparar Producción con Ticketera  
Confronta efectivo vs boletos digitales registrados por la máquina.

**CU-CAJ-005**: Contabilizar Boletos Físicos Vendidos  
Verifica series de boletos utilizados cuando no hay ticketera.

**CU-CAJ-006**: Registrar Entregas en el Sistema  
Documenta cada entrega parcial con hora, monto y conductor.

**CU-CAJ-007**: Detectar Billetes Falsos  
Verifica autenticidad del dinero recibido en cada entrega.

**CU-CAJ-008**: Manejar Diferencias en Entregas  
Gestiona faltantes o sobrantes durante entregas parciales.

**CU-CAJ-009**: Liquidar al Conductor (Final de Turno)  
Actúa como liquidador al cierre del turno del conductor.

**CU-CAJ-010**: Cerrar Caja del Conductor  
Finaliza la caja abierta y calcula totales del día.

**CU-CAJ-011**: Calcular Liquidación Final  
Determina monto a pagar al conductor según acuerdos.

**CU-CAJ-012**: Emitir Comprobante de Liquidación  
Genera recibo oficial de liquidación al conductor.

**CU-CAJ-013**: Cuadrar Caja Propia Diaria  
Reconcilia total recibido vs total registrado en sistema.

**CU-CAJ-014**: Depositar en Banco  
Traslada efectivo consolidado a entidades financieras.

**CU-CAJ-015**: Administrar Caja Chica  
Gestiona fondos para gastos operativos menores.

**CU-CAJ-016**: Entregar Vueltos y Cambio  
Proporciona efectivo para operaciones de conductores.

**CU-CAJ-017**: Entregar Talonarios de Boletos Físicos a Conductores  
Entrega talonarios a los conductores próximos a salir a ruta

**CU-CAJ-018**: Procesar Devolución de Boletos (Reasignación)  
Conductor devuelve boletos al cajero y este los reserva para la siguiente asignación. Otro escenario, puede ser cuando el cajero debe reasignar porque en ruta un conductor recibió talonarios de otro conductor (casos en los q se ha acabado su talonario de boletos).

## JEFE DE LIQUIDADOR

**CU-JLI-001**: Supervisar Liquidaciones Diarias  
Controla que todas las liquidaciones se realicen correctamente.

**CU-JLI-002**: Revisar Cajas Liquidadas  
Valida post-liquidación que los cálculos estén correctos.

**CU-JLI-003**: Registrar Gastos Administrativos  
Documenta descuentos adicionales (combustible, mantenimiento, multas).

**CU-JLI-004**: Calcular Liquidación al Propietario  
Determina monto final después de gastos administrativos.

**CU-JLI-005**: Resolver Conflictos de Liquidación  
Media disputas entre conductores y cajeros por diferencias.

**CU-JLI-006**: Autorizar Ajustes Especiales  
Aprueba correcciones excepcionales en liquidaciones.

**CU-JLI-007**: Generar Reportes de Liquidación  
Consolida información diaria de todas las liquidaciones.

**CU-JLI-008**: Coordinar con Propietarios  
Comunica resultados y gestiona pagos a dueños de unidades.

## ANALISTA FINANCIERO

**CU-ANF-001**: Analizar Productividad por Unidad  
Evalúa rendimiento económico individual de cada vehículo.

**CU-ANF-002**: Comparar Ingresos Históricos  
Identifica tendencias y variaciones en la recaudación.

**CU-ANF-003**: Calcular Indicadores Financieros  
Determina KPIs como ingreso por kilómetro, por servicio, por hora.

**CU-ANF-004**: Detectar Anomalías en Recaudo  
Identifica patrones irregulares o sospechas de fraude.

**CU-ANF-005**: Proyectar Ingresos  
Estima recaudación futura basada en datos históricos.

**CU-ANF-006**: Analizar Rentabilidad por Ruta  
Evalúa performance económica de diferentes recorridos.

**CU-ANF-007**: Generar Dashboard Financiero  
Crea indicadores visuales para toma de decisiones.

## AUDITOR INTERNO

**CU-AUD-001**: Revisar Procesos de Recaudo  
Evalúa controles internos en manejo de efectivo.

**CU-AUD-002**: Auditar Liquidaciones Aleatorias  
Verifica aleatoriamente entregas de conductores específicos.

**CU-AUD-003**: Investigar Irregularidades  
Profundiza en casos sospechosos o reportes de fraude.

**CU-AUD-004**: Validar Inventarios de Boletos  
Confirma existencias físicas vs registros contables.

**CU-AUD-005**: Evaluar Cumplimiento de Procedimientos  
Verifica adherencia a políticas internas de recaudo.

**CU-AUD-006**: Recomendar Mejoras de Control  
Propone fortalecimiento de procesos financieros.

## CONDUCTOR (Lado Recaudo)

**CU-CON-R01**: Abrir Caja al Inicio de Turno  
Inicia caja en sistema para registrar recaudación del día.

**CU-CON-R02**: Inicializar Ticketera  
Configura máquina expendedora y sincroniza con caja abierta.

**CU-CON-R03**: Vender Boletos con Tarifa Normal  
Expende tickets a pasajeros regulares (ticketera o manual).

**CU-CON-R04**: Vender Boletos con Tarifa Diferenciada  
Aplica descuentos a estudiantes, adultos mayores, discapacitados.

**CU-CON-R05**: Manejar Vueltos  
Gestiona cambio de dinero en ventas manuales.

**CU-CON-R06**: Registrar Ventas Manuales  
Documenta boletos físicos vendidos cuando no hay ticketera.

**CU-CON-R07**: Controlar Stock de Boletos Físicos  
Verifica inventario de tickets manuales disponible.

**CU-CON-R08**: Reportar Fallas de Ticketera  
Comunica problemas técnicos y continúa venta manual.

**CU-CON-R09**: Entregar Recaudo Parcial (Por Vuelta)  
Lleva efectivo al cajero después de cada recorrido.

**CU-CON-R10**: Abrir Nueva Caja (Por Salida)  
Inicia nueva caja si trabaja múltiples salidas en el día.

**CU-CON-R11**: Cerrar Caja Temporal  
Finaliza caja cuando para por descanso o entre salidas.

**CU-CON-R12**: Justificar Diferencias en Entregas  
Explica faltantes o sobrantes al cajero en cada entrega.

**CU-CON-R13**: Cerrar Caja Final de Turno  
Termina la última caja del día y va a liquidación final.

**CU-CON-R14**: Recibir Liquidación Final  
Obtiene pago final del cajero-liquidador al terminar turno.

**CU-CON-R15**: Solicitar Reposición de Boletos  
Pide nuevos tickets físicos cuando se agota stock.

**CU-CON-R16**: Manejar Devoluciones  
Procesa reclamos de pasajeros por servicios no prestados.

## COBRADOR (si aplica)

**CU-COB-R01**: Cobrar Pasajes en Efectivo  
Recibe dinero de pasajeros y entrega boletos.

**CU-COB-R02**: Validar Boletos Precomprados  
Verifica tickets adquiridos previamente.

**CU-COB-R03**: Controlar Aforo del Vehículo  
Gestiona capacidad máxima según normativa.

**CU-COB-R04**: Manejar Conflictos de Pago  
Resuelve disputas sobre tarifas con pasajeros.

**CU-COB-R05**: Rendir Cuentas al Conductor  
Entrega efectivo recolectado durante el servicio.

**CU-COB-R06**: Reportar Incidencias de Recaudo  
Comunica problemas en cobranza al conductor.

**CU-COB-R07**: Aplicar Tarifas Especiales  
Gestiona promociones o descuentos autorizados.


## ENCARGADO DE ALMACÉN

**CU-ALM-01**: *Registrar Ingreso de Talonarios*
Registra la entrada de talonarios desde imprenta, valida series y actualiza el stock central.

**CU-ALM-02**: *Registrar Salida de Talonarios a Terminal*
Registra la distribución de talonarios desde el almacén central hacia un terminal, actualizando ambos inventarios.

**CU-ALM-03**: *Confirmar Recepción de Traslado en Terminal*
Gestiona la confirmación del traslado por parte del terminal y valida que el stock recibido coincida con lo enviado.

**CU-ALM-04**: *Generar Reporte de Inventario*
Genera un reporte consolidado del inventario total (central, terminales y conductores), incluyendo valorización.


## **COORDINADOR DE SUMINISTROS**

**CU-COS-01**: *Abrir Gestión de Entidad (Inicio de Turno)*
Abre el turno del terminal, valida stock disponible y habilita operaciones de suministro.

**CU-COS-02**: *Suministrar Talonarios a Conductor*
Entrega talonarios a un conductor al inicio de su jornada y registra la asignación con las series correspondientes.

**CU-COS-03**: *Transferir Boletos entre Conductores*
Gestiona la transferencia de boletos entre dos conductores cuando uno presenta una contingencia operativa.

**CU-COS-04**: Validar Calidad de Boletos  
Verifica estado físico de tickets recibidos.


## INSPECTOR RECAUDO (si aplica)

**CU-INR-001**: Verificar Ventas en Ruta  
Supervisa proceso de cobranza durante servicios.

**CU-INR-002**: Controlar Tarifas Aplicadas  
Verifica que se cobren tarifas correctas.

**CU-INR-003**: Detectar Evasión de Pago  
Identifica pasajeros sin boleto válido.

**CU-INR-004**: Auditar Ticketeras  
Revisa funcionamiento de máquinas expendedoras.

**CU-INR-005**: Reportar Irregularidades  
Documenta fraudes o malas prácticas detectadas.

**CU-INR-006**: Capacitar Personal  
Entrena conductores en procedimientos de recaudo.

## SISTEMA (Automatizaciones Recaudo)

**CU-SIS-R01**: Gestionar Apertura de Caja  
Registra inicio de caja del conductor con hora y datos iniciales.

**CU-SIS-R02**: Calcular Producción por Ticketera  
Determina ingresos automáticamente desde boletos digitales.

**CU-SIS-R03**: Validar Series de Boletos Físicos  
Verifica secuencia de boletos manuales vendidos.

**CU-SIS-R04**: Comparar Efectivo vs Producción  
Confronta dinero entregado vs ingresos calculados por caja.

**CU-SIS-R05**: Generar Alertas de Diferencias  
Notifica discrepancias entre efectivo y producción esperada.

**CU-SIS-R06**: Consolidar Entregas Parciales  
Suma recaudos por vuelta dentro de la misma caja.

**CU-SIS-R07**: Calcular Liquidación Final  
Determina monto a pagar al conductor según acuerdos.

**CU-SIS-R08**: Registrar Cierre de Caja  
Documenta finalización de caja con totales y diferencias.

**CU-SIS-R09**: Generar Comprobantes de Liquidación  
Emite documentos oficiales de liquidación automáticamente.

**CU-SIS-R10**: Detectar Fraudes en Cajas  
Identifica patrones sospechosos en apertura/cierre de cajas.

**CU-SIS-R11**: Actualizar Inventarios de Boletos  
Ajusta stock físico según boletos reportados como vendidos.

**CU-SIS-R12**: Consolidar Recaudación Diaria  
Suma todas las cajas liquidadas del día por unidad/conductor.

## ESPECIALISTA COBRANZAS

**CU-ESC-001**: Gestionar Cuentas Vencidas  
Administra deudas pendientes de conductores.

**CU-ESC-002**: Negociar Planes de Pago  
Establece acuerdos de pago con deudores.

**CU-ESC-003**: Ejecutar Cobranza Judicial  
Inicia procesos legales por deudas mayores.

**CU-ESC-004**: Actualizar Estados de Cuenta  
Mantiene registro actualizado de deudas.

**CU-ESC-005**: Reportar Incobrables  
Identifica deudas imposibles de recuperar.

**CU-ESC-006**: Coordinar con Legal  
Trabaja con abogados en casos complejos.