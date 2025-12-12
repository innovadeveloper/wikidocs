# 📋 CASOS DE USO DETALLADOS - MÓDULO DESPACHO
## PARTE 1: JEFE OPERACIONES, ANALISTA Y SUPERVISOR TERMINAL

---

## JEFE OPERACIONES

### **CU-JOP-001: Planificar Operación Diaria**

**ID:** CU-JOP-001

**Actor:** Jefe Operaciones

**Precondiciones:**
- El Jefe Operaciones debe estar autenticado en el sistema con permisos de planificación
- Debe existir información histórica de operaciones de al menos 30 días
- Deben estar registradas las rutas activas en TbRuta
- Debe haber conductores disponibles registrados en TbPersona
- Debe haber unidades operativas disponibles en TbUnidad
- El Analista Operaciones debe haber generado la programación de salidas (si aplica)
- Deben estar configuradas las frecuencias por ruta en TbIntervaloFrecuencia

**Trigger:**
Se inicia un nuevo día operativo (generalmente a las 04:00 AM), o se requiere replantear la operación durante el día por eventos extraordinarios, o el sistema genera alerta de planificación diaria automática.

**Flujo Principal:**
1. El Jefe Operaciones accede al módulo de Planificación Operativa
2. El sistema muestra el dashboard operativo del día con:
   - Fecha y día de la semana
   - Tipo de día (laboral, sábado, domingo, feriado)
   - Programación base del día (si existe)
   - Recursos disponibles:
     * Total de conductores disponibles
     * Total de unidades operativas
     * Total de unidades en mantenimiento
   - Estado del clima (si tiene integración)
   - Eventos especiales del día (si están registrados)
3. El Jefe Operaciones revisa la demanda proyectada:
   - Demanda histórica del mismo día de semanas anteriores
   - Tendencias de demanda por franja horaria
   - Eventos especiales que pueden afectar demanda (conciertos, partidos, feriados)
4. El Jefe Operaciones revisa recursos disponibles:
   - Conductores:
     * Total activos
     * Con documentos vigentes
     * Sin restricciones
     * Disponibles por turno (mañana, tarde, noche)
   - Unidades:
     * Total operativas
     * Sin restricciones técnicas
     * Con mantenimiento al día
     * Combustible suficiente
5. El Jefe Operaciones define la estrategia operativa del día:
   - Selecciona esquema de operación:
     * Normal (sin eventos especiales)
     * Reforzado (alta demanda esperada)
     * Reducido (baja demanda, feriado)
     * Emergencia (contingencia)
   - Establece prioridades:
     * Rutas críticas que deben operar al 100%
     * Rutas secundarias con flexibilidad
     * Servicios express o especiales
6. El Jefe Operaciones asigna recursos por ruta:
   - Para cada ruta prioritaria:
     * Número de unidades a operar
     * Número de conductores requeridos
     * Frecuencia objetivo (minutos entre despachos)
     * Horario de inicio de operaciones
     * Horario de fin de operaciones
7. El sistema valida la asignación propuesta:
   - Verifica que hay suficientes conductores
   - Verifica que hay suficientes unidades
   - Calcula cobertura de frecuencias
   - Identifica brechas o sobreasignaciones
8. Si hay alertas de recursos insuficientes:
   - El sistema muestra faltantes:
     * "Faltan 5 conductores para cubrir turno tarde"
     * "Faltan 3 unidades para ruta 25"
   - El Jefe Operaciones ajusta:
     * Reasigna recursos entre rutas
     * Reduce frecuencias en rutas secundarias
     * Solicita conductores de reemplazo
     * Solicita préstamo de unidades (si aplica)
9. El Jefe Operaciones establece metas de producción:
   - Producción esperada por ruta (ingresos proyectados)
   - Número de servicios objetivo
   - Kilometraje a recorrer
   - Indicadores de puntualidad (% cumplimiento frecuencias)
10. El Jefe Operaciones configura turnos de personal:
    - Asigna Despachadores a terminales (A y B)
    - Asigna Monitoreadores GPS al turno
    - Asigna Supervisores de Terminal
    - Define rotaciones si hay relevos
11. El Jefe Operaciones registra instrucciones especiales:
    - Observaciones para despachadores
    - Alertas operativas del día
    - Restricciones o consideraciones especiales
    - Contactos de emergencia activos
12. El Jefe Operaciones hace clic en "Aprobar Plan Operativo del Día"
13. El sistema solicita confirmación mostrando resumen:
    ```
    PLAN OPERATIVO - 06/12/2024 (Viernes)
    Esquema: NORMAL
    
    RECURSOS ASIGNADOS:
    - Conductores: 45 activos
    - Unidades: 42 operativas
    - Rutas: 8 rutas activas
    
    COBERTURA:
    - Ruta 25: 100% (12 unidades, frecuencia 8 min)
    - Ruta 30: 100% (10 unidades, frecuencia 10 min)
    - Ruta 15: 90% (8 unidades, frecuencia 12 min)
    ...
    
    METAS:
    - Servicios objetivo: 450 salidas
    - Producción esperada: $15,000
    - Cumplimiento frecuencias: >= 85%
    ```
14. El Jefe Operaciones confirma el plan
15. El sistema registra el plan operativo en TbPlanOperativoDia:
    - Fecha
    - EsquemaOperacion
    - RecursosAsignados
    - MetasProduccion
    - Observaciones
    - Estado: Aprobado
    - UsuarioAprueba
    - FechaHoraAprobacion
16. El sistema ejecuta acciones automáticas:
    - Actualiza TbProgramacionDia con el plan aprobado
    - Activa las programaciones de salidas configuradas
    - Habilita terminales para operación
    - Configura frecuencias en el sistema de despacho
17. El sistema genera notificaciones automáticas:
    - A Supervisores de Terminal: plan del día aprobado
    - A Despachadores: instrucciones y metas del día
    - A Monitoreadores GPS: rutas y unidades a monitorear
    - A Analista Operaciones: plan ejecutado para seguimiento
18. El sistema genera documentos:
    - Hoja de ruta imprimible por terminal
    - Plan operativo en PDF
    - Dashboard de metas del día
19. El sistema activa monitoreo automático:
    - Indicadores de cumplimiento en tiempo real
    - Alertas de desviaciones del plan
    - Seguimiento de metas de producción
20. El sistema muestra confirmación: "Plan Operativo del Día aprobado y activado"

**Postcondiciones:**
- El plan operativo del día queda registrado y aprobado en el sistema
- Los recursos (conductores, unidades) quedan asignados a rutas específicas
- Las metas de producción quedan establecidas y activas para seguimiento
- El personal operativo recibe notificaciones con instrucciones del día
- El sistema de despacho queda configurado según el plan aprobado
- Los indicadores de seguimiento quedan activos para monitoreo en tiempo real
- El plan queda disponible para consulta y ajustes durante el día
- Queda registrado en auditoría la aprobación del plan operativo

---

### CU-JOP-002: Supervisar Cumplimiento Operativo

**ID:** CU-JOP-002

**Actor:** Jefe Operaciones

**Precondiciones:**
- Jefe Operaciones autenticado en el sistema
- Debe haber operación activa con despachos ejecutados
- Sistema registrando salidas en Tb_SalidaUnidad
- Datos históricos disponibles para comparación

**Trigger:**
- Jefe Operaciones necesita evaluar desempeño operativo del turno/día
- Se requiere reporte para gerencia
- Revisión programada (cada 2 horas)
- Finalización de turno

**Flujo Principal:**

1. **Acceso al Módulo de Supervisión**

Jefe Operaciones accede a "Supervisión Operativa"

Sistema muestra dashboard inicial:
```
📊 SUPERVISIÓN OPERATIVA
Terminal: A
Fecha: 06/12/2024
Hora: 10:30 AM

Estado: OPERACIÓN NORMAL ✅
```

2. **Selección de Tipo de Análisis**

Sistema presenta opciones según configuración:
```
📋 TIPO DE ANÁLISIS

Empresa configurada con:
[•] Programación de salidas (TbProgramacionSalida)
[•] Frecuencias objetivo (TbIntervaloFrecuencia)

Análisis disponible:
○ Cumplimiento vs Programación
○ Cumplimiento vs Frecuencias
● Análisis comparativo (sin programación)

Período:
[•] Última hora
[ ] Turno actual
[ ] Día completo

[GENERAR ANÁLISIS]
```

3. **Análisis con Programación/Frecuencias** (si aplica)

Sistema procesa datos y muestra:
```
⏰ CUMPLIMIENTO DE HORARIOS - RUTA 25

Período: 09:00 - 10:00 AM

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DESPACHOS EJECUTADOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Unidad | Hr Programa | Hr Real  | Desvío    | Estado
-------|-------------|----------|-----------|-------
245    | 09:00       | 09:01    | +1 min    | ✅
167    | 09:10       | 09:11    | +1 min    | ✅
312    | 09:20       | 09:19    | -1 min    | ✅
201    | 09:30       | 09:32    | +2 min    | ✅
189    | 09:40       | 09:44    | +4 min    | ⚠️

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MÉTRICAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Frecuencia objetivo: 10 minutos
Frecuencia real promedio: 10.6 minutos
Desviación: +0.6 min (+6%)

Cumplimiento (±2 min): 80% (4/5)
Retrasos >2 min: 20% (1/5)
Adelantos: 0%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OBSERVACIONES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• BUS-189: Retraso +4 min (única desviación)
• Tendencia general: Estable
• Impacto pasajeros: Bajo
```

4. **Análisis SIN Programación** (modo híbrido)

Si empresa opera sin programación formal, sistema muestra análisis comparativo:
```
📊 ANÁLISIS OPERATIVO COMPARATIVO - RUTA 25

Período: 09:00 - 10:00 AM

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PRODUCTIVIDAD HOY vs HISTÓRICO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Servicios ejecutados:
  Hoy (09:00-10:00):     5 servicios
  Promedio histórico:    6 servicios
  Diferencia:           -1 servicio (-17%)

Intervalo promedio despachos:
  Hoy:                  12.0 minutos
  Ayer mismo horario:   10.0 minutos
  Promedio semana:      10.5 minutos
  Diferencia:          +1.5 min (+14%)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DETALLE DESPACHOS EJECUTADOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Unidad | Hora Real | Intervalo | Observación
-------|-----------|-----------|-------------
245    | 09:00     | --        | Primera salida
167    | 09:11     | 11 min    | Normal
312    | 09:23     | 12 min    | Aceptable
201    | 09:37     | 14 min    | Ligeramente alto
189    | 09:51     | 14 min    | Ligeramente alto

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FACTORES IDENTIFICADOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• Disponibilidad unidades: 5 de 6 operando
  (BUS-401 fuera servicio)

• Tiempo promedio en cola: 8 minutos
  (Normal: 5-6 minutos)

• Demanda observada: Normal
• Congestión vial: No reportada

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EVALUACIÓN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Rendimiento: 83% vs histórico
Tendencia: ↓ Ligeramente bajo
Criticidad: 🟡 MEDIA (no crítico)

Causa principal aparente:
- Déficit de 1 unidad operativa
```

5. **Análisis Consolidado por Ruta**

Jefe Operaciones selecciona "Vista General Todas las Rutas":
```
📊 RESUMEN OPERATIVO - TODAS LAS RUTAS

Período: Turno Mañana (06:00 - 14:00)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CON PROGRAMACIÓN/FRECUENCIAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ruta | Servicios | Cumplim. | Desv.Prom | Estado
-----|-----------|----------|-----------|-------
25   | 24        | 92%      | +1.2 min  | ⭐ Excelente
30   | 19        | 95%      | +0.8 min  | ⭐ Excelente

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SIN PROGRAMACIÓN (Análisis comparativo)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ruta | Servic.Hoy | Prom.Hist | Variación | Estado
-----|------------|-----------|-----------|-------
15   | 11         | 13        | -15%      | ⚠️ Bajo
40   | 8          | 8         | 0%        | ✅ Normal

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
INDICADORES GLOBALES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total despachos turno: 62
Promedio histórico: 67
Rendimiento: 92.5%

Rutas con desempeño óptimo: 2 (Ruta 25, 30)
Rutas requieren atención: 1 (Ruta 15)
```

6. **Identificación de Patrones**

Sistema genera análisis de tendencias:
```
📈 ANÁLISIS DE TENDENCIAS

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PATRÓN HORA PICO (07:00-09:00)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Con programación:
• Cumplimiento: 88%
• Retrasos promedio: +2.1 min
• Patrón: Desviaciones normales hora pico

Sin programación:
• Servicios: 85% vs histórico
• Intervalos: +15% más largos que promedio
• Patrón: Déficit de unidades disponibles

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PATRÓN HORA VALLE (10:00-12:00)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Con programación:
• Cumplimiento: 96%
• Retrasos promedio: +0.5 min
• Patrón: Excelente control

Sin programación:
• Servicios: 98% vs histórico
• Intervalos: Consistentes con histórico
• Patrón: Operación normal
```

7. **Generación de Reporte Informativo**

Jefe Operaciones hace clic en "Generar Reporte":
```
📄 REPORTE OPERATIVO - SUPERVISIÓN

Fecha: 06/12/2024
Turno: Mañana (06:00 - 14:00)
Generado por: Roberto Sánchez (Jefe Operaciones)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RESUMEN EJECUTIVO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Despachos ejecutados: 62
Meta programada: 67
Cumplimiento: 92.5%

Calificación general: 🟢 BUENO

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RUTAS CON PROGRAMACIÓN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ruta 25:
• Cumplimiento horarios: 92% ⭐
• Frecuencia real: 10.6 min (obj: 10 min)
• Desviación: +6%
• Evaluación: Excelente

Ruta 30:
• Cumplimiento horarios: 95% ⭐
• Frecuencia real: 12.2 min (obj: 12 min)
• Desviación: +2%
• Evaluación: Excelente

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RUTAS SIN PROGRAMACIÓN (Análisis comparativo)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ruta 15:
• Servicios ejecutados: 11 (histórico: 13)
• Rendimiento: 85% vs promedio
• Intervalo promedio: 13.2 min (histórico: 11.5)
• Evaluación: Por debajo del estándar
• Causa identificada: 1 unidad fuera servicio

Ruta 40:
• Servicios ejecutados: 8 (histórico: 8)
• Rendimiento: 100% vs promedio ⭐
• Intervalo promedio: 15.0 min (histórico: 15.1)
• Evaluación: Conforme a patrón histórico

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SITUACIONES IDENTIFICADAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Ruta 15 - Rendimiento bajo
   Período: Todo el turno
   Factor: BUS-401 fuera servicio (avería)
   Impacto: -15% servicios vs histórico
   Prioridad: MEDIA

2. Hora pico - Ligeros retrasos
   Período: 07:00-09:00
   Factor: Congestión vehicular normal
   Impacto: +2.1 min promedio (aceptable)
   Prioridad: BAJA

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OBSERVACIONES OPERATIVAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Fortalezas:
✅ Rutas programadas con excelente cumplimiento
✅ Hora valle con operación óptima
✅ Ruta 40 mantiene patrón histórico consistente

Áreas de atención:
⚠️ Ruta 15 requiere unidad reemplazo
⚠️ Considerar refuerzo hora pico Ruta 25

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
COMPARACIÓN HISTÓRICA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

vs Turno anterior: Similar (+0.5%)
vs Promedio semanal: -7.5%
vs Meta mensual: 92.5% (meta: 90%) ✅

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONCLUSIÓN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Operación dentro de parámetros aceptables.
Rutas programadas con desempeño sobresaliente.
Ruta 15 presenta oportunidad de mejora por
déficit de unidad operativa.

Recomendación: Monitoreo continuo Ruta 15.

[EXPORTAR PDF] [ENVIAR EMAIL] [GUARDAR]
```

8. **Distribución del Reporte**

Sistema ofrece opciones:
```
📧 DISTRIBUIR REPORTE

Destinatarios sugeridos:
[x] Gerencia Operaciones
[x] Supervisor Terminal A
[ ] Analista Operaciones
[ ] Jefe Mantenimiento

Formato:
[•] PDF
[ ] Excel
[ ] Ambos

Adjuntar gráficos: [x] Sí

[ENVIAR] [CANCELAR]
```

**Postcondiciones:**
- Análisis de cumplimiento documentado (con/sin programación)
- Desviaciones identificadas y cuantificadas
- Causas probables registradas
- Reporte informativo generado
- Información disponible para toma de decisiones
- Historial actualizado para análisis de tendencias
- Sin acciones correctivas automáticas ejecutadas

**Diferencias Clave por Modalidad:**

| Aspecto | Con Programación | Sin Programación |
|---------|-----------------|------------------|
| Métrica principal | % Cumplimiento vs programado | % vs histórico |
| Referencia | TbProgramacionSalida/TbIntervaloFrecuencia | Promedio histórico |
| Evaluación | Objetivo/Verde/Amarillo/Rojo | Tendencia ↑↓→ |
| Salida | "Cumplimiento 92%" | "Rendimiento 85% vs histórico" |


---

### **CU-JOP-003: Coordinar con Gerencia** (omitir)

**ID:** CU-JOP-003

**Actor:** Jefe Operaciones

**Precondiciones:**
- El Jefe Operaciones debe estar autenticado en el sistema
- Debe existir una situación que requiera escalamiento a Gerencia
- Debe haber información operativa actualizada en el sistema
- Los KPIs operativos deben estar calculados y disponibles

**Trigger:**
Se presenta una situación crítica que excede la autoridad del Jefe Operaciones, o se programa reunión periódica de reporte gerencial, o la Gerencia solicita informe operativo urgente.

**Flujo Principal:**
1. El Jefe Operaciones accede al módulo de Coordinación Gerencial
2. El sistema muestra opciones de coordinación:
   - Generar reporte operativo ejecutivo
   - Escalar decisión crítica
   - Solicitar autorización especial
   - Reportar incidencia mayor
3. El Jefe Operaciones selecciona el tipo de coordinación requerida
4. El sistema prepara información contextual automáticamente:
   - Estado operativo actual
   - KPIs del día/período
   - Incidencias relevantes
   - Decisiones pendientes
5. El Jefe Operaciones completa la información:
   - Descripción de la situación
   - Análisis realizado
   - Opciones evaluadas
   - Recomendación
   - Urgencia (Alta/Media/Baja)
6. El sistema valida que la información esté completa
7. El Jefe Operaciones envía la coordinación a Gerencia
8. El sistema notifica inmediatamente a Gerencia Operaciones
9. El sistema registra el escalamiento con timestamp
10. El Jefe Operaciones espera respuesta o toma decisión temporal
11. Cuando Gerencia responde, el sistema notifica al Jefe Operaciones
12. El Jefe Operaciones ejecuta la decisión gerencial

**Postcondiciones:**
- La coordinación con Gerencia queda registrada en el sistema
- Las decisiones gerenciales quedan documentadas
- Queda trazabilidad de escalamientos y autorizaciones
- La información queda disponible para auditoría

---

### **CU-JOP-004: Gestionar Recursos Operativos**

**ID:** CU-JOP-004

**Actor:** Jefe Operaciones

**Precondiciones:**
- El Jefe Operaciones debe estar autenticado en el sistema
- Deben estar registrados los recursos disponibles (conductores, unidades)
- Debe existir demanda operativa (rutas activas)

**Trigger:**
Se detecta necesidad de reasignación de recursos durante la operación, o se presenta ausencia inesperada de personal, o una unidad sale de servicio.

**Flujo Principal:**
1. El Jefe Operaciones accede al módulo de Gestión de Recursos
2. El sistema muestra el inventario de recursos actual
3. El Jefe Operaciones identifica la necesidad de reasignación
4. El sistema valida disponibilidad de recursos alternativos
5. El Jefe Operaciones ejecuta la reasignación
6. El sistema actualiza asignaciones y notifica al personal afectado
7. El sistema registra el cambio en auditoría

**Postcondiciones:**
- Los recursos quedan reasignados según nueva configuración
- El personal afectado recibe notificación de cambios
- Queda registro de la reasignación en auditoría

---

### **CU-JOP-005: Evaluar Performance del Equipo**

**ID:** CU-JOP-005

**Actor:** Jefe Operaciones

**Precondiciones:**
- El Jefe Operaciones debe estar autenticado en el sistema
- Debe existir información histórica de desempeño del personal
- Los indicadores de productividad deben estar configurados

**Trigger:**
Se programa evaluación periódica del equipo (semanal/mensual), o se requiere evaluar desempeño para toma de decisiones.

**Flujo Principal:**
1. El Jefe Operaciones accede al módulo de Evaluación de Performance
2. El sistema muestra indicadores de productividad del equipo operativo
3. El Jefe Operaciones selecciona período a evaluar
4. El sistema genera análisis comparativo de desempeño
5. El Jefe Operaciones revisa indicadores por rol:
   - Despachadores: eficiencia, precisión, incidencias
   - Monitoreadores: tiempo de respuesta, alertas gestionadas
   - Supervisores: resolución de conflictos, liderazgo
6. El Jefe Operaciones identifica fortalezas y áreas de mejora
7. El Jefe Operaciones documenta evaluaciones y recomendaciones
8. El sistema genera reporte de evaluación

**Postcondiciones:**
- Las evaluaciones de performance quedan documentadas
- Se identifican necesidades de capacitación o refuerzo
- Se genera información para decisiones de RRHH

---

### **CU-JOP-006: Configurar Geocercas y Alertas**

**ID:** CU-JOP-006

**Actor Principal:** Jefe de operacione ( u otro usuario con permisos de configuración)

**Precondiciones:**
- Usuario con rol de configuración
- Rutas definidas en sistema
- Necesidad de ajuste operativo identificada

**Trigger:**
- Nueva ruta requiere geocerca
- Cambio en recorrido autorizado
- Zona de riesgo identificada
- Optimización de alertas requerida

**Flujo Principal:**

1. **Acceso a Configuración**
   - Usuario accede a módulo de geocercas
   - Sistema muestra mapa con geocercas existentes
   - Muestra panel de configuración de alertas

2. **Creación de Geocerca**
   - Selecciona herramienta de dibujo
   - Define área en mapa:
     * Polígono irregular (para rutas complejas)
     * Círculo (para puntos de control)
     * Corredor (para avenidas principales)
   - Asigna propiedades:
     * Nombre: "Ruta 25 - Tramo Centro"
     * Tipo: Ruta autorizada
     * Tolerancia: ±100 metros
     * Horario: 05:00-23:00

3. **Configuración de Alertas**
   - Define reglas:
     * Si unidad sale de geocerca > 5 minutos → Alerta MEDIA
     * Si velocidad > 80 km/h → Alerta ALTA
     * Si parada > 15 minutos fuera de terminal → Alerta BAJA
   - Asigna responsables:
     * Monitoreador GPS (primera línea)
     * Supervisor Terminal (escalamiento)

4. **Validación y Activación**
   - Sistema valida configuración
   - Prueba con datos históricos
   - Monitoreador activa geocerca
   - Sistema comienza monitoreo

**Postcondiciones:**
- Geocercas configuradas y activas
- Alertas automatizadas funcionando
- Monitoreo optimizado para operación
- Configuración documentada en sistema

---

### **CU-JOP-007 – Gestionar Restricciones Operativas**

**Actor:** Jefe de Operaciones  
**Precondición:** Motivo válido para restringir conductor/unidad

**Flujo:**
1. Jefe detecta situación que amerita restricción
2. Accede a Operaciones > Restricciones
3. Busca conductor/unidad
4. Define restricción:
   - **Tipo:** Temporal / Indefinida
   - **Duración:** Minutos/Horas/Días/Meses/Infinito
   - **Motivo:** Caja pendiente / Sanción / Investigación / Deuda / Mantenimiento
   - **Severidad:** Advertencia / Bloqueo total
5. Sistema registra en `TbRestriccion`
6. **Efecto inmediato:** Despachador ve alerta roja al intentar despachar
7. Para levantar: Jefe verifica resolución del motivo y libera

**Flujo alterno - Restricción automática:**
- Sistema detecta: Caja sin liquidar >24h
- Genera restricción automática
- Notifica Jefe Operaciones
- Jefe revisa y confirma/libera

**Diferencia con Especialista Documentos:**
- **Especialista:** Alerta preventiva (doc. vence en 7 días) → No bloquea
- **Jefe Operaciones:** Restricción coercitiva → Bloquea despacho

---

### **CU-JOP-008 – Diseñar Ruta Operativa**

**Actor:** Jefe de Operaciones  
**Actor Secundario:** Analista Operaciones (ejecuta técnicamente)  
**Precondición:** Autorización de ruta por ATU vigente

**Flujo Principal:**

1. Jefe recibe resolución ATU autorizando nueva ruta: **1065 (Puente Piedra - Miraflores)**
2. Delega a Analista Operaciones el diseño técnico
3. Analista accede a **Parámetros Operación > Diseño de Ruta**
4. Click **"Nueva Ruta"**
5. Ingresa datos básicos:
   - **Código:** 1065
   - **Nombre:** Puente Piedra - Miraflores
   - **Sentido A:** Puente Piedra → Miraflores
   - **Sentido B:** Miraflores → Puente Piedra
   - **Tipo:** Urbano regular
   - **Distancia estimada:** 32 km
6. **Traza recorrido Sentido A** en mapa:
   - Click en origen: Terminal Puente Piedra
   - Define puntos intermedios (calles principales)
   - Click en destino: Terminal Miraflores
   - Sistema genera línea azul con 45 puntos GPS
7. **Valida recorrido:**
   - Revisa con Google Maps
   - Verifica coincide con resolución ATU
8. **Traza recorrido Sentido B** (retorno):
   - Puede ser misma ruta o diferente
   - Sistema genera línea roja
9. **Guarda diseño**
10. Sistema registra en **TbRuta** + **TbRutaTrazado** (coordenadas)

**Postcondición:**
- Ruta lista para configurar geocercas (CU-ANO-002)
- Habilitada para crear controles de paso
- Disponible para programación de servicios

**Flujos Alternos:**

**FA1: Ruta con variantes**
- Define ruta principal + 2 variantes (obras, eventos)
- Sistema almacena 3 trazados alternativos
- Programación puede elegir cuál usar por fecha

**FA2: Modificación ruta existente**
- Selecciona ruta 1059
- Ajusta tramo por cambio vial
- Guarda como nueva versión
- Mantiene histórico trazados anteriores

---

### **CU-JOP-009 – Registrar Nueva Unidad**

**Actor:** Jefe de Operaciones

**Flujo:**
1. Accede a T-REG > Unidades > Nuevo
2. Ingresa datos técnicos:
   - **Padrón:** 089 (número interno)
   - **Placa:** F1P-925
   - **Marca/Modelo:** Mercedes-Benz / OF-1721
   - **Año fabricación:** 2018
   - **Capacidad:** 45 pasajeros sentados
   - **Combustible:** Diésel
   - **N° motor / chasis**
3. Datos operativos:
   - **Ruta asignada:** 1059 (San Gabriel - Lima)
   - **Terminal base:** Chuquitanta
   - **Tipo servicio:** Regular urbano
4. Documentación vehículo:
   - Tarjeta propiedad
   - SOAT vigencia
   - Revisión técnica
   - Certificado GNV (si aplica)
5. Estado inicial: "Activo - Sin GPS"
6. Sistema registra en TbUnidad
7. Genera ficha técnica imprimible

**Pendiente:** Enlace GPS (CU-ANO-006) y propietario (CU-JOP-008)

---

### **CU-JOP-010 – Enlazar Unidad a Propietario**

**Actor:** Jefe de Operaciones

**Flujo:**
1. Accede a T-REG > Enlace de Unidad
2. Busca unidad: 089 F1P-925
3. Busca propietario en TbPersonas (tipo: Propietario)
4. Si no existe propietario:
   - Crea persona tipo "Propietario"
   - DNI/RUC, razón social
5. Enlaza unidad → propietario
6. Define participación:
   - **Propietario único:** 100%
   - **Accionistas múltiples:** % distribución (ej: 60% + 40%)
7. Registra contrato vigencia
8. Sistema crea TbEnlaceUnidadPropietario
9. Habilita acceso móvil para propietario:
   - Usuario: dni.propietario@empresa
   - Perfil: "Propietario" (solo consulta su unidad)
10. Propietario puede ver desde app:
    - Producción diaria de su unidad
    - Ubicación GPS
    - Reportes de rendimiento

**Validación:** Suma de participaciones = 100%

---


### **CU-JOP-011 – Aplicar Restricciones por Documentación**

**Actor:** Jefe de Operaciones  
**Trigger:** Alerta automática del sistema

**Flujo:**
1. Sistema genera alerta diaria 6:00 AM:
```
CONDUCTORES CON DOCUMENTACIÓN CRÍTICA:

MEDINA, Jorge - Licencia vence en 5 días ⚠️
- Acción sugerida: Restricción parcial
- Última renovación: 10/12/2020

GONZALES, Luis - SOAT vencido hace 2 días 🔴
- Acción sugerida: Bloqueo total
- Última renovación: 09/12/2025
```

2. Jefe revisa cada caso
3. **Caso MEDINA (preventivo):**
   - Accede a Operaciones > Restricciones
   - Busca conductor: MEDINA, Jorge
   - Aplica restricción:
     * Tipo: Temporal
     * Duración: 7 días (hasta renovación)
     * Motivo: "Licencia vence 10/12"
     * Severidad: Advertencia
   - Despachador verá: 🟡 "Renovar licencia urgente"
   - Puede despachar, pero queda registrado
4. **Caso GONZALES (crítico):**
   - Aplica restricción:
     * Tipo: Indefinida
     * Motivo: "SOAT vencido"
     * Severidad: Bloqueo total
   - Despachador verá: 🔴 "BLOQUEADO - SOAT vencido"
   - **No puede despachar** hasta renovación
5. Notifica a conductores vía SMS/WhatsApp
6. Sistema registra en TbRestriccion
7. **Para levantar restricción:**
   - Especialista Documentos valida documento renovado
   - Notifica Jefe Operaciones
   - Jefe marca restricción "Liberada"
   - Conductor vuelve operativo

**Trazabilidad completa:** Quién bloqueó, cuándo, por qué, quién liberó.

---

## ANALISTA OPERACIONES

### **CU-ANL-001: Crear Programación de Salidas** (No ajustado a la realidad)

**ID:** CU-ANL-001

**Actor:** Analista Operaciones

**Precondiciones:**
- El Analista Operaciones debe estar autenticado en el sistema con permisos de programación
- Deben estar definidas las rutas activas en TbRuta
- Deben estar configuradas las frecuencias objetivo en TbIntervaloFrecuencia
- Debe haber información histórica de demanda de al menos 30 días
- Deben estar disponibles conductores y unidades suficientes

**Trigger:**
Se inicia el proceso de programación diaria (generalmente día anterior a las 18:00), o se requiere reprogramación por cambios en la operación, o se planifica operación especial (feriado, evento).

**Flujo Principal:**
1. El Analista Operaciones accede al módulo de Programación de Salidas
2. El sistema muestra el asistente de programación:
   - Fecha a programar
   - Tipo de día (laboral, sábado, domingo, feriado)
   - Eventos especiales registrados
   - Programación base sugerida (template)
3. El Analista selecciona la fecha objetivo (ej: mañana 07/12/2024)
4. El sistema analiza demanda histórica:
   - Recupera datos de mismos días de semanas anteriores
   - Calcula promedio de demanda por franja horaria
   - Identifica patrones estacionales
   - Proyecta demanda esperada
5. El sistema muestra matriz de programación base:
   ```
   RUTA 25 - Frecuencia Objetivo: Variable
   
   Franja Horaria    | Frecuencia | Unidades | Servicios
   ------------------|------------|----------|----------
   05:00 - 06:00     | 15 min     | 4        | 16
   06:00 - 09:00     | 8 min      | 8        | 96
   09:00 - 12:00     | 12 min     | 6        | 72
   12:00 - 14:00     | 10 min     | 6        | 48
   14:00 - 18:00     | 12 min     | 6        | 72
   18:00 - 21:00     | 8 min      | 8        | 96
   21:00 - 23:00     | 15 min     | 4        | 32
   ```
6. El Analista revisa y ajusta la programación:
   - Modifica frecuencias según demanda esperada
   - Ajusta número de unidades por franja
   - Considera restricciones operativas:
     * Disponibilidad de conductores
     * Unidades en mantenimiento
     * Combustible disponible
7. Para cada ruta, el Analista define:
   - Hora de primer despacho (ej: 05:00)
   - Hora de último despacho (ej: 23:00)
   - Frecuencia por franja horaria
   - Tipo de servicio (normal, express, especial)
8. El sistema calcula automáticamente:
   - Total de servicios programados
   - Total de unidades requeridas
   - Total de conductores necesarios
   - Kilometraje total a recorrer
   - Combustible estimado
   - Producción esperada (ingresos proyectados)
9. El sistema valida la factibilidad:
   - Verifica suficientes conductores disponibles
   - Verifica suficientes unidades operativas
   - Valida cumplimiento de frecuencias mínimas ATU
   - Calcula índice de utilización de recursos
10. Si hay alertas de factibilidad:
    - "Faltan 3 conductores para cubrir turno tarde"
    - "Frecuencia en hora pico menor a la autorizada por ATU"
    - El Analista ajusta la programación
11. El Analista genera horarios detallados:
    - Para cada salida programada:
      * Número de salida
      * Hora de despacho exacta
      * Unidad sugerida (si hay asignación previa)
      * Conductor sugerido (si hay asignación previa)
      * Terminal de salida (A o B)
      * Tipo de servicio
12. El sistema genera vista previa de la programación:
    - Cronograma completo de salidas
    - Gráfico de distribución de frecuencias
    - Resumen de recursos
    - KPIs proyectados
13. El Analista revisa la programación completa
14. El Analista hace clic en "Guardar Programación"
15. El sistema registra en TbProgramacionSalida:
    - Fecha programada
    - Ruta
    - Detalle de cada salida (hora, frecuencia, etc.)
    - Recursos asignados
    - Estado: Borrador
    - Usuario: Analista
    - Fecha creación
