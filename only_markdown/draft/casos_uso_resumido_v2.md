
# **Síntesis de Casos de Uso – Módulo Administrativo RRHH**

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

# **Síntesis de Casos de Uso – Módulo operativo**

## **JEFE OPERACIONES**

1. **CU-JOP-001 – Planificar Operación Diaria**
   *Actor:* Jefe Operaciones.
   *Síntesis:* Define estrategia, asigna recursos y establece metas de producción.

2. **CU-JOP-002 – Supervisar Cumplimiento de Frecuencias**
   *Actor:* Jefe Operaciones.
   *Síntesis:* Monitorea intervalos de despacho establecidos.

3. **CU-JOP-003 – Coordinar con Gerencia**
   *Actor:* Jefe Operaciones.
   *Síntesis:* Reporta estado operativo y escala decisiones.

4. **CU-JOP-004 – Gestionar Recursos Operativos**
   *Actor:* Jefe Operaciones.
   *Síntesis:* Asigna personal, unidades y equipos.

5. **CU-JOP-005 – Evaluar Performance del Equipo**
   *Actor:* Jefe Operaciones.
   *Síntesis:* Analiza indicadores de productividad.

6. **CU-JOP-006 – Configurar Geocercas y Alertas**
   *Actor:* Jefe Operaciones.
   *Síntesis:* Configura geocercas y alertas de la ruta.

7. **CU-JOP-007 – Gestionar Restricciones Operativas**
   *Actor:* Jefe Operaciones.
   *Síntesis:* Registra restricciones a conductores o unidades.

8. **CU-JOP-008 – Diseñar Ruta Operativa**
   *Actor:* Jefe Operaciones.
   *Síntesis:* Diseño de ruta operativa.

9. **CU-JOP-009 – Registrar Nueva Unidad**
   *Actor:* Jefe Operaciones.
   *Síntesis:* Registra una nueva unidad vehicular con datos técnicos, operativos y documentación, quedando lista para configuración GPS y propietario.

10. **CU-JOP-010 – Enlazar Unidad a Propietario**
    *Actor:* Jefe Operaciones.
    *Síntesis:* Asocia una unidad a uno o varios propietarios, define porcentajes de participación y habilita acceso móvil de consulta al propietario.

11. **CU-JOP-011 – Aplicar Restricciones por Documentación**
    *Actor:* Jefe Operaciones.
    *Síntesis:* Aplica restricciones preventivas o críticas a conductores según alertas automáticas por documentos vencidos o próximos a vencer.

---

## **ANALISTA OPERACIONES**

12. **CU-ANL-001 – Crear Programación de Salidas**
    *Actor:* Analista Operaciones.
    *Síntesis:* Elabora cronograma de despachos del día siguiente.

13. **CU-ANL-002 – Optimizar Frecuencias por Horario**
    *Actor:* Analista Operaciones.
    *Síntesis:* Ajusta intervalos según demanda histórica.

14. **CU-ANL-003 – Analizar Cumplimiento Operativo**
    *Actor:* Analista Operaciones.
    *Síntesis:* Genera reportes programado vs ejecutado.

15. **CU-ANL-004 – Identificar Cuellos de Botella**
    *Actor:* Analista Operaciones.
    *Síntesis:* Detecta puntos críticos operativos.

16. **CU-ANL-005 – Proponer Mejoras Operativas**
    *Actor:* Analista Operaciones.
    *Síntesis:* Sugiere cambios basados en análisis.

17. **CU-ANL-006 – Configurar Parámetros del Sistema**
    *Actor:* Analista Operaciones.
    *Síntesis:* Ajusta tiempos, frecuencias y reglas.

---

## **SUPERVISOR TERMINAL**

18. **CU-SUP-001 – Resolver Excepciones Escaladas**
    *Actor:* Supervisor Terminal.
    *Síntesis:* Autoriza/rechaza casos que exceden autoridad del despachador.

19. **CU-SUP-002 – Monitorear KPIs en Tiempo Real**
    *Actor:* Supervisor Terminal.
    *Síntesis:* Supervisa indicadores críticos durante turno.

20. **CU-SUP-003 – Gestionar Personal del Turno**
    *Actor:* Supervisor Terminal.
    *Síntesis:* Controla asistencia, reemplazos y disciplina.

21. **CU-SUP-004 – Coordinar con Autoridades Externas**
    *Actor:* Supervisor Terminal.
    *Síntesis:* Comunica con ATU, Policía, Municipio.

