# LISTA COMPLETA DE CASOS DE USO - MÓDULO DESPACHO

## JEFE OPERACIONES

**CU-JOP-001**: Planificar Operación Diaria  
Define estrategia operativa del día, asigna recursos y establece metas de producción.

**CU-JOP-002**: Supervisar Cumplimiento de Frecuencias  
Monitorea que se cumplan los intervalos de despacho establecidos por la autoridad de transporte.

**CU-JOP-003**: Coordinar con Gerencia  
Reporta estado operativo y escala decisiones que exceden su autoridad.

**CU-JOP-004**: Gestionar Recursos Operativos  
Asigna personal, unidades y equipos según necesidades operativas.

**CU-JOP-005**: Evaluar Performance del Equipo  
Analiza indicadores de productividad del personal operativo.

## ANALISTA OPERACIONES

**CU-ANL-001**: Crear Programación de Salidas  
Elabora cronograma detallado de despachos para el día siguiente (empresas con planificación).

**CU-ANL-002**: Optimizar Frecuencias por Horario  
Analiza demanda histórica y ajusta intervalos de despacho por franjas horarias.

**CU-ANL-003**: Analizar Cumplimiento Operativo  
Genera reportes de desempeño comparando programado vs ejecutado.

**CU-ANL-004**: Identificar Cuellos de Botella  
Detecta puntos críticos que afectan la fluidez operativa.

**CU-ANL-005**: Proponer Mejoras Operativas  
Sugiere cambios en procesos basado en análisis de datos históricos.

**CU-ANL-006**: Configurar Parámetros del Sistema  
Ajusta tiempos, frecuencias y reglas operativas en el sistema.

## SUPERVISOR TERMINAL

**CU-SUP-001**: Resolver Excepciones Escaladas  
Autoriza o rechaza casos que exceden la autoridad del despachador.

**CU-SUP-002**: Monitorear KPIs en Tiempo Real  
Supervisa indicadores operativos críticos durante su turno.

**CU-SUP-003**: Gestionar Personal del Turno  
Controla asistencia, reemplazos y disciplina del personal operativo.

**CU-SUP-004**: Coordinar con Autoridades Externas  
Maneja comunicación con ATU, Policía, Municipio ante incidencias mayores.

**CU-SUP-005**: Autorizar Despachos Especiales  
Aprueba salidas fuera de programación por necesidades operativas.

**CU-SUP-006**: Gestionar Incidencias Críticas  
Coordina respuesta ante emergencias, accidentes o situaciones complejas.

**CU-SUP-007**: Generar Reporte de Turno  
Documenta eventos relevantes, decisiones tomadas y estado operativo.

## DESPACHADOR

**CU-DES-001**: Consultar Cola de Despacho  
Visualiza lista de unidades en espera ordenadas por llegada o programación.

**CU-DES-002**: Autorizar Despacho Normal  
Aprueba salida de unidades que cumplen todos los requisitos.

**CU-DES-003**: Gestionar Excepciones Menores  
Evalúa y resuelve restricciones leves (documentos próximos a vencer, stock bajo).

**CU-DES-004**: Ejecutar Programación Predefinida  
Sigue cronograma establecido por analista (empresas con planificación).

**CU-DES-005**: Despachar por Criterio Propio  
Decide orden de salidas según experiencia operativa (empresas sin planificación).

**CU-DES-006**: Reorganizar Cola por Prioridades  
Modifica orden de despacho por necesidades operativas urgentes.

**CU-DES-007**: Registrar Incidencias en Terminal  
Documenta eventos que afectan la operación en su zona de responsabilidad.

**CU-DES-008**: Comunicarse con Conductores  
Informa cambios, instrucciones o resuelve consultas del personal.

**CU-DES-009**: Controlar Cumplimiento de Horarios  
Verifica que los despachos se ejecuten según frecuencias establecidas.

**CU-DES-010**: Escalar Casos Complejos  
Deriva al supervisor situaciones que exceden su autoridad.

## MONITOREADOR GPS

**CU-MON-001**: Monitorear Flota en Tiempo Real  
Supervisa posición y estado de todas las unidades operativas.

**CU-MON-002**: Gestionar Alertas Automáticas  
Atiende notificaciones de desviaciones, velocidad excesiva, paradas prolongadas.

**CU-MON-003**: Comunicarse con Conductores  
Contacta conductores por radio, app o teléfono según necesidad.

**CU-MON-004**: Validar Cumplimiento de Rutas  
Verifica que las unidades sigan recorridos autorizados.