16. El Analista puede:
    - Enviar para aprobación al Jefe Operaciones
    - Publicar directamente (si tiene autorización)
    - Guardar como template para futuros días
17. Si envía para aprobación:
    - El sistema notifica al Jefe Operaciones
    - Estado cambia a: "Pendiente Aprobación"
18. Cuando el Jefe Operaciones aprueba:
    - Estado cambia a: "Aprobada"
    - La programación queda activa para el día objetivo
    - El sistema configura automáticamente:
      * ProcColaDespacho con los horarios
      * Alertas de cumplimiento
      * Metas del día
19. El sistema genera documentos:
    - Hoja de ruta imprimible por terminal
    - Programación en PDF para despachadores
    - Dashboard de seguimiento
20. El sistema muestra confirmación: "Programación creada exitosamente"

**Postcondiciones:**
- La programación de salidas queda registrada en TbProgramacionSalida
- Los horarios detallados están definidos para cada servicio
- Los recursos (conductores, unidades) quedan pre-asignados o disponibles
- El sistema de despacho queda configurado para ejecutar la programación
- Los despachadores tienen acceso a la programación para el día siguiente
- Las metas de producción quedan establecidas
- Queda registro en auditoría de la programación creada

---

### CU-ANL-001: Cargar Programación de Salidas desde Archivo (No todas las empresas optan por este medio, poco común)


**IDENTIFICACIÓN**

* **ID:** CU-ANL-001
* **Nombre:** Cargar Programación de Salidas desde Archivo Externo
* **Actor Principal:** Analista Operaciones
* **Nivel:** Táctico



**PRECONDICIONES**

* Analista autenticado con permisos de carga
* Archivo preparado externamente (Excel/CSV)
* Formato validado según plantilla estándar
* Rutas activas registradas
* Fecha de programación definida



**TRIGGER**

* Programación completada en FreeWay/Excel
* Reprogramación de un día
* Evento especial (feriado, cambio de demanda)



**FLUJO PRINCIPAL**

1. **Preparación del Archivo (Proceso Externo)**

   * Analista usa herramienta externa (FreeWay/Excel):

     * Analiza demanda
     * Optimiza frecuencias
     * Define horarios
   * Exporta archivo Excel o CSV con columnas:

     ```
     Fecha | Ruta | HoraSalida | Terminal | Unidad | Conductor | TipoServicio
     ```

2. **Acceso al Módulo de Carga**

   * Ingresa a “Gestión de Programación”
   * Selecciona *"Cargar Programación desde Archivo"*
   * Sistema muestra fecha, plantilla y botón para cargar archivo

3. **Selección y Validación del Archivo**

   ```
   VALIDACIONES PRE-CARGA:
   ✓ Formato válido
   ✓ Columnas correctas
   ✓ Fechas correctas
   ✓ Rutas existentes
   ✓ Horarios dentro de rango
   ⚠ 3 advertencias (unidad inexistente)
   ✖ 2 errores (hora inválida)
   ```

4. **Revisión de Errores/Advertencias**

   ```
   ERRORES CRÍTICOS (2):
   - Fila 45: Hora "25:30"
   - Fila 78: Ruta "99"

   ADVERTENCIAS (3):
   - Fila 12: Unidad no encontrada
   - Fila 34: Conductor no asignado
   - Fila 56: Gap de 15 min
   ```

5. **Vista Previa de Datos**

   ```
   PROGRAMACIÓN A CARGAR:
   Fecha: 07/12/2024

   Ruta 25: 145 salidas  
   Ruta 30: 98 salidas  
   Ruta 15: 76 salidas  
   Total: 319 servicios
   ```

6. **Confirmación de Carga**

   ```
   ¿Cargar 319 servicios para el 07/12/2024?
   Esta acción reemplaza programación existente.
   ```

7. **Proceso de Carga Masiva**

   ```
   BEGIN TRANSACTION
   DELETE programación previa
   INSERT registros del archivo
   COMMIT
   ```

   Progreso:

   ```
   [████████████░░░] 75%
   ```

8. **Validaciones Post-Carga**

   ```
   ✓ 319 registros insertados
   ✓ Sin duplicados
   ✓ Frecuencias consistentes
   ⚠ Ruta 15: sin servicios 10:00-12:00
   ```

9. **Configuración Automática**

   * Marca programación como *Aprobada*
   * Configura horarios para despacho
   * Activa alertas de cumplimiento
   * Prepara dashboard del día siguiente

10. **Selección de Modo de Ejecución**

```
( ) Manual
(•) Semi-Automático
( ) Automático
```

11. **Generación de Documentos**

* Hoja de ruta PDF
* Archivo maestro
* Dashboard web
* Notificaciones al personal

12. **Confirmación Final**

```
✓ PROGRAMACIÓN CARGADA

Total: 319 servicios  
Modo: Semi-Automático  
Estado: Aprobada
```



**POSTCONDICIONES**

* Programación cargada en base de datos
* Validaciones realizadas
* Modo definido
* Documentos generados
* Personal notificado


---
### **CU-ANL-002: Optimizar Frecuencias por Horario**

**ID:** CU-ANL-002

**Actor:** Analista Operaciones

**Precondiciones:**
- El Analista Operaciones debe estar autenticado en el sistema
- Debe existir información histórica de demanda de al menos 90 días
- Deben estar registradas las frecuencias actuales en TbIntervaloFrecuencia
- Debe haber datos de cumplimiento de frecuencias en el sistema
- Los puntos de control deben estar configurados en Tb_Control

**Trigger:**
Se programa análisis periódico de optimización (mensual), o se detectan desviaciones sistemáticas de frecuencias, o hay cambios significativos en patrones de demanda.

**Flujo Principal:**
1. El Analista Operaciones accede al módulo de Optimización de Frecuencias
2. El sistema muestra el panel de análisis con:
   - Rutas disponibles para optimizar
   - Última fecha de optimización
   - Desviaciones detectadas
3. El Analista selecciona la ruta a optimizar (ej: Ruta 25)
4. El sistema solicita período de análisis:
   - Fecha inicio
   - Fecha fin
   - Días a incluir (Lunes-Viernes, Sábados, Domingos)
5. El Analista configura parámetros (ej: últimos 90 días, solo laborables)
6. El sistema procesa información histórica:
   - Extrae datos de Tb_RegistroTrack (GPS)
   - Extrae datos de TbBoletoTransaccion (demanda real)
   - Extrae datos de Tb_SalidaUnidad (servicios ejecutados)
7. El sistema analiza patrones de demanda:
   - Genera matriz de demanda por hora del día:
     ```
     Hora  | Lun | Mar | Mié | Jue | Vie | Promedio | Desv.Est
     ------|-----|-----|-----|-----|-----|----------|----------
     05:00 |  45 |  42 |  48 |  44 |  46 |   45     |   2.2
     06:00 | 120 | 118 | 125 | 122 | 130 |  123     |   4.5
     07:00 | 280 | 275 | 290 | 285 | 295 |  285     |   7.6
     08:00 | 350 | 345 | 360 | 355 | 365 |  355     |   7.9
     ...
     ```
   - Identifica horas pico:
     * Mañana: 07:00 - 09:00 (demanda 285-355 pasajeros/hora)
     * Mediodía: 12:00 - 14:00 (demanda 180-210 pasajeros/hora)
     * Tarde: 18:00 - 20:00 (demanda 290-340 pasajeros/hora)
   - Identifica horas valle:
     * Madrugada: 05:00 - 06:00 (demanda 40-50 pasajeros/hora)
     * Media mañana: 09:00 - 11:00 (demanda 120-150 pasajeros/hora)
     * Noche: 21:00 - 23:00 (demanda 60-80 pasajeros/hora)
8. El sistema calcula capacidad requerida: 
   - Capacidad por unidad: 40 pasajeros sentados + 60 parados = 100
   - Factor de ocupación objetivo: 80%
   - Capacidad efectiva: 80 pasajeros por unidad
9. El sistema calcula frecuencias óptimas:
   ```
   Franja Horaria | Demanda | Capacidad | Unidades | Frecuencia
                  | (pas/h) | Req(un/h) | Óptimas  | Óptima
   ---------------|---------|-----------|----------|------------
   05:00 - 06:00  |   45    |   0.6     |    2     |  30 min
   06:00 - 07:00  |  123    |   1.5     |    4     |  15 min
   07:00 - 08:00  |  285    |   3.6     |    6     |  10 min
   08:00 - 09:00  |  355    |   4.4     |    8     |   8 min
   09:00 - 12:00  |  140    |   1.8     |    4     |  15 min
   12:00 - 14:00  |  195    |   2.4     |    5     |  12 min
   14:00 - 18:00  |  160    |   2.0     |    4     |  15 min
   18:00 - 20:00  |  315    |   3.9     |    7     |   9 min
   20:00 - 23:00  |   70    |   0.9     |    3     |  20 min
   ```
10. El sistema compara con frecuencias actuales:
    - Frecuencia actual vs. óptima
    - Identifica sobre-oferta (desperdicio de recursos)
    - Identifica sub-oferta (demanda insatisfecha)
11. El sistema genera recomendaciones:
    - "Reducir frecuencia 09:00-12:00 de 12 a 15 min (ahorro: 2 unidades)"
    - "Incrementar frecuencia 18:00-20:00 de 12 a 9 min (mejora servicio)"
    - "Mantener frecuencia actual en hora pico mañana (óptima)"
12. El sistema calcula impacto de optimización:
    - Ahorro de recursos:
      * Reducción de 15 servicios diarios
      * Ahorro combustible: 120 galones/mes
      * Ahorro horas conductor: 45 horas/mes
    - Mejora de servicio:
      * Reducción tiempo espera: -3 minutos promedio
      * Mejora ocupación: +12% factor de ocupación
      * Incremento satisfacción estimada: +8%
13. El Analista revisa las recomendaciones
14. El Analista puede:
    - Aceptar todas las recomendaciones
    - Aceptar selectivamente algunas
    - Ajustar manualmente frecuencias
15. El Analista aplica los cambios:
    - Hace clic en "Aplicar Optimización"
16. El sistema solicita confirmación:
    - Muestra resumen de cambios
    - Muestra impacto esperado
17. El Analista confirma los cambios
18. El sistema actualiza TbIntervaloFrecuencia:
    - Registra nuevas frecuencias por franja horaria
    - Marca fecha de última optimización
    - Registra usuario que optimizó
19. El sistema genera documento de optimización:
    - Análisis de demanda
    - Frecuencias anteriores vs. nuevas
    - Justificación de cambios
    - Impacto proyectado
20. El sistema notifica:
    - Al Jefe Operaciones: frecuencias optimizadas
    - Al equipo de programación: usar nuevas frecuencias
21. El sistema programa seguimiento:
    - Evaluación en 30 días de impacto real
    - Comparación resultados vs. proyección
22. El sistema muestra confirmación: "Frecuencias optimizadas exitosamente"

**Postcondiciones:**
- Las frecuencias óptimas quedan registradas en TbIntervaloFrecuencia
- Queda documentado el análisis y justificación de cambios
- Las nuevas frecuencias quedan disponibles para programación de salidas
- Se establece seguimiento automático de impacto de optimización
- Queda registro en auditoría de la optimización realizada
- El equipo operativo queda notificado de los cambios
- Se proyectan ahorros y mejoras de servicio

---

### **CU-SUP-002: Configurar Tiempos de Recorrido y Controles** 


**ID:** CU-ANL-003

**Nombre:** Configurar Tiempos de Llegada a Controles por Horario

**Actor:** Analista Operaciones

**Precondiciones:**

* Analista autenticado con permisos de configuración operativa
* Ruta con recorrido definido en TbRecorrido
* Puntos de control configurados en Tb_Control y Tb_RecorridoXControl
* Orden secuencial de controles establecido (NroOrden)
* Distancias entre controles calculadas
* Datos históricos de tiempos de recorrido disponibles (mínimo 30 días)

**Trigger:**

* Nueva ruta requiere configuración de tiempos
* Cambios significativos en tráfico vehicular observados
* Actualización mensual programada de tiempos
* Solicitud de ajuste por desviaciones sistemáticas
* Modificación de recorrido autorizado

**Flujo Principal:**

1. **Acceso al Módulo de Configuración de Tiempos**

   Analista ingresa a "Gestión de Recorridos y Tiempos"

   Sistema muestra:

   * Listado de rutas activas
   * Última fecha de actualización de tiempos
   * Alertas de rutas con desviaciones >10% tiempo programado vs real

2. **Selección de Ruta y Período de Análisis**

   Analista selecciona ruta a configurar (ej: Ruta 25)

   Sistema solicita:

   ```
   Período de análisis histórico:
   Fecha inicio: 01/10/2024
   Fecha fin: 06/12/2024
   Tipo de días: [X] Laborables [ ] Sábados [ ] Domingos
   Franjas horarias: [X] Todas [ ] Solo horas pico
   ```

3. **Visualización de Recorrido Actual**

   Sistema muestra matriz actual:

   ```
   RUTA 25 - CONFIGURACIÓN ACTUAL

   Control | Nombre                | Km Acum | Tiempo Prog | Tiempo Real Prom
   --------|----------------------|---------|-------------|------------------
   1       | Terminal A (Origen)  |  0.0    |  00:00      |  00:00
   2       | Paradero Central     |  3.5    |  00:08      |  00:09 (+1 min)
   3       | Av. Principal Norte  |  7.2    |  00:16      |  00:19 (+3 min)
   4       | Cruce Hospital       | 10.8    |  00:24      |  00:28 (+4 min)
   5       | Plaza Mayor          | 14.3    |  00:32      |  00:38 (+6 min)
   6       | Terminal B (Destino) | 18.0    |  00:40      |  00:48 (+8 min)
   ```

4. **Análisis de Tiempos Históricos Reales**

   Sistema procesa datos de Tb_RegistroTrack y Tb_SalidaUnidadHoraPaso:

   ```
   ANÁLISIS POR FRANJA HORARIA

   HORA PICO MAÑANA (07:00-09:00):
   Control 1 → 2: 9 min promedio (programado: 8 min) +12%
   Control 2 → 3: 11 min promedio (programado: 8 min) +37%
   Control 3 → 4: 10 min promedio (programado: 8 min) +25%
   Control 4 → 5: 11 min promedio (programado: 8 min) +37%
   Control 5 → 6: 9 min promedio (programado: 8 min) +12%

   HORA VALLE (10:00-16:00):
   Control 1 → 2: 7 min promedio (programado: 8 min) -12%
   Control 2 → 3: 8 min promedio (programado: 8 min) OK
   Control 3 → 4: 7 min promedio (programado: 8 min) -12%
   Control 4 → 5: 8 min promedio (programado: 8 min) OK
   Control 5 → 6: 7 min promedio (programado: 8 min) -12%
   ```

5. **Identificación de Puntos Críticos**

   Sistema resalta:

   **Cuellos de botella detectados:**

   * Control 2 → 3 (Av. Principal Norte): Congestión hora pico +37%
   * Control 4 → 5 (Plaza Mayor): Semáforos múltiples +37%

   **Tramos eficientes:**

   * Control 1 → 2: Cumple en todas las franjas
   * Control 5 → 6: Tramo final fluido

6. **Configuración Diferenciada por Franja Horaria**

   Analista define tiempos distintos según horario:

   ```
   NUEVA CONFIGURACIÓN PROPUESTA

   HORA PICO (06:00-09:00 y 18:00-20:00):
   Control | Tiempo Actual | Tiempo Real | Tiempo Propuesto
   1 → 2   |  8 min       |  9 min      |  9 min
   2 → 3   |  8 min       | 11 min      | 11 min ⚠️ Ajustado
   3 → 4   |  8 min       | 10 min      | 10 min ⚠️ Ajustado
   4 → 5   |  8 min       | 11 min      | 11 min ⚠️ Ajustado
   5 → 6   |  8 min       |  9 min      |  9 min
   TOTAL   | 40 min       | 50 min      | 50 min

   HORA VALLE (09:00-18:00):
   Control | Tiempo Actual | Tiempo Real | Tiempo Propuesto
   1 → 2   |  8 min       |  7 min      |  7 min ✓ Optimizado
   2 → 3   |  8 min       |  8 min      |  8 min
   3 → 4   |  8 min       |  7 min      |  7 min ✓ Optimizado
   4 → 5   |  8 min       |  8 min      |  8 min
   5 → 6   |  8 min       |  7 min      |  7 min ✓ Optimizado
   TOTAL   | 40 min       | 37 min      | 37 min
   ```

7. **Ajuste Manual de Tiempos Específicos**

   Analista puede editar manualmente:

   * Hace clic en celda de tiempo
   * Ingresa nuevo valor (ej: "12 min")
   * Sistema valida: tiempo mínimo físico según velocidad máxima permitida

8. **Cálculo de Horarios de Paso**

   Sistema genera matriz completa para hoja de ruta:

   ```
   Ejemplo: Salida programada 07:00 (Hora Pico)

   Control | Nombre              | Hora Paso | Tolerancia
   --------|--------------------|-----------|-----------
   1       | Terminal A         | 07:00     | ±0 (salida)
   2       | Paradero Central   | 07:09     | ±2 min
   3       | Av. Principal      | 07:20     | ±3 min
   4       | Cruce Hospital     | 07:30     | ±3 min
   5       | Plaza Mayor        | 07:41     | ±3 min
   6       | Terminal B         | 07:50     | ±2 min (llegada)
   ```

9. **Configuración de Tolerancias**

   Analista define márgenes para alertas:

   ```
   TOLERANCIAS POR TIPO DE CONTROL:

   Salida de terminal: ±0 min (exacto)
   Control intermedio: ±3 min (flexible)
   Llegada terminal: ±2 min (puntualidad crítica)

   ALERTAS CONFIGURADAS:
   - Retraso >5 min: ALERTA AMARILLA
   - Retraso >10 min: ALERTA ROJA
   - Adelanto >3 min: ALERTA (posible servicio acelerado)
   ```

10. **Vista Previa de Hoja de Ruta**

    Sistema genera preview:

    ```
    HOJA DE RUTA - RUTA 25
    Válida desde: 08/12/2024

    SALIDA 07:00 (HORA PICO):
    Terminal A      07:00
    Paradero Ctral  07:09 (±2)
    Av. Principal   07:20 (±3)
    Cruce Hospital  07:30 (±3)
    Plaza Mayor     07:41 (±3)
    Terminal B      07:50 (±2)
    Tiempo total: 50 minutos

    SALIDA 11:00 (HORA VALLE):
    Terminal A      11:00
    Paradero Ctral  11:07 (±2)
    Av. Principal   11:15 (±3)
    Cruce Hospital  11:22 (±3)
    Plaza Mayor     11:30 (±3)
    Terminal B      11:37 (±2)
    Tiempo total: 37 minutos
    ```

11. **Validación y Confirmación**

    Sistema valida:

    * Tiempos físicamente posibles según distancias
    * Coherencia entre franjas horarias
    * Sin conflictos con normativa ATU

    Analista confirma: **"Guardar Configuración"**

12. **Registro en Base de Datos**

    Sistema actualiza:

    **Tb_TiempoPromedioControl:** Tiempos por tramo y franja horaria

    **Tb_RecorridoXControl:** Actualiza tiempos esperados por control

    **TbConfiguracionRecorrido:** Parámetros generales de la ruta

13. **Generación Automática de Hojas de Ruta**

    Sistema produce documentos para impresión:

    **Hoja de Ruta Conductor (PDF):**

    * Listado de controles con horarios
    * Tolerancias marcadas
    * Instrucciones especiales

    **Hoja de Control Inspector (PDF):**

    * Matriz de horarios de todas las salidas del día
    * Espacios para registrar hora real de paso
    * Sección de observaciones

14. **Aplicación en Programación de Salidas**

    Cuando Analista carga programación (CU-ANL-001):

    * Sistema calcula automáticamente horarios de paso usando configuración
    * Genera hojas de ruta individuales por salida
    * Prepara sistema para detectar retrasos/adelantos

**Postcondiciones:**

* Tiempos de recorrido actualizados por franja horaria en sistema
* Matriz de horarios de paso configurada para cada control
* Tolerancias de retraso/adelanto definidas
* Hojas de ruta generadas automáticamente
* Sistema preparado para detectar desviaciones operativas
* Base para cálculo de retrasos y adelantos establecida
* Documentación disponible para conductores e inspectores
* Auditoría de cambios registrada con justificación


---

## SUPERVISOR TERMINAL

### **CU-SUP-001: Resolver Excepciones Escaladas**

**ID:** CU-SUP-001

**Actor:** Supervisor Terminal

**Precondiciones:**
- El Supervisor Terminal debe estar autenticado en el sistema con permisos de autorización especial
- Debe existir una excepción que requiere autorización de supervisor
- El despachador debe haber intentado resolver primero la situación
- Debe haber información completa de la unidad, conductor y restricción en el sistema
- La excepción debe estar registrada en TbDespachoOcurrencia

**Trigger:**
Un despachador escala un caso que excede su autoridad, o el sistema detecta una restricción crítica que requiere autorización manual, o un conductor solicita excepción a través del despachador.

**Flujo Principal:**
1. El sistema genera alerta al Supervisor Terminal:
   ```
   🚨 EXCEPCIÓN REQUIERE AUTORIZACIÓN
   
   Unidad: BUS-245
   Conductor: Juan Pérez
   Tipo: Documentos próximos a vencer
   Despachador: María González (Terminal A)
   Hora: 08:15 AM
   ```
2. El Supervisor Terminal accede al módulo de Gestión de Excepciones
3. El sistema muestra el detalle de la excepción escalada:
   - **Información de la Unidad:**
     * CodUnidad: 245
     * Placa: ABC-123
     * Estado mecánico: Operativo ✅
     * Última revisión: 01/12/2024
     * GPS activo: Sí ✅
   - **Información del Conductor:**
     * Nombre: Juan Pérez
     * Licencia: A-1234567
     * Puntos actuales: 82 puntos ✅
     * Experiencia: 5 años
   - **Detalle de la Restricción:**
     * Tipo: Documento próximo a vencer
     * Documento: Examen psicosomático
     * Fecha vencimiento: 15/12/2024 (9 días)
     * Criticidad: Media ⚠️
     * Política: Alertar < 30 días
   - **Suministros:**
     * Boletos físicos: Completo ✅
     * Stock mínimo: Cumple ✅
   - **Contexto Operativo:**
     * Ruta asignada: Ruta 25
     * Frecuencia objetivo: 10 minutos
     * Unidades operando: 7 de 8
     * Demanda actual: Alta (hora pico)
4. El sistema muestra el historial del conductor:
   - Excepciones anteriores: 2 en último año
     * 15/03/2024: Documento vencido - Autorizado
     * 22/08/2024: Stock bajo - Rechazado
   - Cumplimiento general: 95% ✅
   - Incidencias: 1 en último mes (menor)
   - Última capacitación: 10/11/2024
5. El sistema muestra opciones de decisión:
   - ✅ **AUTORIZAR** despacho con observaciones
   - ❌ **RECHAZAR** despacho hasta regularizar
   - 🔄 **AUTORIZAR TEMPORAL** (solo este turno)
   - 📋 **SOLICITAR INFORMACIÓN ADICIONAL**
6. El Supervisor analiza el caso considerando:
   - Criticidad de la restricción (Media)
   - Tiempo para vencimiento (9 días - suficiente)
   - Impacto operativo (ruta crítica, hora pico)
   - Historial del conductor (bueno)
   - Alternativas disponibles (no hay conductor de reemplazo)
7. El Supervisor toma la decisión: **AUTORIZAR con observaciones**
8. El sistema solicita justificación obligatoria:
   - Campo de texto para motivo de autorización
   - Selección de tipo de autorización:
     * Temporal (solo este turno)
     * Hasta regularización
     * Excepcional
9. El Supervisor completa la justificación:
   ```
   Documento vence en 9 días (plazo razonable).
   Conductor con buen historial (95% cumplimiento).
   Hora pico, ruta crítica, sin reemplazo disponible.
   CONDICIÓN: Conductor debe renovar documento en máximo 7 días.
   ```
10. El Supervisor selecciona condiciones de la autorización:
    - ☑️ Válido solo para este turno
    - ☑️ Requiere seguimiento en 7 días
    - ☑️ Notificar a RRHH para renovación
    - ☑️ Alerta automática si no se regulariza
11. El Supervisor hace clic en "Autorizar Despacho"
12. El sistema registra la autorización en TbDespachoOcurrencia:
    - CodDespachoOcurrencia: Auto-generado
    - TipoOcurrencia: "Autorización Excepcional"
    - CodUnidad: 245
    - CodPersona: Juan Pérez
    - MotivoOriginal: "Documento próximo a vencer"
    - DecisionSupervisor: "AUTORIZADO"
    - Justificacion: [texto completo]
    - Condiciones: [lista de condiciones]
    - FechaHoraAutorizacion: Timestamp actual
    - UsuarioAutoriza: Supervisor Terminal
    - EstadoSeguimiento: "Pendiente"
13. El sistema ejecuta acciones automáticas:
    - **Actualiza TbDespachoValidacion:**
      * Marca restricción como "Autorizada por Supervisor"
      * Registra vigencia de autorización
    - **Notifica al Despachador:**
      * "Excepción AUTORIZADA - Puede despachar unidad 245"
    - **Notifica al Conductor:**
      * "Despacho autorizado. RECORDATORIO: Renovar examen psicosomático antes del 13/12"
    - **Notifica a RRHH:**
      * "Conductor Juan Pérez requiere renovación urgente de examen psicosomático"
    - **Programa seguimiento automático:**
      * Alerta en 7 días si no se renovó documento
      * Bloqueo automático si llega a vencer
14. El sistema habilita el despacho:
    - Actualiza estado en ProcColaDespacho
    - Permite continuar proceso de autorización
    - Marca unidad como "Despacho Autorizado con Condiciones"
15. El Despachador recibe notificación y puede proceder con el despacho normal
16. El sistema registra en auditoría:
    - Excepción escalada
    - Decisión del Supervisor
    - Justificación completa
    - Condiciones establecidas
    - Timestamp completo
17. El sistema genera documento de autorización:
    - Comprobante imprimible
    - Código de autorización único
    - Vigencia de la autorización
    - Condiciones y responsabilidades
18. El Supervisor puede monitorear seguimiento:
    - Accede a panel de "Autorizaciones Pendientes"
    - Ve estado de cumplimiento de condiciones
    - Recibe alertas si no se regulariza
19. El sistema actualiza KPIs del Supervisor:
    - Total de excepciones gestionadas: +1
    - Autorizaciones concedidas: +1
    - Tiempo promedio de resolución: actualizado
20. El sistema muestra confirmación: "Excepción autorizada exitosamente - Despacho habilitado"

**Flujos Alternativos:**

**FA1: Supervisor Rechaza Despacho**
- En paso 7, el Supervisor decide **RECHAZAR**
- Sistema solicita motivo de rechazo
- Supervisor ingresa: "Documento crítico muy próximo a vencer. Riesgo operativo alto"
- Sistema bloquea despacho de la unidad
- Notifica a Despachador, Conductor y Jefe Operaciones
- Conductor debe regularizar antes de operar
- Sistema registra rechazo en auditoría

**FA2: Supervisor Solicita Información Adicional**
- En paso 7, el Supervisor selecciona **SOLICITAR INFORMACIÓN**
- Sistema permite solicitar:
  * Fotos del documento
  * Confirmación de cita médica
  * Información adicional del conductor
- Despachador recopila información
- Supervisor evalúa nuevamente
- Continúa con autorización o rechazo

**FA3: Autorización Temporal (Solo Este Turno)**
- En paso 7, el Supervisor elige **AUTORIZAR TEMPORAL**
- Autorización válida solo para este servicio
- Al finalizar turno, restricción vuelve a bloquear
- Conductor debe regularizar obligatoriamente antes del siguiente turno
- Sistema envía alerta crítica a RRHH

**Postcondiciones:**
- La excepción queda resuelta con decisión documentada
- Si se autorizó, el despacho queda habilitado para proceder
- Si se rechazó, la unidad queda bloqueada hasta regularización
- Queda registro completo en auditoría de la decisión y justificación
- Las partes involucradas (Despachador, Conductor, RRHH) reciben notificación
- Se establece seguimiento automático de las condiciones
- Los KPIs del Supervisor se actualizan
- El caso queda disponible para análisis posterior
- Se genera trazabilidad completa de autorizaciones excepcionales

---

### **CU-SUP-002: Monitorear KPIs en Tiempo Real**

**ID:** CU-SUP-002

**Actor:** Supervisor Terminal

**Precondiciones:**
- El Supervisor Terminal debe estar autenticado en el sistema
- Debe haber un turno operativo activo
- Deben estar configurados los KPIs operativos en TbConfiguracion
- Debe haber unidades operando en tiempo real
- El sistema GPS debe estar activo y registrando en Tb_RegistroTrack

**Trigger:**
El Supervisor Terminal inicia su turno, o se programa revisión periódica de KPIs (cada 30 minutos), o el sistema detecta desviación significativa de un indicador.

**Flujo Principal:**
1. El Supervisor Terminal accede al Dashboard de Indicadores Operativos
2. El sistema muestra vista general del turno:
   ```
   📊 DASHBOARD OPERATIVO - TERMINAL A
   Turno: Mañana (05:00 - 14:00)
   Supervisor: Carlos Rodríguez
   Hora actual: 08:45 AM
   Tiempo transcurrido: 3h 45min
   ```
3. El sistema presenta KPIs principales en tiempo real:

   **A. CUMPLIMIENTO DE FRECUENCIAS**
   ```
   Indicador Global: 87% ✅
   Meta: >= 85%
   
   Por Ruta:
   - Ruta 25: 92% ✅ (Excelente)
   - Ruta 30: 88% ✅ (Bueno)
   - Ruta 15: 78% ⚠️ (Bajo objetivo)
   - Ruta 40: 95% ✅ (Excelente)
   ```

   **B. EFICIENCIA DE DESPACHO**
   ```
   Tiempo Promedio Despacho: 3.2 minutos
   Meta: <= 4 minutos ✅
   
   Despachos realizados: 142
   Despachos programados: 155
   Cumplimiento: 91.6% ✅
   
   Unidades en cola actual: 4
   Tiempo máximo en cola: 12 minutos ✅
   ```

   **C. PRODUCTIVIDAD**
   ```
   Servicios completados: 128
   Servicios en curso: 14
   Servicios programados: 155
   Avance: 82.6% ✅
   
   Producción acumulada: $4,250
   Producción objetivo turno: $5,000
   Avance: 85% ✅
   Proyección cierre turno: $5,100 ✅
   ```

   **D. INCIDENCIAS**
   ```
   Total incidencias: 8
   - Críticas: 1 ⚠️
   - Medias: 3
   - Menores: 4
   
   Tiempo promedio resolución: 15 minutos ✅
   Incidencias sin resolver: 2
   ```

   **E. RECURSOS OPERATIVOS**
   ```
   Conductores activos: 18 de 20
   Unidades operando: 16 de 18
   Utilización: 88.9% ✅
   
   Conductores en descanso: 2
   Unidades en mantenimiento: 2
   ```

4. El sistema muestra gráficos visuales:
   - **Gráfico de Frecuencias en el Tiempo:**
     * Eje X: Hora del día (05:00 - 14:00)
     * Eje Y: Minutos entre despachos
     * Línea objetivo vs. línea real por ruta
   - **Gráfico de Cola de Despacho:**
     * Unidades en cola por hora
     * Picos de congestión
   - **Gráfico de Productividad:**
     * Producción acumulada vs. objetivo
     * Proyección al cierre del turno

5. El Supervisor identifica un KPI en alerta: **Ruta 15 con 78% cumplimiento**
6. El Supervisor hace clic en "Ruta 15" para análisis detallado
7. El sistema despliega vista drill-down de la Ruta 15:
   ```
   RUTA 15 - ANÁLISIS DETALLADO
   
   Frecuencia Objetivo: 12 minutos
   Frecuencia Real Promedio: 15.8 minutos
   Desvío: +3.8 minutos (31.7%)
   Cumplimiento: 78% ⚠️
   
   CAUSAS IDENTIFICADAS:
   1. Unidad 167 - Fuera de servicio (avería mecánica 07:30 AM)
   2. Congestión Av. Principal - Retraso promedio +5 min
   3. Conductor 023 - Paradas prolongadas (+2 min promedio)
   
   SERVICIOS:
   - Programados: 24
   - Ejecutados: 18
   - En curso: 2
   - Cancelados: 4 (por falta de unidad)
   
   ACCIONES TOMADAS:
   - 08:00 AM: Despachador solicitó unidad de reemplazo
   - 08:15 AM: Unidad 189 asignada como reemplazo
   ```

8. El Supervisor evalúa si requiere acción adicional:
   - Unidad de reemplazo ya asignada ✅
   - Congestión es temporal (tráfico normal para hora)
   - Conductor 023 en observación

9. El Supervisor decide: **Monitorear de cerca - Sin acción inmediata**
10. El Supervisor registra nota en el sistema:
    ```
    Ruta 15 bajo observación especial.
    Unidad de reemplazo ya despachada (08:15).
    Monitorear conductor 023 - paradas prolongadas.
    Evaluar nuevamente en 30 minutos.
    ```

11. El sistema permite al Supervisor configurar alertas personalizadas:
    - Alerta si Ruta 15 baja a < 75%
    - Alerta si tiempo en cola > 20 minutos
    - Alerta si productividad < 80% del objetivo