22. **CU-SUP-005 – Autorizar Despachos Especiales**
    *Actor:* Supervisor Terminal.
    *Síntesis:* Aprueba salidas fuera de programación.

23. **CU-SUP-006 – Gestionar Incidencias Críticas**
    *Actor:* Supervisor Terminal.
    *Síntesis:* Coordina respuesta ante emergencias.

24. **CU-SUP-007 – Generar Reporte de Turno**
    *Actor:* Supervisor Terminal.
    *Síntesis:* Documenta eventos y decisiones del turno.

---

## **DESPACHADOR**

25. **CU-DES-001 – Consultar Cola de Despacho**
    *Actor:* Despachador.
    *Síntesis:* Visualiza lista de unidades en espera ordenadas.

26. **CU-DES-002 – Autorizar Despacho Normal**
    *Actor:* Despachador.
    *Síntesis:* Aprueba salida de unidades que cumplen requisitos.

27. **CU-DES-003 – Gestionar Excepciones Menores**
    *Actor:* Despachador.
    *Síntesis:* Evalúa restricciones leves (documentos próximos a vencer, stock bajo).

28. **CU-DES-004 – Ejecutar Programación Predefinida**
    *Actor:* Despachador.
    *Síntesis:* Sigue cronograma del analista.

29. **CU-DES-005 – Despachar por Criterio Propio**
    *Actor:* Despachador.
    *Síntesis:* Decide orden según experiencia operativa.

30. **CU-DES-006 – Reorganizar Cola por Prioridades**
    *Actor:* Despachador.
    *Síntesis:* Modifica orden por necesidades urgentes.

31. **CU-DES-007 – Registrar Incidencias en Terminal**
    *Actor:* Despachador.
    *Síntesis:* Documenta eventos que afectan operación.

32. **CU-DES-008 – Comunicarse con Conductores**
    *Actor:* Despachador.
    *Síntesis:* Informa cambios o resuelve consultas.

33. **CU-DES-009 – Controlar Cumplimiento de Horarios**
    *Actor:* Despachador.
    *Síntesis:* Verifica despachos según frecuencias.

34. **CU-DES-010 – Escalar Casos Complejos**
    *Actor:* Despachador.
    *Síntesis:* Deriva al supervisor situaciones que exceden su autoridad.

---

## **MONITOREADOR GPS**

35. **CU-MON-001 – Monitorear Flota en Tiempo Real**
    *Actor:* Monitoreador GPS.
    *Síntesis:* Supervisa posición y estado de unidades.

36. **CU-MON-002 – Gestionar Alertas Automáticas**
    *Actor:* Monitoreador GPS.
    *Síntesis:* Atiende notificaciones de desviaciones, velocidad, paradas.

37. **CU-MON-003 – Comunicarse con Conductores**
    *Actor:* Monitoreador GPS.
    *Síntesis:* Contacta por radio, app o teléfono.

38. **CU-MON-004 – Validar Cumplimiento de Rutas**
    *Actor:* Monitoreador GPS.
    *Síntesis:* Verifica seguimiento de recorridos autorizados.

39. **CU-MON-005 – Rastrear Unidades Perdidas**
    *Actor:* Monitoreador GPS.
    *Síntesis:* Localiza vehículos con GPS inactivo.

40. **CU-MON-006 – Generar Reportes de Tracking**
    *Actor:* Monitoreador GPS.
    *Síntesis:* Documenta recorridos, alertas y comunicaciones.

41. **CU-MON-007 – Coordinar Respuesta a Emergencias**
    *Actor:* Monitoreador GPS.
    *Síntesis:* Gestiona apoyo ante accidentes o averías.

---

## **CONDUCTOR**

42. **CU-CON-001 – Ingresar a Cola de Despacho**
    *Actor:* Conductor.
    *Síntesis:* Se posiciona en terminal y espera autorización.

43. **CU-CON-002 – Recibir Autorización de Despacho**
    *Actor:* Conductor.
    *Síntesis:* Confirma autorización e inicia servicio.

44. **CU-CON-003 – Vender Boletos con Ticketera**
    *Actor:* Conductor.
    *Síntesis:* Opera máquina expendedora.

45. **CU-CON-004 – Vender Boletos Manualmente**
    *Actor:* Conductor.
    *Síntesis:* Expende boletos físicos sin ticketera.

46. **CU-CON-005 – Registrar Producción de Viaje**
    *Actor:* Conductor.
    *Síntesis:* Reporta ingresos y boletos vendidos.

