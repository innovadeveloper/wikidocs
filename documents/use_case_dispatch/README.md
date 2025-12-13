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