12. El Supervisor revisa **Incidencia Crítica**:
    ```
    🚨 INCIDENCIA CRÍTICA
    
    Hora: 07:30 AM
    Unidad: BUS-167
    Tipo: Avería mecánica
    Descripción: Falla en sistema de frenos
    Estado: En atención
    Conductor: Pedro Martínez (ileso)
    Ubicación: Km 12 de la ruta
    
    ACCIONES TOMADAS:
    - 07:35 AM: Grúa solicitada
    - 07:40 AM: Unidad 189 enviada como reemplazo
    - 07:45 AM: Pasajeros transbordados
    - 08:00 AM: Unidad 167 en camino a taller
    
    ESTADO ACTUAL: En resolución ⏳
    Responsable: Supervisor Carlos Rodríguez
    ```

13. El Supervisor verifica que todas las acciones fueron ejecutadas
14. El Supervisor actualiza estado de incidencia: **Resuelta**
15. El sistema solicita cierre de incidencia:
    - Resumen de acciones
    - Tiempo total de resolución: 30 minutos
    - Impacto: 4 servicios cancelados
    - Aprendizajes: [opcional]

16. El Supervisor cierra la incidencia con resumen
17. El sistema actualiza KPIs:
    - Incidencias críticas resueltas: +1
    - Tiempo promedio resolución: actualizado
    - Servicios afectados: +4

18. El Supervisor genera acciones preventivas:
    - Solicita revisión mecánica de unidades similares
    - Programa mantenimiento preventivo reforzado
    - Documenta lecciones aprendidas

19. El sistema permite exportar reporte del turno:
    - Resumen de KPIs
    - Incidencias gestionadas
    - Decisiones tomadas
    - Observaciones

20. Al finalizar su turno, el Supervisor genera reporte ejecutivo:
    ```
    REPORTE DE TURNO - TERMINAL A
    Supervisor: Carlos Rodríguez
    Fecha: 06/12/2024
    Turno: Mañana (05:00 - 14:00)
    
    RESUMEN DE KPIs:
    ✅ Cumplimiento Frecuencias: 87%
    ✅ Eficiencia Despacho: 3.2 min promedio
    ✅ Productividad: 102% del objetivo
    ⚠️ Incidencias: 8 (1 crítica)
    
    LOGROS:
    - Producción superó objetivo en 2%
    - Tiempo de despacho mejoró vs. ayer (-0.3 min)
    - Todas las incidencias resueltas
    
    ÁREAS DE MEJORA:
    - Ruta 15 requiere optimización de frecuencias
    - Conductor 023 en plan de capacitación
    - Mantenimiento preventivo de frenos (unidad 167)
    
    RECOMENDACIONES:
    - Ajustar frecuencia Ruta 15 en hora pico
    - Reforzar supervisión paradas de conductores
    - Programar mantenimiento preventivo flota
    ```

**Postcondiciones:**
- El estado operativo del turno queda monoreado y documentado
- Los KPIs quedan actualizados en tiempo real
- Las desviaciones significativas quedan identificadas y atendidas
- Las incidencias críticas quedan resueltas y cerradas
- Las acciones correctivas quedan registradas y asignadas
- El reporte del turno queda disponible para análisis gerencial
- Queda registro en auditoría de las decisiones del Supervisor
- Se generan recomendaciones para mejora continua

---

### **CU-SUP-003: Gestionar Personal del Turno**

**ID:** CU-SUP-003

**Actor:** Supervisor Terminal

**Precondiciones:**
- El Supervisor Terminal debe estar autenticado en el sistema
- Debe haber personal asignado al turno en TbProgramacionDia
- Deben estar registrados los roles y permisos del personal
- El sistema de asistencia debe estar activo

**Trigger:**
Se inicia el turno y el Supervisor debe verificar asistencia, o se presenta una ausencia inesperada de personal, o se requiere un reemplazo urgente.

**Flujo Principal:**
1. El Supervisor Terminal accede al módulo de Gestión de Personal
2. El sistema muestra el roster del turno:
   ```
   PERSONAL ASIGNADO - TURNO MAÑANA
   Terminal: A
   Fecha: 06/12/2024
   Horario: 05:00 - 14:00
   
   DESPACHADORES:
   ✅ María González - Presente (05:00)
   ✅ Pedro Ramírez - Presente (05:05)
   ❌ Ana Torres - AUSENTE
   
   MONITOREADORES GPS:
   ✅ Luis Mendoza - Presente (04:55)
   
   SUPERVISOR:
   ✅ Carlos Rodríguez - Presente (04:50)
   ```

3. El sistema detecta ausencia: **Ana Torres (Despachadora)**
4. El sistema genera alerta automática al Supervisor
5. El Supervisor verifica motivo de ausencia:
   - Consulta si hay justificación previa
   - Revisa historial de asistencia
   - Contacta al despachador ausente

6. El Supervisor determina: **Ausencia injustificada**
7. El Supervisor evalúa impacto operativo:
   - Despachadores disponibles: 2 (María y Pedro)
   - Carga esperada: 155 despachos en turno
   - Capacidad con 2 despachadores: Suficiente ✅
   - Decisión: No requiere reemplazo inmediato

8. El Supervisor registra la ausencia en el sistema:
   - Tipo: Injustificada
   - Requiere seguimiento RRHH: Sí
   - Impacto operativo: Bajo

9. El sistema notifica automáticamente a RRHH
10. El Supervisor reasigna carga de trabajo:
    - María González: Terminal A - Zona 1
    - Pedro Ramírez: Terminal A - Zona 2
    - Ambos cubren la operación completa

11. Durante el turno, Pedro Ramírez reporta malestar
12. El Supervisor evalúa la situación:
    - Síntomas: Dolor de cabeza, mareo
    - Capacidad para continuar: Limitada
    - Hora: 10:30 AM
    - Servicios restantes: 45

13. El Supervisor decide: **Relevar a Pedro - Solicitar reemplazo**
14. El Supervisor contacta al despachador de reserva:
    - Llama a Juan Sánchez (reserva del día)
    - Confirma disponibilidad: Sí
    - Tiempo estimado de llegada: 30 minutos

15. El Supervisor autoriza a Pedro para retirarse:
    - Registra salida anticipada
    - Motivo: Salud
    - Requiere justificación médica: Sí

16. El Supervisor reorganiza temporalmente (30 min):
    - María González cubre ambas zonas
    - Reduce frecuencia de despacho temporalmente
    - Comunica situación a Jefe Operaciones

17. Juan Sánchez llega y se integra al turno
18. El Supervisor registra el cambio:
    - Pedro Ramírez: Salida 10:30 AM
    - Juan Sánchez: Ingreso 11:00 AM
    - Observaciones: Relevo por salud

19. El sistema actualiza asignaciones automáticamente
20. Al finalizar turno, el Supervisor genera reporte de personal:
    ```
    REPORTE DE PERSONAL - TURNO MAÑANA
    
    ASISTENCIA:
    - Programados: 4
    - Presentes al inicio: 3
    - Ausentes: 1 (Ana Torres - Injustificada)
    
    INCIDENCIAS:
    - Pedro Ramírez - Retiro por salud (10:30 AM)
    - Juan Sánchez - Reemplazo (11:00 AM)
    
    DESEMPEÑO:
    - María González: Excelente (142 despachos)
    - Pedro Ramírez: Bueno (hasta salida - 68 despachos)
    - Juan Sánchez: Bueno (32 despachos en 3 horas)
    
    OBSERVACIONES:
    - Ana Torres: Derivar a RRHH por ausencia
    - Pedro Ramírez: Requiere certificado médico
    - María González: Destacar por cubrir operación
    ```

**Postcondiciones:**
- La asistencia del personal queda registrada
- Las ausencias quedan documentadas y notificadas a RRHH
- Los reemplazos quedan gestionados y registrados
- La continuidad operativa queda asegurada
- El desempeño del personal queda evaluado
- Queda trazabilidad de cambios y decisiones

---

### **CU-SUP-004: Coordinar con Autoridades Externas** 

***Nota*** : 
- Por revisar que tan crítico es para el negocio un módulo como este, debido a q se acerca a una especie de gestión de ticket/incidencias.



**ID:** CU-SUP-004

**Actor:** Supervisor Terminal

**Precondiciones:**
- El Supervisor Terminal debe estar autenticado en el sistema
- Debe existir una situación que requiere coordinación externa
- Deben estar configurados los contactos de emergencia
- El Supervisor debe tener autorización para representar a la empresa

**Trigger:**
Se presenta un accidente de tránsito con una unidad, o hay un operativo de fiscalización de ATU, o se requiere apoyo de Policía o Municipio, o hay una emergencia que involucra autoridades.

**Flujo Principal (Caso: Accidente de Tránsito):**
1. El Monitoreador GPS reporta al Supervisor: "Unidad 245 involucrada en accidente"
2. El Supervisor solicita información inmediata:
   - Ubicación exacta
   - Gravedad del accidente
   - Estado del conductor
   - Pasajeros heridos
   - Daños materiales

3. El Monitoreador reporta:
   ```
   Ubicación: Av. Principal Km 15
   Gravedad: Moderada (choque con vehículo particular)
   Conductor: Ileso
   Pasajeros: 2 con contusiones menores
   Daños: Frontal de la unidad
   ```

4. El Supervisor activa protocolo de emergencia:
   - Contacta al Conductor para verificar estado
   - Solicita fotos del accidente
   - Verifica que conductor active triángulos de seguridad

5. El Supervisor coordina con Policía Nacional:
   - Llama al 105 (emergencias)
   - Reporta el accidente
   - Solicita presencia policial
   - Proporciona datos:
     * Ubicación exacta
     * Placa de la unidad
     * Nombre del conductor
     * Número de heridos

6. El Supervisor coordina asistencia médica:
   - Llama a ambulancia (si hay heridos)
   - Coordina con SAMU o servicio privado
   - Proporciona información de heridos

7. El Supervisor notifica internamente:
   - Jefe Operaciones: Accidente en curso
   - Jefe Flota: Unidad 245 fuera de servicio
   - Área Legal: Preparar documentación
   - Seguros: Activar póliza

8. El Supervisor coordina con ATU (Autoridad de Transporte):
   - Reporta el accidente según normativa
   - Proporciona información requerida
   - Coordina inspección si es necesaria

9. El Supervisor gestiona reemplazo operativo:
   - Asigna unidad de reemplazo para la ruta
   - Transborda pasajeros si es necesario
   - Ajusta programación temporalmente

10. El Supervisor documenta en el sistema:
    ```
    INCIDENCIA: ACCIDENTE DE TRÁNSITO
    
    Fecha/Hora: 06/12/2024 - 08:45 AM
    Unidad: BUS-245
    Conductor: Juan Pérez
    Ubicación: Av. Principal Km 15
    
    AUTORIDADES CONTACTADAS:
    - Policía Nacional: ✅ Patrulla 156 en camino
    - Ambulancia: ✅ SAMU unidad 03 despachada
    - ATU: ✅ Reportado (Ticket #12345)
    
    ACCIONES TOMADAS:
    - 08:47: Unidad 189 asignada como reemplazo
    - 08:50: Pasajeros transbordados
    - 08:55: Personal legal en camino
    - 09:00: Grúa solicitada
    
    ESTADO: En atención de autoridades
    ```

11. El Supervisor coordina con Policía en sitio:
    - Proporciona documentación requerida
    - Facilita declaración del conductor
    - Obtiene copia del parte policial

12. El Supervisor coordina con perito de seguros:
    - Facilita inspección de daños
    - Proporciona documentos del vehículo
    - Coordina evaluación de responsabilidades

13. El Supervisor da seguimiento hasta cierre:
    - Verifica que conductor esté bien
    - Confirma atención a heridos
    - Asegura traslado seguro de la unidad

14. El Supervisor genera reporte oficial:
    ```
    REPORTE OFICIAL DE ACCIDENTE
    
    DATOS DEL INCIDENTE:
    - Fecha: 06/12/2024
    - Hora: 08:45 AM
    - Lugar: Av. Principal Km 15
    - Unidad: BUS-245 (Placa ABC-123)
    
    CONDUCTOR:
    - Nombre: Juan Pérez
    - Licencia: A-1234567
    - Estado: Ileso
    - Resultado alcoholemia: Negativo
    
    DAÑOS:
    - Unidad propia: Frontal (estimado $5,000)
    - Tercero: Lateral derecho (estimado $3,000)
    
    AUTORIDADES:
    - Parte Policial: #789456
    - Oficial a cargo: Sgt. Ramírez
    - Perito seguros: Lic. Mendoza
    
    RESPONSABILIDAD PRELIMINAR:
    - Tercero invadió carril
    - Pendiente investigación oficial
    
    SEGUIMIENTO:
    - Unidad en taller (estimado 7 días)
    - Seguro activado: Póliza #ABC123
    - Legal: En proceso de reclamación
    ```

**Flujos Alternativos:**

**FA1: Operativo de Fiscalización ATU**
- ATU llega al terminal para inspección
- Supervisor coordina acceso a instalaciones
- Facilita documentación requerida
- Coordina con personal para atender requerimientos
- Documenta resultado de la inspección

**FA2: Bloqueo de Vía por Municipio**
- Municipio notifica cierre temporal de vía
- Supervisor coordina rutas alternas
- Comunica a monitoreadores y despachadores
- Ajusta frecuencias por desvío
- Documenta impacto operativo

**Postcondiciones:**
- La coordinación con autoridades queda registrada y documentada
- Las acciones de emergencia quedan ejecutadas conforme a protocolo
- Los reportes oficiales quedan generados para autoridades
- El seguimiento del caso queda establecido
- La trazabilidad completa queda disponible para auditoría

---

## DESPACHADOR

### **CU-DES-001: Consultar Cola de Despacho**

**ID:** CU-DES-001

**Actor:** Despachador

**Precondiciones:**
- El Despachador debe estar autenticado en el sistema
- Debe tener asignado un terminal (A o B)
- Debe haber al menos una unidad en cola o próxima a entrar
- El sistema de cola debe estar activo (ProcColaDespacho)

**Trigger:**
El Despachador inicia su turno, o finaliza un despacho y necesita ver la siguiente unidad, o consulta el estado de la cola proactivamente.

**Flujo Principal:**
1. El Despachador accede al módulo de Cola de Despacho
2. El sistema muestra la vista principal de la cola:
   ```
   📋 COLA DE DESPACHO - TERMINAL A
   Despachador: María González
   Fecha: 06/12/2024
   Hora: 08:15 AM
   
   UNIDADES EN COLA: 6
   ```

3. El sistema presenta la lista ordenada de unidades:
   ```
   ╔══════╦═══════════╦═══════════╦══════════╦════════════╗
   ║ Pos  ║  Unidad   ║ Conductor ║   Ruta   ║  Hr Prog   ║
   ╠══════╬═══════════╬═══════════╬══════════╬════════════╣
   ║  1️⃣  ║ BUS-245   ║ J. Pérez  ║ Ruta 25  ║ 08:20 AM   ║
   ║  2️⃣  ║ BUS-189   ║ M. López  ║ Ruta 30  ║ 08:22 AM   ║
   ║  3️⃣  ║ BUS-167   ║ C. García ║ Ruta 25  ║ 08:25 AM   ║
   ║  4️⃣  ║ BUS-201   ║ A. Torres ║ Ruta 15  ║ 08:30 AM   ║
   ║  5️⃣  ║ BUS-198   ║ L. Rojas  ║ Ruta 30  ║ 08:32 AM   ║
   ║  6️⃣  ║ BUS-223   ║ P. Castro ║ Ruta 40  ║ 08:35 AM   ║
   ╚══════╩═══════════╩═══════════╩══════════╩════════════╝
   ```

4. Para cada unidad, el sistema muestra indicadores visuales:
   - **🟢 Verde:** Lista para despachar (sin restricciones)
   - **🟡 Amarillo:** Alerta menor (requiere atención)
   - **🔴 Rojo:** Restricción crítica (requiere autorización)
   - **⏰ Reloj:** Tiempo en cola

5. El Despachador hace clic en la primera unidad (BUS-245)
6. El sistema despliega información detallada:
   ```
   🚌 UNIDAD: BUS-245 (Placa: ABC-123)
   
   DATOS BÁSICOS:
   - Marca/Modelo: Mercedes Benz O-500
   - Año: 2019
   - Estado: Operativo 🟢
   - GPS: Activo ✅
   - Ubicación actual: Terminal A - Bahía 3
   
   CONDUCTOR:
   - Nombre: Juan Pérez Gómez
   - Licencia: A-1234567
   - Puntos: 85 ✅
   - Experiencia: 5 años
   - Última capacitación: 15/11/2024
   
   RUTA ASIGNADA:
   - Ruta: 25 (Centro - Terminal Sur)
   - Sentido: Ida
   - Frecuencia objetivo: 10 minutos
   - Última salida ruta 25: 08:10 AM (hace 5 min)
   
   PROGRAMACIÓN:
   - Hora programada: 08:20 AM
   - Tiempo para despacho: -5 minutos (En hora) ✅
   - Número de salida: 42
   - Tipo servicio: Normal
   
   VALIDACIONES:
   ✅ Documentos vigentes (14/14)
   ✅ Suministro completo
   ✅ Puntos licencia (85 >= 75)
   ✅ Stock mínimo cumplido
   ✅ GPS activo
   ✅ Ubicación en terminal
   
   ESTADO: LISTO PARA DESPACHAR 🟢
   ```

7. El Despachador revisa validaciones automáticas:
   - Todos los checks en verde ✅
   - No hay restricciones
   - Unidad lista para autorizar

8. El sistema muestra información adicional útil:
   ```
   HISTORIAL RECIENTE:
   - Último servicio: Ayer 18:45 PM (Ruta 25)
   - Producción último servicio: $145.50
   - Cumplimiento: 100%
   - Incidencias: 0
   
   SUMINISTROS DETALLE:
   - Boletos Ruta 25 (Adulto): 450 unidades ✅
   - Boletos Ruta 25 (Estudiante): 200 unidades ✅
   - Boletos Ruta 25 (Universitario): 150 unidades ✅
   - Stock total: 800 boletos
   
   COMBUSTIBLE:
   - Nivel: 87% (tanque lleno ayer) ✅
   - Autonomía: ~350 km
   - Suficiente para: 4 vueltas completas
   ```

9. El Despachador puede:
   - **Autorizar despacho inmediatamente**
   - Ver siguiente unidad en cola
   - Filtrar cola por ruta
   - Buscar unidad específica
   - Reorganizar orden (si tiene permiso)

10. El Despachador consulta siguiente unidad (BUS-189)
11. El sistema muestra que tiene una alerta 🟡:
    ```
    🚌 UNIDAD: BUS-189
    
    ALERTAS:
    ⚠️ Stock de boletos bajo límite óptimo
    - Stock actual: 320 boletos
    - Stock mínimo: 300 boletos
    - Stock óptimo: 400 boletos
    - Estado: Por debajo de óptimo (puede despachar)
    
    RECOMENDACIÓN:
    - Puede despachar sin problema
    - Considerar reabastecer al finalizar servicio
    - Suficiente para 1 vuelta completa
    ```

12. El Despachador hace nota mental de reabastecer BUS-189 después

13. El Despachador consulta filtros disponibles:
    - **Por Ruta:** Ver solo unidades de Ruta 25
    - **Por Estado:** Ver solo unidades listas / con alertas / bloqueadas
    - **Por Prioridad:** Ver servicios express primero
    - **Por Hora Programada:** Orden cronológico estricto

14. El Despachador aplica filtro: **Solo Ruta 25**
15. El sistema muestra:
    ```
    COLA FILTRADA - RUTA 25
    
    1️⃣ BUS-245 - J. Pérez - 08:20 AM 🟢
    2️⃣ BUS-167 - C. García - 08:25 AM 🟢
    3️⃣ BUS-312 - R. Sánchez - 08:30 AM 🟡
    ```

16. El Despachador quita el filtro para ver cola completa
17. El sistema restaura vista completa de todas las rutas

18. El Despachador consulta información de cola global:
    ```
    ESTADÍSTICAS DE COLA
    
    Total unidades en cola: 6
    Por ruta:
    - Ruta 25: 3 unidades
    - Ruta 30: 2 unidades
    - Ruta 15: 1 unidad
    - Ruta 40: 0 unidades (sin unidades esperando)
    
    Tiempo promedio en cola: 8 minutos
    Tiempo máximo en cola: 15 minutos (BUS-201)
    
    Próximos despachos programados (15 min):
    - 08:20 AM - BUS-245 (Ruta 25)
    - 08:22 AM - BUS-189 (Ruta 30)
    - 08:25 AM - BUS-167 (Ruta 25)
    - 08:30 AM - BUS-201 (Ruta 15)
    ```

19. El Despachador puede exportar la cola actual:
    - PDF para impresión
    - Excel para análisis
    - Enviar por email a Supervisor

20. El sistema actualiza la cola automáticamente cada 30 segundos:
    - Nuevas unidades que llegan
    - Cambios de estado
    - Modificaciones de horarios
    - Alertas nuevas

**Postcondiciones:**
- El Despachador tiene visibilidad completa de la cola
- Conoce el estado de cada unidad en espera
- Identifica restricciones o alertas que requieren atención
- Puede planificar los próximos despachos
- Tiene información para tomar decisiones informadas

---

### **CU-DES-002: Autorizar Despacho Normal**

**ID:** CU-DES-002

**Actor:** Despachador

**Precondiciones:**
- El Despachador debe estar autenticado en el sistema
- Debe haber consultado la cola de despacho (CU-DES-001)
- La unidad seleccionada debe estar en cola activa
- Todas las validaciones automáticas deben estar aprobadas
- La unidad debe estar dentro de la ventana de despacho programada

**Trigger:**
La hora programada de despacho se aproxima (dentro de 5 minutos), o el Despachador decide adelantar un despacho por necesidad operativa, o finaliza el proceso de validación manual.

**Flujo Principal:**
1. El Despachador selecciona la unidad lista para despachar (BUS-245)
2. El sistema muestra resumen pre-despacho:
   ```
   🚌 PRE-DESPACHO - BUS-245
   
   ✅ VALIDACIONES COMPLETAS
   
   Conductor: Juan Pérez
   Ruta: 25 (Centro - Terminal Sur)
   Hora programada: 08:20 AM
   Hora actual: 08:18 AM
   Estado: LISTO PARA AUTORIZAR 🟢
   
   ÚLTIMA VERIFICACIÓN:
   ✅ Documentos: 14/14 vigentes
   ✅ Licencia: 85 puntos
   ✅ Suministros: Completo
   ✅ GPS: Activo y en terminal
   ✅ Combustible: 87%
   ✅ Stock: 800 boletos
   ```

3. El Despachador verifica visualmente que:
   - El conductor está presente en la unidad
   - La unidad está en posición de salida
   - No hay pasajeros abordando aún
   - El área de salida está despejada

4. El Despachador hace clic en **"AUTORIZAR DESPACHO"**

5. El sistema solicita confirmación final:
   ```
   ⚠️ CONFIRMAR DESPACHO
   
   Unidad: BUS-245
   Conductor: Juan Pérez
   Ruta: 25
   Hora: 08:20 AM
   
   ¿Está seguro de autorizar este despacho?
   
   [SÍ, AUTORIZAR]  [CANCELAR]
   ```

6. El Despachador confirma: **SÍ, AUTORIZAR**

7. El sistema ejecuta el despacho llamando a `proc_tgps_set_DespacharUnidad`:
   ```sql
   EXEC proc_tgps_set_DespacharUnidad
       @IdUnidad = 245,
       @HoraProgramada = '2024-12-06 08:20:00',
       @HoraDespacho = '2024-12-06 08:20:15',
       @IdRecorrido = 25,
       @Usuario = 'MGonzalez',
       @IPOrigen = '192.168.1.45',
       @HostName = 'DESPACHO-A1',
       @NomConductor = 'Juan Pérez',
       @Frecuencia = 10
   ```

8. El sistema registra el despacho en múltiples tablas:
   
   **Tb_SalidaUnidad:**
   ```
   IdSalida: AUTO-GENERADO (ej: 45678)
   CodUnidad: 245
   CodPersonaConductor: 1234
   CodRuta: 25
   CodRecorrido: 25
   FechaHoraProgramada: 2024-12-06 08:20:00
   FechaHoraReal: 2024-12-06 08:20:15
   Terminal: 'A'
   F_Estado: 11 (En curso)
   UsuarioDespacha: 'MGonzalez'
   ```

   **TbSalida:**
   ```
   CodSalida: AUTO-GENERADO
   FechaSalida: 2024-12-06
   HoraSalida: 08:20:15
   CodUnidad: 245
   CodEstadoSalida: 1 (Activa)
   ```

   **TbUnidadColaDespacho:**
   ```
   UPDATE: ColaDespachoActual = 0 (saca de cola)
   FechaHoraSalida: 2024-12-06 08:20:15
   CodEstado: 3 (Despachada)
   ```

9. El sistema actualiza estado del GPS:
   ```
   Tb_Dispositivo:
   - EstadoRuta: 'EN_SERVICIO'
   - FechaHoraInicioServicio: 2024-12-06 08:20:15
   - RutaActual: 25
   ```

10. El sistema configura alertas automáticas de monitoreo:
    - Alerta si no sale de geocerca terminal en 5 minutos
    - Alerta si no pasa primer control en 15 minutos
    - Alerta si se desvía de la ruta
    - Alerta si supera velocidad máxima
    - Alerta si tiempo fuera de recorrido > 40 min

11. El sistema actualiza la cola automáticamente:
    - Elimina BUS-245 de la cola visual
    - Recalcula posiciones de las unidades restantes
    - Actualiza contadores y estadísticas

12. El sistema muestra notificación de éxito:
    ```
    ✅ DESPACHO AUTORIZADO EXITOSAMENTE
    
    Unidad: BUS-245
    Hora despacho: 08:20:15
    ID Salida: 45678
    
    PRÓXIMA UNIDAD:
    BUS-189 - Ruta 30 - 08:22 AM
    
    [VER PRÓXIMA]  [VOLVER A COLA]
    ```

13. El sistema envía notificaciones automáticas:
    - **Al Conductor (app móvil/GPS):**
      ```
      ✅ DESPACHO AUTORIZADO
      Salida: 45678
      Ruta: 25
      Hora: 08:20:15
      
      Buen viaje. Recuerde cumplir frecuencias.
      ```
    
    - **Al Monitoreador GPS:**
      ```
      🚌 BUS-245 despachado
      Salida: 45678
      Ruta: 25
      Monitoreo activo iniciado
      ```
    
    - **Al Supervisor Terminal:**
      ```
      📊 Despacho registrado
      BUS-245 - Ruta 25 - 08:20:15
      Despachador: María González
      ```

14. El sistema registra en auditoría:
    ```
    TbAuditoria:
    - Accion: 'DESPACHO_AUTORIZADO'
    - Usuario: 'MGonzalez'
    - Tabla: 'Tb_SalidaUnidad'
    - IdRegistro: 45678
    - FechaHora: 2024-12-06 08:20:15
    - IP: 192.168.1.45
    - Detalles: 'Despacho normal sin restricciones'
    ```

15. El sistema actualiza KPIs en tiempo real:
    ```
    Dashboard Operativo:
    - Despachos realizados hoy: +1
    - Despachos Terminal A: +1
    - Cumplimiento horario: Actualizado
    - Tiempo promedio despacho: Actualizado
    - Unidades operando: +1
    ```

16. El sistema actualiza estadísticas de la ruta:
    ```
    Ruta 25:
    - Última salida: 08:20:15
    - Intervalo real: 10 min 15 seg
    - Frecuencia objetivo: 10 min ✅
    - Cumplimiento: 98.8%
    - Unidades operando: 4
    ```

17. El sistema inicia tracking GPS automático:
    - Comienza registro continuo en Tb_RegistroTrack
    - Calcula tiempos estimados de paso por controles
    - Programa alertas de cumplimiento de ruta

18. El Despachador visualiza confirmación en pantalla:
    - Despacho marcado como completado ✅
    - Cola actualizada con siguiente unidad
    - Contador de despachos incrementado

19. El sistema prepara automáticamente la próxima unidad:
    - BUS-189 pasa a posición #1 en cola
    - Información prellenada y lista
    - Validaciones actualizadas

20. El Despachador puede:
    - Proceder con siguiente despacho inmediatamente
    - Consultar estado de la unidad despachada
    - Ver historial de despachos del día
    - Generar reporte parcial

**Flujos Alternativos:**

**FA1: Despacho Adelantado (antes de hora programada)**
- En paso 4, la hora actual es 08:17 (3 minutos antes)
- Sistema pregunta: "¿Despachar antes de hora programada?"
- Despachador ingresa justificación: "Demanda alta - adelantar servicio"
- Sistema registra despacho adelantado
- Marca como excepción justificada en auditoría

**FA2: Error en Proceso de Despacho**
- En paso 7, `proc_tgps_set_DespacharUnidad` falla
- Sistema muestra error: "Error técnico - No se pudo registrar despacho"
- Sistema hace rollback de cambios parciales
- Unidad permanece en cola
- Sistema genera alerta técnica a soporte
- Despachador puede reintentar o escalar a Supervisor

**FA3: Conductor No Responde**
- Después de autorización, conductor no arranca
- Despachador intenta comunicarse
- Si no hay respuesta en 5 minutos:
  * Sistema genera alerta
  * Despachador puede anular el despacho
  * Unidad vuelve a cola o sale de servicio

**Postcondiciones:**
- El despacho queda registrado oficialmente en Tb_SalidaUnidad con IdSalida único
- La unidad sale de la cola y pasa a estado "En Servicio"
- El tracking GPS queda activo para la unidad
- Las alertas de monitoreo quedan configuradas automáticamente
- Todas las partes involucradas reciben notificación del despacho
- Los KPIs y estadísticas quedan actualizados en tiempo real
- Queda registro completo en auditoría con trazabilidad
- La siguiente unidad en cola queda lista para despachar
- El sistema está listo para recibir el próximo despacho

---

### **CU-DES-003: Gestionar Excepciones Menores**

**ID:** CU-DES-003

**Actor:** Despachador

**Precondiciones:**
- El Despachador debe estar autenticado en el sistema
- Debe haber una unidad con restricción menor detectada
- Las excepciones menores deben estar dentro de la autoridad del Despachador
- El sistema debe haber validado y clasificado la restricción como "menor"

**Trigger:**
El sistema detecta una restricción leve durante validación pre-despacho, o el Despachador identifica una situación que requiere evaluación manual.

**Flujo Principal (Ejemplo: Stock Bajo pero Suficiente):**
1. El Despachador selecciona BUS-189 para despachar
2. El sistema muestra alerta amarilla ⚠️:
   ```
   ⚠️ ALERTA: STOCK BAJO
   
   Unidad: BUS-189
   Conductor: Mario López
   Ruta: 30
   
   VALIDACIONES:
   ✅ Documentos vigentes
   ✅ Puntos licencia: 90
   ✅ GPS activo
   ⚠️ Stock de boletos bajo límite óptimo
   
   DETALLE STOCK:
   - Stock actual: 320 boletos
   - Stock mínimo: 300 boletos ✅
   - Stock óptimo: 400 boletos ⚠️
   - Estado: Por debajo de óptimo
   
   ANÁLISIS:
   - Suficiente para: 1 vuelta completa ✅
   - Riesgo de agotamiento: Bajo
   - Puede completar servicio: Sí
   
   DECISIÓN REQUERIDA:
   ¿Autorizar despacho con stock actual?
   ```

3. El Despachador evalúa la situación:
   - Stock suficiente para el servicio: Sí ✅
   - Ruta corta (1 vuelta = 2-3 horas): Sí ✅
   - Puede reabastecer al regresar: Sí ✅
   - Demanda esperada: Normal

4. El Despachador decide: **AUTORIZAR con observación**

5. El sistema solicita confirmación:
   ```
   ⚠️ CONFIRMAR DESPACHO CON ALERTA
   
   Está autorizando despacho con:
   - Stock: 320 boletos (bajo óptimo)
   - Suficiente para: 1 vuelta
   
   RECOMENDACIÓN AUTOMÁTICA:
   ✅ Puede despachar
   ⚠️ Reabastecer al retorno
   
   ¿Desea continuar?
   
   [SÍ, AUTORIZAR]  [NO, REABASTECER AHORA]  [CANCELAR]
   ```

6. El Despachador selecciona: **SÍ, AUTORIZAR**

7. El sistema solicita observación del Despachador:
   ```
   📝 REGISTRAR OBSERVACIÓN
   
   Ingrese motivo de autorización con stock bajo:
   
   [____________________________________]
   
   Sugerencias:
   - Demanda baja esperada
   - Servicio corto
   - Reabastecimiento programado al retorno
   ```

8. El Despachador ingresa: "Servicio corto. Reabastecerá al retorno (11:00 AM)"

9. El sistema registra la excepción menor:
   ```
   TbDespachoOcurrencia:
   - CodDespachoOcurrencia: AUTO-GENERADO
   - TipoOcurrencia: 'Excepción Menor'
   - CodUnidad: 189
   - Descripcion: 'Stock bajo óptimo - Autorizado'
   - Observacion: 'Servicio corto. Reabastecerá al retorno'
   - UsuarioAutoriza: 'MGonzalez' (Despachador)
   - NivelAutoridad: 'DESPACHADOR'
   - Estado: 'AUTORIZADO'
   - FechaHora: 2024-12-06 08:22:30
   ```

10. El sistema programa alerta de seguimiento:
    - Alerta a las 11:00 AM: "BUS-189 debe reabastecer boletos"
    - Notificación al almacenero de boletos
    - Recordatorio al conductor al finalizar servicio

11. El sistema actualiza el estado de la unidad:
    - Marca como "Despachado con observación"
    - Añade nota visible en monitoreo
    - Registra condición de reabastecimiento

12. El sistema ejecuta el despacho normalmente (como CU-DES-002)