47. **CU-CON-006 – Cumplir Recorrido Autorizado**
    *Actor:* Conductor.
    *Síntesis:* Sigue ruta respetando paraderos y horarios.

48. **CU-CON-007 – Reportar Incidencias en Ruta**
    *Actor:* Conductor.
    *Síntesis:* Comunica averías, accidentes, bloqueos.

49. **CU-CON-008 – Liquidar Producción Diaria**
    *Actor:* Conductor.
    *Síntesis:* Entrega recaudación y rinde cuentas.

50. **CU-CON-009 – Consultar Estado Personal**
    *Actor:* Conductor.
    *Síntesis:* Revisa documentos, puntos de licencia y alertas.

---

# **LISTA COMPLETA DE CASOS DE USO – MÓDULO RECAUDO**

## **JEFE CONTABILIDAD**

1. **CU-JCO-001 – Planificar Recaudo Diario**
   *Actor:* Jefe Contabilidad.
   *Síntesis:* Establece metas de ingresos y coordina procesos de cobranza del día.

2. **CU-JCO-002 – Supervisar Liquidaciones**
   *Actor:* Jefe Contabilidad.
   *Síntesis:* Controla que todas las unidades liquiden correctamente su producción diaria.

3. **CU-JCO-003 – Autorizar Ajustes de Producción**
   *Actor:* Jefe Contabilidad.
   *Síntesis:* Aprueba correcciones en liquidaciones por diferencias o incidencias.

4. **CU-JCO-004 – Generar Reportes Financieros**
   *Actor:* Jefe Contabilidad.
   *Síntesis:* Consolida ingresos diarios, semanales y mensuales para gerencia.

5. **CU-JCO-005 – Controlar Cumplimiento Tributario**
   *Actor:* Jefe Contabilidad.
   *Síntesis:* Supervisa emisión de comprobantes y cumplimiento fiscal.

6. **CU-JCO-006 – Gestionar Cuentas por Cobrar**
   *Actor:* Jefe Contabilidad.
   *Síntesis:* Administra deudas pendientes de conductores o terceros.

---

## **CONTADOR GENERAL**

7. **CU-CON-001 – Registrar Ingresos Diarios**
   *Actor:* Contador General.
   *Síntesis:* Contabiliza todos los ingresos por venta de boletos y servicios.

8. **CU-CON-002 – Conciliar Caja vs Producción**
   *Actor:* Contador General.
   *Síntesis:* Verifica que el efectivo recaudado coincida con boletos reportados.

9. **CU-CON-003 – Procesar Diferencias de Caja**
   *Actor:* Contador General.
   *Síntesis:* Investiga y documenta faltantes o sobrantes en liquidaciones.

10. **CU-CON-004 – Generar Estados Financieros**
    *Actor:* Contador General.
    *Síntesis:* Elabora balances y estados de resultados operativos.

11. **CU-CON-005 – Controlar Inventario de Boletos**
    *Actor:* Contador General.
    *Síntesis:* Administra stock de boletos físicos y digitales.

12. **CU-CON-006 – Calcular Impuestos y Tasas**
    *Actor:* Contador General.
    *Síntesis:* Determina obligaciones tributarias sobre ingresos operativos.

13. **CU-CON-007 – Archivar Documentación**
    *Actor:* Contador General.
    *Síntesis:* Organiza y resguarda comprobantes, liquidaciones y reportes.

---

## **CAJERO PRINCIPAL (Recaudador/Liquidador)**

14. **CU-CAJ-001 – Abrir Caja de Recaudo**
    *Actor:* Cajero Principal.
    *Síntesis:* Inicia caja para recibir entregas parciales durante el día de operación.

15. **CU-CAJ-002 – Recibir Entregas Parciales de Conductores**
    *Actor:* Cajero Principal.
    *Síntesis:* Registra efectivo después de cada vuelta del conductor durante el día.

16. **CU-CAJ-003 – Contar y Verificar Efectivo Parcial**
    *Actor:* Cajero Principal.
    *Síntesis:* Valida montos entregados vs producción del sistema por vuelta.

17. **CU-CAJ-004 – Comparar Producción con Ticketera**
    *Actor:* Cajero Principal.
    *Síntesis:* Confronta efectivo vs boletos digitales registrados por la máquina.

18. **CU-CAJ-005 – Contabilizar Boletos Físicos Vendidos**
    *Actor:* Cajero Principal.
    *Síntesis:* Verifica series de boletos utilizados cuando no hay ticketera.