**CU-MON-005**: Rastrear Unidades Perdidas  
Localiza vehículos con GPS inactivo o comunicación perdida.

**CU-MON-006**: Generar Reportes de Tracking  
Documenta recorridos, alertas y comunicaciones del turno.

**CU-MON-007**: Coordinar Respuesta a Emergencias  
Gestiona apoyo ante accidentes, averías o situaciones de riesgo.

**CU-MON-008**: Configurar Geocercas y Alertas  
Ajusta parámetros de monitoreo según cambios operativos.

## CONDUCTOR

**CU-CON-001**: Ingresar a Cola de Despacho  
Se posiciona en terminal y espera autorización de salida.

**CU-CON-002**: Recibir Autorización de Despacho  
Confirma autorización y inicia servicio programado.

**CU-CON-003**: Vender Boletos con Ticketera  
Opera máquina expendedora durante el recorrido.

**CU-CON-004**: Vender Boletos Manualmente  
Expende boletos físicos cuando no hay ticketera disponible.

**CU-CON-005**: Registrar Producción de Viaje  
Reporta ingresos y boletos vendidos al finalizar servicio.

**CU-CON-006**: Cumplir Recorrido Autorizado  
Sigue ruta asignada respetando paraderos y horarios.

**CU-CON-007**: Reportar Incidencias en Ruta  
Comunica averías, accidentes, bloqueos o problemas operativos.

**CU-CON-008**: Liquidar Producción Diaria  
Entrega recaudación y rinde cuentas de boletos al final del turno.

**CU-CON-009**: Consultar Estado Personal  
Revisa documentos vigentes, puntos de licencia y alertas.

**CU-CON-010**: Solicitar Permisos o Descansos  
Gestiona ausencias programadas o solicitudes especiales.

**CU-CON-011**: Mantener Comunicación Operativa  
Responde llamadas del monitoreador y reporta novedades.

**CU-CON-012**: Abastecer Combustible  
Gestiona carga de GNV o combustible según programación.

**CU-CON-013**: Realizar Mantenimiento Preventivo  
Ejecuta revisiones básicas de seguridad pre y post servicio.

## SISTEMA (VALIDACIONES AUTOMÁTICAS)

**CU-SIS-001**: Validar Documentos de Conductor  
Verifica vigencia de 14 documentos obligatorios automáticamente.

**CU-SIS-002**: Validar Suministro de Boletos  
Confirma que la unidad tenga boletos suficientes por modalidad.

**CU-SIS-003**: Validar Stock Mínimo  
Alerta cuando el inventario está próximo al límite mínimo.

**CU-SIS-004**: Validar Producción Pendiente  
Bloquea despacho si hay viajes sin liquidar del día actual o anterior.

**CU-SIS-005**: Validar Ubicación GPS  
Confirma que la unidad esté en terminal antes del despacho.

**CU-SIS-006**: Validar Estado del Vehículo  
Verifica que la unidad esté operativa y sin restricciones técnicas.

**CU-SIS-007**: Validar Horario de Operación  
Confirma que el despacho esté dentro de horarios autorizados.

**CU-SIS-008**: Generar Alertas Preventivas  
Notifica vencimientos próximos, mantenimientos pendientes.

## COBRADOR (si aplica según empresa)

**CU-COB-001**: Vender Boletos a Pasajeros  
Expende tickets y maneja tarifas diferenciadas.

**CU-COB-002**: Controlar Acceso de Pasajeros  
Verifica pagos y gestiona aforo del vehículo.

**CU-COB-003**: Rendir Producción Parcial  
Reporta ventas durante el recorrido al conductor.

**CU-COB-004**: Manejar Situaciones de Pasajeros  
Resuelve conflictos, quejas o situaciones especiales.

**CU-COB-005**: Apoyar en Maniobras de Seguridad  
Asiste al conductor en estacionamiento y operaciones complejas.

## INSPECTOR (si aplica según empresa)

**CU-INS-001**: Verificar Cumplimiento de Ruta  
Supervisa que las unidades sigan recorridos autorizados.

**CU-INS-002**: Controlar Frecuencias en Campo  
Mide intervalos reales de paso en puntos críticos.

**CU-INS-003**: Verificar Estado de Unidades  
Inspecciona condiciones técnicas y de seguridad.

**CU-INS-004**: Atender Incidencias en Ruta  
Responde a llamadas de apoyo desde central de monitoreo.

**CU-INS-005**: Generar Reportes de Campo  
Documenta hallazgos, infracciones y estado operativo.