13. El sistema envía notificaciones adicionales:
    - **Al Conductor:**
      ```
      ⚠️ RECORDATORIO IMPORTANTE
      Stock de boletos: 320 unidades
      Al retornar (aprox. 11:00 AM):
      - Dirigirse a almacén
      - Solicitar reabastecimiento
      - No salir nuevamente sin reabastecer
      ```
    
    - **Al Almacenero:**
      ```
      📦 REABASTECIMIENTO PROGRAMADO
      Unidad: BUS-189
      Hora estimada retorno: 11:00 AM
      Preparar: 500 boletos Ruta 30
      Prioridad: Media
      ```
    
    - **Al Supervisor:**
      ```
      ℹ️ Excepción menor gestionada
      BUS-189 - Stock bajo (autorizado)
      Despachador: María González
      Seguimiento: 11:00 AM
      ```

14. El Despachador puede agregar la unidad a lista de seguimiento:
    - Marca BUS-189 con ícono de "Seguimiento"
    - Panel lateral muestra unidades con observaciones
    - Puede ver recordatorios pendientes

15. El sistema actualiza estadísticas:
    ```
    Excepciones Menores del Día:
    - Total: 3
    - Autorizadas por despachador: 3
    - Rechazadas: 0
    - Escaladas a supervisor: 0
    ```

16. Al retornar la unidad, el sistema genera alerta automática:
    ```
    🔔 BUS-189 retornó a terminal
    Hora: 11:05 AM
    
    RECORDATORIO PENDIENTE:
    ⚠️ Reabastecer boletos antes de nuevo despacho
    
    [MARCAR COMO COMPLETADO]
    ```

17. El Despachador verifica que conductor va a almacén

18. Una vez reabastecido, el Almacenero confirma en sistema:
    ```
    ✅ REABASTECIMIENTO COMPLETADO
    Unidad: BUS-189
    Boletos entregados: 500
    Stock nuevo: 820 boletos
    Hora: 11:12 AM
    ```

19. El sistema cierra la observación automáticamente:
    - Actualiza TbDespachoOcurrencia: Estado = 'RESUELTO'
    - Elimina alerta de seguimiento
    - Registra cierre en auditoría

20. El Despachador recibe notificación de cierre:
    ```
    ✅ Observación resuelta
    BUS-189 reabastecido exitosamente
    Listo para próximo despacho
    ```

**Flujos Alternativos:**

**FA1: Despachador Decide Reabastecer Antes de Despachar**
- En paso 6, selecciona "NO, REABASTECER AHORA"
- Sistema contacta a almacenero
- Unidad espera reabastecimiento (5-10 minutos)
- Una vez completado, procede con despacho normal
- No genera observación pendiente

**FA2: Conductor Olvida Reabastecer al Retornar**
- Unidad retorna pero conductor no va a almacén
- Sistema detecta que no se reabastece
- En 15 minutos, genera alerta crítica
- Despachador contacta al conductor
- Si conductor intenta entrar a cola sin reabastecer:
  * Sistema bloquea nueva entrada a cola
  * Mensaje: "Debe reabastecer antes de nuevo servicio"

**FA3: Stock Crítico Durante Servicio**
- Durante servicio, conductor reporta que boletos se agotan
- Sistema recibe alerta de conductor
- Despachador coordina:
  * Envío de boletos a punto intermedio, O
  * Autorizar finalizar servicio anticipadamente, O
  * Conductor vende manualmente con recibos temporales

**Postcondiciones:**
- La excepción menor queda registrada en TbDespachoOcurrencia
- El despacho se ejecuta con la observación documentada
- Se establece seguimiento automático de la condición
- Las partes relevantes reciben notificación de la situación
- Queda trazabilidad de la decisión del Despachador
- El sistema monitorea el cumplimiento de la solución
- Al resolverse, la observación se cierra automáticamente

---

### **CU-DES-004: Ejecutar Programación Predefinida** (Forma asistida / semi automático)

**ID:** CU-DES-004

**Actor:** Despachador

**Precondiciones:**
- El Despachador debe estar autenticado en el sistema
- Debe existir una programación de salidas aprobada en TbProgramacionSalida
- La programación debe estar activa para el día actual
- Deben estar asignadas las unidades y conductores en la programación
- El Analista Operaciones debe haber creado la programación previamente

**Trigger:**
La empresa opera con planificación estricta y el Despachador debe seguir horarios predefinidos, o se inicia el turno con programación automática activada.

**Flujo Principal:**
1. El Despachador ingresa al sistema al iniciar su turno (06:00 AM)
2. El sistema detecta que hay programación activa para el día
3. El sistema muestra notificación:
   ```
   📋 PROGRAMACIÓN ACTIVA DETECTADA
   
   Fecha: 06/12/2024
   Tipo: Día laboral
   Programación: PRG-2024-1206-A
   Creada por: Analista José Martínez
   Aprobada por: Jefe Operaciones
   
   RESUMEN:
   - Total servicios programados: 155
   - Rutas: 4 (Ruta 25, 30, 15, 40)
   - Horario: 06:00 - 23:00
   - Modo: Automático con asistente
   
   ¿Activar modo programación asistida?
   
   [SÍ, ACTIVAR]  [NO, MODO MANUAL]
   ```

4. El Despachador selecciona: **SÍ, ACTIVAR**

5. El sistema carga la programación completa:
   ```
   🗓️ PROGRAMACIÓN DEL DÍA - TERMINAL A
   
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   PRÓXIMOS DESPACHOS (30 minutos):
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   06:00 AM ⏰ BUS-245 - Juan Pérez - Ruta 25
   06:05 AM ⏰ BUS-189 - Mario López - Ruta 30
   06:10 AM ⏰ BUS-167 - Carlos García - Ruta 25
   06:15 AM ⏰ BUS-201 - Ana Torres - Ruta 15
   06:20 AM ⏰ BUS-198 - Luis Rojas - Ruta 30
   06:25 AM ⏰ BUS-223 - Pedro Castro - Ruta 40
   06:30 AM ⏰ BUS-312 - Rosa Sánchez - Ruta 25
   
   Estado: ⏳ Esperando hora de inicio
   ```

6. A las 06:00 AM, el sistema genera alerta automática:
   ```
   🔔 DESPACHO PROGRAMADO
   
   Hora: 06:00 AM
   Unidad: BUS-245
   Conductor: Juan Pérez
   Ruta: 25
   Tipo: Servicio normal
   
   Estado: Listo para despachar
   
   [AUTORIZAR AHORA]  [RETRASAR 5 MIN]
   ```

7. El Despachador verifica:
   - Unidad BUS-245 está en posición ✅
   - Conductor Juan Pérez presente ✅
   - Validaciones automáticas aprobadas ✅

8. El Despachador hace clic en **AUTORIZAR AHORA**

9. El sistema ejecuta el despacho automáticamente:
   - Llama a `proc_tgps_set_DespacharUnidad` con datos de programación
   - Registra en Tb_SalidaUnidad vinculando a TbProgramacionSalida
   - Marca servicio como "Ejecutado según programación"

10. El sistema actualiza la programación:
    ```
    ✅ 06:00 AM - BUS-245 DESPACHADO
       06:05 AM - BUS-189 (Próximo en 5 min)
       06:10 AM - BUS-167
       06:15 AM - BUS-201
       ...
    ```

11. El sistema cuenta regresiva para siguiente despacho:
    ```
    ⏱️ PRÓXIMO DESPACHO EN: 4:35
    
    Unidad: BUS-189
    Conductor: Mario López
    Ruta: 30
    Hora programada: 06:05 AM
    
    Preparación automática en curso...
    ```

12. A 2 minutos del siguiente despacho (06:03), el sistema:
    - Pre-carga información de BUS-189
    - Ejecuta validaciones automáticas
    - Prepara pantalla de autorización
    - Genera notificación sonora al Despachador

13. A las 06:05 AM exactas, el sistema presenta:
    ```
    🔔 DESPACHO PROGRAMADO
    
    Hora: 06:05 AM
    Unidad: BUS-189
    Conductor: Mario López
    Ruta: 30
    
    ✅ Validaciones: Aprobadas
    
    [AUTORIZAR AHORA]  [RETRASAR]
    ```

14. El Despachador autoriza el segundo despacho

15. El sistema continúa el ciclo automáticamente durante todo el turno

16. El Despachador puede ver estadísticas de cumplimiento:
    ```
    📊 CUMPLIMIENTO DE PROGRAMACIÓN
    
    Servicios programados: 155
    Servicios ejecutados: 42
    Servicios pendientes: 113
    
    CUMPLIMIENTO HORARIO:
    - A tiempo (±2 min): 38 (90.5%) ✅
    - Retrasados (>2 min): 3 (7.1%)
    - Adelantados: 1 (2.4%)
    
    PROMEDIO DESVIACIÓN: +1.2 minutos
    
    DESPACHOS POR RUTA:
    - Ruta 25: 15/42 servicios (35.7%)
    - Ruta 30: 12/42 servicios (28.6%)
    - Ruta 15: 8/42 servicios (19.0%)
    - Ruta 40: 7/42 servicios (16.7%)
    ```

17. Si surge una desviación, el sistema alerta:
    ```
    ⚠️ DESVIACIÓN DE PROGRAMACIÓN
    
    Servicio: 08:20 AM - BUS-245 - Ruta 25
    Hora programada: 08:20 AM
    Hora actual: 08:25 AM
    Retraso: 5 minutos
    
    CAUSA:
    Unidad BUS-245 no presente en cola
    
    OPCIONES:
    1. Esperar unidad (estima llegada: 5 min)
    2. Usar unidad de reemplazo
    3. Cancelar servicio
    
    ¿Qué desea hacer?
    ```

18. El Despachador decide: **Usar unidad de reemplazo**

19. El sistema sugiere unidades disponibles:
    ```
    UNIDADES DISPONIBLES PARA REEMPLAZO:
    
    1. BUS-312 - Rosa Sánchez
       - Estado: En terminal
       - Ruta habitual: 25 (compatible ✅)
       - Siguiente servicio: 09:00 AM (40 min)
       - Recomendado: ⭐⭐⭐⭐⭐
    
    2. BUS-401 - Roberto Díaz
       - Estado: Finalizando servicio
       - ETA terminal: 10 min
       - Siguiente servicio: 09:30 AM
       - Recomendado: ⭐⭐⭐
    ```

20. El Despachador selecciona: **BUS-312**

21. El sistema ejecuta reemplazo:
    - Actualiza programación: BUS-245 → BUS-312
    - Registra cambio en TbProgramacionSalidaDetalle
    - Notifica a Supervisor del cambio
    - Despacha BUS-312 en lugar de BUS-245
    - Marca observación: "Reemplazo por ausencia de unidad programada"

22. El sistema reprograma BUS-245 automáticamente:
    - Cuando BUS-245 llegue, la asigna al siguiente servicio disponible
    - Ajusta programación restante del día

23. Al finalizar el turno, el sistema genera reporte:
    ```
    📋 REPORTE DE PROGRAMACIÓN EJECUTADA
    
    Fecha: 06/12/2024
    Terminal: A
    Despachador: María González
    Turno: 06:00 - 14:00
    
    SERVICIOS:
    - Programados: 72
    - Ejecutados: 70 (97.2%) ✅
    - Cancelados: 2 (2.8%)
    
    CUMPLIMIENTO HORARIO:
    - Puntuales (±2 min): 63 (90.0%) ✅
    - Retrasados: 5 (7.1%)
    - Adelantados: 2 (2.9%)
    - Desviación promedio: +1.5 minutos
    
    REEMPLAZOS:
    - Total: 4
    - Por ausencia de unidad: 2
    - Por falla técnica: 1
    - Por ausencia de conductor: 1
    
    INCIDENCIAS:
    - Menores: 3
    - Escaladas a supervisor: 1
    - Resueltas: 4/4 (100%)
    
    EVALUACIÓN: ⭐⭐⭐⭐ (Muy Bueno)
    Cumplimiento: 97.2%
    Puntualidad: 90.0%
    ```

**Flujos Alternativos:**

**FA1: Despachador Elige Modo Manual**
- En paso 4, selecciona "NO, MODO MANUAL"
- Sistema desactiva asistente automático
- Despachador gestiona cola manualmente
- Puede consultar programación como referencia
- No hay alertas automáticas de hora

**FA2: Cambio de Conductor en Último Momento**
- Conductor programado no se presenta
- Sistema detecta ausencia 10 minutos antes
- Sugiere conductores de reemplazo disponibles
- Despachador selecciona reemplazo
- Sistema actualiza programación y ejecuta despacho

**FA3: Cancelación de Servicio Programado**
- Unidad tiene falla técnica irreparable
- No hay unidad de reemplazo disponible
- Despachador cancela servicio
- Sistema marca como "Cancelado por fuerza mayor"
- Ajusta frecuencia de servicios restantes
- Notifica a Jefe Operaciones

**Postcondiciones:**
- La programación del día se ejecuta de manera asistida y controlada
- Los despachos quedan vinculados a la programación original en TbProgramacionSalida
- Las desviaciones y reemplazos quedan registrados con justificación
- Se mantiene trazabilidad entre programado vs ejecutado
- Los cambios a la programación quedan auditados
- El cumplimiento de la programación queda medido y reportado
- El Despachador recibe asistencia automática para cumplir horarios
- Se genera información para análisis de cumplimiento

---

### **CU-DES-005: Despachar por Criterio Propio**

**ID:** CU-DES-005

**Actor:** Despachador

**Precondiciones:**
- El Despachador debe estar autenticado en el sistema
- La empresa NO opera con programación estricta (modo manual/flexible)
- Debe haber unidades en cola de despacho
- El Despachador debe tener autorización para decidir orden de despachos
- Deben estar configuradas las frecuencias objetivo por ruta

**Trigger:**
No existe programación predefinida y el Despachador debe decidir qué unidad despachar, o la empresa opera con sistema de "cola libre", o se requiere ajuste dinámico por demanda.

**Flujo Principal:**
1. El Despachador ingresa al módulo de Despacho en modo manual
2. El sistema muestra la cola sin orden estricto:
   ```
   🚌 COLA DE DESPACHO - MODO MANUAL
   Terminal: A
   Despachador: María González
   
   UNIDADES DISPONIBLES: 8
   (Sin orden de prioridad - Decisión del despachador)
   
   ┌─────┬─────────┬────────────┬────────┬──────────┐
   │ Bus │ Conduct │ Ruta       │ Estado │ Espera   │
   ├─────┼─────────┼────────────┼────────┼──────────┤
   │ 245 │ J.Pérez │ Ruta 25    │ 🟢     │ 5 min    │
   │ 189 │ M.López │ Ruta 30    │ 🟢     │ 3 min    │
   │ 167 │ C.García│ Ruta 25    │ 🟢     │ 8 min    │
   │ 201 │ A.Torres│ Ruta 15    │ 🟢     │ 12 min   │
   │ 198 │ L.Rojas │ Ruta 30    │ 🟡     │ 6 min    │
   │ 223 │ P.Castro│ Ruta 40    │ 🟢     │ 15 min   │
   │ 312 │ R.Sánch │ Ruta 25    │ 🟢     │ 2 min    │
   │ 267 │ M.Ortiz │ Ruta 15    │ 🔴     │ 20 min   │
   └─────┴─────────┴────────────┴────────┴──────────┘
   ```

3. El Despachador analiza factores para tomar decisión:
   ```
   📊 INFORMACIÓN PARA DECISIÓN
   
   FRECUENCIAS ACTUALES:
   - Ruta 25: Última salida hace 12 min (objetivo: 10 min) ⚠️
   - Ruta 30: Última salida hace 6 min (objetivo: 12 min) ✅
   - Ruta 15: Última salida hace 18 min (objetivo: 15 min) ⚠️
   - Ruta 40: Última salida hace 20 min (objetivo: 20 min) ✅
   
   DEMANDA EN TERMINAL:
   - Ruta 25: ~30 pasajeros esperando 🔴
   - Ruta 30: ~8 pasajeros esperando 🟢
   - Ruta 15: ~25 pasajeros esperando 🟡
   - Ruta 40: ~5 pasajeros esperando 🟢
   
   UNIDADES OPERANDO:
   - Ruta 25: 3 unidades en servicio
   - Ruta 30: 2 unidades en servicio
   - Ruta 15: 1 unidad en servicio ⚠️
   - Ruta 40: 2 unidades en servicio
   ```

4. El Despachador aplica su criterio basado en experiencia:
   - **Prioridad 1:** Ruta 15 (solo 1 unidad operando, 25 pasajeros esperando)
   - **Prioridad 2:** Ruta 25 (30 pasajeros, frecuencia excedida)
   - **Prioridad 3:** Rutas 30 y 40 (dentro de frecuencias, menos pasajeros)

5. El Despachador revisa unidades de Ruta 15:
   - BUS-201 (Ana Torres): 🟢 Lista, esperando 12 minutos
   - BUS-267 (Mario Ortiz): 🔴 Restricción (documento vencido)

6. El Despachador selecciona: **BUS-201**

7. El sistema valida la decisión:
   ```
   ✅ DECISIÓN VALIDADA
   
   Unidad seleccionada: BUS-201
   Ruta: 15
   Justificación automática del sistema:
   - Ruta con mayor tiempo desde última salida ✅
   - Mayor acumulación de pasajeros en terminal ✅
   - Menor número de unidades operando ✅
   
   ¿Proceder con despacho?
   ```

8. El Despachador confirma y autoriza el despacho

9. El sistema registra la decisión con métricas:
   ```
   TbDespachoDecision:
   - CodDespacho: [ID del despacho]
   - TipoDecision: 'MANUAL_CRITERIO_DESPACHADOR'
   - FactoresClave: 'Demanda alta, Frecuencia excedida'
   - PrioridadAsignada: 1
   - UsuarioDecide: 'MGonzalez'
   - TiempoDecision: 45 segundos
   - FechaHora: 2024-12-06 08:15:30
   ```

10. Despachada la primera unidad, el Despachador evalúa siguiente

11. El sistema actualiza información de decisión:
    ```
    FRECUENCIAS ACTUALIZADAS:
    - Ruta 15: Última salida hace 0 min (ahora) ✅
    - Ruta 25: Última salida hace 13 min ⚠️⚠️
    - Ruta 30: Última salida hace 7 min ✅
    - Ruta 40: Última salida hace 21 min ⚠️
    ```

12. El Despachador aplica criterio nuevamente:
    - Ahora prioriza Ruta 25 (frecuencia muy excedida + demanda alta)

13. El Despachador selecciona entre opciones de Ruta 25:
    - BUS-245 (Juan Pérez): Esperando 5 min
    - BUS-167 (Carlos García): Esperando 8 min ⭐ (más tiempo en cola)
    - BUS-312 (Rosa Sánchez): Esperando 2 min

14. El Despachador aplica subcri criterio: **FIFO dentro de la misma ruta**

15. El Despachador selecciona: **BUS-167** (más tiempo esperando)

16. El sistema valida y ejecuta segundo despacho

17. El Despachador continúa este proceso durante su turno

18. El sistema asiste con recomendaciones inteligentes:
    ```
    💡 SUGERENCIA DEL SISTEMA
    
    Basado en patrones actuales:
    
    PRÓXIMO DESPACHO RECOMENDADO:
    🥇 BUS-189 (Ruta 30)
       Razón: Frecuencia objetivo próxima a excederse
       Pasajeros esperando: 12 (aumento rápido)
       Prioridad sugerida: ALTA
    
    🥈 BUS-312 (Ruta 25)
       Razón: Completar ciclo de frecuencia
       Prioridad sugerida: MEDIA
    
    [ACEPTAR SUGERENCIA]  [DECIDIR MANUALMENTE]
    ```

19. El Despachador puede:
    - Aceptar la sugerencia automática
    - Ignorar y decidir diferente
    - Solicitar más información antes de decidir

20. Al final del turno, el sistema evalúa las decisiones:
    ```
    📊 EVALUACIÓN DE DECISIONES DEL DESPACHADOR
    
    Turno: 06:00 - 14:00
    Despachador: María González
    Total despachos: 72
    
    EFECTIVIDAD DE DECISIONES:
    
    Cumplimiento de Frecuencias:
    - Decisiones que mejoraron frecuencia: 65/72 (90.3%) ✅
    - Decisiones óptimas: 58/72 (80.6%) ⭐
    - Decisiones subóptimas: 7/72 (9.7%)
    
    Gestión de Demanda:
    - Rutas con alta demanda priorizadas: 95.2% ✅
    - Tiempo promedio espera pasajeros: 8.5 min ✅
    
    Eficiencia Operativa:
    - Unidades con mayor tiempo en cola priorizadas: 85.4%
    - Distribución equitativa entre rutas: 92.1%
    
    Comparación vs Sugerencias del Sistema:
    - Coincidencia con IA: 75.2%
    - Decisiones mejores que IA: 15.3% 🏆
    - Decisiones peores que IA: 9.5%
    
    CALIFICACIÓN GLOBAL: ⭐⭐⭐⭐ (Muy Bueno)
    
    FORTALEZAS IDENTIFICADAS:
    ✅ Excelente gestión de demanda en hora pico
    ✅ Buena distribución entre rutas
    ✅ Criterio FIFO aplicado correctamente
    
    OPORTUNIDADES DE MEJORA:
    ⚠️ Considerar más frecuentemente sugerencias del sistema
    ⚠️ Atención a Ruta 40 en horario valle
    ```

**Flujos Alternativos:**

**FA1: Despachador Solicita Modo Asistido**
- En cualquier momento, puede activar "Modo Asistido"
- Sistema pasa a sugerir próximo despacho automáticamente
- Despachador solo confirma o rechaza sugerencias
- Reduce carga cognitiva en horas pico

**FA2: Conflicto entre Frecuencia y Demanda**
- Ruta con frecuencia excedida pero sin pasajeros
- Ruta con frecuencia cumplida pero alta demanda
- Despachador debe priorizar según contexto
- Sistema documenta justificación de la decisión

**FA3: Despachador Reorganiza Cola Manualmente**
- Puede arrastrar y soltar unidades para cambiar orden
- Sistema solicita justificación del cambio
- Queda registrado en auditoría
- Útil para situaciones especiales (VIP, emergencias)

**Postcondiciones:**
- Los despachos ejecutados reflejan el criterio y experiencia del Despachador
- Cada decisión queda documentada con sus factores determinantes
- El sistema evalúa la efectividad de las decisiones tomadas
- Se genera información para capacitación y mejora continua
- Queda comparación entre decisiones humanas vs sugerencias del sistema
- Se identifican fortalezas y áreas de mejora del Despachador

---

### **CU-DES-006: Reorganizar Cola por Prioridades**

**ID:** CU-DES-006

**Actor:** Despachador

**Precondiciones:**
- El Despachador debe estar autenticado en el sistema
- Debe tener permisos para modificar el orden de la cola
- Debe haber al menos 2 unidades en cola
- Debe existir una justificación operativa válida para reorganizar

**Trigger:**
Se presenta una situación urgente que requiere cambiar el orden de despacho, o hay un servicio express que debe priorizarse, o se detecta una necesidad operativa crítica (alta demanda en ruta específica).

**Flujo Principal:**
1. El Despachador está viendo la cola normal de despacho:
   ```
   📋 COLA DE DESPACHO - ORDEN ACTUAL
   
   1️⃣ BUS-245 - J. Pérez - Ruta 25 - 08:20 AM
   2️⃣ BUS-189 - M. López - Ruta 30 - 08:22 AM
   3️⃣ BUS-167 - C. García - Ruta 25 - 08:25 AM
   4️⃣ BUS-201 - A. Torres - Ruta 15 - 08:30 AM
   5️⃣ BUS-312 - R. Sánchez - Ruta 25 - 08:35 AM (EXPRESS ⚡)
   6️⃣ BUS-198 - L. Rojas - Ruta 30 - 08:40 AM
   ```

2. El Despachador recibe comunicación del Supervisor:
   ```
   📞 MENSAJE DEL SUPERVISOR
   
   De: Supervisor Carlos Rodríguez
   Hora: 08:18 AM
   
   "BUS-312 es servicio EXPRESS a Terminal Sur.
   Pasajeros corporativos esperando.
   PRIORIZAR despacho inmediato."
   
   Urgencia: ALTA 🔴
   ```

3. El Despachador identifica que BUS-312 está en posición #5

4. El Despachador hace clic en **"Reorganizar Cola"**

5. El sistema muestra modo de reorganización:
   ```
   🔄 MODO REORGANIZACIÓN ACTIVO
   
   Instrucciones:
   - Arrastre unidades para cambiar orden
   - El sistema solicitará justificación
   - Los cambios se registrarán en auditoría
   
   Cola actual:
   [Arrastrar para reordenar ↕️]
   
   1️⃣ BUS-245 - Ruta 25 - Normal
   2️⃣ BUS-189 - Ruta 30 - Normal
   3️⃣ BUS-167 - Ruta 25 - Normal
   4️⃣ BUS-201 - Ruta 15 - Normal
   5️⃣ BUS-312 - Ruta 25 - EXPRESS ⚡
   6️⃣ BUS-198 - Ruta 30 - Normal
   ```

6. El Despachador arrastra BUS-312 de posición #5 a posición #1

7. El sistema detecta el cambio y solicita justificación:
   ```
   ⚠️ JUSTIFICACIÓN REQUERIDA
   
   Cambio detectado:
   BUS-312 movido de posición 5 → 1
   
   Unidades afectadas:
   - BUS-245: posición 1 → 2 (retraso +5 min)
   - BUS-189: posición 2 → 3 (retraso +3 min)
   - BUS-167: posición 3 → 4 (retraso +2 min)
   - BUS-201: posición 4 → 5 (retraso +1 min)
   
   Tipo de priorización:
   ◉ Servicio Express
   ○ Emergencia operativa
   ○ Solicitud Supervisor
   ○ VIP/Corporativo
   ○ Otra (especificar)
   
   Motivo detallado:
   [_________________________________]
   
   Autorización:
   [_________________________________]
   (Nombre supervisor que autoriza)
   ```

8. El Despachador completa:
   - Tipo: **Servicio Express** + **Solicitud Supervisor**
   - Motivo: "Servicio corporativo express a Terminal Sur. Pasajeros VIP esperando."
   - Autorizado por: "Supervisor Carlos Rodríguez"

9. El sistema valida la justificación:
   - Verifica que el usuario tenga permiso para reorganizar ✅
   - Valida que exista autorización de supervisor ✅
   - Confirma que BUS-312 está marcado como EXPRESS ✅

10. El Despachador hace clic en **"Aplicar Cambios"**

11. El sistema reorganiza la cola:
    ```
    ✅ COLA REORGANIZADA
    
    NUEVO ORDEN:
    1️⃣ BUS-312 - Ruta 25 - EXPRESS ⚡ (PRIORIZADO)
    2️⃣ BUS-245 - Ruta 25 - Normal
    3️⃣ BUS-189 - Ruta 30 - Normal
    4️⃣ BUS-167 - Ruta 25 - Normal
    5️⃣ BUS-201 - Ruta 15 - Normal
    6️⃣ BUS-198 - Ruta 30 - Normal
    
    Cambios aplicados: 08:19 AM
    ```

12. El sistema registra la reorganización:
    ```sql
    INSERT INTO TbColaDespachoReorganizacion (
        FechaHora,
        CodUnidadPriorizada,
        PosicionAnterior,
        PosicionNueva,
        TipoPriorizacion,
        Motivo,
        UsuarioAutoriza,
        SupervisorAprueba,
        UnidadesAfectadas
    ) VALUES (
        '2024-12-06 08:19:00',
        312,
        5,
        1,
        'EXPRESS + SUPERVISOR',
        'Servicio corporativo express',
        'MGonzalez',
        'CRodriguez',
        'BUS-245,BUS-189,BUS-167,BUS-201'
    )
    ```

13. El sistema actualiza TbUnidadColaDespacho:
    - BUS-312: NroOrdenDespacho = 1, Prioridad = 'ALTA'
    - BUS-245: NroOrdenDespacho = 2
    - BUS-189: NroOrdenDespacho = 3
    - BUS-167: NroOrdenDespacho = 4
    - BUS-201: NroOrdenDespacho = 5

14. El sistema notifica a las partes afectadas:
    
    **A Conductores afectados:**
    ```
    📢 CAMBIO EN ORDEN DE COLA
    
    Su posición ha cambiado:
    Anterior: #1
    Nueva: #2
    Retraso estimado: 5 minutos
    
    Motivo: Priorización de servicio express
    
    Disculpe las molestias.
    ```
    
    **A Conductor priorizado:**
    ```
    ⚡ PRIORIZADO PARA DESPACHO
    
    BUS-312 - Nueva posición: #1
    Despacho inmediato en 2 minutos
    
    Servicio: EXPRESS a Terminal Sur
    Pasajeros: Corporativos VIP
    
    Por favor, esté listo.
    ```
    
    **Al Supervisor:**
    ```
    ✅ Reorganización ejecutada
    BUS-312 priorizado según su solicitud
    Despachador: María González
    Hora: 08:19 AM
    ```

15. El sistema genera marca visual en la cola:
    ```
    📋 COLA DE DESPACHO
    
    🔥 BUS-312 - EXPRESS - PRIORIZADO ⚡
       └─ Servicio corporativo
       └─ Autorizado por: Sup. Rodríguez
    
    2️⃣ BUS-245 - Normal (+5 min retraso)
    3️⃣ BUS-189 - Normal (+3 min retraso)
    4️⃣ BUS-167 - Normal (+2 min retraso)
    5️⃣ BUS-201 - Normal (+1 min retraso)
    6️⃣ BUS-198 - Normal (sin cambio)
    ```

16. El Despachador procede a despachar BUS-312 inmediatamente

17. El sistema registra tiempo de respuesta:
    - Solicitud supervisor: 08:18 AM
    - Reorganización: 08:19 AM
    - Despacho: 08:20 AM
    - Tiempo total: 2 minutos ✅

18. Al finalizar el día, el sistema genera estadísticas:
    ```
    📊 REORGANIZACIONES DEL DÍA
    
    Total reorganizaciones: 3
    
    Por motivo:
    - Servicios Express: 1
    - Emergencias operativas: 1
    - Alta demanda en ruta: 1
    
    Promedio retraso generado: 3.5 minutos
    Impacto en frecuencias: Mínimo ✅
    
    Autorizaciones:
    - Supervisor: 2
    - Jefe Operaciones: 1
    
    Efectividad:
    - Objetivos cumplidos: 3/3 (100%) ✅
    ```

**Flujos Alternativos:**

**FA1: Reorganización Sin Autorización de Supervisor**
- Despachador intenta priorizar sin autorización
- Sistema solicita contactar al Supervisor
- Si Despachador insiste:
  * Sistema genera alerta al Supervisor
  * Supervisor debe aprobar en tiempo real
  * Si Supervisor rechaza, cambio no se aplica

**FA2: Múltiples Reorganizaciones Simultáneas**
- Se requiere priorizar 2 o más unidades
- Despachador reorganiza varias a la vez
- Sistema solicita justificación global
- Calcula impacto total en frecuencias
- Alerta si impacto es muy alto

**FA3: Reversión de Reorganización**
- Situación que motivó el cambio se resuelve
- Despachador puede "Deshacer reorganización"
- Cola vuelve a orden anterior
- Se registra reversión en auditoría

**Postcondiciones:**
- La cola queda reorganizada según prioridades operativas
- Todos los cambios quedan justificados y autorizados
- Las partes afectadas reciben notificación del cambio
- Queda registro completo en auditoría
- Se mide el impacto de la reorganización
- Se evalúa la efectividad de la priorización

---

### **CU-DES-007: Registrar Incidencias en Terminal** (omitir)
 
***Nota*** :
- Esta gestión es poco probable que el despachador la vaya a aprovechar.


**ID:** CU-DES-007

**Actor:** Despachador

**Precondiciones:**
- El Despachador debe estar autenticado en el sistema
- Debe ocurrir un evento que afecte o pueda afectar la operación
- El sistema de registro de incidencias debe estar activo

**Trigger:**
Se presenta un evento anormal en el terminal, o el Despachador observa una situación que debe documentarse, o un conductor reporta un problema.

**Flujo Principal (Ejemplo: Avería de Unidad en Terminal):**
1. El Despachador observa que BUS-245 tiene humo saliendo del motor
2. El conductor reporta: "Problema mecánico, no puedo despachar"
3. El Despachador accede a **"Registrar Incidencia"**
4. El sistema muestra formulario de incidencia:
   ```
   📝 REGISTRO DE INCIDENCIA
   
   Fecha/Hora: 06/12/2024 - 08:25 AM (automático)
   Despachador: María González
   Terminal: A
   
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   DATOS BÁSICOS
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   Tipo de incidencia: *
   [ ] Avería mecánica
   [ ] Accidente
   [ ] Problema de conductor
   [ ] Problema de pasajeros
   [ ] Falla de equipo (GPS, ticketera)
   [ ] Congestión vehicular
   [ ] Bloqueo de vía
   [ ] Otra
   
   Gravedad: *
   ○ Baja (sin impacto operativo)
   ○ Media (impacto moderado)
   ○ Alta (impacto significativo)
   ○ Crítica (detención de operación)
   ```

5. El Despachador selecciona:
   - Tipo: **Avería mecánica**
   - Gravedad: **Alta** (unidad programada no puede salir)