19. **CU-CAJ-006 – Registrar Entregas en el Sistema**
    *Actor:* Cajero Principal.
    *Síntesis:* Documenta cada entrega parcial con hora, monto y conductor.

20. **CU-CAJ-007 – Detectar Billetes Falsos**
    *Actor:* Cajero Principal.
    *Síntesis:* Verifica autenticidad del dinero recibido en cada entrega.

21. **CU-CAJ-008 – Manejar Diferencias en Entregas**
    *Actor:* Cajero Principal.
    *Síntesis:* Gestiona faltantes o sobrantes durante entregas parciales.

22. **CU-CAJ-009 – Liquidar al Conductor (Final de Turno)**
    *Actor:* Cajero Principal.
    *Síntesis:* Actúa como liquidador al cierre del turno del conductor.

23. **CU-CAJ-010 – Cerrar Caja del Conductor**
    *Actor:* Cajero Principal.
    *Síntesis:* Finaliza la caja abierta y calcula totales del día.

24. **CU-CAJ-011 – Calcular Liquidación Final**
    *Actor:* Cajero Principal.
    *Síntesis:* Determina monto a pagar al conductor según acuerdos.

25. **CU-CAJ-012 – Emitir Comprobante de Liquidación**
    *Actor:* Cajero Principal.
    *Síntesis:* Genera recibo oficial de liquidación al conductor.

26. **CU-CAJ-013 – Cuadrar Caja Propia Diaria**
    *Actor:* Cajero Principal.
    *Síntesis:* Reconcilia total recibido vs total registrado en sistema.

27. **CU-CAJ-014 – Depositar en Banco**
    *Actor:* Cajero Principal.
    *Síntesis:* Traslada efectivo consolidado a entidades financieras.

28. **CU-CAJ-015 – Administrar Caja Chica**
    *Actor:* Cajero Principal.
    *Síntesis:* Gestiona fondos para gastos operativos menores.

29. **CU-CAJ-016 – Entregar Vueltos y Cambio**
    *Actor:* Cajero Principal.
    *Síntesis:* Proporciona efectivo para operaciones de conductores.

30. **CU-CAJ-017 – Entregar Talonarios de Boletos Físicos a Conductores**
    *Actor:* Cajero Principal.
    *Síntesis:* Entrega talonarios a los conductores próximos a salir a ruta

31. **CU-CAJ-018 – Procesar Devolución de Boletos (Reasignación)**
    *Actor:* Cajero Principal.
    *Síntesis:* Conductor devuelve boletos al cajero y este los reserva para la siguiente asignación. Otro escenario, puede ser cuando el cajero debe reasignar porque en ruta un conductor recibió talonarios de otro conductor (casos en los q se ha acabado su talonario de boletos).

---

## **JEFE DE LIQUIDADOR**

32. **CU-JLI-001 – Supervisar Liquidaciones Diarias**
    *Actor:* Jefe de Liquidador.
    *Síntesis:* Controla que todas las liquidaciones se realicen correctamente.

33. **CU-JLI-002 – Revisar Cajas Liquidadas**
    *Actor:* Jefe de Liquidador.
    *Síntesis:* Valida post-liquidación que los cálculos estén correctos.

34. **CU-JLI-003 – Registrar Gastos Administrativos**
    *Actor:* Jefe de Liquidador.
    *Síntesis:* Documenta descuentos adicionales (combustible, mantenimiento, multas).

35. **CU-JLI-004 – Calcular Liquidación al Propietario**
    *Actor:* Jefe de Liquidador.
    *Síntesis:* Determina monto final después de gastos administrativos.

36. **CU-JLI-005 – Resolver Conflictos de Liquidación**
    *Actor:* Jefe de Liquidador.
    *Síntesis:* Media disputas entre conductores y cajeros por diferencias.

37. **CU-JLI-006 – Autorizar Ajustes Especiales**
    *Actor:* Jefe de Liquidador.
    *Síntesis:* Aprueba correcciones excepcionales en liquidaciones.

38. **CU-JLI-007 – Generar Reportes de Liquidación**
    *Actor:* Jefe de Liquidador.
    *Síntesis:* Consolida información diaria de todas las liquidaciones.

39. **CU-JLI-008 – Coordinar con Propietarios**
    *Actor:* Jefe de Liquidador.
    *Síntesis:* Comunica resultados y gestiona pagos a dueños de unidades.