6. El sistema solicita información específica:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   DATOS DE LA UNIDAD
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   Unidad afectada: *
   [Buscar: _________] [📋 Seleccionar de cola]
   
   Conductor:
   [Se llena automáticamente]
   
   Ubicación:
   ○ En bahía de terminal
   ○ En cola de despacho
   ○ Área de mantenimiento
   ○ Otra: [_______]
   ```

7. El Despachador busca y selecciona: **BUS-245**
8. El sistema precarga datos:
   ```
   Unidad: BUS-245 (Placa ABC-123)
   Conductor: Juan Pérez
   Ruta programada: Ruta 25
   Hora programada: 08:20 AM
   Estado previo: En cola de despacho
   ```

9. El Despachador continúa con descripción detallada:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   DESCRIPCIÓN DEL PROBLEMA
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   Síntomas observados: *
   [Humo saliendo del motor. Conductor reporta       ]
   [sobrecalentamiento. Unidad no puede arrancar.    ]
   
   Parte de la unidad afectada:
   [ ] Motor/Transmisión ✓
   [ ] Sistema eléctrico
   [ ] Frenos
   [ ] Suspensión
   [ ] Carrocería
   [ ] GPS/Comunicaciones
   [ ] Otro: [_______]
   
   ¿Unidad puede movilizarse?
   ○ Sí, con precaución
   ● No, requiere grúa
   ○ No evaluado aún
   ```

10. El Despachador completa datos del problema

11. El sistema solicita impacto operativo:
    ```
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    IMPACTO OPERATIVO
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    Servicios afectados:
    [x] Servicio 08:20 AM cancelado
    [x] Frecuencia Ruta 25 impactada
    
    Pasajeros afectados (estimado):
    [~40] pasajeros
    
    ¿Se requiere unidad de reemplazo?
    ● Sí, urgente
    ○ Sí, cuando esté disponible
    ○ No necesario
    
    ¿Se requiere apoyo externo?
    [x] Mecánico/Taller
    [x] Grúa
    [ ] Ambulancia
    [ ] Policía
    [ ] Otro: [_______]
    ```

12. El Despachador indica que requiere reemplazo urgente

13. El sistema sugiere acciones automáticas:
    ```
    💡 ACCIONES SUGERIDAS
    
    ✓ Solicitar grúa automáticamente
    ✓ Notificar a taller mecánico
    ✓ Buscar unidad de reemplazo disponible
    ✓ Ajustar programación de Ruta 25
    ✓ Notificar a Supervisor Terminal
    ✓ Informar a pasajeros en terminal
    
    ¿Ejecutar acciones sugeridas?
    [SÍ, EJECUTAR TODAS] [PERSONALIZAR] [NO]
    ```

14. El Despachador selecciona: **SÍ, EJECUTAR TODAS**

15. El sistema ejecuta acciones en paralelo:
    
    **Acción 1: Solicitar Grúa**
    ```
    ✅ Grúa solicitada
    Proveedor: Grúas Express SAC
    ETA: 15 minutos
    Destino: Taller Central
    ```
    
    **Acción 2: Notificar Taller**
    ```
    ✅ Taller notificado
    Mensaje: "BUS-245 con problema motor.
             Llegada estimada: 08:45 AM.
             Prioridad: ALTA"
    ```
    
    **Acción 3: Buscar Reemplazo**
    ```
    🔍 Buscando unidades disponibles...
    
    OPCIONES DE REEMPLAZO:
    1. BUS-312 - Disponible ahora
       - En terminal
       - Conductor listo
       - Misma ruta (Ruta 25)
       - Recomendado: ⭐⭐⭐⭐⭐
    
    2. BUS-401 - Disponible en 20 min
       - Finalizando servicio
       - Requiere conductor
       - Recomendado: ⭐⭐⭐
    ```
    
    **Acción 4: Ajustar Programación**
    ```
    ✅ Programación ajustada
    - Servicio 08:20 → Cancelado
    - Servicio 08:25 → Reasignado a BUS-312
    - Frecuencia Ruta 25 → Temporal 15 min
    ```
    
    **Acción 5: Notificaciones**
    ```
    ✅ Notificaciones enviadas
    - Supervisor: Incidencia registrada
    - Jefe Flota: Unidad fuera de servicio
    - Pasajeros: Información en pantallas
    ```

16. El Despachador revisa y confirma las acciones

17. El sistema registra la incidencia completa:
    ```sql
    INSERT INTO TbDespachoOcurrencia (
        CodDespachoOcurrencia,
        FechaHora,
        TipoOcurrencia,
        Gravedad,
        CodUnidad,
        CodPersona,
        Descripcion,
        ParteAfectada,
        RequiereGrua,
        RequiereMecanico,
        ImpactoOperativo,
        ServiciosAfectados,
        PasajerosAfectados,
        UnidadReemplazo,
        AccionesEjecutadas,
        Estado,
        UsuarioRegistra
    ) VALUES (
        [AUTO],
        '2024-12-06 08:25:00',
        'AVERIA_MECANICA',
        'ALTA',
        245,
        1234,
        'Sobrecalentamiento motor...',
        'MOTOR',
        1,
        1,
        'Servicio cancelado, frecuencia impactada',
        1,
        40,
        312,
        'Grúa, Taller, Reemplazo, Ajuste programación',
        'EN_ATENCION',
        'MGonzalez'
    )
    ```

18. El sistema genera número de incidencia único:
    ```
    ✅ INCIDENCIA REGISTRADA
    
    Nº Incidencia: INC-2024-1206-0042
    Fecha/Hora: 06/12/2024 - 08:25 AM
    Tipo: Avería mecánica
    Gravedad: ALTA
    Unidad: BUS-245
    Estado: EN ATENCIÓN
    
    Acciones en curso:
    ✓ Grúa solicitada (ETA 15 min)
    ✓ Taller notificado
    ✓ Reemplazo asignado (BUS-312)
    ✓ Programación ajustada
    
    [VER DETALLE] [AGREGAR SEGUIMIENTO]
    ```

19. El Despachador puede agregar fotos de evidencia:
    ```
    📸 EVIDENCIA FOTOGRÁFICA (Opcional)
    
    [📷 Tomar foto] [📁 Subir archivo]
    
    Fotos adjuntas:
    - Motor con humo (IMG_001.jpg)
    - Panel de control (IMG_002.jpg)
    ```

20. El sistema permite seguimiento de la incidencia:
    ```
    📋 SEGUIMIENTO DE INCIDENCIA
    INC-2024-1206-0042
    
    Cronología:
    
    08:25 AM - Incidencia registrada
               Despachador: M. González
    
    08:30 AM - Grúa confirmada
               ETA actualizado: 10 minutos
    
    08:35 AM - BUS-312 despachado como reemplazo
               Servicio normalizado
    
    08:40 AM - Grúa llegó a terminal
               Inicio traslado BUS-245
    
    08:55 AM - BUS-245 arribó a taller
               Diagnóstico en proceso
    
    Estado actual: ⏳ En diagnóstico
    ```

21. El Despachador puede actualizar estado:
    - Agregar comentarios
    - Subir documentos
    - Cambiar prioridad
    - Escalar a Supervisor
    - Cerrar incidencia (cuando se resuelve)

22. Al finalizar el día, el sistema consolida:
    ```
    📊 RESUMEN DE INCIDENCIAS DEL DÍA
    
    Total incidencias: 5
    
    Por gravedad:
    - Críticas: 0
    - Altas: 2 (incluye BUS-245)
    - Medias: 2
    - Bajas: 1
    
    Por tipo:
    - Averías mecánicas: 2
    - Problemas conductor: 1
    - Congestión vehicular: 1
    - Falla GPS: 1
    
    Estado:
    - Resueltas: 4
    - En atención: 1 (BUS-245 en taller)
    - Escaladas: 0
    
    Tiempo promedio resolución: 35 minutos
    ```

**Flujos Alternativos:**

**FA1: Incidencia con Heridos**
- Gravedad automáticamente: **CRÍTICA**
- Sistema solicita inmediatamente ambulancia
- Protocolo de emergencia se activa
- Notificación a Gerencia y Seguros
- Registro ampliado de datos médicos

**FA2: Incidencia Recurrente**
- Sistema detecta que BUS-245 tiene historial
- Alerta: "3ra incidencia mecánica en 30 días"
- Sugiere revisión técnica profunda
- Notifica a Jefe de Flota automáticamente

**FA3: Cierre de Incidencia**
- Cuando problema se resuelve
- Despachador marca como "Resuelta"
- Sistema solicita:
  * Solución aplicada
  * Tiempo total de resolución
  * Costo involucrado
  * Lecciones aprendidas
- Incidencia pasa a histórico

**Postcondiciones:**
- La incidencia queda registrada con número único de seguimiento
- Todas las acciones correctivas quedan documentadas
- Las partes involucradas reciben notificación
- Se establece trazabilidad completa del evento
- Queda evidencia fotográfica y documental
- El seguimiento de resolución queda activo
- Se genera información para análisis preventivo
- El sistema alimenta estadísticas de incidencias

---
### **CU-DES-008: Comunicarse con Unidades Pre-Despacho**

**ID:** CU-DES-008

**Nombre:** Comunicarse con Unidades en Terminal (Pre-Despacho)

**Actor:** Despachador

**Precondiciones:**

- Despachador autenticado en el sistema
- Unidad en cola de despacho (aún no despachada)
- Dispositivo GPS activo en unidad
- Conductor identificado en sistema
- Al menos un medio de comunicación disponible

**Trigger:**

- Despachador necesita dar instrucción antes de despachar
- Requiere confirmación de conductor sobre observación
- Necesita aclarar restricción o alerta detectada
- Coordinación de cambio de última hora (unidad, ruta, etc.)

**Flujo Principal:**

1. **Identificación de Necesidad de Comunicación**

Despachador está por autorizar BUS-245, pero sistema muestra alerta:
```
⚠️ ALERTA PRE-DESPACHO
BUS-245 - Juan Pérez

Stock boletos Serie B: BAJO (28/50)
Recomendación: Reabastecer antes de salir
```

2. **Acceso a Panel de Comunicación**

Despachador hace clic en ícono 📞 junto a la unidad.

Sistema muestra medios disponibles:
```
📞 COMUNICACIÓN CON BUS-245

Estado unidad: EN COLA (Posición 3)
Conductor: Juan Pérez
GPS: Activo (señal 98%)

MEDIOS DISPONIBLES:

🌐 WebRTC (Recomendado)
   Estado: Disponible ✅
   Calidad: Alta
   Latencia: 45ms
   
📱 Llamada Celular GPS
   Número: +51-987-654-321
   Operadora: Movistar
   Estado: Disponible ✅
   
🔊 Mensaje TTS (Texto a Voz)
   Estado: Disponible ✅
   Idioma: Español PE
   Voz: Masculina/Femenina
```

3. **Selección de Medio - Opción A: WebRTC**

Despachador selecciona **WebRTC** (comunicación bidireccional).

Sistema inicia conexión:
```
🌐 INICIANDO LLAMADA WebRTC

Conectando con GPS de BUS-245...
[▓▓▓▓▓▓░░░░] 60%

✅ Conexión establecida

🔴 EN LLAMADA
Duración: 00:00:15
Calidad: ████████ 95%

[🔇 SILENCIAR] [FINALIZAR]
```

Conversación:
- **Despachador:** "Juan, tu stock de boletos Serie B está bajo. ¿Puedes reabastecer antes de salir?"
- **Conductor (por GPS):** "Confirmado, voy al almacén ahora. 5 minutos."
- **Despachador:** "Perfecto, te espero."

Despachador finaliza llamada.

4. **Selección de Medio - Opción B: Mensaje TTS**

Si Despachador prefiere mensaje de voz automático, selecciona **TTS**.

Sistema muestra editor:
```
🔊 ENVIAR MENSAJE TTS

Destinatario: BUS-245 - Juan Pérez

Mensaje a convertir en voz:
┌─────────────────────────────────────┐
│ Conductor de BUS-245, debe          │
│ reabastecer boletos Serie B antes   │
│ de despachar. Dirigirse a almacén.  │
│                                      │
└─────────────────────────────────────┘

Voz: ( ) Masculina (•) Femenina
Velocidad: [====|====] Normal
Repeticiones: [2▼]

[👂 PREVISUALIZAR] [ENVIAR]
```

Despachador hace clic en **PREVISUALIZAR** → escucha mensaje.

Hace clic en **ENVIAR**.

Sistema transmite:
```
✅ Mensaje TTS enviado

A: GPS BUS-245
Hora: 08:25:30
Tamaño: 2.3 KB
Estado: Entregado al GPS ✅

El mensaje se reproducirá automáticamente
en el dispositivo GPS de la unidad.
```

5. **Selección de Medio - Opción C: Llamada Celular GPS**

Despachador selecciona **Llamada Celular GPS**.

Sistema muestra instrucciones:
```
📱 LLAMAR A GPS BUS-245

Número: +51-987-654-321
```

Despachador llama directamente a conductor a través del celular integrado al GPS.

6. **Registro de Comunicación (Solo para WebRTC/TTS)**

Sistema documenta automáticamente:
```sql
TbComunicacionDespacho:
- FechaHora: 2024-12-06 08:25:30
- CodUnidad: 245
- CodPersona: 1523
- MedioUtilizado: 'WEBRTC' | 'TTS' | 'CELULAR_GPS'
- Motivo: 'STOCK_BAJO'
- DuracionSegundos: 45 (si aplica)
- MensajeEnviado: "Reabastecer boletos Serie B..."
- AccionSolicitada: 'REABASTECER'
- UsuarioDespacha: 'MGonzalez'
```

7. **Conductor ejecuta instrucciones impartidas por el despachador**

8. **Confirmación y Despacho**

5 minutos después, conductor retorna con stock completo.

Despachador verifica en sistema: Stock actualizado ✅

Procede con despacho normal (CU-DES-002).

**Postcondiciones:**

- Comunicación pre-despacho registrada con timestamp
- Medio utilizado documentado
- Acción solicitada al conductor confirmada
- Unidad puede ser despachada sin restricciones
- Historial de comunicaciones disponible para auditoría

**Flujos Alternativos:**

**FA1: Sin Respuesta del Conductor**
- Despachador intenta WebRTC → no contesta
- Prueba con TTS → mensaje enviado
- Espera 2 minutos
- Si no hay acción, contacta físicamente en terminal

**FA2: GPS Sin Conectividad**
- Medios digitales (WebRTC, TTS) no disponibles
- Solo opción: Llamada celular tradicional (si GPS tiene SIM)
- O comunicación física presencial

**FA3: Emergencia Requiere Inmediatez**
- Despachador usa WebRTC (más rápido que celular)
- Si falla, escala a Supervisor para contacto físico

---

### **CU-DES-009: Controlar Cumplimiento de Horarios (omitir porque se movió CU-JOP-002)**

---

### **CU-DES-010: Escalar Casos Complejos**

**ID:** CU-DES-010

**Actor:** Despachador

**Precondiciones:**
- El Despachador debe estar autenticado en el sistema
- Debe existir una situación que excede su autoridad o capacidad de resolución
- Debe haber intentado resolver el caso dentro de sus competencias
- El Supervisor Terminal debe estar disponible y contactable
- El sistema de escalamiento debe estar activo

**Trigger:**
Se presenta una situación compleja que requiere autorización superior, o múltiples restricciones simultáneas impiden el despacho, o hay conflicto entre políticas operativas, o el Despachador detecta un patrón anormal que requiere decisión gerencial.

**Flujo Principal (Ejemplo: Múltiples Restricciones Simultáneas):**
1. El Despachador está intentando despachar BUS-245
2. El sistema muestra múltiples alertas:
   ```
   🚨 UNIDAD CON MÚLTIPLES RESTRICCIONES
   
   Unidad: BUS-245
   Conductor: Juan Pérez
   Ruta: 25
   Hora programada: 10:00 AM
   
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   RESTRICCIONES DETECTADAS: 3
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   ⚠️ RESTRICCIÓN 1: DOCUMENTACIÓN
   - Examen psicosomático vence en 5 días
   - Criticidad: Media
   - Política: Alertar <30 días, Bloquear <7 días
   - Estado: Alerta activa
   
   ⚠️ RESTRICCIÓN 2: STOCK BOLETOS
   - Stock actual: 280 boletos
   - Stock mínimo: 300 boletos
   - Déficit: 20 boletos (7%)
   - Criticidad: Media-Alta
   
   🔴 RESTRICCIÓN 3: PUNTOS LICENCIA
   - Puntos actuales: 72 puntos
   - Mínimo permitido: 75 puntos
   - Déficit: 3 puntos
   - Criticidad: ALTA
   - Estado: Requiere autorización
   
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ANÁLISIS DEL SISTEMA
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   Complejidad: ALTA
   Riesgo operativo: MEDIO-ALTO
   
   Conductor tiene buen historial (95% cumplimiento)
   Última infracción: Hace 8 meses
   Sin incidencias últimos 3 meses
   
   PERO:
   - Combinación de 3 restricciones simultáneas
   - Una restricción crítica (puntos licencia)
   - Déficit acumulado de condiciones
   
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   RECOMENDACIÓN DEL SISTEMA
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   🚫 NO AUTORIZAR sin aprobación de Supervisor
   
   Motivo: Restricción crítica (puntos licencia)
           + 2 restricciones adicionales
           = Riesgo acumulado demasiado alto
   
   CASO COMPLEJO - REQUIERE ESCALAMIENTO
   
   [ESCALAR A SUPERVISOR] [BUSCAR ALTERNATIVA]
   ```

3. El Despachador reconoce que excede su autoridad

4. El Despachador hace clic en **ESCALAR A SUPERVISOR**

5. El sistema abre formulario de escalamiento:
   ```
   📤 ESCALAMIENTO A SUPERVISOR
   
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   INFORMACIÓN DEL CASO
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   Tipo de escalamiento:
   ● Autorización de excepción múltiple
   ○ Conflicto de políticas
   ○ Situación de emergencia
   ○ Decisión técnica compleja
   ○ Otro
   
   Urgencia:
   ○ Baja (puede esperar >30 min)
   ● Media (requiere decisión en 15 min)
   ○ Alta (requiere decisión inmediata)
   ○ Crítica (emergencia operativa)
   
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   CONTEXTO OPERATIVO
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   Impacto si se rechaza despacho:
   [x] Servicio programado se cancela
   [x] Frecuencia de ruta se afecta
   [ ] Pasajeros sin alternativa de transporte
   [x] Reemplazo difícil de conseguir
   
   Alternativas evaluadas:
   [x] Buscar conductor de reemplazo
       → No disponible en este momento
   [x] Usar otra unidad
       → BUS-312 tiene restricciones similares
   [ ] Reprogramar servicio
       → Afectaría frecuencia de ruta
   
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   OPINIÓN DEL DESPACHADOR
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   
   Situación:
   [Conductor confiable con buen historial.      ]
   [Restricciones son límites (no incumplimientos]
   [graves). Deficiencia de puntos es menor (3). ]
   [Stock de boletos suficiente para 1 vuelta.   ]
   [Documento vence en 5 días (tiempo razonable).]
   
   Recomendación personal:
   ● Autorizar con condiciones estrictas
   ○ Rechazar y buscar alternativa
   ○ Diferir decisión
   
   Condiciones sugeridas si se autoriza:
   [x] Solo este turno
   [x] Reabastecer boletos al retorno
   [x] Renovar documento en máximo 3 días
   [x] Seguimiento especial por Supervisor
   [ ] Otra: [___________________]
   
   [ENVIAR ESCALAMIENTO]
   ```

6. El Despachador completa el formulario y hace clic en **ENVIAR ESCALAMIENTO**

7. El sistema registra el escalamiento:
   ```sql
   INSERT INTO TbEscalamientoCasos (
       CodEscalamiento,
       FechaHora,
       TipoEscalamiento,
       Urgencia,
       CodUnidad,
       CodPersona,
       RestriccionesDetectadas,
       AlternativasEvaluadas,
       OpinionDespachador,
       RecomendacionDespachador,
       CondicionesSugeridas,
       Estado,
       UsuarioEscala,
       SupervisorAsignado
   ) VALUES (
       [AUTO],
       '2024-12-06 10:05:00',
       'AUTORIZACION_EXCEPCION_MULTIPLE',
       'MEDIA',
       245,
       1234,
       'Puntos licencia (72<75), Stock bajo, Doc próximo vencer',
       'Reemplazo no disponible, Otras unidades similares',
       'Conductor confiable...',
       'AUTORIZAR_CON_CONDICIONES',
       'Solo turno, Reabastecer, Renovar doc',
       'PENDIENTE',
       'MGonzalez',
       'CRodriguez'
   )
   ```

8. El sistema notifica inmediatamente al Supervisor:
   ```
   🔔 NOTIFICACIÓN AL SUPERVISOR
   
   Para: Carlos Rodríguez (Supervisor Terminal A)
   
   🚨 CASO ESCALADO - DECISIÓN REQUERIDA
   
   De: María González (Despachador)
   Fecha/Hora: 06/12/2024 - 10:05 AM
   Urgencia: MEDIA (Decisión en 15 min)
   
   Caso: BUS-245 - Múltiples restricciones
   
   Restricciones:
   • Puntos licencia: 72 (mín 75) 🔴
   • Stock boletos: 280 (mín 300) ⚠️
   • Doc vence: 5 días ⚠️
   
   Impacto: Servicio 10:00 AM - Ruta 25
   
   Despachador recomienda: AUTORIZAR CON CONDICIONES
   
   [VER DETALLE COMPLETO] [DECIDIR AHORA]
   ```

9. El Despachador espera decisión del Supervisor

10. El sistema muestra estado del escalamiento:
    ```
    ⏳ ESCALAMIENTO EN PROCESO
    
    Nº Escalamiento: ESC-2024-1206-0015
    Estado: PENDIENTE DECISIÓN
    
    Enviado a: Supervisor Carlos Rodríguez
    Hora envío: 10:05 AM
    Tiempo transcurrido: 3 minutos
    Tiempo límite decisión: 15 minutos
    
    Estado Supervisor: 🟢 En línea
    Última actividad: Hace 1 minuto
    
    [RECORDAR AL SUPERVISOR] [CANCELAR ESCALAMIENTO]
    ```

11. A los 5 minutos, el Supervisor responde:
    ```
    ✅ DECISIÓN RECIBIDA DEL SUPERVISOR
    
    De: Supervisor Carlos Rodríguez
    Hora: 10:10 AM
    Tiempo respuesta: 5 minutos
    
    DECISIÓN: AUTORIZADO CON CONDICIONES
    
    Justificación:
    "Conductor Juan Pérez tiene excelente historial.
     Restricciones son límites técnicos, no infracciones.
     Situación operativa justifica autorización excepcional.
     
     CONDICIONES OBLIGATORIAS:
     1. Válido SOLO para este turno
     2. Reabastecer boletos al retornar (11:30 AM)
     3. Renovar examen psicosomático en 3 días
     4. Seguimiento especial - reportar cualquier anomalía
     5. No despachar nuevamente hasta regularizar puntos
     
     Responsabilidad asumida por Supervisor."
    
    Autorización válida hasta: 06/12/2024 14:00
    Código autorización: AUT-SUP-20241206-0042
    
    [PROCEDER CON DESPACHO] [VER CONDICIONES COMPLETAS]
    ```

12. El Despachador recibe la notificación en pantalla grande:
    ```
    ✅ CASO APROBADO
    
    BUS-245 AUTORIZADO PARA DESPACHO
    
    Supervisor: Carlos Rodríguez
    Válido: Solo turno actual
    
    IMPORTANTE - CONDICIONES OBLIGATORIAS:
    ☑️ Reabastecer al retorno
    ☑️ Renovar documento en 3 días
    ☑️ Seguimiento especial activo
    ☑️ Reportar cualquier anomalía
    
    Puede proceder con despacho normal.
    
    [DESPACHAR AHORA] [VER DETALLES]
    ```

13. El Despachador procede con el despacho siguiendo proceso normal (CU-DES-002)

14. El sistema marca el despacho especialmente:
    ```
    ⚠️ DESPACHO BAJO AUTORIZACIÓN ESPECIAL
    
    Unidad: BUS-245
    Hora: 10:12 AM
    Autorización: AUT-SUP-20241206-0042
    Supervisor: Carlos Rodríguez
    
    Condiciones activas - Seguimiento especial
    ```

15. El sistema programa alertas automáticas de seguimiento:
    ```
    🔔 SEGUIMIENTOS PROGRAMADOS
    
    1. 11:30 AM - Verificar reabastecimiento boletos
       → Alerta automática a Despachador
       → Verificar con Almacenero
    
    2. 09/12/2024 - Verificar renovación documento
       → Alerta a RRHH
       → Bloqueo automático si no se renueva
    
    3. Continuo - Monitoreo GPS especial
       → Alertas sensibles de velocidad
       → Seguimiento de ruta estricto
    
    4. Fin de turno - Verificar cumplimiento condiciones
       → Reporte automático a Supervisor
    ```

16. El sistema actualiza registros:
    ```
    TbDespachoOcurrencia:
    - TipoOcurrencia: 'AUTORIZACION_EXCEPCIONAL'
    - Gravedad: 'ALTA'
    - RestriccionesOriginales: 'Puntos, Stock, Doc'
    - AutorizacionSupervisor: 'CRodriguez'
    - CodigoAutorizacion: 'AUT-SUP-20241206-0042'
    - CondicionesImpuestas: [lista completa]
    - VigenciaAutorizacion: '2024-12-06 14:00:00'
    - SeguimientoActivo: 1
    ```

17. El sistema genera documento de autorización:
    ```
    📄 COMPROBANTE DE AUTORIZACIÓN ESPECIAL
    
    Código: AUT-SUP-20241206-0042
    Fecha: 06/12/2024 10:10 AM
    
    UNIDAD: BUS-245 (Placa ABC-123)
    CONDUCTOR: Juan Pérez (Lic. A-1234567)
    RUTA: 25
    
    RESTRICCIONES AUTORIZADAS:
    • Puntos licencia: 72 (bajo mínimo 75)
    • Stock boletos: 280 (bajo mínimo 300)
    • Examen psicosomático: Vence en 5 días
    
    CONDICIONES OBLIGATORIAS:
    1. Vigencia: Solo turno 06/12/2024
    2. Reabastecer boletos: Obligatorio
    3. Renovar documento: Máximo 3 días
    4. Seguimiento: Especial activo
    5. Restricción: No despachar hasta regularizar
    
    AUTORIZADO POR:
    Supervisor: Carlos Rodríguez
    Despachador: María González
    
    RESPONSABILIDAD:
    Supervisor asume responsabilidad de autorización
    
    [Firma digital: Carlos Rodríguez - 10:10:05]
    [Firma digital: María González - 10:12:18]
    ```

18. Al finalizar el turno, el sistema genera reporte de escalamientos:
    ```
    📊 REPORTE DE ESCALAMIENTOS DEL TURNO
    
    Despachador: María González
    Turno: 06:00 - 14:00
    
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    RESUMEN
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    Total escalamientos: 2
    Aprobados: 2 (100%)
    Rechazados: 0
    Pendientes: 0
    
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    DETALLE
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    1. ESC-2024-1206-0015 - BUS-245
       Tipo: Múltiples restricciones
       Hora: 10:05 AM
       Decisión: APROBADO CON CONDICIONES
       Supervisor: Carlos Rodríguez
       Tiempo respuesta: 5 minutos ✅
       Estado seguimiento: Activo
    
    2. ESC-2024-1206-0023 - BUS-189
       Tipo: Conflicto programación
       Hora: 12:15 PM
       Decisión: APROBADO
       Supervisor: Carlos Rodríguez
       Tiempo respuesta: 3 minutos ✅
       Estado seguimiento: Cerrado
    
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    MÉTRICAS
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    Tiempo promedio respuesta: 4 minutos ✅
    Tasa aprobación: 100%
    Casos con seguimiento activo: 1
    
    Evaluación: Excelente gestión de escalamientos
    ```

**Flujos Alternativos:**

**FA1: Supervisor Rechaza Autorización**
- Supervisor decide NO autorizar
- Despachador debe buscar alternativa:
  * Conductor de reemplazo
  * Otra unidad
  * Cancelar servicio
- Sistema registra rechazo con justificación
- Caso cerrado como "No autorizado"

**FA2: Urgencia Crítica - Decisión Inmediata**
- Escalamiento con urgencia CRÍTICA
- Sistema notifica con máxima prioridad
- Supervisor tiene 5 minutos para responder
- Si no responde, escala a Jefe Operaciones
- Puede requerir contacto telefónico directo

**FA3: Escalamiento a Jefe Operaciones**
- Caso excede autoridad del Supervisor
- Despachador o Supervisor escalan a Jefe Operaciones
- Requiere justificación adicional
- Mayor nivel de documentación
- Decisión queda registrada en alta gerencia

**FA4: Cancelación de Escalamiento**
- Antes de recibir respuesta, situación se resuelve
- Ej: Conductor de reemplazo aparece
- Despachador puede cancelar escalamiento
- Sistema notifica a Supervisor de cancelación
- Queda registro de escalamiento cancelado

**Postcondiciones:**
- El caso complejo queda escalado y documentado
- La decisión del Supervisor queda registrada oficialmente
- Las condiciones de autorización quedan establecidas y monitoreadas
- El seguimiento automático queda programado
- Queda trazabilidad completa de la cadena de autorización
- Se genera comprobante oficial de autorización especial
- Las alertas de cumplimiento de condiciones quedan activas
- El sistema alimenta métricas de escalamiento para análisis


---

## MONITOREADOR GPS

### **CU-MON-001: Monitorear Flota en Tiempo Real**

**ID:** CU-MON-001

**Actor Principal:** Monitoreador GPS

**Stakeholders:**
- Jefe Operaciones (recibe reportes de estado)
- Supervisor Terminal (recibe escalamientos)
- Conductores (objeto del monitoreo)
- Sistema GPS (proveedor de datos)

**Precondiciones:**
- Monitoreador autenticado con perfil GPS activo
- Mínimo 1 unidad operando con GPS funcional
- Sistema GPS central operativo y sincronizado
- Geocercas configuradas en Tb_GeoCerca
- Puntos de control definidos en Tb_Control
- Conexión estable a servidor de rastreo
- Debe estar asignado como monitoreador de turno permitido por el JEFE DE OPERACIONES (CU-JOP-001)

**Trigger:**
- Inicio de turno del monitoreador
- Unidad entra en operación (despacho exitoso)
- Sistema detecta pérdida de señal GPS
- Alerta automática de desviación activada

**Flujo Principal:**

1. **Autenticación y Configuración Inicial**
   - Monitoreador ingresa credenciales
   - Sistema valida perfil con permisos GPS
   - Sistema carga configuración personalizada:
     * Rutas asignadas al turno
     * Geocercas activas
     * Umbrales de alertas
     * Layout preferido del dashboard

2. **Carga del Dashboard en Tiempo Real**
   - Sistema consulta Tb_RegistroTrack (últimos 60 segundos)
   - Extrae posiciones activas de unidades operando
   - Renderiza mapa con:
     * Unidades activas (íconos diferenciados por estado)
     * Rutas autorizadas (líneas superpuestas)
     * Geocercas (áreas sombreadas)
     * Puntos de control (marcadores)
   - Muestra panel lateral:
     * Total unidades monitoreadas: 42
     * Unidades en ruta: 38 ✅
     * Unidades detenidas: 2 ⚠️
     * Unidades con alertas: 2 🚨

3. **Visualización de Estado por Unidad**
   - Para cada unidad activa:
     * Identificador: BUS-245
     * Conductor: Juan Pérez
     * Ruta: 25 - Terminal A ↔ Terminal B
     * Estado GPS: Activo (señal 95%)
     * Última actualización: hace 12 seg
     * Velocidad: 45 km/h
     * Ubicación: Av. Principal, altura paradero 15
     * Dirección: Norte
     * Próximo control: Paradero 18 (1.2 km)
   - Código de colores:
     * Verde: En ruta, sin alertas
     * Amarillo: Alerta menor (retraso leve)
     * Rojo: Alerta crítica (fuera de ruta)
     * Gris: GPS sin señal

4. **Actualización Automática Continua**
   - Sistema refresca posiciones cada 30 segundos
   - Animación suave de movimiento de íconos
   - Contador de tiempo desde última actualización
   - Indicador visual de conectividad del sistema

5. **Detección de Patrones Anómalos**
   - Sistema analiza automáticamente:
     * Unidades detenidas > 10 minutos
     * Velocidades inusuales (>80 km/h o <5 km/h)
     * Desviaciones de ruta
     * Patrones de movimiento irregulares

6. **Interacción del Monitoreador**
   - Puede hacer clic en cualquier unidad para ver:
     * Historial de posiciones (últimas 2 horas)
     * Trazado de ruta recorrida
     * Alertas generadas durante el día
     * Comunicaciones registradas
     * Información del conductor
   - Puede filtrar vista por:
     * Ruta específica
     * Estado (todas/alertas/normales)
     * Terminal de origen
     * Conductor

7. **Monitoreo de KPIs en Tiempo Real**
   - Panel de métricas:
     * Cobertura GPS: 95% unidades conectadas
     * Cumplimiento de rutas: 92%
     * Velocidad promedio flota: 38 km/h
     * Alertas activas: 4
     * Tiempo promedio respuesta alertas: 3.2 min

8. **Registro de Eventos Relevantes**
   - Sistema auto-registra en Tb_TrackOperacion:
     * Timestamp de eventos significativos
     * Unidades involucradas
     * Tipo de evento
     * Acción tomada (si aplica)

**Postcondiciones Exitosas:**
- Dashboard actualizado continuamente
- Todas las unidades monitoreadas en tiempo real
- Alertas detectadas y priorizadas
- Historial de tracking registrado
- Métricas de operación calculadas

**Flujos Alternativos:**

**FA1: Pérdida de Conectividad de Unidad**
- Sistema detecta ausencia de señal > 2 minutos
- Marca unidad en estado "Señal Perdida"
- Genera alerta automática nivel MEDIO
- Monitoreador intenta contacto por radio/celular
- Si no hay respuesta en 5 min → Escalamiento a Supervisor

**FA2: Sobrecarga de Alertas Simultáneas**
- Si alertas activas > 10:
  * Sistema prioriza automáticamente por criticidad
  * Agrupa alertas similares
  * Monitoreador atiende por orden de prioridad
  * Puede solicitar apoyo de segundo monitoreador

**Escenarios de Excepción:**

**EX1: Falla del Sistema GPS Central**
- Sistema detecta caída del servidor GPS
- Activa modo contingencia:
  * Usa último estado conocido
  * Habilita comunicación directa radio
  * Notifica a IT de emergencia
  * Registra incidente crítico
- Monitoreador escala inmediatamente a Jefe Operaciones

**Requisitos Especiales:**
- Tiempo de respuesta UI: < 2 segundos
- Latencia actualización GPS: < 60 segundos
- Capacidad concurrente: 100 unidades simultáneas
- Disponibilidad sistema: 99.5% (máximo 3.6 horas downtime/mes)

**Información Adicional:**
- Frecuencia de uso: Continua durante turno (8-12 horas)
- Nivel de automatización: 80% (sistema auto-detecta, monitoreador decide)
- Dependencias tecnológicas: GPS satelital, red celular, servidor central

---

### **CU-MON-002: Gestionar Alertas Automáticas**

**ID:** CU-MON-002

**Actor Principal:** Monitoreador GPS

**Precondiciones:**
- Sistema de alertas configurado en Tb_Alerta
- Umbrales definidos por tipo de alerta
- Unidades operando con GPS activo
- Canal de comunicación con conductores disponible

**Trigger:**
- Sistema detecta condición que activa alerta automática
- Monitoreador recibe notificación sonora/visual
- Alerta escalada desde otro módulo

**Flujo Principal:**

1. **Detección y Generación de Alerta**
   - Sistema evalúa continuamente condiciones:
     * Velocidad excesiva: >80 km/h en zona urbana
     * Fuera de ruta: >500m de recorrido autorizado
     * Parada prolongada: >15 min sin movimiento
     * Geocerca violada: salida de área autorizada
     * Batería baja GPS: <20% carga

2. **Notificación al Monitoreador**
   - Alerta visual:
     * Pop-up emergente con detalles
     * Ícono de unidad cambia a rojo parpadeante
     * Panel de alertas actualizado
   - Alerta sonora:
     * Tono diferenciado por criticidad
     * Alta: alarma continua
     * Media: beep intermitente
     * Baja: notificación suave

3. **Clasificación de Alerta**
   - Sistema asigna automáticamente:
     * Criticidad: Alta/Media/Baja
     * Tipo: Velocidad/Ruta/Tiempo/Técnica
     * Urgencia: Inmediata/Pronto/Informativa
   - Ejemplo de alerta:
     ```
     🚨 ALERTA CRÍTICA - ALTA PRIORIDAD
     Unidad: BUS-245
     Conductor: Juan Pérez
     Tipo: FUERA DE RUTA
     Detalle: 850m fuera de recorrido autorizado
     Ubicación: Av. Secundaria altura calle 8
     Tiempo: 08:15:23 AM
     Duración: 5 minutos
     ```

4. **Evaluación por el Monitoreador**
   - Revisa contexto de la alerta:
     * Historial reciente de la unidad
     * Ubicación exacta en mapa
     * Ruta autorizada vs. posición actual
     * Alertas previas del mismo conductor
   - Determina causa probable:
     * Desvío por congestión vehicular
     * Error del GPS
     * Conductor perdido
     * Situación de emergencia

5. **Acciones Correctivas**
   - **Para Fuera de Ruta:**
     * Contacta conductor por radio
     * Verifica motivo del desvío
     * Si justificado (tráfico): documenta y cierra
     * Si no justificado: instruye retornar a ruta
     * Si persiste >10 min: escalamiento
   
   - **Para Exceso de Velocidad:**
     * Contacta conductor inmediatamente
     * Instruye reducción de velocidad
     * Registra incidente para reporte
     * Si reincide: escalamiento a Supervisor
   
   - **Para Parada Prolongada:**
     * Verifica si es en terminal/paradero autorizado
     * Contacta conductor para verificar estado
     * Si es avería: coordina asistencia técnica
     * Si no hay respuesta: escalamiento urgente

6. **Registro de Gestión**
   - Sistema documenta en Tb_AlertaRecepcion:
     * Hora detección alerta
     * Hora atención monitoreador
     * Acción tomada
     * Resultado de gestión
     * Hora cierre de alerta
   - Calcula tiempo de respuesta:
     * Objetivo: <3 minutos para alertas críticas
     * Objetivo: <10 minutos para alertas medias

7. **Seguimiento Post-Resolución**
   - Monitoreador marca unidad para seguimiento especial
   - Sistema monitorea comportamiento próximos 30 minutos
   - Si se repite alerta similar: escalamiento automático

8. **Cierre de Alerta**
   - Monitoreador confirma resolución
   - Sistema actualiza estado: CERRADA
   - Genera estadística para KPIs

**Postcondiciones:**
- Alerta atendida y resuelta
- Incidente documentado en sistema
- Conductor notificado de acción correctiva
- Seguimiento establecido si es necesario
- Métricas de tiempo de respuesta registradas

**Flujos Alternativos:**

**FA1: Alerta Falsa Positiva**
- Monitoreador identifica error del sistema
- Marca alerta como falsa positiva
- Documenta causa (ej: error GPS)
- Sistema ajusta algoritmo de detección
- Cierra alerta sin acción sobre conductor

**FA2: Escalamiento por Gravedad**
- Si alerta es crítica y conductor no responde:
  * Notifica a Supervisor Terminal inmediatamente
  * Activa protocolo de emergencia
  * Intenta contacto por vías alternas
  * Considera envío de inspector a campo

**Tipos de Alertas Principales:**

| Tipo Alerta | Criticidad | Tiempo Respuesta | Acción Típica |
|-------------|------------|------------------|---------------|
| Fuera de ruta >500m | Alta | <3 min | Contacto inmediato |
| Velocidad >80 km/h | Alta | <2 min | Instrucción reducir |
| Parada >15 min | Media | <5 min | Verificación estado |
| Geocerca violada | Alta | <3 min | Retorno a zona |
| Batería GPS <20% | Baja | <15 min | Alerta preventiva |
| Sin señal GPS >5min | Media | <5 min | Verificación técnica |

---

### **CU-MON-003: Comunicarse con Conductores**

**ID:** CU-MON-003

**Actor Principal:** Monitoreador GPS

**Precondiciones:**
- Canal de comunicación disponible (radio/celular/app)
- Conductor localizable en sistema
- Motivo válido de comunicación

**Trigger:**
- Alerta GPS requiere contacto
- Supervisor solicita ubicación de unidad
- Conductor solicita apoyo
- Verificación de rutina programada

**Flujo Principal:**

1. **Selección de Unidad a Contactar**
   - Monitoreador identifica unidad en dashboard
   - Hace clic en "Contactar Conductor"
   - Sistema muestra opciones:
     * Radio (preferente)
     * Celular conductor
     * App móvil (mensaje)
     * Chat del sistema

2. **Establecimiento de Comunicación**
   - Monitoreador selecciona radio
   - Sistema marca unidad como "En comunicación"
   - Monitoreador transmite:
     * "Central a Unidad BUS-245, cambio"
     * Conductor responde: "BUS-245, adelante Central"

3. **Intercambio de Información**
   - Monitoreador comunica motivo:
     * Alerta detectada
     * Instrucción operativa
     * Verificación de estado
     * Apoyo requerido
   - Conductor proporciona información solicitada
   - Monitoreador toma notas en sistema

4. **Registro de Comunicación**
   - Sistema documenta automáticamente:
     * Hora inicio comunicación
     * Duración llamada
     * Motivo
     * Resultado/acuerdos
     * Hora finalización

5. **Acciones Derivadas**
   - Si se requiere seguimiento:
     * Programa recordatorio
     * Marca unidad para verificación
     * Genera ticket de soporte (si es técnico)
   - Si es informativo:
     * Cierra comunicación
     * Actualiza estado en sistema

**Postcondiciones:**
- Comunicación registrada en sistema
- Información obtenida y documentada
- Acciones de seguimiento establecidas
- Historial de comunicaciones actualizado

---

### CU-MON-004: Validar Cumplimiento de Salidas de Unidades

**ID:** CU-MON-004

**Actor:** Monitoreador GPS

**Precondiciones:**
- Unidades despachadas en operación
- Puntos de control/paraderos configurados por ruta en Tb_RecorridoXControl
- Sistema registrando pasos en Tb_SalidaUnidadHoraPaso
- GPS activo transmitiendo posiciones

**Trigger:**
- Revisión de rutina programada cada hora
- Fin de turno del monitoreador
- Solicitud de supervisor para auditoría
- Generación de reporte de compliance

**Flujo Principal:**

1. **Acceso a Panel de Validación**

Monitoreador accede a "Validación de Salidas":
```
📋 VALIDACIÓN DE CUMPLIMIENTO DE SALIDAS

Período: [Hoy 06/12/2024] [Ruta: Todas ▼]
Estado: [Todas ▼] [CONSULTAR]

Mostrando: 15 salidas activas/finalizadas
```

2. **Lista de Salidas para Validación**

Sistema muestra tabla consolidada:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SALIDAS - VALIDACIÓN DE CONTROLES/PARADEROS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Unidad | Ruta | Hr Salida | Estado    | Controles | Faltantes | Validación
-------|------|-----------|-----------|-----------|-----------|------------
245    | 25   | 08:00     | Finalizada| 10/10 ✅  | Ninguno   | ⭐ CONFORME
167    | 30   | 08:15     | Finalizada| 8/8 ✅    | Ninguno   | ⭐ CONFORME
312    | 25   | 08:30     | En ruta   | 7/10 ⏳   | 3 pend.   | ⏳ En curso
201    | 15   | 08:45     | Finalizada| 5/6 ⚠️    | Control 4 | ⚠️ OBSERVADO
189    | 25   | 09:00     | Finalizada| 8/10 ⚠️   | Ctrl 3,7  | ⚠️ OBSERVADO
198    | 30   | 09:15     | Finalizada| 4/8 ❌    | 4 ctrl.   | ❌ NO CONFORME

[VER DETALLE] [EXPORTAR] [FILTROS]
```

3. **Selección de Salida para Análisis**

Monitoreador hace clic en BUS-198 (4/8 controles - umbral crítico >3 omitidos):

```
🔍 DETALLE DE SALIDA - BUS-198 (Ruta 30)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
INFORMACIÓN GENERAL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Conductor: Carlos Méndez
Hora salida: 09:15 AM
Hora llegada: 10:32 AM
Duración total: 1h 17min (objetivo: 1h 10min)
Estado: FINALIZADA

⚠️ ALERTA: 4 controles omitidos (>umbral permitido)
ACCIÓN REQUERIDA: Contactar conductor

[📞 LLAMAR CONDUCTOR] [VER RETRASOS/ADELANTOS]
```

4. **Contacto con Conductor** (umbral >3 omitidos)

Monitoreador hace clic en "LLAMAR CONDUCTOR":
```
📞 CONTACTAR CONDUCTOR - BUS-198

Medio de contacto:
(•) Celular GPS: +51-987-654-321
( ) WebRTC
( ) Radio

[INICIAR LLAMADA]
```

Monitoreador llama y obtiene información:
```
📝 REGISTRO DE CONTACTO

Hora llamada: 10:35 AM
Duración: 2min 15seg
Respondió: Carlos Méndez

Motivo controles omitidos:
┌────────────────────────────────────────┐
│ "Tomé Av. Paralela por congestión      │
│ severa en ruta principal. Obra vial no │
│ señalizada en Km 4. Evité 30 min de    │
│ demora."                                │
└────────────────────────────────────────┘

Verificación:
[x] Consultar tráfico en tiempo real
[x] Confirmar con otros conductores
[ ] Solicitar foto evidencia

[GUARDAR] [REGISTRAR INCIDENCIA]
```

5. **Visor de Retrasos/Adelantos (RA)**

Monitoreador hace clic en "VER RETRASOS/ADELANTOS":
```
📊 MATRIZ DE RETRASOS/ADELANTOS - BUS-198

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Control/Paradero         | Terminal | Paradero | Control | Paradero | Control | Paradero | Control | Paradero | Control | Terminal
                         | Origen   | Pla      | Km 3    | Mercado  | Km 7    | Centro   | Km 12   | Norte    | Km 16   | Destino
-------------------------|----------|----------|---------|----------|---------|----------|---------|----------|---------|----------
BUS-198                  |    0     |    0     |SALTADO  |    -1    |   -3    |    0     |    0    |    0     |    0    |    0

Leyenda:
  0       = A tiempo (±2 min)
  -1, -2  = Adelanto (minutos)
  +1, +2  = Retraso (minutos)
  SALTADO = Control no pasado
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Análisis:
• Control Km 3: SALTADO (desviación de ruta)
• Paradero Mercado: -1 min (adelanto leve post-desvío)
• Control Km 7: -3 min (adelanto por ruta alterna más rápida)
• Resto: A tiempo después de retornar a ruta oficial

[CERRAR] [EXPORTAR TABLA]
```

6. **Ejemplo Multi-Unidad (Comparativo)**

Si monitoreador selecciona vista múltiple:
```
📊 MATRIZ COMPARATIVA RETRASOS/ADELANTOS - RUTA 25

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Unidad      | Terminal | Paradero | Control | Paradero | Control | Paradero | Control | Paradero | Control | Terminal
            | Origen   | Plaza    | Km 3    | Mercado  | Km 7    | Centro   | Km 12   | Norte    | Km 16   | Destino
------------|----------|----------|---------|----------|---------|----------|---------|----------|---------|----------
AXD-223     |    0     |    0     |    0    |    -1    |   -3    |    0     |    0    |    0     |    0    |    0
AXD-222     |    0     |    2     |    2    |     4    |    0    |    0     |    0    |    0     |    0    |    0
AXD-221     |    0     |    0     |    0    |     0    | SALTADO |    6     |   44    |    3     |    3    |    1
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚨 ALERTAS DETECTADAS:
• AXD-221: Retraso crítico +44 min en Control Km 12
• AXD-221: Control Km 7 SALTADO

[CONTACTAR AXD-221] [VER DETALLE] [EXPORTAR]
```

7. **Registro de Incidencia (Controles Saltados)**

Para BUS-198, monitoreador registra incidencia:
```
📝 REGISTRAR INCIDENCIA - BUS-198

Tipo: Control/Paradero Omitido
Gravedad: [•] Media (3-5 omitidos) [ ] Alta (>5)

Controles afectados:
[x] Control Km 3
[x] Control Km 5  
[x] Control Km 10
[x] Control Km 15

Causa (según conductor):
┌────────────────────────────────────────┐
│ Congestión severa ruta principal.      │
│ Obra vial no señalizada Km 4.          │
│ Ruta alterna Av. Paralela (8km).       │
│ Retorno ruta oficial Km 12.            │
└────────────────────────────────────────┘

Verificación externa:
[x] Confirmado: Obra vial activa Km 4-5
[x] Google Maps: +25min demora ruta oficial
[x] Otros conductores: Reportan misma situación

Clasificación:
(•) Justificado ✅ (causa válida verificada)
( ) Requiere investigación ⚠️
( ) No justificado ❌

Acción:
[x] Registrado en sistema
[x] No requiere sanción
[ ] Actualizar info ruta
[ ] Notificar a despachadores

[GUARDAR INCIDENCIA] [CANCELAR]
```

Sistema registra en TbIncidencia:
```sql
INSERT INTO TbIncidencia (
    CodSalida,
    TipoIncidencia,
    Gravedad,
    ControlesOmitidos,
    CausaReportada,
    Verificacion,
    Clasificacion,
    FechaHora,
    UsuarioRegistra
) VALUES (
    12345,
    'CONTROLES_OMITIDOS',
    'MEDIA',
    '3,5,10,15',
    'Obra vial - Ruta alterna',
    'Verificado con Google Maps',
    'JUSTIFICADO',
    '2024-12-06 10:35:00',
    'ATorres'
)
```

8. **Caso Crítico - Retraso Extremo**

Para AXD-221 (+44 min en Km 12):
```
🚨 INCIDENCIA CRÍTICA - AXD-221

Control Km 12: +44 minutos de retraso

ACCIÓN OBLIGATORIA:
[📞 LLAMAR CONDUCTOR AHORA]

[Monitoreador llama...]

Conductor reporta:
"Avería mecánica. Sobrecalentamiento motor.
Parada forzosa 40 min. Ahora operativo."

[REGISTRAR INCIDENCIA TÉCNICA]
[NOTIFICAR MANTENIMIENTO]
[ESCALAR A SUPERVISOR]
```

**Postcondiciones:**
- Todas las salidas validadas con matriz RA generada
- Controles saltados identificados y cuantificados
- Conductores contactados cuando umbral excedido (>3 omitidos)
- Incidencias registradas con causa, verificación y clasificación
- Retrasos/adelantos documentados por control
- Casos críticos escalados a supervisor
- Datos disponibles para análisis de puntualidad

---

### **CU-MON-005: Rastrear Unidades Perdidas**

**ID:** CU-MON-005

**Actor Principal:** Monitoreador GPS

**Precondiciones:**
- Unidad reportada como "perdida"
- Último registro GPS disponible
- Canales de comunicación activos

**Trigger:**
- Pérdida de señal GPS >10 minutos
- Conductor no responde comunicaciones
- Supervisor solicita ubicación urgente
- Denuncia de robo/pérdida

**Flujo Principal:**

1. **Declaración de Unidad Perdida**
   - Sistema marca unidad en estado crítico
   - Genera alerta de alta prioridad
   - Notifica automáticamente a supervisor

2. **Recuperación de Última Posición Conocida**
   - Sistema consulta Tb_RegistroTrack
   - Muestra en mapa:
     * Última coordenada GPS
     * Hora última transmisión
     * Dirección de movimiento
     * Velocidad registrada

3. **Intentos de Contacto**
   - Monitoreador ejecuta protocolo:
     * Llamada radio (3 intentos)
     * Llamada celular conductor (2 intentos)
     * Mensaje app móvil
     * Contacto con base si es terminal

4. **Análisis de Contexto**
   - Revisa historial reciente:
     * Ruta que seguía
     * Última alerta generada
     * Patrón de movimiento
     * Zona de última ubicación

5. **Activación de Búsqueda**
   - Si no hay respuesta:
     * Notifica a Jefe Operaciones
     * Activa protocolo de búsqueda
     * Coordina con inspectores en campo
     * Considera contacto autoridades (robo)

6. **Monitoreo de Reactivación**
   - Sistema queda en espera de señal GPS
   - Al recuperar señal:
     * Alerta inmediata a monitoreador
     * Verifica posición actual
     * Contacta conductor urgente

**Postcondiciones:**
- Unidad localizada o búsqueda activa iniciada
- Incidente documentado completamente
- Protocolo de emergencia activado si necesario
- Seguimiento continuo hasta resolución

---

### **CU-MON-006: Generar Reportes de Tracking**

**ID:** CU-MON-006

**Actor Principal:** Monitoreador GPS

**Precondiciones:**
- Datos GPS registrados en Tb_RegistroTrack
- Período de reporte definido
- Permisos para generación de reportes

**Trigger:**
- Fin de turno del monitoreador
- Solicitud de supervisor/gerencia
- Generación programada automática
- Investigación de incidente

**Flujo Principal:**

1. **Acceso a Módulo de Reportes**
   - Monitoreador ingresa a generación de reportes
   - Sistema muestra plantillas disponibles:
     * Reporte de turno
     * Cumplimiento de rutas
     * Alertas gestionadas
     * Comunicaciones realizadas
     * Incidentes críticos

2. **Selección de Parámetros**
   - Define alcance:
     * Fecha/hora inicio
     * Fecha/hora fin
     * Rutas incluidas
     * Unidades específicas (opcional)

3. **Generación Automática**
   - Sistema procesa información:
     * Extrae datos de tracking
     * Calcula métricas
     * Identifica eventos relevantes
     * Genera gráficos

4. **Revisión y Complemento**
   - Monitoreador revisa reporte generado
   - Agrega observaciones:
     * Incidentes destacados
     * Decisiones tomadas
     * Recomendaciones
     * Pendientes para siguiente turno

5. **Finalización y Distribución**
   - Monitoreador aprueba reporte
   - Sistema distribuye a:
     * Jefe Operaciones
     * Supervisor Terminal
     * Archivo digital
   - Registra reporte en base de datos

**Postcondiciones:**
- Reporte generado y aprobado
- Información distribuida a stakeholders
- Datos disponibles para análisis histórico
- Tendencias identificadas para mejora

---

### **CU-MON-007: Coordinar Respuesta a Emergencias**

**ID:** CU-MON-007

**Actor Principal:** Monitoreador GPS

**Precondiciones:**
- Sistema de emergencias configurado
- Protocolos de respuesta definidos
- Contactos de emergencia disponibles
- Canales de comunicación activos

**Trigger:**
- Conductor reporta emergencia (accidente, asalto, avería grave)
- Sistema detecta patrón de emergencia (GPS estático + alerta pánico)
- Testigo externo reporta incidente con unidad
- Alerta crítica no atendida por conductor

**Flujo Principal:**

1. **Recepción de Alerta de Emergencia**
   - Sistema recibe señal de emergencia
   - Activa protocolo automático:
     * Alarma sonora crítica
     * Pop-up emergente pantalla completa
     * Grabación automática de comunicaciones
     * Notificación a supervisor

2. **Clasificación de Emergencia**
   - Monitoreador determina tipo:
     * Médica (conductor o pasajero)
     * Accidente de tránsito
     * Seguridad (asalto, amenaza)
     * Técnica grave (incendio, falla crítica)
   - Asigna nivel de criticidad:
     * Crítica: riesgo de vida
     * Alta: requiere atención inmediata
     * Media: situación controlable

3. **Activación de Protocolo Específico**
   - **Para Emergencia Médica:**
     * Contacta conductor para detalles
     * Llama ambulancia con ubicación GPS exacta
     * Instruye conductor en primeros auxilios
     * Coordina evacuación si necesario
   
   - **Para Accidente:**
     * Verifica estado de conductor y pasajeros
     * Contacta ambulancia si hay heridos
     * Notifica a policía de tránsito
     * Envía inspector para levantamiento
     * Coordina grúa si es necesario
   
   - **Para Asalto/Seguridad:**
     * Contacta policía inmediatamente
     * Comparte última ubicación GPS
     * Instruye conductor NO resistir
     * Activa rastreo continuo
     * Coordina con autoridades seguimiento

4. **Coordinación con Entidades Externas**
   - Llama a servicios de emergencia:
     * Ambulancia: proporciona ubicación GPS
     * Policía: describe situación
     * Bomberos: si hay fuego
   - Mantiene línea abierta hasta llegada de ayuda

5. **Gestión Interna**
   - Notifica cadena de mando:
     * Supervisor Terminal (inmediato)
     * Jefe Operaciones (< 5 minutos)
     * Gerencia (según gravedad)
   - Coordina recursos internos:
     * Unidad de reemplazo
     * Inspector a terreno
     * Apoyo logístico

6. **Documentación de Emergencia**
   - Sistema registra automáticamente:
     * Hora inicio emergencia
     * Tipo y clasificación
     * Acciones tomadas (timeline)
     * Entidades contactadas
     * Tiempos de respuesta
     * Resultado final
   - Monitoreador complementa con:
     * Observaciones detalladas
     * Comunicaciones textuales
     * Decisiones críticas tomadas

7. **Seguimiento Hasta Resolución**
   - Monitoreador permanece involucrado hasta:
     * Ayuda externa arriba al lugar
     * Situación controlada
     * Conductor/pasajeros a salvo
     * Unidad asegurada
   - Coordina transición a siguiente fase (investigación)

8. **Cierre y Reporte**
   - Genera reporte de emergencia
   - Documenta lecciones aprendidas
   - Identifica mejoras a protocolos
   - Archiva evidencia para seguros/legal

**Postcondiciones:**
- Emergencia atendida según protocolo
- Ayuda externa coordinada exitosamente
- Personas involucradas seguras
- Incidente completamente documentado
- Seguimiento establecido para cierre
- Mejoras identificadas para prevención

---


## CONDUCTOR

### **CU-CON-001: Ingresar a Cola de Despacho**

**ID:** CU-CON-001

**Actor Principal:** Conductor

**Precondiciones:**
- Conductor autenticado en sistema
- Unidad asignada y operativa
- Documentos vigentes (14 tipos obligatorios)
- Puntos de licencia ≥75
- Suministro de boletos completo
- Ubicación GPS en terminal
- Turno activo para el conductor

**Trigger:**
- Conductor llega a terminal listo para servicio
- Finaliza viaje anterior y retorna a terminal
- Recibe instrucción de despacho programado

**Flujo Principal:**

1. **Llegada a Terminal**
   - Conductor estaciona unidad en zona de espera
   - Sistema GPS detecta entrada a geocerca terminal
   - Registro automático en Tb_RegistroTrack:
     * Timestamp llegada
     * Coordenadas GPS
     * IdDispositivo
     * IdUnidad

2. **Presentación en Ventanilla de Despacho**
   - Conductor se acerca al despachador
   - Identifica su unidad: "Unidad BUS-245 para cola Ruta 25"
   - Despachador verifica visualmente la unidad

3. **Registro en Sistema**
   - Despachador accede a ProcColaDespacho
   - Ingresa datos:
     * CodUnidad: 245
     * CodPersonaConductor: ID del conductor
     * CodRuta: 25
     * Terminal: A o B
     * TipoIngresoCola: M (Manual), A (Automático), P (Programado)
   - Sistema ejecuta validaciones automáticas

4. **Validaciones Automáticas Pre-Cola**
   ```
   VALIDACIÓN 1: Documentos Conductor
   - DNI vigente ✅
   - Licencia categoría adecuada ✅
   - CAC vigente ✅
   - Examen psicosomático vigente ✅
   - [10 documentos más...]
   Resultado: APROBADO
   
   VALIDACIÓN 2: Puntos de Licencia
   - Puntos actuales: 95
   - Mínimo requerido: 75
   Resultado: APROBADO
   
   VALIDACIÓN 3: Suministro de Boletos
   - Boletos físicos serie A: 45 disponibles ✅
   - Boletos físicos serie B: 30 disponibles ✅
   - Stock mínimo: 50 (ALERTA: Stock bajo)
   Resultado: APROBADO CON OBSERVACIÓN
   
   VALIDACIÓN 4: Estado Unidad
   - Estado operativo: SÍ ✅
   - Mantenimiento al día: SÍ ✅
   - Combustible: 75% ✅
   Resultado: APROBADO
   
   VALIDACIÓN 5: Ubicación GPS
   - En terminal: SÍ ✅
   - Distancia al control: 45 metros
   Resultado: APROBADO
   ```

5. **Asignación de Posición en Cola**
   - Sistema asigna NroOrdenDespacho secuencial
   - Ejemplo: 
     * Primera unidad en cola: Orden 1
     * Segunda: Orden 2
     * Conductor actual: Orden 7
   - Sistema registra en TbUnidadColaDespacho:
     ```sql
     CodUnidadColaDespacho: [AutoIncrement]
     CodUnidad: 245
     CodPersonaConductor: 1523
     CodRuta: 25
     CodRecorrido: 50
     NroOrdenDespacho: 7
     ColaDespachoActual: 1 (Activa)
     FechaHoraIngreso: 2024-12-06 08:15:23
     Lado: 'A' (Terminal A)
     TipoIngresoCola: 'M' (Manual)
     CodEstado: 1 (En cola)
     ```

6. **Notificación al Conductor**
   - Despachador informa verbalmente:
     * "Unidad 245, posición 7 en cola"
     * "Tiempo estimado de espera: 25 minutos"
     * "Permanezca en zona de espera"
   - Conductor confirma:
     * "Recibido, posición 7"

7. **Visualización en Pantalla**
   - Sistema muestra en pantalla LED del terminal:
     ```
     COLA RUTA 25 - TERMINAL A
     1. BUS-210 - Próximo despacho
     2. BUS-189 - En preparación
     3. BUS-301
     4. BUS-145
     5. BUS-278
     6. BUS-192
     7. BUS-245 ← (Conductor puede ver su posición)
     ```

8. **Espera en Cola**
   - Conductor permanece en zona de espera
   - Puede:
     * Revisar unidad (limpieza, verificaciones)
     * Consultar información en app móvil
     * Descansar en área designada
     * Reabastecer boletos si stock bajo

9. **Actualización Automática de Posición**
   - A medida que se despachan unidades:
     * Posición 7 → 6 → 5 → 4...
     * Sistema actualiza TbUnidadColaDespacho
     * Pantalla LED se actualiza cada 30 segundos

10. **Alerta de Próximo Despacho**
    - Cuando llega a posición 2:
      * Sistema envía notificación (si hay app)
      * Pantalla muestra "PRÓXIMO DESPACHO"
      * Conductor se prepara para salir

**Postcondiciones:**
- Conductor registrado en cola de despacho
- Posición asignada y visible
- Validaciones pre-despacho completadas
- Sistema monitorea tiempo de espera
- Conductor en espera de autorización

**Flujos Alternativos:**

**FA1: Validación Fallida - Documentos Vencidos**
- Sistema detecta documento vencido
- Despachador notifica: "Licencia vencida, no puede ingresar a cola"
- Conductor debe:
  * Renovar documento urgente
  * Reportar a RRHH
  * No puede operar hasta regularizar
- Sistema registra intento bloqueado

**FA2: Stock de Boletos Insuficiente**
- Sistema detecta stock < mínimo requerido
- Despachador indica: "Debe reabastecer boletos antes de ingresar"
- Conductor:
  * Va a ventanilla de suministros
  * Solicita talonario adicional
  * Retorna e ingresa a cola
- Sistema actualiza inventario

**FA3: Cola Saturada**
- Si cola tiene >15 unidades:
  * Sistema sugiere esperar o ir a Terminal opuesta
  * Despachador informa tiempo estimado real
  * Conductor decide si espera o cambia terminal

---

### **CU-CON-002: Recibir Autorización de Despacho**

**ID:** CU-CON-002

**Actor Principal:** Conductor

**Precondiciones:**
- Conductor en posición 1 de cola
- Todas validaciones aprobadas
- Despachador disponible
- Horario dentro de operación autorizada
- Sistema GPS activo

**Trigger:**
- NroOrdenDespacho = 1 (primera posición)
- Despachador ejecuta despacho
- Hora programada alcanzada (si hay programación)

**Flujo Principal:**

1. **Llamado a Despacho**
   - Despachador llama al conductor:
     * Por radio: "Unidad BUS-245 a despacho"
     * Verbalmente: "¡BUS-245, listo para salir!"
     * En pantalla: "UNIDAD 245 - DESPACHANDO"

2. **Verificación Final**
   - Conductor confirma:
     * Motor encendido ✅
     * Puertas funcionando ✅
     * GPS activo ✅
     * Ticketera operativa ✅ (si aplica)
     * Boletos disponibles ✅

3. **Ejecución del Despacho**
   - Despachador ejecuta: `proc_tgps_set_DespacharUnidad`
   - Sistema realiza validaciones finales en cascada
   - Si TODAS las validaciones = OK:
     * Sistema genera salida oficial
     * Registra en Tb_SalidaUnidad:
       ```sql
       IdSalida: [AutoIncrement]
       CodUnidad: 245
       CodPersonaConductor: 1523
       CodRuta: 25
       FechaHoraProgramada: 2024-12-06 09:00:00
       FechaHoraReal: 2024-12-06 09:02:15 (retraso 2min)
       F_Estado: 11 (En curso)
       CodUsuarioDespacho: ID_Despachador
       ```

4. **Autorización Verbal**
   - Despachador indica:
     * "Autorizado para salir"
     * "Ruta 25, buen viaje"
     * "Frecuencia 10 minutos, próximo en 09:12"

5. **Inicio de Tracking GPS**
   - Sistema activa monitoreo continuo
   - Registra en Tb_RegistroTrack cada 30-60 seg:
     * Latitud, Longitud
     * Velocidad
     * Dirección
     * Timestamp

6. **Salida Física del Terminal**
   - Conductor:
     * Enciende luces de ruta
     * Inicia movimiento
     * Sale del terminal hacia primer paradero
   - Sistema GPS detecta salida de geocerca terminal

7. **Confirmación de Despacho Exitoso**
   - Sistema verifica:
     * Unidad en movimiento (velocidad >5 km/h)
     * Dirección correcta hacia ruta
     * GPS transmitiendo posiciones
   - Actualiza cola:
     * Elimina unidad de TbUnidadColaDespacho
     * Sube siguiente unidad a posición 1

8. **Notificación a Monitoreador GPS**
   - Sistema notifica: "BUS-245 despachado en Ruta 25"
   - Monitoreador comienza seguimiento activo

**Postcondiciones:**
- Conductor autorizado oficialmente
- Salida registrada en sistema
- Tracking GPS activo
- Cola actualizada (siguiente unidad lista)
- Monitoreo iniciado

**Flujos Alternativos:**

**FA1: Validación de Última Hora Falla**
- Si GPS sin señal justo antes de despachar:
  * Despachador espera recuperación señal (max 2 min)
  * Si no recupera: despacho manual con seguimiento especial
  * Sistema marca salida como "Sin GPS inicial"

**FA2: Conductor Reporta Falla Técnica**
- Conductor indica problema (ej: puerta no cierra):
  * Despachador cancela despacho
  * Unidad sale de cola a mantenimiento
  * Siguiente unidad pasa a posición 1
  * Sistema registra incidencia

---

### **CU-CON-003: Vender Boletos con Ticketera**

**ID:** CU-CON-003

**Actor Principal:** Conductor

**Precondiciones:**
- Unidad con validador/ticketera operativo
- Conductor autenticado en ticketera
- Caja abierta (ProcCajaGestionConductor @Indice=21)
- En ruta realizando servicio
- Pasajeros abordando

**Trigger:**
- Pasajero aborda y solicita boleto
- Pasajero presenta tarjeta de pago
- Pasajero presenta efectivo

**Flujo Principal:**

1. **Pasajero Aborda**
   - Pasajero sube a la unidad
   - Se acerca al validador/ticketera

2. **Selección de Tarifa**
   - Conductor determina tarifa aplicable:
     * Adulto normal: $2.50
     * Estudiante (50% descuento): $1.25
     * Adulto mayor (50% descuento): $1.25
     * Persona con discapacidad (gratuito): $0.00

3. **Procesamiento de Pago**
   
   **3a. Pago en Efectivo:**
   - Pasajero entrega dinero al conductor
   - Conductor ingresa monto en ticketera
   - Ticketera calcula vuelto si necesario
   - Conductor entrega vuelto al pasajero
   - Ticketera imprime boleto automáticamente
   
   **3b. Pago con Tarjeta:**
   - Pasajero acerca tarjeta a lector NFC
   - Validador procesa transacción
   - Confirma pago exitoso (beep + luz verde)
   - Imprime boleto automáticamente

4. **Registro Automático de Transacción**
   - Sistema ejecuta: `ProcBoletoTransaccion @Indice=21`
   - Registra en TbBoletoTransaccion:
     ```sql
     NumCorrelativo: [Siguiente número único]
     FechaTransaccion: 2024-12-06 09:15:43
     MontoTransaccion: 2.50
     TipoTransaccion: 1 (Efectivo) o 2 (Tarjeta)
     CodValidador: 1523
     CodRuta: 25
     GPS_Latitud: -12.0464
     GPS_Longitud: -77.0428
     CodEstado: 1 (Válida)
     ```

5. **Acumulación en Caja Digital**
   - Sistema actualiza TbLiquidacionValidador:
     ```sql
     Si efectivo:
       ProduccionEfectivo += 2.50
       CantidadEfectivo += 1
     
     Si tarjeta:
       ProduccionTarjeta += 2.50
       CantidadTarjeta += 1
     ```

6. **Entrega de Boleto**
   - Ticketera imprime boleto con:
     * Número correlativo
     * Fecha y hora
     * Monto pagado
     * Ruta
     * Tipo de tarifa
   - Pasajero recibe boleto
   - Pasajero toma asiento

7. **Transmisión a Servidor Central**
   - Ticketera transmite datos en tiempo real
   - Si hay conectividad:
     * Envío inmediato a servidor
   - Si no hay conectividad:
     * Almacena en buffer local
     * Transmite al recuperar señal

**Postcondiciones:**
- Transacción registrada automáticamente
- Producción actualizada en tiempo real
- Boleto impreso entregado al pasajero
- Datos sincronizados con servidor central
- Historial de ventas completo

**Flujos Alternativos:**

**FA1: Ticketera Sin Papel**
- Ticketera detecta rollo de papel agotado
- Alerta al conductor (luz roja + beep)
- Conductor:
  * Detiene venta temporalmente
  * Cambia rollo de papel
  * Reinicia ticketera
  * Continúa operación normal

**FA2: Falla en Lector de Tarjetas**
- Lector NFC no responde
- Conductor informa: "Solo efectivo por favor"
- Registra transacción manual en efectivo
- Reporta falla técnica al finalizar turno

**FA3: Pasajero sin Cambio**
- Pasajero presenta billete de $20 para pasaje $2.50
- Conductor verifica si tiene vuelto
- Si NO tiene vuelto suficiente:
  * Puede autorizar viaje gratis (registra justificación)
  * O solicita al pasajero cambio exacto
  * Documenta situación para liquidación

---

### **CU-CON-004: Vender Boletos Manualmente**

**ID:** CU-CON-004

**Actor Principal:** Conductor

**Precondiciones:**
- Talonario de boletos físicos asignado
- Conductor sin ticketera (o ticketera averiada)
- Boletos serie A-001 a A-100 disponibles
- En ruta realizando servicio

**Trigger:**
- Pasajero aborda unidad sin ticketera
- Ticketera averiada durante servicio
- Modo de contingencia activado

**Flujo Principal:**

1. **Pasajero Solicita Boleto**
   - Pasajero aborda y solicita boleto
   - Conductor identifica tarifa aplicable

2. **Cobro del Pasaje**
   - Conductor indica monto: "$2.50 por favor"
   - Pasajero entrega efectivo
   - Conductor verifica autenticidad (si es billete)

3. **Selección de Boleto del Talonario**
   - Conductor toma siguiente boleto de la serie:
     * Serie A, Número 045
   - Verifica que boleto esté en buen estado

4. **Registro Mental/Manual**
   - Conductor mentalmente registra:
     * Primer boleto vendido del turno: A-045
     * Último boleto vendido: A-067 (va actualizando)
     * Boletos vendidos hasta ahora: 23

5. **Entrega de Boleto y Vuelto**
   - Conductor entrega boleto físico al pasajero
   - Si aplica, entrega vuelto
   - Guarda efectivo en caja personal

6. **Acumulación de Efectivo**
   - Conductor mantiene efectivo en:
     * Bolsillo destinado
     * Bolsa segura
     * Caja de cobro
   - Separado por denominación (opcional)

**Postcondiciones:**
- Boleto físico entregado
- Efectivo recaudado guardado
- Control manual de boletos vendidos
- Pasajero con comprobante de pago

**Nota:** El registro digital ocurre posteriormente cuando el conductor entrega al cajero, quien crea el CCU (Caja Conductor Usuario) manualmente usando `ProcRecaudoV2`.

---

### **CU-CON-005: Registrar Producción de Viaje**

**ID:** CU-CON-005

**Actor Principal:** Conductor

**Precondiciones:**
- Viaje completado (llegada a terminal destino)
- Producción del viaje conocida
- Sistema operativo disponible

**Trigger:**
- Finalización de recorrido completo
- Llegada a terminal para entrega parcial
- Sistema solicita reporte de producción

**Flujo Principal:**

**CASO A: Con Ticketera (Automático)**

1. **Llegada a Terminal**
   - Conductor estaciona en zona designada
   - GPS detecta entrada a geocerca terminal

2. **Cierre Automático de Viaje**
   - Sistema detecta fin de recorrido
   - Calcula automáticamente:
     * Tiempo total de viaje
     * Distancia recorrida GPS
     * Número de transacciones
     * Producción total del viaje

3. **Generación de Reporte Automático**
   - Ticketera muestra resumen:
     ```
     VIAJE COMPLETADO
     Ruta: 25
     Salida: 09:00 | Llegada: 10:15
     Duración: 1h 15min
     
     VENTAS:
     Efectivo: 25 boletos × $2.50 = $62.50
     Tarjeta: 15 boletos × $2.50 = $37.50
     TOTAL: 40 boletos = $100.00
     ```

4. **Confirmación del Conductor**
   - Conductor revisa resumen
   - Confirma en ticketera: "Aceptar"
   - Sistema consolida datos

**CASO B: Sin Ticketera (Manual)**

1. **Cálculo Manual**
   - Conductor contabiliza:
     * Primer boleto vendido: A-045
     * Último boleto vendido: A-084
     * Total vendidos: 84 - 45 + 1 = 40 boletos
     * Producción: 40 × $2.50 = $100.00

2. **Verificación de Efectivo**
   - Conductor cuenta efectivo acumulado
   - Compara con cálculo de producción
   - Identifica diferencias si existen

3. **Registro Mental para Entrega**
   - Conductor memoriza/anota:
     * Boletos vendidos: 40
     * Efectivo recaudado: $100.00
     * Diferencias: ninguna (o justificación)

**Postcondiciones:**
- Producción del viaje cuantificada
- Datos listos para entrega/liquidación
- Diferencias identificadas (si existen)
- Sistema actualizado (automático) o pendiente (manual)

---

### **CU-CON-006: Cumplir Recorrido Autorizado**

**ID:** CU-CON-006

**Actor Principal:** Conductor

**Precondiciones:**
- Despacho autorizado
- Ruta asignada conocida
- GPS activo
- Mapa de ruta disponible (físico o mental)

**Trigger:**
- Salida de terminal autorizada
- Inicio de servicio en ruta

**Flujo Principal:**

1. **Inicio del Recorrido**
   - Conductor sale de terminal
   - Sigue ruta autorizada memorizada/señalizada
   - GPS comienza tracking automático

2. **Cumplimiento de Paraderos**
   - Conductor detiene en paraderos oficiales:
     * Paradero 1: Terminal A (origen)
     * Paradero 2: Av. Principal altura calle 5
     * Paradero 3: Av. Principal altura calle 10
     * ...
     * Paradero 15: Terminal B (destino)
   - Sistema GPS registra cada parada

3. **Respeto de Puntos de Control**
   - Conductor pasa por controles obligatorios:
     * Control 1: Entrada zona centro (km 3.5)
     * Control 2: Mitad de ruta (km 7.2)
     * Control 3: Salida zona centro (km 10.8)
   - GPS valida paso por geocercas de control

4. **Mantenimiento de Velocidad Segura**
   - Conductor respeta límites:
     * Zona urbana: máx 50 km/h
     * Zona escolar: máx 30 km/h
     * Avenida principal: máx 60 km/h
   - GPS monitorea velocidad continuamente

5. **Gestión de Desvíos Autorizados**
   - Si hay congestión vehicular:
     * Conductor evalúa ruta alterna conocida
     * Informa por radio a central
     * Toma desvío temporal
     * Retorna a ruta autorizada ASAP
   - Monitoreador GPS valida justificación

6. **Llegada a Destino**
   - Conductor llega a Terminal B
   - GPS registra entrada a geocerca terminal
   - Sistema valida cumplimiento de ruta:
     * Todos los controles pasados ✅
     * Tiempo dentro de rango esperado ✅
     * Sin desviaciones injustificadas ✅

**Postcondiciones:**
- Recorrido completo ejecutado
- Ruta autorizada cumplida
- GPS tracking completo registrado
- Validaciones de cumplimiento OK

**Flujos Alternativos:**

**FA1: Desvío por Emergencia**
- Conductor detecta bloqueo total de vía
- Informa inmediatamente a monitoreador GPS
- Toma ruta alterna coordinada
- Documenta motivo del desvío
- Sistema marca como "Desvío Justificado"

**FA2: Pérdida de Señal GPS Temporal**
- GPS pierde señal en túnel/zona de sombra
- Conductor continúa ruta normal
- Al salir de zona: GPS recupera señal
- Sistema valida continuidad de ruta

---

### **CU-CON-007: Reportar Incidencias en Ruta**

**ID:** CU-CON-007

**Actor Principal:** Conductor

**Precondiciones:**
- En servicio activo en ruta
- Canal de comunicación disponible
- Ocurrencia de incidencia

**Trigger:**
- Avería mecánica
- Accidente de tránsito
- Situación de seguridad
- Bloqueo de vía
- Emergencia médica

**Flujo Principal:**

1. **Detección de Incidencia**
   - Conductor identifica situación anormal:
     * Motor sobrecalentando
     * Ruido mecánico extraño
     * Accidente menor (choque leve)
     * Pasajero con emergencia médica

2. **Evaluación de Criticidad**
   - Conductor clasifica mentalmente:
     * CRÍTICA: Riesgo inmediato de vida/seguridad
     * ALTA: Requiere atención urgente
     * MEDIA: Puede continuar con precaución
     * BAJA: Informativa/menor

3. **Contacto con Central**
   - Conductor llama por radio:
     * "Central, Unidad BUS-245"
     * "Reporto [tipo de incidencia]"
     * "Ubicación: [paradero/referencia]"
   - Monitoreador GPS responde

4. **Descripción Detallada**
   - Conductor proporciona:
     * Naturaleza exacta del problema
     * Estado actual (detenido/en movimiento)
     * Número de pasajeros afectados
     * Necesidad de apoyo (ambulancia, grúa, etc.)

5. **Recepción de Instrucciones**
   - Monitoreador/Supervisor indica:
     * Si debe continuar o detener servicio
     * Si requiere evacuación de pasajeros
     * Si debe esperar apoyo
     * Si debe reportar a autoridades

6. **Ejecución de Protocolo**
   - Conductor sigue instrucciones:
     * Seguridad de pasajeros (prioridad 1)
     * Señalización de vehículo
     * Contacto con servicios externos (si aplica)
     * Documentación del incidente

7. **Registro en Sistema**
   - Monitoreador registra en sistema:
     * TbIncidencia
     * TbDespachoOcurrencia
     * Tb_AlertaRecepcion
   - Genera número de incidente

8. **Seguimiento Hasta Resolución**
   - Conductor mantiene comunicación
   - Informa cambios de estado
   - Coordina cierre del incidente

**Postcondiciones:**
- Incidencia reportada y registrada
- Protocolo de respuesta activado
- Seguridad de pasajeros garantizada
- Seguimiento establecido hasta resolución

---

### **CU-CON-008: Liquidar Producción Diaria**

**ID:** CU-CON-008

**Actor Principal:** Conductor

**Precondiciones:**
- Turno finalizado
- Todas las salidas completadas
- Producción total acumulada
- Caja digital cerrada (si hay ticketera)

**Flujo Principal:**

**CASO A: Con Ticketera**

1. **Cierre de Caja Digital**
   - Conductor ejecuta cierre en ticketera
   - Sistema ejecuta: `ProcCajaGestionConductor @Indice=31`
   - Genera reporte automático:
     ```
     RESUMEN DE TURNO
     Conductor: Juan Pérez
     Fecha: 06/12/2024
     Turno: 06:00 - 14:00 (8 horas)
     
     PRODUCCIÓN:
     Efectivo: 150 transacciones = $375.00
     Tarjeta: 100 transacciones = $250.00
     TOTAL: 250 transacciones = $625.00
     ```

2. **Entrega en Ventanilla de Recaudo**
   - Conductor se acerca al cajero/liquidador
   - Entrega efectivo recaudado: $375.00
   - Cajero cuenta y verifica
   - Compara vs. reporte digital

3. **Proceso de Liquidación**
   - Cajero/Liquidador ejecuta: `ProcLiquidacionValidador @Indice=20`
   - Sistema calcula:
     ```
     Producción Total: $625.00
     (-) Gastos operativos: $45.00
     (-) Honorarios conductor (30%): $187.50
     (-) Anticipos: $50.00
     (=) Neto a entregar: $342.50
     ```

4. **Recepción de Liquidación**
   - Liquidador entrega al conductor: $342.50
   - Genera comprobante digital
   - Conductor firma recibo (digital o físico)

**CASO B: Sin Ticketera (Boletos Físicos)**

1. **Entrega al Cajero**
   - Conductor entrega:
     * Efectivo total recaudado
     * Talonario con boletos restantes
   - Informa verbalmente:
     * "Primer boleto vendido: A-045"
     * "Último boleto vendido: A-084"
     * "Total efectivo: $100.00"

2. **Verificación Física del Cajero**
   - Cajero cuenta:
     * Boletos restantes en talonario
     * Calcula vendidos: 100 - restantes = vendidos
     * Cuenta efectivo entregado
   - Compara: efectivo vs. boletos vendidos

3. **Creación de CCU Manual**
   - Cajero ejecuta: `ProcRecaudoV2 @Indice=20`
   - Registra producción calculada
   - Identifica diferencias

4. **Liquidación Final**
   - Liquidador procesa con `ProcRecaudoGastoV2`
   - Calcula neto a entregar
   - Entrega pago al conductor

**Postcondiciones:**
- Producción diaria liquidada
- Efectivo entregado y verificado
- Conductor recibe pago neto
- Comprobante generado
- Cierre de turno completo

---

### **CU-CON-009: Consultar Estado Personal**

**ID:** CU-CON-009

**Actor Principal:** Conductor

**Precondiciones:**
- Conductor autenticado en sistema
- Datos personales actualizados

**Trigger:**
- Necesidad de verificar documentos
- Consulta rutinaria de puntos licencia
- Verificación antes de despacho

**Flujo Principal:**

1. **Acceso al Sistema**
   - Conductor ingresa a portal/app
   - Sistema autentica credenciales

2. **Dashboard Personal**
   - Sistema muestra:
     ```
     ESTADO PERSONAL - Juan Pérez
     
     DOCUMENTOS:
     ✅ DNI: Vigente hasta 2028
     ✅ Licencia: Vigente hasta Jun-2025
     ⚠️ CAC: Vence en 25 días
     ✅ Examen Psicosomático: Vigente
     
     LICENCIA:
     Puntos actuales: 95/100
     Infracciones: 1 (exceso velocidad menor)
     
     ESTADO OPERATIVO: ACTIVO
     ```

3. **Revisión Detallada**
   - Conductor puede ver detalles de cada documento
   - Puede descargar certificados
   - Puede ver historial de vencimientos

4. **Alertas Preventivas**
   - Sistema muestra: "Tu CAC vence en 25 días - Renueva pronto"
   - Conductor toma nota para gestión

**Postcondiciones:**
- Conductor informado de su estado
- Alertas de vencimientos identificadas
- Acciones preventivas conocidas

---

## SISTEMA

### **CU-SIS-001: Validar Documentos de Conductor**

**ID:** CU-SIS-001

**Actor Principal:** Sistema (Automatización)

**Precondiciones:**
- TbPersonaVencimiento poblada con fechas de vencimiento
- TbVencimientoConcepto configurada con los 14 tipos de documentos
- Conductor registrado en TbPersona
- Fecha actual del sistema válida

**Trigger:**
- Conductor intenta ingresar a cola de despacho
- Ejecución de ProcDespachoValidacion @Indice=17
- Login del conductor en el sistema
- Consulta manual de estado

**Flujo Principal:**

1. **Inicio de Validación Automática**
   - Sistema recibe: @CodPersona (ID del conductor)
   - Fecha actual: GETDATE() = 2024-12-06
   - Inicia proceso de verificación

2. **Consulta de Documentos Obligatorios**
   ```sql
   SELECT 
       vc.NomVencimientoConcepto,
       pv.FechaVencimiento,
       DATEDIFF(DAY, GETDATE(), pv.FechaVencimiento) AS DiasRestantes,
       CASE 
           WHEN pv.FechaVencimiento < GETDATE() THEN 'VENCIDO'
           WHEN DATEDIFF(DAY, GETDATE(), pv.FechaVencimiento) <= 30 THEN 'POR VENCER'
           ELSE 'VIGENTE'
       END AS Estado
   FROM TbPersonaVencimiento pv
   INNER JOIN TbVencimientoConcepto vc ON pv.CodVencimientoConcepto = vc.CodVencimientoConcepto
   WHERE pv.CodPersona = @CodPersona
     AND vc.Obligatorio = 1
   ```

3. **Evaluación por Tipo de Documento**
   
   **Documentos Críticos (Bloqueo Automático si Vencido):**
   - DNI/Carnet Extranjería
   - Licencia de Conducir
   - Código CAC
   - Seguro Responsabilidad Civil
   - AFOCAT
   
   **Documentos de Alta Prioridad (Alerta Mayor):**
   - Examen Psicosomático
   - Inspección Técnica GNV
   - Chip de Gas
   
   **Documentos de Media Prioridad (Alerta Menor):**
   - Credencial Empresa
   - Curso Actualización
   - Botiquín
   - Extintor
   - Certificado Cilindro

4. **Generación de Resultado por Documento**
   ```
   DOCUMENTO 1: DNI
   Vencimiento: 15/08/2028
   Días restantes: 1348
   Estado: VIGENTE ✅
   Criticidad: CRÍTICA
   Resultado: APROBADO
   
   DOCUMENTO 2: Licencia de Conducir
   Vencimiento: 20/06/2025
   Días restantes: 196
   Estado: VIGENTE ✅
   Criticidad: CRÍTICA
   Resultado: APROBADO
   
   DOCUMENTO 3: CAC
   Vencimiento: 15/12/2024
   Días restantes: 9
   Estado: POR VENCER ⚠️
   Criticidad: CRÍTICA
   Resultado: ALERTA PREVENTIVA
   
   DOCUMENTO 4: Examen Psicosomático
   Vencimiento: 01/11/2024
   Días restantes: -35
   Estado: VENCIDO ❌
   Criticidad: ALTA
   Resultado: BLOQUEADO
   ```

5. **Consolidación de Resultados**
   - Sistema cuenta documentos por estado:
     * VIGENTES: 12 documentos
     * POR VENCER (<30 días): 1 documento (CAC)
     * VENCIDOS: 1 documento (Psicosomático)
   - Determina acción final

6. **Decisión Automatizada**
   ```sql
   IF EXISTS(
       SELECT 1 FROM TbPersonaVencimiento pv
       INNER JOIN TbVencimientoConcepto vc ON pv.CodVencimientoConcepto = vc.CodVencimientoConcepto
       WHERE pv.CodPersona = @CodPersona
         AND vc.Criticidad = 'CRITICA'
         AND pv.FechaVencimiento < GETDATE()
   )
   BEGIN
       -- BLOQUEO AUTOMÁTICO
       SET @Resultado = 0
       SET @Mensaje = 'DESPACHO BLOQUEADO: Documento(s) crítico(s) vencido(s)'
   END
   ELSE IF EXISTS(
       SELECT 1 FROM TbPersonaVencimiento pv
       INNER JOIN TbVencimientoConcepto vc ON pv.CodVencimientoConcepto = vc.CodVencimientoConcepto
       WHERE pv.CodPersona = @CodPersona
         AND vc.Criticidad IN ('ALTA', 'CRITICA')
         AND pv.FechaVencimiento < GETDATE()
   )
   BEGIN
       -- REQUIERE AUTORIZACIÓN MANUAL
       SET @Resultado = 2
       SET @Mensaje = 'REQUIERE AUTORIZACIÓN: Documento de alta prioridad vencido'
   END
   ELSE IF EXISTS(
       SELECT 1 FROM TbPersonaVencimiento pv
       WHERE pv.CodPersona = @CodPersona
         AND DATEDIFF(DAY, GETDATE(), pv.FechaVencimiento) <= 30
         AND pv.FechaVencimiento >= GETDATE()
   )
   BEGIN
       -- ALERTA PREVENTIVA
       SET @Resultado = 1
       SET @Mensaje = 'APROBADO CON ALERTA: Documento(s) próximo(s) a vencer'
   END
   ELSE
   BEGIN
       -- TODO OK
       SET @Resultado = 1
       SET @Mensaje = 'APROBADO: Todos los documentos vigentes'
   END
   ```

7. **Registro de Validación**
   - Sistema documenta en TbAuditoriaValidacion:
     * Timestamp validación
     * CodPersona validado
     * Resultado (0=Bloqueado, 1=Aprobado, 2=Requiere Autorización)
     * Detalle de documentos evaluados
     * Usuario/proceso que solicitó validación

8. **Generación de Alertas Automáticas**
   - Si hay documentos por vencer:
     * Genera alerta a RRHH: "Conductor Juan Pérez - CAC vence en 9 días"
     * Genera alerta al conductor: "Tu CAC vence pronto - Renueva urgente"
     * Registra en TbAlerta con prioridad MEDIA
   
   - Si hay documentos vencidos:
     * Genera alerta crítica a RRHH
     * Bloquea conductor en sistema
     * Notifica a Jefe Operaciones

9. **Retorno de Resultado**
   - Sistema devuelve al proceso solicitante:
     ```
     RETURN {
         Resultado: 0 (Bloqueado) | 1 (Aprobado) | 2 (Autorización Requerida)
         Mensaje: "Texto descriptivo"
         DocumentosVencidos: [Lista de documentos]
         DocumentosPorVencer: [Lista con días restantes]
         FechaValidacion: "2024-12-06 08:15:23"
     }
     ```

**Postcondiciones:**
- Validación ejecutada en < 2 segundos
- Resultado determinístico registrado
- Alertas generadas si aplica
- Auditoría completa guardada
- Decisión automatizada tomada

**Matriz de Decisión:**

| Condición | Resultado | Acción Sistema |
|-----------|-----------|----------------|
| Documento CRÍTICO vencido | BLOQUEADO | Impide despacho + Alerta RRHH |
| Documento ALTO vencido | REQUIERE AUTORIZACIÓN | Supervisor debe aprobar |
| Documento MEDIO vencido | ALERTA | Permite despacho + Notifica |
| Documento vence en <30 días | ALERTA PREVENTIVA | Permite + Notifica renovación |
| Todos vigentes | APROBADO | Continúa proceso normal |

---

### **CU-SIS-002: Validar Suministro de Boletos**

**ID:** CU-SIS-002

**Actor Principal:** Sistema (Automatización)

**Precondiciones:**
- TbSuministroDetalle con inventario actualizado
- TbArticulo con artículos de boletos configurados
- Ruta con artículos requeridos definidos
- Modalidad de suministro configurada (Unidad/Persona)

**Trigger:**
- Ejecución de ProcDespachoValidacion @Indice=13
- Conductor solicita ingreso a cola
- Verificación pre-despacho

**Flujo Principal:**

1. **Identificación de Artículos Requeridos**
   ```sql
   SELECT 
       a.CodArticulo,
       a.NomArticulo,
       a.StockMinimoUnidad
   FROM TbArticulo a
   INNER JOIN TbRutaArticulo ra ON a.CodArticulo = ra.CodArticulo
   WHERE ra.CodRuta = @CodRuta
     AND a.EsBoleto = 1
     AND a.CodEstado = 1
   ```
   
   **Ejemplo de resultado:**
   - Serie A (Adulto Normal): Stock mínimo 50
   - Serie B (Estudiante): Stock mínimo 30
   - Serie C (Adulto Mayor): Stock mínimo 20

2. **Consulta de Inventario Disponible**
   
   **Modalidad UNIDAD (suministro por vehículo):**
   ```sql
   SELECT 
       sd.CodArticulo,
       a.NomArticulo,
       SUM(sd.NumFin - sd.NumActual + 1) AS StockDisponible,
       a.StockMinimoUnidad
   FROM TbSuministroDetalle sd
   INNER JOIN TbArticulo a ON sd.CodArticulo = a.CodArticulo
   WHERE sd.CodUnidad = @CodUnidad
     AND sd.Disponible = 1
     AND sd.CodEstado = 1
   GROUP BY sd.CodArticulo, a.NomArticulo, a.StockMinimoUnidad
   ```
   
   **Modalidad PERSONA (suministro por conductor):**
   ```sql
   SELECT 
       sd.CodArticulo,
       a.NomArticulo,
       SUM(sd.NumFin - sd.NumActual + 1) AS StockDisponible,
       a.StockMinimoUnidad
   FROM TbSuministroDetalle sd
   INNER JOIN TbArticulo a ON sd.CodArticulo = a.CodArticulo
   WHERE sd.CodPersona = @CodPersona
     AND sd.Disponible = 1
     AND sd.CodEstado = 1
   GROUP BY sd.CodArticulo, a.NomArticulo, a.StockMinimoUnidad
   ```

3. **Comparación Stock Disponible vs. Requerido**
   ```
   ARTÍCULO: Serie A (Adulto Normal)
   Stock Disponible: 65 boletos
   Stock Mínimo Requerido: 50 boletos
   Estado: SUFICIENTE ✅
   
   ARTÍCULO: Serie B (Estudiante)
   Stock Disponible: 28 boletos
   Stock Mínimo Requerido: 30 boletos
   Estado: INSUFICIENTE ❌
   
   ARTÍCULO: Serie C (Adulto Mayor)
   Stock Disponible: 25 boletos
   Stock Mínimo Requerido: 20 boletos
   Estado: SUFICIENTE ✅
   ```

4. **Evaluación de Completitud**
   ```sql
   DECLARE @ArticulosRequeridos INT
   DECLARE @ArticulosSuficientes INT
   DECLARE @ArticulosFaltantes TABLE (
       NomArticulo VARCHAR(100),
       StockDisponible INT,
       StockRequerido INT,
       Diferencia INT
   )
   
   -- Identifica faltantes
   INSERT INTO @ArticulosFaltantes
   SELECT 
       a.NomArticulo,
       ISNULL(inv.StockDisponible, 0),
       a.StockMinimoUnidad,
       a.StockMinimoUnidad - ISNULL(inv.StockDisponible, 0)
   FROM TbArticulo a
   LEFT JOIN (
       -- Subconsulta de inventario disponible
   ) inv ON a.CodArticulo = inv.CodArticulo
   WHERE ISNULL(inv.StockDisponible, 0) < a.StockMinimoUnidad
   ```

5. **Generación de Resultado**
   ```sql
   IF NOT EXISTS(SELECT 1 FROM @ArticulosFaltantes)
   BEGIN
       -- TODOS LOS ARTÍCULOS SUFICIENTES
       SET @Resultado = 1
       SET @Mensaje = 'APROBADO: Suministro completo'
       SET @CodResultado = 1
   END
   ELSE
   BEGIN
       -- HAY ARTÍCULOS FALTANTES
       SET @Resultado = 0
       SET @Mensaje = 'BLOQUEADO: Suministro incompleto - ' + 
                      (SELECT STRING_AGG(NomArticulo + ' (faltan ' + 
                       CAST(Diferencia AS VARCHAR) + ')', ', ')
                       FROM @ArticulosFaltantes)
       SET @CodResultado = 0
   END
   ```

6. **Registro de Validación**
   - Documenta en TbSuministroValidacion:
     * Timestamp
     * CodUnidad o CodPersona validado
     * Artículos evaluados
     * Resultado global
     * Artículos faltantes detallados

7. **Generación de Alertas**
   - Si hay faltantes:
     * Alerta al despachador: "BUS-245 sin suficientes boletos Serie B"
     * Notifica a coordinador suministros
     * Sugiere reabastecimiento inmediato

**Postcondiciones:**
- Completitud de suministro validada
- Artículos faltantes identificados específicamente
- Decisión de bloqueo o aprobación tomada
- Alertas generadas para reabastecimiento

**Reglas de Negocio:**
- **100% de artículos requeridos = APROBADO**
- **Falta 1 o más artículos = BLOQUEADO**
- **No hay excepciones (salvo autorización supervisor)**

---

### **CU-SIS-003: Validar Stock Mínimo**

**ID:** CU-SIS-003

**Actor Principal:** Sistema (Automatización)

**Precondiciones:**
- TbArticulo con StockMinimoUnidad configurado
- TbSuministroDetalle con inventario actualizado
- Umbrales de alerta configurados en TbConfiguracion

**Trigger:**
- Ejecución de ProcDespachoValidacion @Indice=14
- Verificación preventiva pre-despacho
- Monitoreo continuo de inventario

**Flujo Principal:**

1. **Cálculo de Stock Actual**
   ```sql
   SELECT 
       a.CodArticulo,
       a.NomArticulo,
       a.StockMinimoUnidad,
       SUM(sd.NumFin - sd.NumActual + 1) AS StockActual,
       (a.StockMinimoUnidad * 1.3) AS UmbralAlerta -- 30% sobre mínimo
   FROM TbSuministroDetalle sd
   INNER JOIN TbArticulo a ON sd.CodArticulo = a.CodArticulo
   WHERE sd.CodUnidad = @CodUnidad
     AND sd.Disponible = 1
   GROUP BY a.CodArticulo, a.NomArticulo, a.StockMinimoUnidad
   ```

2. **Clasificación por Nivel de Stock**
   ```sql
   CASE 
       WHEN StockActual >= (StockMinimoUnidad * 1.5) THEN 'NORMAL'
       WHEN StockActual >= (StockMinimoUnidad * 1.3) THEN 'ACEPTABLE'
       WHEN StockActual >= StockMinimoUnidad THEN 'BAJO'
       ELSE 'CRÍTICO'
   END AS NivelStock
   ```
   
   **Ejemplo:**
   - Stock mínimo: 50
   - Stock actual: 48
   - Umbral alerta (130%): 65
   - Clasificación: BAJO ⚠️

3. **Evaluación por Artículo**
   ```
   Serie A:
   - Stock actual: 48
   - Stock mínimo: 50
   - Nivel: BAJO ⚠️
   - Suficiente para despacho: SÍ
   - Requiere reabastecimiento: SÍ (pronto)
   
   Serie B:
   - Stock actual: 85
   - Stock mínimo: 30
   - Nivel: NORMAL ✅
   - Suficiente para despacho: SÍ
   - Requiere reabastecimiento: NO
   ```

4. **Decisión Automatizada**
   ```sql
   IF EXISTS(
       SELECT 1 FROM TbSuministroDetalle sd
       INNER JOIN TbArticulo a ON sd.CodArticulo = a.CodArticulo
       WHERE sd.CodUnidad = @CodUnidad
         AND SUM(sd.NumFin - sd.NumActual + 1) < a.StockMinimoUnidad
   )
   BEGIN
       SET @Resultado = 0 -- CRÍTICO: Bloquea despacho
       SET @Mensaje = 'Stock crítico detectado'
   END
   ELSE IF EXISTS(
       SELECT 1 FROM TbSuministroDetalle sd
       INNER JOIN TbArticulo a ON sd.CodArticulo = a.CodArticulo
       WHERE sd.CodUnidad = @CodUnidad
         AND SUM(sd.NumFin - sd.NumActual + 1) < (a.StockMinimoUnidad * 1.3)
   )
   BEGIN
       SET @Resultado = 1 -- BAJO: Aprueba con alerta
       SET @Mensaje = 'Stock bajo - Reabastecer pronto'
   END
   ELSE
   BEGIN
       SET @Resultado = 1 -- NORMAL
       SET @Mensaje = 'Stock suficiente'
   END
   ```

5. **Generación de Alertas Preventivas**
   - Si stock BAJO (pero >mínimo):
     * Alerta nivel MEDIA a coordinador suministros
     * "Serie A en BUS-245: Stock bajo (48/50) - Reabastecer pronto"
     * Programar reabastecimiento para próximo retorno
   
   - Si stock CRÍTICO (<mínimo):
     * Alerta nivel ALTA
     * Bloqueo de despacho
     * Reabastecimiento URGENTE requerido

**Postcondiciones:**
- Nivel de stock determinado por artículo
- Alertas preventivas generadas
- Reabastecimiento programado (si aplica)
- Decisión de despacho basada en stock

---

### **CU-SIS-004: Validar Producción Pendiente**

**ID:** CU-SIS-004

**Actor Principal:** Sistema

**Precondiciones:**
- TbSalida con registro de servicios
- Tb_SalidaUnidad con tracking de salidas
- TbRecaudo o TbLiquidacionValidador con liquidaciones

**Trigger:**
- Conductor intenta ingresar a cola nuevamente
- Pre-despacho de siguiente servicio
- Verificación de cierre de turno

**Flujo Principal:**

1. **Consulta de Viajes Sin Liquidar**
   ```sql
   SELECT 
       s.IdSalida,
       s.FechaHoraProgramada,
       s.FechaHoraInicio,
       s.CodRuta,
       r.NomRuta,
       DATEDIFF(HOUR, s.FechaHoraInicio, GETDATE()) AS HorasTranscurridas
   FROM Tb_SalidaUnidad s
   INNER JOIN TbRuta r ON s.CodRuta = r.CodRuta
   LEFT JOIN TbRecaudoV2 rec ON s.IdSalida = rec.IdSalida
   WHERE s.CodPersonaConductor = @CodPersona
     AND s.FechaHoraInicio >= CAST(GETDATE() AS DATE) -- Día actual
     AND s.F_Estado = 11 -- En curso
     AND rec.CodRecaudo IS NULL -- Sin liquidar
   ```

2. **Evaluación de Antigüedad**
   ```
   VIAJE PENDIENTE DETECTADO:
   IdSalida: 12345
   Ruta: 25
   Inicio: 06/12/2024 09:00 AM
   Horas transcurridas: 3 horas
   Estado: EN CURSO (no liquidado)
   ```

3. **Clasificación por Criticidad**
   ```sql
   CASE 
       WHEN DATEDIFF(HOUR, s.FechaHoraInicio, GETDATE()) > 12 THEN 'CRÍTICO'
       WHEN DATEDIFF(HOUR, s.FechaHoraInicio, GETDATE()) > 4 THEN 'URGENTE'
       WHEN DATEDIFF(HOUR, s.FechaHoraInicio, GETDATE()) > 2 THEN 'PENDIENTE'
       ELSE 'RECIENTE'
   END AS Criticidad
   ```

4. **Decisión Automatizada**
   ```sql
   IF EXISTS(
       SELECT 1 FROM Tb_SalidaUnidad s
       WHERE s.CodPersonaConductor = @CodPersona
         AND s.FechaHoraInicio < CAST(GETDATE() AS DATE) -- Día anterior
         AND NOT EXISTS(SELECT 1 FROM TbRecaudoV2 WHERE IdSalida = s.IdSalida)
   )
   BEGIN
       -- BLOQUEO: Producción de día anterior sin liquidar
       SET @Resultado = 0
       SET @Mensaje = 'BLOQUEADO: Tiene producción del día anterior sin liquidar'
   END
   ELSE IF EXISTS(
       SELECT 1 FROM Tb_SalidaUnidad s
       WHERE s.CodPersonaConductor = @CodPersona
         AND DATEDIFF(HOUR, s.FechaHoraInicio, GETDATE()) > 4
         AND NOT EXISTS(SELECT 1 FROM TbRecaudoV2 WHERE IdSalida = s.IdSalida)
   )
   BEGIN
       -- ALERTA: Producción antigua sin liquidar
       SET @Resultado = 2 -- Requiere autorización
       SET @Mensaje = 'ALERTA: Viaje iniciado hace >4 horas sin liquidar'
   END
   ELSE
   BEGIN
       -- NORMAL
       SET @Resultado = 1
       SET @Mensaje = 'No hay producción pendiente crítica'
   END
   ```

5. **Generación de Alertas**
   - Si producción día anterior pendiente:
     * Alerta CRÍTICA a supervisor
     * Notificación a cajero: "Conductor Juan Pérez tiene viajes sin liquidar"
     * Bloqueo automático hasta liquidación

**Postcondiciones:**
- Producción pendiente identificada
- Bloqueo aplicado si es crítico
- Liquidación requerida antes de nuevo servicio

---

### **CU-SIS-005: Validar Ubicación GPS**

**ID:** CU-SIS-005

**Actor Principal:** Sistema

**Precondiciones:**
- Tb_RegistroTrack con posiciones actualizadas
- Tb_GeoCerca con geocercas de terminales configuradas
- Dispositivo GPS activo en unidad

**Trigger:**
- Pre-despacho de unidad
- Verificación continua durante operación
- Validación de entrada/salida de geocercas

**Flujo Principal:**

1. **Obtención de Última Posición GPS**
   ```sql
   SELECT TOP 1
       LatitudRegistro,
       LongitudRegistro,
       FechaRegistro,
       DATEDIFF(SECOND, FechaRegistro, GETDATE()) AS SegundosDesdeUpdate
   FROM Tb_RegistroTrack
   WHERE IdDispositivo = @IdDispositivo
   ORDER BY FechaRegistro DESC
   ```

2. **Verificación de Geocerca Terminal**
   ```sql
   -- Función de distancia (Haversine)
   DECLARE @DistanciaTerminal DECIMAL(10,2)
   
   SET @DistanciaTerminal = dbo.FunDistancia(
       @LatitudUnidad,
       @LongitudUnidad,
       @LatitudTerminal,
       @LongitudTerminal
   )
   ```
   
   **Ejemplo:**
   - Coordenadas unidad: (-12.0464, -77.0428)
   - Coordenadas terminal: (-12.0470, -77.0430)
   - Distancia calculada: 85 metros

3. **Evaluación de Ubicación**
   ```sql
   IF @DistanciaTerminal <= @RadioGeocercaTerminal -- Ej: 200 metros
   BEGIN
       SET @DentroDeTerminal = 1
       SET @Mensaje = 'Unidad en terminal (distancia: ' + CAST(@DistanciaTerminal AS VARCHAR) + ' m)'
   END
   ELSE
   BEGIN
       SET @DentroDeTerminal = 0
       SET @Mensaje = 'Unidad FUERA de terminal (distancia: ' + CAST(@DistanciaTerminal AS VARCHAR) + ' m)'
   END
   ```

4. **Validación de Actualización GPS**
   ```sql
   IF @SegundosDesdeUpdate > 300 -- 5 minutos
   BEGIN
       SET @GPSActualizado = 0
       SET @Mensaje = 'ALERTA: GPS sin actualizar por ' + CAST(@SegundosDesdeUpdate AS VARCHAR) + ' segundos'
   END
   ELSE
   BEGIN
       SET @GPSActualizado = 1
   END
   ```

5. **Decisión Final**
   ```sql
   IF @DentroDeTerminal = 1 AND @GPSActualizado = 1
   BEGIN
       SET @Resultado = 1 -- APROBADO
   END
   ELSE IF @DentroDeTerminal = 0
   BEGIN
       SET @Resultado = 0 -- BLOQUEADO: Fuera de terminal
   END
   ELSE IF @GPSActualizado = 0
   BEGIN
       SET @Resultado = 2 -- ALERTA: GPS desactualizado
   END
   ```

**Postcondiciones:**
- Ubicación validada vs. geocerca
- Precisión GPS verificada
- Decisión de despacho basada en posición

---

### **CU-SIS-006: Validar Estado del Vehículo**

**ID:** CU-SIS-006

**Actor Principal:** Sistema

**Precondiciones:**
- TbUnidad con datos actualizados
- TbUnidadRestriccion con restricciones activas
- Tabla de mantenimientos actualizada

**Trigger:**
- Pre-despacho de unidad
- Consulta de disponibilidad operativa

**Flujo Principal:**

1. **Consulta de Estado Operativo**
   ```sql
   SELECT 
       CodEstadoUnidad, -- 1=Operativo, 2=Mantenimiento, 3=Inactivo
       FechaUltimaRevision,
       KilometrajeActual,
       ProximoMantenimiento
   FROM TbUnidad
   WHERE CodUnidad = @CodUnidad
   ```

2. **Verificación de Restricciones Activas**
   ```sql
   SELECT 
       r.TipoRestriccion,
       r.MotivoRestriccion,
       r.FechaInicio,
       r.FechaFin
   FROM TbUnidadRestriccion r
   WHERE r.CodUnidad = @CodUnidad
     AND r.FechaInicio <= GETDATE()
     AND (r.FechaFin >= GETDATE() OR r.FechaFin IS NULL)
     AND r.Activa = 1
   ```

3. **Evaluación de Mantenimiento Pendiente**
   ```sql
   IF @KilometrajeActual >= @ProximoMantenimiento - 500 -- 500 km de tolerancia
   BEGIN
       SET @MantenimientoPendiente = 1
       SET @MensajeAlerta = 'Mantenimiento próximo en ' + 
                           CAST(@ProximoMantenimiento - @KilometrajeActual AS VARCHAR) + ' km'
   END
   ```

4. **Decisión Consolidada**
   ```sql
   IF @CodEstadoUnidad <> 1 -- No operativo
   BEGIN
       SET @Resultado = 0
       SET @Mensaje = 'Unidad en estado NO OPERATIVO'
   END
   ELSE IF EXISTS(SELECT 1 FROM TbUnidadRestriccion WHERE CodUnidad = @CodUnidad AND Activa = 1)
   BEGIN
       SET @Resultado = 0
       SET @Mensaje = 'Unidad con restricción activa: ' + @MotivoRestriccion
   END
   ELSE IF @MantenimientoPendiente = 1 AND (@ProximoMantenimiento - @KilometrajeActual) < 100
   BEGIN
       SET @Resultado = 2 -- Alerta crítica
       SET @Mensaje = 'URGENTE: Mantenimiento en menos de 100 km'
   END
   ELSE
   BEGIN
       SET @Resultado = 1
       SET @Mensaje = 'Unidad en estado operativo OK'
   END
   ```

**Postcondiciones:**
- Estado técnico validado
- Restricciones identificadas
- Mantenimiento preventivo alertado

---

### **CU-SIS-007: Validar Horario de Operación**

**ID:** CU-SIS-007

**Actor Principal:** Sistema

**Precondiciones:**
- TbConfiguracion con horarios operativos
- TbProgramacionDia con esquema del día
- Fecha y hora actual del servidor

**Flujo Principal:**

1. **Consulta de Horario Autorizado**
   ```sql
   SELECT 
       HoraInicioOperacion,
       HoraFinOperacion,
       TipoDia -- Laboral, Sábado, Domingo, Feriado
   FROM TbConfiguracion
   WHERE Activa = 1
   ```

2. **Validación de Hora Actual**
   ```sql
   DECLARE @HoraActual TIME = CAST(GETDATE() AS TIME)
   
   IF @HoraActual >= @HoraInicioOperacion 
      AND @HoraActual <= @HoraFinOperacion
   BEGIN
       SET @DentroDeHorario = 1
   END
   ELSE
   BEGIN
       SET @DentroDeHorario = 0
       SET @Mensaje = 'Fuera de horario autorizado (' + 
                      CAST(@HoraInicioOperacion AS VARCHAR) + ' - ' +
                      CAST(@HoraFinOperacion AS VARCHAR) + ')'
   END
   ```

3. **Consideración de Excepciones**
   ```sql
   -- Verificar si hay servicio especial autorizado
   IF EXISTS(
       SELECT 1 FROM TbProgramacionDia
       WHERE Fecha = CAST(GETDATE() AS DATE)
         AND ServicioEspecial = 1
   )
   BEGIN
       SET @DentroDeHorario = 1
       SET @Mensaje = 'Servicio especial autorizado'
   END
   ```

**Postcondiciones:**
- Horario validado vs. configuración
- Excepciones consideradas
- Decisión de autorización tomada

---

### **CU-SIS-008: Generar Alertas Preventivas**

**ID:** CU-SIS-008

**Actor Principal:** Sistema (Proceso Automático)

**Precondiciones:**
- Job programado ejecutándose periódicamente
- Tablas de vencimientos actualizadas
- TbAlerta configurada

**Trigger:**
- Ejecución programada (diaria 06:00 AM)
- Detección de condición crítica en tiempo real
- Umbral de alerta alcanzado

**Flujo Principal:**

1. **Escaneo de Vencimientos Próximos**
   ```sql
   -- Documentos de conductores
   INSERT INTO TbAlerta (TipoAlerta, Criticidad, Mensaje, CodPersona, FechaGeneracion)
   SELECT 
       'VENCIMIENTO_DOCUMENTO',
       CASE 
           WHEN DATEDIFF(DAY, GETDATE(), FechaVencimiento) <= 7 THEN 'ALTA'
           WHEN DATEDIFF(DAY, GETDATE(), FechaVencimiento) <= 30 THEN 'MEDIA'
           ELSE 'BAJA'
       END,
       'Documento ' + vc.NomVencimientoConcepto + ' vence en ' + 
       CAST(DATEDIFF(DAY, GETDATE(), pv.FechaVencimiento) AS VARCHAR) + ' días',
       pv.CodPersona,
       GETDATE()
   FROM TbPersonaVencimiento pv
   INNER JOIN TbVencimientoConcepto vc ON pv.CodVencimientoConcepto = vc.CodVencimientoConcepto
   WHERE DATEDIFF(DAY, GETDATE(), pv.FechaVencimiento) BETWEEN 0 AND 30
   ```

2. **Detección de Stock Bajo**
   ```sql
   INSERT INTO TbAlerta (TipoAlerta, Criticidad, Mensaje, CodUnidad, FechaGeneracion)
   SELECT 
       'STOCK_BAJO',
       'MEDIA',
       'Stock bajo de ' + a.NomArticulo + ' en unidad ' + u.NomUnidad,
       sd.CodUnidad,
       GETDATE()
   FROM TbSuministroDetalle sd
   INNER JOIN TbArticulo a ON sd.CodArticulo = a.CodArticulo
   INNER JOIN TbUnidad u ON sd.CodUnidad = u.CodUnidad
   WHERE SUM(sd.NumFin - sd.NumActual + 1) < (a.StockMinimoUnidad * 1.3)
   ```

3. **Monitoreo de Mantenimientos Pendientes**
   ```sql
   INSERT INTO TbAlerta (TipoAlerta, Criticidad, Mensaje, CodUnidad, FechaGeneracion)
   SELECT 
       'MANTENIMIENTO_PENDIENTE',
       'ALTA',
       'Unidad ' + u.NomUnidad + ' requiere mantenimiento en ' +
       CAST(u.ProximoMantenimiento - u.KilometrajeActual AS VARCHAR) + ' km',
       u.CodUnidad,
       GETDATE()
   FROM TbUnidad u
   WHERE u.KilometrajeActual >= (u.ProximoMantenimiento - 500)
   ```

4. **Distribución de Alertas**
   - Notificación push a usuarios responsables
   - Email automático a jefaturas
   - SMS para alertas críticas
   - Dashboard de alertas actualizado

**Postcondiciones:**
- Alertas generadas proactivamente
- Responsables notificados
- Prevención de bloqueos operativos
- Gestión preventiva habilitada

---

## INSPECTOR

### **CU-INS-001: Verificar Cumplimiento de Ruta**

**ID:** CU-INS-001

**Actor Principal:** Inspector

**Precondiciones:**
- Inspector autenticado con app móvil/tablet
- Zona de inspección asignada
- Rutas a supervisar definidas
- Puntos de control conocidos
- Acceso GPS en dispositivo móvil

**Trigger:**
- Inicio de turno de inspección
- Asignación a ruta específica por supervisor
- Denuncia ciudadana de desviación
- Verificación rutinaria programada

**Flujo Principal:**

1. **Asignación de Zona/Ruta**
   - Jefe Operaciones o Supervisor asigna al inspector:
     * Ruta 25: Verificar cumplimiento
     * Puntos críticos: Paraderos 5, 10, 15
     * Horario: 08:00 - 12:00 (hora pico)
   - Inspector recibe notificación en app móvil

2. **Desplazamiento al Punto de Control**
   - Inspector se ubica estratégicamente:
     * Paradero 10 (punto medio de ruta)
     * Ubicación visible pero discreta
     * Con visibilidad clara de vía
   - Registra llegada en app: 08:15 AM

3. **Observación de Unidades Pasantes**
   ```
   REGISTRO MANUAL EN APP:
   
   08:20 - BUS-245 pasa por paradero 10 ✅
   - Ruta correcta: SÍ
   - Velocidad apropiada: SÍ
   - Detuvo en paradero: SÍ
   - Observaciones: Ninguna
   
   08:35 - BUS-189 pasa por paradero 10 ⚠️
   - Ruta correcta: SÍ
   - Velocidad apropiada: NO (exceso leve)
   - Detuvo en paradero: SÍ
   - Observaciones: Velocidad ~55 km/h en zona 50
   
   08:50 - BUS-301 NO pasa ❌
   - Esperado según frecuencia: 08:47
   - Retraso: 3 minutos
   - Observaciones: Posible congestión
   ```

4. **Verificación de Recorrido Autorizado**
   - Inspector compara ruta real vs. autorizada
   - Identifica desviaciones:
     * Unidad tomó calle paralela (no autorizada)
     * Inspector toma foto/video como evidencia
     * Registra coordenadas GPS del desvío

5. **Contacto con Central**
   - Si detecta irregularidad mayor:
     * Llama a Monitoreador GPS
     * "Unidad BUS-345 fuera de ruta en Av. Secundaria"
     * Confirma si es desvío autorizado
     * Si no autorizado: solicita acción correctiva

6. **Abordaje de Unidad (si es necesario)**
   - Inspector puede abordar unidad:
     * Muestra credencial de inspector
     * Solicita documentos al conductor
     * Verifica condiciones de servicio
     * Toma registro fotográfico
     * No puede sancionar directamente (solo reporta)

7. **Registro en Sistema**
   - Inspector documenta en app móvil:
     ```
     VERIFICACIÓN DE RUTA - Ruta 25
     Inspector: Carlos Méndez
     Punto: Paradero 10
     Hora: 08:15 - 10:30
     
     Unidades observadas: 15
     Cumplimiento ruta: 14/15 (93%)
     Desviaciones detectadas: 1 (BUS-345)
     Observaciones: Buen cumplimiento general
     
     INCIDENCIAS:
     - BUS-345: Desvío no autorizado Av. Secundaria
     - BUS-189: Exceso velocidad leve
     ```

8. **Transmisión a Sistema Central**
   - App sincroniza datos:
     * Registros insertados en TbInspectoria
     * Fotos/videos adjuntados
     * Coordenadas GPS vinculadas
     * Timestamp de cada observación

**Postcondiciones:**
- Cumplimiento de ruta verificado presencialmente
- Desviaciones documentadas con evidencia
- Incidencias reportadas a central
- Base de datos actualizada con inspección
- Seguimiento establecido para unidades irregulares

**Flujos Alternativos:**

**FA1: Unidad en Desvío por Emergencia**
- Inspector detecta unidad fuera de ruta
- Contacta central: confirma emergencia médica autorizada
- Documenta como "Desvío Justificado"
- No genera reporte de incumplimiento

**FA2: Múltiples Unidades Desviadas (Bloqueo de Vía)**
- Inspector detecta patrón: todas las unidades desviadas
- Identifica causa: bloqueo por accidente
- Reporta a central: actualización general
- Documenta contexto para análisis

---

### **CU-INS-002: Controlar Frecuencias en Campo**

**ID:** CU-INS-002

**Actor Principal:** Inspector

**Precondiciones:**
- Frecuencia autorizada conocida (ej: 10 minutos)
- Punto de control definido
- Cronómetro/app con timer
- Tablet/smartphone operativo

**Trigger:**
- Solicitud de verificación de cumplimiento ATU
- Quejas ciudadanas por baja frecuencia
- Auditoría de frecuencias programada

**Flujo Principal:**

1. **Ubicación en Punto de Medición**
   - Inspector se posiciona en punto crítico:
     * Paradero oficial más transitado
     * Ubicación con visibilidad clara
     * Zona segura para permanecer 1-2 horas

2. **Inicio de Medición**
   - Inspector activa cronómetro en app
   - Registra primera unidad que pasa:
     ```
     CONTROL DE FRECUENCIAS - Ruta 25
     Punto: Paradero Central
     Fecha: 06/12/2024
     Hora inicio: 09:00 AM
     Frecuencia autorizada: 10 minutos
     
     REGISTRO:
     09:00 - BUS-245 (primera unidad - inicia conteo)
     ```

3. **Registro Secuencial de Paso**
   ```
   09:00:00 - BUS-245 | Intervalo: -- (inicial)
   09:08:30 - BUS-189 | Intervalo: 8min 30seg ✅
   09:18:15 - BUS-301 | Intervalo: 9min 45seg ✅
   09:30:00 - BUS-145 | Intervalo: 11min 45seg ⚠️
   09:38:20 - BUS-278 | Intervalo: 8min 20seg ✅
   09:50:45 - BUS-192 | Intervalo: 12min 25seg ❌
   10:02:10 - BUS-456 | Intervalo: 11min 25seg ⚠️
   ```

4. **Cálculo Automático de Cumplimiento**
   - App calcula métricas en tiempo real:
     ```
     ANÁLISIS FRECUENCIAS (1 hora de medición)
     Unidades observadas: 7
     Intervalo promedio: 10min 18seg
     Frecuencia objetivo: 10 minutos
     
     DISTRIBUCIÓN:
     Dentro de rango (8-12 min): 5 unidades (71%)
     Fuera de rango: 2 unidades (29%)
     
     CUMPLIMIENTO: 71% ⚠️
     Estado: BAJO OBJETIVO (meta 85%)
     ```

5. **Identificación de Patrones**
   - Inspector analiza:
     * ¿Hay horas con peor frecuencia?
     * ¿Unidades específicas siempre retrasadas?
     * ¿Tendencia de mejora o empeoramiento?
   - Ejemplo:
     ```
     PATRÓN DETECTADO:
     09:45 - 10:15: Frecuencias deterioradas (>11 min)
     Causa probable: Congestión vehicular hora pico
     Recomendación: Incrementar unidades en esta franja
     ```

6. **Reporte a Central**
   - Inspector transmite hallazgos:
     * Vía radio: "Central, frecuencias en Paradero Central bajo objetivo"
     * Envío de datos por app: automático
     * Llamada telefónica si es crítico (frecuencias >15 min)

7. **Coordinación de Ajustes**
   - Si frecuencias críticas:
     * Central puede despachar unidades adicionales
     * Inspector verifica mejora en siguientes 30 minutos
     * Confirma normalización

8. **Documentación en Sistema**
   - Datos insertados en:
     * TbInspectoriaFrecuencia
     * TbSalidaInspectoria
   - Genera reporte oficial:
     ```
     REPORTE DE FRECUENCIAS
     Inspector: Carlos Méndez
     Ruta: 25
     Punto: Paradero Central
     Período: 09:00-10:00
     
     Cumplimiento: 71%
     Estado: BAJO ESTÁNDAR
     Acción requerida: Incrementar unidades hora pico
     ```

**Postcondiciones:**
- Frecuencias medidas objetivamente
- Cumplimiento vs. ATU verificado
- Patrones identificados
- Reporte oficial generado
- Acciones correctivas sugeridas

---

### **CU-INS-003: Verificar Estado de Unidades**

**ID:** CU-INS-003

**Actor Principal:** Inspector

**Precondiciones:**
- Checklist de verificación configurado
- Inspector con credencial vigente
- Autoridad para abordar unidades

**Trigger:**
- Inspección rutinaria programada
- Denuncia de mal estado de unidad
- Verificación post-mantenimiento
- Auditoría de seguridad

**Flujo Principal:**

1. **Abordaje de Unidad**
   - Inspector detiene unidad en paradero:
     * Muestra credencial oficial
     * Solicita permiso al conductor
     * Explica motivo de inspección

2. **Verificación Visual Exterior**
   ```
   CHECKLIST EXTERIOR:
   ✅ Luces funcionando (delanteras, traseras, freno)
   ✅ Llantas en buen estado (profundidad banda)
   ✅ Espejos laterales completos y funcionales
   ⚠️ Parabrisas con fisura leve (esquina superior)
   ✅ Carrocería sin daños mayores
   ✅ Número de ruta visible
   ✅ Placa legible
   ```

3. **Verificación Interior**
   ```
   CHECKLIST INTERIOR:
   ✅ Asientos en buen estado
   ⚠️ 2 asientos con tapiz roto (fondo del bus)
   ✅ Pasamanos seguros
   ✅ Ventanas operativas
   ❌ Extintor VENCIDO (última recarga: 2023)
   ✅ Botiquín completo
   ✅ Salidas de emergencia señalizadas
   ⚠️ Limpieza interior regular (3/5)
   ```

4. **Verificación de Documentos**
   ```
   DOCUMENTOS UNIDAD:
   ✅ SOAT vigente hasta Jun-2025
   ✅ Revisión técnica vigente
   ✅ Tarjeta de propiedad
   ❌ Certificado GNV VENCIDO
   ✅ Póliza de seguro
   
   DOCUMENTOS CONDUCTOR:
   ✅ Licencia vigente
   ✅ CAC vigente
   ⚠️ Examen psicosomático vence en 15 días
   ```

5. **Verificación de Equipamiento**
   ```
   EQUIPAMIENTO OBLIGATORIO:
   ✅ Botiquín completo (12 ítems)
   ❌ Extintor vencido (CRÍTICO)
   ✅ Triángulos de seguridad (2)
   ✅ Chaleco reflectivo
   ⚠️ Herramientas básicas (incompleto: falta gata)
   ```

6. **Registro Fotográfico**
   - Inspector toma fotos de:
     * Hallazgos negativos (extintor vencido)
     * Placa de la unidad
     * Documentos vencidos
     * Condiciones irregulares

7. **Calificación Global**
   ```
   RESULTADO INSPECCIÓN - BUS-245
   
   CALIFICACIÓN:
   Seguridad: 60% (REPROBADO) ❌
   - Extintor vencido (crítico)
   - Certificado GNV vencido (crítico)
   
   Comodidad: 75% (ACEPTABLE) ⚠️
   - Asientos con desgaste
   - Limpieza regular
   
   Documentación: 85% (APROBADO) ✅
   
   DECISIÓN: RESTRICCIÓN TEMPORAL
   Puede operar HOY (viaje iniciado)
   Debe regularizar en 48 horas
   ```

8. **Notificación al Conductor**
   - Inspector entrega acta de inspección:
     * Hallazgos documentados
     * Plazo de regularización: 48 horas
     * Consecuencias de incumplimiento
     * Firma del conductor

9. **Reporte a Central**
   - Vía radio/telefónica:
     * "BUS-245 con extintor vencido - Restricción 48h"
     * Central actualiza TbUnidadRestriccion
   - Vía app:
     * Carga fotos
     * Registra en TbInspectoria
     * Genera ticket de seguimiento

**Postcondiciones:**
- Estado de unidad verificado presencialmente
- Hallazgos documentados con evidencia
- Restricciones aplicadas si necesario
- Plazo de regularización establecido
- Seguimiento programado

---

### **CU-INS-004: Atender Incidencias en Ruta**

**ID:** CU-INS-004

**Actor Principal:** Inspector

**Precondiciones:**
- Inspector en zona de cobertura
- Radio/celular operativo
- Autoridad para tomar decisiones de campo

**Trigger:**
- Llamado de Monitoreador GPS: "Unidad BUS-345 reporta avería"
- Conductor solicita apoyo directo
- Pasajero reporta incidente
- Inspector detecta situación irregular

**Flujo Principal:**

1. **Recepción de Alerta**
   - Monitoreador GPS contacta:
     * "Inspector Carlos, BUS-345 detenido en Av. Principal altura paradero 8"
     * "Reporta falla mecánica, requiere verificación"
   - Inspector confirma: "Recibido, me dirijo al lugar"

2. **Desplazamiento al Lugar**
   - Inspector verifica ubicación GPS
   - Calcula tiempo de llegada: 8 minutos
   - Informa ETA a central

3. **Evaluación in Situ**
   - Inspector llega al lugar
   - Observa situación:
     ```
     EVALUACIÓN INICIAL:
     - Unidad detenida en paradero ✅
     - Motor apagado
     - Pasajeros a bordo: ~15 personas
     - Conductor indica: "Motor sobrecalienta"
     - Observación: Vapor saliendo del motor
     ```

4. **Toma de Decisiones Inmediatas**
   ```
   DECISIÓN DEL INSPECTOR:
   
   1. SEGURIDAD (Prioridad 1):
      - Evacuar pasajeros inmediatamente
      - Alejar unidad del tráfico (si es posible)
      - Colocar triángulos de seguridad
   
   2. ASISTENCIA:
      - Contactar mecánico de emergencia
      - Coordinar grúa si es necesario
      - Gestionar transporte alternativo para pasajeros
   
   3. COORDINACIÓN:
      - Informar a central: unidad fuera de servicio
      - Solicitar unidad de reemplazo
      - Estimar tiempo fuera de operación: 2-3 horas
   ```

5. **Ejecución de Protocolo**
   - **Evacuación de pasajeros:**
     * Inspector asiste a pasajeros a descender
     * Informa sobre unidad de reemplazo: "En 10 minutos"
     * Ofrece opciones: esperar o tomar otra ruta
   
   - **Coordinación técnica:**
     * Llama a taller: "Necesito mecánico en Av. Principal paradero 8"
     * Conductor intenta diagnóstico básico
     * Inspector documenta síntomas

6. **Gestión de Contingencia**
   - Central despacha unidad de reemplazo
   - Inspector espera llegada
   - Coordina transbordo si es necesario
   - Verifica que no queden pasajeros varados

7. **Documentación del Incidente**
   ```
   REPORTE DE INCIDENCIA
   Unidad: BUS-245
   Conductor: Juan Pérez
   Ubicación: Av. Principal paradero 8
   Hora: 10:35 AM
   
   DESCRIPCIÓN:
   Motor sobrecalentado, vapor visible
   
   ACCIONES TOMADAS:
   - Evacuación 15 pasajeros (10:40)
   - Mecánico solicitado (10:42)
   - Unidad reemplazo despachada (10:45)
   - Pasajeros transferidos (11:00)
   
   ESTADO: RESUELTO
   Tiempo fuera servicio: 3 horas (estimado)
   ```

8. **Seguimiento Hasta Resolución**
   - Inspector permanece hasta:
     * Mecánico arriba y diagnostica
     * Unidad retirada o reparada
     * Todos los pasajeros atendidos
   - Cierra incidente en app

**Postcondiciones:**
- Incidente atendido presencialmente
- Seguridad de pasajeros garantizada
- Servicio restablecido o contingencia activada
- Incidente documentado completamente
- Lecciones aprendidas identificadas

---

### **CU-INS-005: Generar Reportes de Campo**

**ID:** CU-INS-005

**Actor Principal:** Inspector

**Precondiciones:**
- Turno de inspección finalizado o en curso
- Datos recopilados en app móvil
- Acceso a sistema de reportes

**Trigger:**
- Fin de turno del inspector
- Solicitud de Jefe Operaciones
- Reporte periódico programado (diario/semanal)

**Flujo Principal:**

1. **Consolidación de Actividades**
   - Inspector revisa jornada:
     ```
     TURNO: 08:00 - 16:00 (8 horas)
     
     ACTIVIDADES REALIZADAS:
     - Verificaciones de ruta: 3 puntos
     - Control de frecuencias: 2 horas
     - Inspecciones de unidades: 5 vehículos
     - Atención de incidencias: 2 casos
     - Kilómetros recorridos: 45 km
     ```

2. **Generación Automática desde App**
   - App consolida datos registrados:
     * Unidades verificadas
     * Cumplimientos/incumplimientos
     * Fotos adjuntas
     * Coordenadas GPS de actividades
     * Timestamps de cada evento

3. **Complemento Manual**
   - Inspector agrega:
     ```
     OBSERVACIONES GENERALES:
     
     - Buen cumplimiento de Ruta 25 (93%)
     - Ruta 30 con frecuencias irregulares (necesita atención)
     - 2 unidades con documentos próximos a vencer
     - 1 unidad requiere mantenimiento urgente (extintor)
     
     RECOMENDACIONES:
     - Incrementar inspecciones Ruta 30
     - Coordinar renovación de extintores
     - Verificar autorización desvíos Av. Secundaria
     ```

4. **Adjuntos y Evidencias**
   - Sistema compila automáticamente:
     * 15 fotografías
     * 3 videos cortos
     * 8 registros GPS
     * 2 actas de inspección

5. **Generación de Reporte Final**
   ```
   REPORTE DE INSPECCIÓN DIARIA
   Inspector: Carlos Méndez
   Fecha: 06/12/2024
   Turno: 08:00-16:00
   Zona: Centro-Norte
   
   RESUMEN EJECUTIVO:
   Unidades inspeccionadas: 5
   Cumplimiento rutas: 93%
   Cumplimiento frecuencias: 71%
   Incidentes atendidos: 2
   Restricciones aplicadas: 1
   
   HALLAZGOS CRÍTICOS:
   - BUS-245: Extintor vencido (restricción 48h)
   - BUS-345: Avería mecánica (fuera servicio)
   
   ESTADÍSTICAS:
   Estado unidades: 80% Bueno, 20% Regular
   Documentación: 85% vigente
   Equipamiento: 75% completo
   
   [ANEXOS: 15 fotos, 3 videos, 2 actas]
   ```

6. **Distribución del Reporte**
   - Envío automático a:
     * Jefe Operaciones (email + app)
     * Supervisor Terminal (notificación)
     * Jefe Mantenimiento (hallazgos técnicos)
     * Base de datos central (archivo)

7. **Registro en Sistema**
   - Datos almacenados en:
     * TbInspectoria (registro principal)
     * TbSalidaInspectoria (verificaciones)
     * TbInspectoriaReportes (reporte consolidado)

**Postcondiciones:**
- Reporte completo generado
- Hallazgos documentados con evidencia
- Distribución a stakeholders completada
- Base de datos actualizada
- Histórico de inspecciones consolidado

---
