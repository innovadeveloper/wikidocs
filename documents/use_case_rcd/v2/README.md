## CASOS DE USO - CAJERO PRINCIPAL (Recaudador/Liquidador)



### **CU-CAJ-001: Abrir Caja de Recaudo**

**ID:** CU-CAJ-001

**Actor:** Cajero Principal

**Precondiciones:**
- Cajero autenticado en el sistema
- Turno asignado
- Fondo inicial disponible

**Trigger:** 
Inicio del turno operativo del cajero

**Flujo Principal:**
1. Cajero ingresa al sistema y selecciona "Abrir Caja"
2. Registra monto inicial del fondo (efectivo base)
3. Sistema genera número único de caja y registra hora de apertura
4. Cajero recibe del coordinador de suministros los tapers/bolsas con talonarios organizados por unidad
5. Verifica contenido de tapers recibidos
6. Sistema marca caja como ABIERTA y lista para recibir entregas

**Postcondiciones:**
- Caja abierta y operativa
- Talonarios disponibles para entrega a conductores
- Sistema listo para registrar transacciones del día



### **CU-CAJ-002: Recibir Entregas Parciales de Conductores**

**ID:** CU-CAJ-002

**Actor:** Cajero Principal

**Precondiciones:**
- Caja abierta
- Conductor ha completado al menos una vuelta
- Conductor se presenta en ventanilla

**Trigger:** 
Conductor entrega efectivo después de completar una vuelta

**Flujo Principal:**
1. Conductor se identifica y menciona su unidad
2. Cajero verifica identidad en sistema
3. Conductor entrega efectivo recaudado de la vuelta
4. Si hay ticketera: cajero consulta reporte digital de producción
5. Si hay boletos físicos: cajero recibe también el talonario para verificación
6. Cajero cuenta el efectivo recibido
7. Emite comprobante temporal de recepción al conductor
8. Guarda efectivo en caja separado por conductor/unidad

**Postcondiciones:**
- Efectivo recibido y guardado
- Comprobante de recepción emitido
- Entrega parcial registrada temporalmente
- Conductor puede continuar operando



### **CU-CAJ-003: Contar y Verificar Efectivo Parcial**

**ID:** CU-CAJ-003

**Actor:** Cajero Principal

**Precondiciones:**
- Efectivo recibido del conductor
- Comprobante temporal emitido

**Trigger:** 
Recepción de efectivo en entrega parcial

**Flujo Principal:**
1. Cajero cuenta billete por billete y moneda por moneda
2. Separa y verifica visualmente autenticidad de billetes
3. Suma total del efectivo contado
4. Compara con monto declarado por el conductor
5. Si coincide: acepta y confirma
6. Si difiere: solicita explicación al conductor y documenta diferencia
7. Registra monto final verificado

**Postcondiciones:**
- Efectivo contado y verificado
- Diferencias documentadas (si existen)
- Monto registrado para consolidación



### **CU-CAJ-004: Comparar Producción con Ticketera**

**ID:** CU-CAJ-004

**Actor:** Cajero Principal

**Precondiciones:**
- Conductor operó con ticketera
- Reporte digital disponible en sistema
- Efectivo parcial recibido

**Trigger:** 
Verificación de entrega parcial con ticketera

**Flujo Principal:**
1. Cajero consulta reporte automático de ticketera en sistema
2. Identifica cantidad de boletos vendidos y monto total
3. Calcula producción esperada: boletos × tarifa
4. Compara producción digital vs efectivo entregado
5. Sistema calcula diferencia automáticamente
6. Si diferencia está dentro de tolerancia: acepta
7. Si diferencia es significativa: marca alerta para justificación
8. Registra resultado de comparación

**Postcondiciones:**
- Producción digital comparada con efectivo físico
- Diferencias identificadas y marcadas
- Alerta generada si supera tolerancia



### **CU-CAJ-005: Contabilizar Boletos Físicos Vendidos**

**ID:** CU-CAJ-005

**Actor:** Cajero Principal

**Precondiciones:**
- Conductor operó con boletos físicos
- Talonario recibido con boletos restantes
- Registro de asignación de talonario disponible

**Trigger:** 
Verificación de entrega parcial con boletos físicos

**Flujo Principal:**
1. Cajero recibe talonario con boletos restantes
2. Verifica serie del talonario entregado originalmente
3. Consulta en sistema: NumInicio y NumFin del talonario asignado
4. Cuenta boletos físicos restantes en el talonario
5. Calcula boletos vendidos: (NumFin - NumInicio + 1) - Boletos restantes
6. Calcula producción esperada: Boletos vendidos × Tarifa
7. Compara producción calculada vs efectivo entregado
8. Identifica y documenta diferencias

**Postcondiciones:**
- Boletos vendidos calculados físicamente
- Producción esperada determinada
- Diferencias identificadas
- Talonario parcialmente usado registrado



### **CU-CAJ-006: Registrar Entregas en el Sistema**

**ID:** CU-CAJ-006

**Actor:** Cajero Principal

**Precondiciones:**
- Efectivo contado y verificado
- Producción comparada (ticketera o física)
- Diferencias documentadas

**Trigger:** 
Finalización de verificación de entrega parcial

**Flujo Principal:**
1. Cajero ingresa al sistema módulo de registro de entregas
2. Selecciona conductor y unidad
3. Registra datos de la entrega:
   - Hora de entrega
   - Número de vuelta
   - Monto efectivo recibido
   - Método (ticketera/físico)
   - Producción calculada
   - Diferencia (si existe)
4. Sistema genera registro único con timestamp
5. Vincula entrega a la caja abierta del conductor
6. Actualiza acumulado del día del conductor
7. Sistema confirma registro exitoso

**Postcondiciones:**
- Entrega parcial registrada digitalmente
- Trazabilidad completa del registro
- Acumulado del conductor actualizado
- Registro disponible para liquidación final



### **CU-CAJ-007: Detectar Billetes Falsos**

**ID:** CU-CAJ-007

**Actor:** Cajero Principal

**Precondiciones:**
- Efectivo recibido del conductor
- Herramientas de detección disponibles (detector UV, lápiz)

**Trigger:** 
Conteo de efectivo durante entrega

**Flujo Principal:**
1. Durante conteo, cajero examina cada billete:
   - Revisión visual de marcas de agua
   - Verificación del tacto del papel
   - Uso de detector UV (si disponible)
   - Aplicación de lápiz detector
2. Si detecta billete sospechoso:
   - Separa inmediatamente el billete
   - Verifica nuevamente con todas las herramientas
   - Informa al conductor del hallazgo
3. Cajero registra en acta de observaciones
4. Descuenta el billete falso del monto a recibir
5. En casos críticos, notifica a supervisor
6. Retiene billete falso según protocolo de seguridad

**Postcondiciones:**
- Billetes falsos identificados y separados
- Monto ajustado sin incluir billetes falsos
- Incidente documentado
- Conductor informado del descuento



### **CU-CAJ-008: Manejar Diferencias en Entregas**

**ID:** CU-CAJ-008

**Actor:** Cajero Principal

**Precondiciones:**
- Diferencia detectada entre efectivo y producción esperada
- Entrega parcial en proceso de verificación

**Trigger:** 
Sistema detecta diferencia fuera de tolerancia

**Flujo Principal:**
1. Sistema alerta sobre diferencia detectada
2. Cajero identifica tipo de diferencia:
   - **Faltante**: Efectivo < Producción esperada
   - **Sobrante**: Efectivo > Producción esperada
3. Cajero pregunta al conductor causa de la diferencia
4. Para faltantes:
   - Solicita justificación escrita
   - Verifica posibles vueltos mal dados
   - Confirma si hubo evasión de pasajeros
   - Registra faltante en sistema
5. Para sobrantes:
   - Verifica posibles errores de conteo de boletos
   - Confirma origen del excedente
   - Registra sobrante
6. Documenta explicación del conductor
7. Marca para revisión en liquidación final

**Postcondiciones:**
- Diferencia documentada y justificada
- Explicación registrada
- Caso marcado para seguimiento
- Alerta generada para liquidación



### **CU-CAJ-009: Liquidar al Conductor (Final de Turno)**

**ID:** CU-CAJ-009

**Actor:** Cajero Principal (actúa como Liquidador)

**Precondiciones:**
- Conductor finalizó su turno
- Todas las entregas parciales registradas
- Caja del conductor cerrada
- Producción total consolidada

**Trigger:** 
Conductor se presenta para liquidación final de turno

**Flujo Principal:**
1. Cajero/Liquidador consulta todas las entregas del conductor del día
2. Sistema suma producción total acumulada
3. Consulta descuentos pendientes:
   - Anticipos otorgados
   - Combustible
   - Multas
   - Gastos administrativos
4. Ejecuta proceso de liquidación en sistema
5. Sistema calcula según acuerdo laboral:
   - Porcentaje del conductor (ej: 30%)
   - Porcentaje del propietario (ej: 70%)
6. Aplica descuentos al neto del conductor
7. Calcula monto final a entregar
8. Muestra desglose completo en pantalla
9. Verifica cálculo con conductor
10. Prepara documentación de liquidación

**Postcondiciones:**
- Liquidación calculada
- Desglose detallado disponible
- Monto a pagar determinado
- Sistema listo para emitir comprobante



### **CU-CAJ-010: Cerrar Caja del Conductor**

**ID:** CU-CAJ-010

**Actor:** Cajero Principal

**Precondiciones:**
- Todas las vueltas del conductor registradas
- Última entrega parcial verificada
- Conductor terminó operación del día

**Trigger:** 
Conductor entrega última producción del turno

**Flujo Principal:**
1. Cajero accede a la caja abierta del conductor en sistema
2. Verifica que todas las vueltas estén registradas
3. Sistema suma automáticamente producción total del día
4. Cajero confirma cierre de caja
5. Sistema marca caja como CERRADA con timestamp
6. Genera reporte consolidado de producción del día
7. Vincula caja cerrada al proceso de liquidación
8. Sistema actualiza estado de caja a LIQUIDADA

**Postcondiciones:**
- Caja del conductor cerrada
- Producción total consolidada
- Reporte del día generado
- Estado actualizado para liquidación



### **CU-CAJ-011: Calcular Liquidación Final**

**ID:** CU-CAJ-011

**Actor:** Cajero Principal (Liquidador)

**Precondiciones:**
- Caja del conductor cerrada
- Producción total conocida
- Gastos administrativos registrados
- Acuerdo laboral configurado en sistema

**Trigger:** 
Proceso de liquidación iniciado

**Flujo Principal:**
1. Sistema consulta producción total del día del conductor
2. Consulta gastos administrativos registrados:
   - Combustible consumido
   - Peajes pagados
   - Mantenimiento preventivo
   - Multas pendientes
3. Resta gastos de producción bruta
4. Aplica porcentaje según acuerdo laboral configurado
5. Sistema calcula automáticamente:
   ```
   Producción Total: $XXX
   (-) Gastos administrativos: $YY
   (=) Producción neta: $ZZZ
   Conductor (30%): $AAA
   Propietario (70%): $BBB
   ```
6. Descuenta anticipos o préstamos pendientes del conductor
7. Calcula neto final a entregar
8. Muestra desglose completo en pantalla

**Postcondiciones:**
- Liquidación final calculada
- Desglose detallado disponible
- Montos por actor determinados
- Cálculo listo para pago



### **CU-CAJ-012: Emitir Comprobante de Liquidación**

**ID:** CU-CAJ-012

**Actor:** Cajero Principal (Liquidador)

**Precondiciones:**
- Liquidación final calculada
- Desglose verificado con conductor
- Monto a pagar confirmado

**Trigger:** 
Confirmación de liquidación para emisión de comprobante

**Flujo Principal:**
1. Sistema genera documento oficial con:
   - Datos del conductor (nombre, DNI)
   - Datos de la unidad
   - Fecha y turno trabajado
   - Detalle de producción (efectivo + tarjeta si aplica)
   - Descuentos aplicados (desglosados)
   - Porcentaje del conductor
   - Neto a pagar
2. Cajero/Liquidador imprime comprobante en duplicado
3. Conductor revisa y verifica datos
4. Conductor firma comprobante como recibido
5. Cajero entrega:
   - Efectivo calculado
   - Original del comprobante
6. Cajero archiva copia firmada
7. Sistema registra emisión del comprobante

**Postcondiciones:**
- Comprobante oficial emitido
- Conductor con documento respaldatorio
- Copia archivada para auditoría
- Pago documentado en sistema



### **CU-CAJ-013: Cuadrar Caja Propia Diaria**

**ID:** CU-CAJ-013

**Actor:** Cajero Principal

**Precondiciones:**
- Finalización del turno del cajero
- Todas las liquidaciones del día completadas
- Efectivo total en caja física

**Trigger:** 
Cierre del turno operativo del cajero

**Flujo Principal:**
1. Cajero suma todo el efectivo recibido de conductores durante el día
2. Resta pagos de liquidación entregados a conductores
3. Sistema suma digitalmente todos los registros de entregas
4. Sistema resta todas las liquidaciones pagadas
5. Cajero cuenta físicamente billetes y monedas totales en caja
6. Compara:
   - Total físico vs Total registrado en sistema
7. Si cuadra: procede a cierre
8. Si difiere:
   - Revisa transacción por transacción
   - Identifica origen de discrepancia
   - Documenta diferencia encontrada
9. Registra cierre de caja propia con resultado
10. Justifica diferencias (si existen)

**Postcondiciones:**
- Caja propia del cajero cerrada
- Diferencias identificadas y justificadas
- Efectivo total cuadrado
- Cierre registrado en sistema



### **CU-CAJ-014: Depositar en Banco**

**ID:** CU-CAJ-014

**Actor:** Cajero Principal

**Precondiciones:**
- Caja propia cerrada y cuadrada
- Efectivo consolidado del día
- Bolsa de seguridad disponible
- Formato de depósito preparado

**Trigger:** 
Finalización de cierre de caja diaria

**Flujo Principal:**
1. Cajero prepara efectivo consolidado separado por denominación
2. Introduce efectivo en bolsa de seguridad y sella
3. Completa formato de depósito bancario:
   - Monto total
   - Desglose por denominación
   - Número de bolsa
4. Coordina traslado con personal de seguridad (si aplica)
5. Traslada a entidad bancaria
6. Realiza depósito en cuenta empresarial
7. Recibe comprobante/voucher bancario
8. Registra depósito en sistema:
   - Monto depositado
   - Número de voucher
   - Fecha y hora
9. Vincula depósito con cierre de caja del día
10. Archiva voucher bancario como respaldo

**Postcondiciones:**
- Efectivo depositado en banco
- Comprobante bancario archivado
- Depósito registrado en sistema
- Trazabilidad completa del efectivo



### **CU-CAJ-015: Administrar Caja Chica**

**ID:** CU-CAJ-015

**Actor:** Cajero Principal

**Precondiciones:**
- Fondo fijo de caja chica asignado
- Caja chica operativa
- Límites de gasto configurados

**Trigger:** 
Solicitud de gasto menor o necesidad de reposición

**Flujo Principal:**
1. Se presenta solicitud de gasto menor operativo
2. Cajero verifica que gasto califique para caja chica
3. Entrega efectivo solicitado
4. Registra salida inmediatamente:
   - Monto entregado
   - Concepto del gasto
   - Beneficiario
   - Fecha y hora
5. Solicita y archiva comprobante de gasto
6. Actualiza saldo disponible de caja chica
7. Cuando fondo baja de mínimo establecido:
   - Prepara rendición con todos los comprobantes
   - Solicita reposición del fondo
8. Presenta rendición semanal:
   - Suma de gastos realizados
   - Comprobantes adjuntos
   - Saldo restante
9. Sistema valida: Gastos + Saldo = Fondo inicial

**Postcondiciones:**
- Gastos menores cubiertos
- Registros completos de caja chica
- Comprobantes archivados
- Saldo de caja chica actualizado



### **CU-CAJ-016: Entregar Vueltos y Cambio** (omitir)


### **CU-CAJ-017: Entregar Talonarios de Boletos Físicos a Conductores**

**ID:** CU-CAJ-017

**Actor:** Cajero Principal

**Precondiciones:**
- Talonarios preparados por coordinador de suministros
- Tapers/bolsas organizados por unidad
- Conductor autenticado y con unidad asignada
- Sistema operativo disponible

**Trigger:** 
Conductor se presenta antes de salida para recibir talonario

**Flujo Principal:**
1. Conductor se presenta en ventanilla antes de su salida
2. Cajero verifica identidad del conductor y unidad asignada
3. Busca taper/bolsa correspondiente a la unidad del conductor
4. Abre empaque y verifica contenido:
   - Serie del talonario
   - Número de inicio (NumInicio)
   - Número de fin (NumFin)
   - Estado físico de los boletos
5. Registra entrega en sistema:
   - Ejecuta `ProcAlmacenBoleto @Indice=20`
   - Parámetros: CodUnidad, CodPersona, NumSerie, NumInicio, NumFin
6. Sistema marca talonario como "Asignado"
7. Conductor firma formato de recepción (físico o digital)
8. Cajero entrega físicamente el talonario
9. Proporciona instrucciones breves:
   - Uso correcto del talonario
   - Reporte de producción al finalizar
   - Cuidado y responsabilidad
10. Sistema vincula talonario al conductor para control posterior

**Postcondiciones:**
- Talonario entregado al conductor
- Entrega registrada en sistema con trazabilidad completa
- Talonario marcado como "Asignado" a conductor específico
- Formato de recepción firmado y archivado
- Control de inventario actualizado
- Talonario vinculado para verificación en liquidación

## JEFE DE LIQUIDADOR

### **CU-JLI-001: Supervisar Liquidaciones Diarias**

**ID:** CU-JLI-001

**Actor:** Jefe de Liquidador

**Precondiciones:**
- Jefe de Liquidador autenticado en el sistema
- Liquidaciones en proceso o completadas
- Cajeros/Liquidadores operando
- Conductores finalizando turnos

**Trigger:** 
Inicio de proceso de liquidaciones diarias o revisión continua durante turno

**Flujo Principal:**
1. Jefe de Liquidador accede a panel de supervisión de liquidaciones
2. Sistema muestra dashboard con liquidaciones del día:
   - En proceso
   - Completadas
   - Pendientes
   - Con alertas
3. Revisa estado de cada liquidador:
   - Cantidad procesada
   - Tiempo promedio por liquidación
   - Casos escalados
4. Monitorea indicadores en tiempo real:
   - Total de conductores liquidados
   - Conductores pendientes
   - Diferencias detectadas
   - Conflictos activos
5. Identifica liquidaciones con alertas:
   - Diferencias significativas
   - Tiempos excesivos
   - Rechazos de conductores
6. Interviene cuando detecta anomalías
7. Asigna o reasigna conductores entre liquidadores según carga
8. Verifica que se cumplan tiempos establecidos

**Postcondiciones:**
- Proceso de liquidación supervisado
- Anomalías identificadas
- Intervenciones realizadas cuando necesario
- Distribución de carga optimizada



### **CU-JLI-002: Revisar Cajas Liquidadas**

**ID:** CU-JLI-002

**Actor:** Jefe de Liquidador

**Precondiciones:**
- Liquidaciones completadas por cajeros/liquidadores
- Comprobantes emitidos
- Conductores han recibido pago

**Trigger:** 
Revisión post-liquidación o auditoría de calidad

**Flujo Principal:**
1. Jefe de Liquidador selecciona liquidaciones completadas para revisar
2. Sistema muestra detalle de cada liquidación:
   - Producción total registrada
   - Gastos administrativos aplicados
   - Porcentajes calculados
   - Monto pagado al conductor
   - Liquidador que procesó
3. Verifica cálculos matemáticos:
   - Suma de entregas parciales
   - Aplicación correcta de porcentajes
   - Descuentos aplicados correctamente
4. Valida coherencia de datos:
   - Boletos vendidos vs efectivo
   - Tiempos de operación razonables
   - Gastos justificados
5. Revisa documentación:
   - Comprobantes firmados
   - Justificaciones de diferencias
   - Archivos adjuntos
6. Si encuentra error:
   - Marca liquidación para corrección
   - Notifica al liquidador responsable
   - Registra observación
7. Si está correcto:
   - Aprueba liquidación
   - Marca como validada

**Postcondiciones:**
- Liquidaciones revisadas y validadas
- Errores identificados y marcados para corrección
- Calidad del proceso verificada
- Observaciones registradas



### **CU-JLI-003: Registrar Gastos Administrativos**

**ID:** CU-JLI-003

**Actor:** Jefe de Liquidador

**Precondiciones:**
- Unidad operativa registrada
- Conductor activo
- Documentación de gastos disponible

**Trigger:** 
Recepción de comprobantes de gastos o registro de eventos administrativos

**Flujo Principal:**
1. Jefe de Liquidador accede a módulo de gastos administrativos
2. Selecciona unidad y/o conductor
3. Registra tipo de gasto:
   - **Combustible**: monto, litros, fecha, comprobante
   - **Mantenimiento**: tipo de servicio, monto, fecha, taller
   - **Multas**: infracción, monto, fecha, autoridad
   - **Peajes**: cantidad, monto total, ruta
   - **Otros**: descripción, monto, justificación
4. Adjunta comprobante digitalizado (foto o escaneado)
5. Indica si se descuenta de:
   - Liquidación del conductor
   - Pago al propietario
   - Ambos (según porcentaje)
6. Sistema valida:
   - Monto no exceda límites establecidos
   - Comprobante adjunto
   - Justificación adecuada
7. Registra gasto en sistema con timestamp
8. Sistema vincula gasto a próxima liquidación

**Postcondiciones:**
- Gasto administrativo registrado
- Comprobante archivado digitalmente
- Gasto vinculado para descuento automático
- Trazabilidad completa del gasto



### **CU-JLI-004: Calcular Liquidación al Propietario**

**ID:** CU-JLI-004

**Actor:** Jefe de Liquidador

**Precondiciones:**
- Liquidación al conductor completada
- Gastos administrativos registrados
- Acuerdo con propietario configurado en sistema
- Modalidad de operación: conductor NO es propietario

**Trigger:** 
Cierre diario o semanal para pago a propietarios

**Flujo Principal:**
1. Jefe de Liquidador accede a módulo de liquidación a propietarios
2. Selecciona período: día, semana o mes según acuerdo
3. Selecciona unidad(es) del propietario
4. Sistema consolida:
   - Producción total del período
   - Gastos administrativos del período
   - Porcentaje del propietario (ej: 70%)
5. Sistema calcula:
   ```
   Producción Total: $XXX
   (-) Gastos administrativos: $YY
   (=) Producción neta: $ZZZ
   Propietario (70%): $AAA
   (-) Anticipos al propietario: $BB
   (=) Neto a pagar: $CCC
   ```
6. Verifica gastos deducibles:
   - Reparaciones mayores
   - Seguros
   - Permisos de operación
7. Genera desglose detallado
8. Revisa y valida cálculo
9. Prepara documentación para pago

**Postcondiciones:**
- Liquidación al propietario calculada
- Desglose detallado generado
- Monto a pagar determinado
- Documentación preparada para coordinación



### **CU-JLI-005: Resolver Conflictos de Liquidación**

**ID:** CU-JLI-005

**Actor:** Jefe de Liquidador

**Precondiciones:**
- Conflicto escalado por cajero/liquidador
- Conductor en desacuerdo con liquidación
- Partes disponibles para mediación

**Trigger:** 
Escalamiento de disputa entre conductor y cajero/liquidador

**Flujo Principal:**
1. Jefe de Liquidador recibe notificación de conflicto escalado
2. Revisa caso en sistema:
   - Liquidación cuestionada
   - Punto de desacuerdo (diferencia, descuento, cálculo)
   - Posición del conductor
   - Posición del liquidador
3. Convoca a las partes involucradas:
   - Conductor
   - Cajero/Liquidador que procesó
4. Escucha argumentos de cada parte
5. Revisa evidencia:
   - Reportes de ticketera
   - Conteo de boletos físicos
   - Comprobantes de gastos
   - Registros históricos
6. Analiza registros del sistema:
   - Entregas parciales del día
   - Comparación con días anteriores
   - Patrones de producción
7. Toma decisión:
   - **Acepta versión del liquidador**: mantiene liquidación original
   - **Acepta versión del conductor**: ordena ajuste
   - **Solución intermedia**: negocia acuerdo
8. Registra resolución en sistema con justificación
9. Si se requiere ajuste:
   - Autoriza corrección de liquidación
   - Ordena pago adicional o recuperación
10. Documenta aprendizajes para prevenir casos similares

**Postcondiciones:**
- Conflicto resuelto
- Decisión documentada
- Ajustes aplicados (si corresponde)
- Partes notificadas de resolución
- Caso cerrado en sistema



### **CU-JLI-006: Autorizar Ajustes Especiales**

**ID:** CU-JLI-006

**Actor:** Jefe de Liquidador

**Precondiciones:**
- Solicitud de ajuste excepcional presentada
- Justificación documentada
- Liquidación original existente

**Trigger:** 
Solicitud de corrección excepcional por error o situación especial

**Flujo Principal:**
1. Jefe de Liquidador recibe solicitud de ajuste especial:
   - Error en liquidación detectado posteriormente
   - Gasto no registrado oportunamente
   - Producción no contabilizada
   - Pago duplicado
   - Descuento incorrecto
2. Revisa documentación de respaldo:
   - Comprobantes
   - Reportes originales
   - Evidencia del error
3. Verifica en sistema:
   - Liquidación original
   - Registros de transacciones
   - Histórico del conductor/unidad
4. Valida necesidad del ajuste:
   - Error comprobado
   - Impacto económico significativo
   - Dentro de período permitido para ajustes
5. Evalúa monto del ajuste:
   - Si es menor a límite establecido: autoriza directamente
   - Si excede límite: requiere aprobación gerencial
6. Registra autorización en sistema:
   - Tipo de ajuste
   - Monto
   - Justificación detallada
   - Documentación adjunta
7. Sistema ejecuta ajuste:
   - Modifica liquidación original
   - Genera nota de crédito/débito
   - Actualiza saldos
8. Notifica a partes involucradas:
   - Conductor
   - Cajero/Liquidador
   - Propietario (si aplica)

**Postcondiciones:**
- Ajuste especial autorizado
- Liquidación corregida
- Documentación completa archivada
- Trazabilidad del ajuste registrada
- Partes notificadas



### **CU-JLI-007: Generar Reportes de Liquidación**

**ID:** CU-JLI-007

**Actor:** Jefe de Liquidador

**Precondiciones:**
- Liquidaciones registradas en sistema
- Período de reporte definido
- Datos consolidados disponibles

**Trigger:** 
Cierre diario, semanal o mensual para reporting

**Flujo Principal:**
1. Jefe de Liquidador accede a módulo de reportes
2. Selecciona tipo de reporte:
   - **Reporte Diario**: todas las liquidaciones del día
   - **Reporte por Liquidador**: desempeño individual
   - **Reporte por Unidad**: producción consolidada
   - **Reporte de Diferencias**: análisis de faltantes/sobrantes
   - **Reporte Financiero**: consolidado para gerencia
3. Define parámetros:
   - Período (fecha inicio - fecha fin)
   - Filtros (unidad, conductor, ruta)
   - Nivel de detalle
4. Sistema procesa y genera reporte con:
   - Total de liquidaciones procesadas
   - Producción total consolidada
   - Gastos administrativos totales
   - Pagos a conductores
   - Pagos a propietarios (si aplica)
   - Diferencias detectadas
   - Conflictos resueltos
   - Ajustes autorizados
   - Indicadores clave (KPIs):
     * Tiempo promedio de liquidación
     * Porcentaje de liquidaciones sin diferencias
     * Monto promedio de diferencias
     * Casos escalados
5. Revisa y valida información
6. Exporta reporte en formato requerido (PDF, Excel)
7. Distribuye a stakeholders:
   - Gerencia
   - Contabilidad
   - Propietarios
8. Archiva reporte para auditoría

**Postcondiciones:**
- Reporte de liquidación generado
- Información consolidada disponible
- Reporte distribuido a áreas correspondientes
- Archivo almacenado para auditoría



### **CU-JLI-008: Coordinar con Propietarios**

**ID:** CU-JLI-008

**Actor:** Jefe de Liquidador

**Precondiciones:**
- Liquidación al propietario calculada
- Período de pago acordado cumplido
- Documentación de respaldo preparada

**Trigger:** 
Fecha de pago a propietarios o consulta del propietario

**Flujo Principal:**
1. Jefe de Liquidador prepara información para propietario:
   - Liquidación del período
   - Desglose de producción
   - Gastos administrativos aplicados
   - Detalle de descuentos
2. Contacta al propietario:
   - Por teléfono
   - Por correo electrónico
   - Reunión presencial (si es necesario)
3. Presenta resultados del período:
   - Producción total de su(s) unidad(es)
   - Gastos deducidos
   - Monto neto a pagar
4. Proporciona documentación:
   - Reporte detallado de liquidación
   - Comprobantes de gastos
   - Registro de operaciones
5. Atiende consultas del propietario:
   - Aclaraciones sobre gastos
   - Explicación de diferencias
   - Validación de cálculos
6. Si propietario está conforme:
   - Coordina forma de pago (efectivo, transferencia)
   - Programa fecha de pago
   - Registra acuerdo en sistema
7. Si propietario tiene objeciones:
   - Documenta puntos de desacuerdo
   - Revisa en detalle los cuestionamientos
   - Propone solución o escala a gerencia
8. Gestiona el pago:
   - Coordina con cajero/tesorería
   - Verifica transferencia o prepara efectivo
   - Entrega comprobante de pago
9. Solicita firma de conformidad del propietario
10. Archiva documentación completa

**Postcondiciones:**
- Propietario informado de resultados
- Consultas atendidas y resueltas
- Pago coordinado o en proceso
- Comprobante de pago emitido
- Conformidad del propietario registrada
- Documentación archivada para auditoría


## CONDUCTOR (Lado Recaudo)

# CASOS DE USO - CONDUCTOR (Lado Recaudo)


### **CU-CON-R01: Abrir Caja al Inicio de Turno**

**ID:** CU-CON-R01

**Actor:** Conductor

**Precondiciones:**
- Conductor autenticado en el sistema
- Unidad asignada para el turno
- Turno programado activo
- Sistema de recaudo operativo

**Trigger:** 
Conductor inicia su turno antes de primera salida

**Flujo Principal:**
1. Conductor accede al sistema de recaudo:
   - Desde ticketera (si tiene)
   - Desde aplicación móvil
   - Cajero abre caja por él (si no tiene acceso digital)
2. Selecciona opción "Abrir Caja"
3. Sistema solicita datos:
   - Unidad asignada (ej: BUS-245)
   - Turno (mañana/tarde/noche)
   - Tipo de recaudo (ticketera/boletos físicos)
4. Sistema ejecuta `ProcCajaGestionConductor @Indice=21`:
   - Genera número único de caja (CodCaja)
   - Registra hora de apertura
   - Estado: ABIERTA
   - Vincula a conductor y unidad
5. Si usa ticketera:
   - Sistema sincroniza caja con dispositivo
   - Inicializa contadores en cero
6. Si usa boletos físicos:
   - Conductor recibe talonario del cajero (CU-CAJ-017)
   - Sistema registra serie y rango asignado
7. Sistema confirma apertura exitosa:
   ```
   CAJA ABIERTA
   Conductor: Juan Pérez
   Unidad: BUS-245
   Turno: Mañana
   Hora: 05:45 AM
   Caja N°: 12345
   ```
8. Conductor queda listo para iniciar recaudación

**Postcondiciones:**
- Caja abierta y operativa
- Número de caja único asignado
- Sistema listo para registrar ventas
- Talonario asignado (si es físico)
- Ticketera sincronizada (si aplica)



### **CU-CON-R02: Inicializar Ticketera**

**ID:** CU-CON-R02

**Actor:** Conductor

**Precondiciones:**
- Caja abierta (CU-CON-R01)
- Ticketera instalada en unidad
- Dispositivo con energía
- Conexión a sistema central disponible

**Trigger:** 
Inicio de operación con ticketera electrónica

**Flujo Principal:**
1. Conductor enciende ticketera:
   - Presiona botón de encendido
   - Dispositivo inicia secuencia de arranque
2. Ticketera realiza auto-diagnóstico:
   - Verifica hardware (impresora, pantalla, botones)
   - Comprueba papel disponible
   - Valida memoria interna
3. Sistema solicita autenticación:
   - Conductor ingresa código/PIN
   - O sistema reconoce automáticamente por GPS/unidad
4. Ticketera sincroniza con servidor central:
   - Descarga tarifas vigentes
   - Actualiza configuración
   - Sincroniza hora del sistema
5. Sistema valida vinculación con caja abierta:
   - Verifica CodCaja activo
   - Confirma conductor autorizado
   - Vincula transacciones a caja del día
6. Ticketera muestra estado:
   ```
   TICKETERA LISTA
   Unidad: BUS-245
   Conductor: Juan Pérez
   Caja: 12345
   Papel: OK
   Conexión: OK
   ```
7. Conductor verifica:
   - Pantalla operativa
   - Papel suficiente para el turno
   - Tarifas cargadas correctamente
8. Si hay problemas:
   - Intenta reinicio
   - Reporta falla (CU-CON-R08)
   - Activa modo boletos físicos como respaldo

**Postcondiciones:**
- Ticketera inicializada y operativa
- Sincronización con servidor completada
- Tarifas actualizadas cargadas
- Vinculada a caja del conductor
- Sistema listo para vender boletos electrónicos



### **CU-CON-R03: Vender Boletos con Tarifa Normal**

**ID:** CU-CON-R03

**Actor:** Conductor

**Precondiciones:**
- Caja abierta
- Sistema de venta operativo (ticketera o boletos físicos)
- Pasajero abordando el vehículo

**Trigger:** 
Pasajero aborda y solicita pasaje con tarifa regular

**Flujo Principal:**

**CASO A: Con Ticketera**
1. Pasajero aborda y solicita boleto
2. Conductor indica tarifa: "$2.50"
3. Pasajero entrega efectivo
4. Conductor presiona botón de tarifa normal en ticketera
5. Ticketera registra transacción:
   - Ejecuta `ProcBoletoTransaccion @Indice=21`
   - Genera correlativo único
   - Imprime boleto con:
     * Fecha y hora
     * Unidad
     * Tarifa: $2.50
     * Número de boleto
6. Conductor entrega boleto al pasajero
7. Si pasajero dio más dinero, entrega vuelto
8. Ticketera acumula automáticamente en producción del día

**CASO B: Con Boletos Físicos**
1. Pasajero aborda y solicita boleto
2. Conductor indica tarifa: "$2.50"
3. Pasajero entrega efectivo
4. Conductor toma siguiente boleto del talonario
5. Verifica que boleto esté en buen estado
6. Entrega boleto físico al pasajero
7. Si pasajero dio más dinero, entrega vuelto
8. Guarda efectivo en caja/bolsillo destinado
9. Mentalmente actualiza control de boletos vendidos

**Postcondiciones:**
- Boleto vendido y entregado
- Efectivo recibido y guardado
- Transacción registrada (automática o manual)
- Pasajero con comprobante de pago
- Producción acumulada actualizada



### **CU-CON-R04: Vender Boletos con Tarifa Diferenciada**

**ID:** CU-CON-R04

**Actor:** Conductor

**Precondiciones:**
- Caja abierta
- Tarifas especiales configuradas en sistema
- Pasajero con derecho a tarifa reducida

**Trigger:** 
Pasajero con tarifa diferenciada aborda (estudiante, adulto mayor, discapacitado)

**Flujo Principal:**
1. Pasajero aborda y solicita pasaje con tarifa especial
2. Conductor solicita documentación:
   - **Universitario**: carnet universitario vigente
   - **Escolar**: carnet escolar vigente
   - **Adulto mayor**: DNI (>65 años)
   - **Discapacidad**: carnet CONADIS
3. Conductor verifica validez del documento:
   - Vigencia de carnet
   - Fotografía corresponde
   - Edad correcta (adulto mayor)
4. Si documento es válido:
   
   **Con Ticketera:**
   - Selecciona tipo de tarifa en ticketera:
     * Botón "Universitario" → $1.25
     * Botón "Escolar" → $1.25
     * Botón "Adulto Mayor" → $1.00
     * Botón "Discapacidad" → $1.00
   - Ticketera registra y imprime boleto con tarifa especial
   - Boleto muestra tipo de descuento aplicado
   
   **Con Boletos Físicos:**
   - Cobra tarifa reducida según tipo
   - Entrega boleto físico estándar
   - Anota mentalmente tipo de tarifa para rendición
   
5. Pasajero paga tarifa diferenciada
6. Conductor entrega boleto
7. Sistema registra tipo de tarifa aplicada

**Si documento no es válido:**
- Conductor solicita tarifa normal
- Explica requisitos de documentación
- Procede con venta de tarifa regular

**Postcondiciones:**
- Tarifa diferenciada aplicada correctamente
- Documentación validada
- Boleto con descuento entregado
- Transacción registrada con tipo de tarifa
- Descuento justificado



### **CU-CON-R05: Manejar Vueltos**

**ID:** CU-CON-R05

**Actor:** Conductor

**Precondiciones:**
- Venta en efectivo en proceso
- Pasajero entregó monto mayor a la tarifa
- Conductor tiene cambio disponible

**Trigger:** 
Pasajero paga con billete mayor al monto del pasaje

**Flujo Principal:**
1. Pasajero entrega efectivo (ej: billete de $10.00)
2. Conductor identifica tarifa a cobrar (ej: $2.50)
3. Calcula vuelto mental o visualmente:
   - $10.00 - $2.50 = $7.50
4. Verifica disponibilidad de cambio:
   - Revisa monedas y billetes chicos disponibles
5. Si tiene cambio suficiente:
   - Cuenta vuelto exacto ($7.50)
   - Entrega boleto al pasajero
   - Entrega vuelto contado
   - Pasajero verifica monto recibido
6. Si no tiene cambio exacto:
   - **Opción 1**: Pide al pasajero monto exacto o más cercano
   - **Opción 2**: Solicita cambio a otros pasajeros
   - **Opción 3**: Registra deuda temporal con pasajero
   - **Opción 4**: En terminal, solicita cambio al cajero
7. Guarda efectivo recibido ($10.00) en caja
8. Mantiene vueltos organizados por denominación:
   - Monedas de 0.50, 1.00, 2.00
   - Billetes de 5.00, 10.00

**Caso Especial: Sin cambio disponible**
- Conductor se disculpa con pasajero
- Ofrece descenso sin cobro hasta conseguir cambio
- O registra pasajero para cobro al descender

**Postcondiciones:**
- Vuelto correcto entregado
- Pasajero satisfecho con cambio
- Efectivo organizado en caja
- Inventario de vueltos actualizado



### **CU-CON-R06: Registrar Ventas Manuales**

**ID:** CU-CON-R06

**Actor:** Conductor

**Precondiciones:**
- Operación con boletos físicos
- Talonario asignado
- Caja abierta

**Trigger:** 
Venta de boletos físicos durante el servicio (sin ticketera)

**Flujo Principal:**
1. Conductor vende boletos físicos durante recorrido
2. Mantiene control mental/manual de ventas:
   - Primer boleto vendido del turno
   - Último boleto vendido hasta el momento
   - Aproximado de boletos vendidos
3. Durante operación, anota (si es posible):
   - Número inicial vendido: A-045
   - Número final vendido: A-084
4. Al finalizar vuelta o turno:
   - Cuenta boletos restantes en talonario
   - Calcula vendidos: Asignados - Restantes
   - Ejemplo: 100 - 16 restantes = 84 vendidos
5. Calcula producción aproximada:
   - Boletos vendidos × Tarifa estándar
   - 84 × $2.50 = $210.00
6. Compara con efectivo acumulado:
   - Cuenta efectivo en caja/bolsillo
   - Identifica diferencias (vueltos dados, tarifas especiales)
7. Prepara información para entrega al cajero:
   - Primer boleto vendido
   - Último boleto vendido
   - Total aproximado de boletos
   - Efectivo total recaudado
8. Si hubo tarifas diferenciadas:
   - Estima cantidad por tipo
   - Ajusta cálculo de producción esperada

**Postcondiciones:**
- Ventas manuales registradas mentalmente
- Boletos vendidos calculados
- Producción aproximada determinada
- Información lista para rendición al cajero
- Control básico de talonario mantenido



### **CU-CON-R07: Controlar Stock de Boletos Físicos**

**ID:** CU-CON-R07

**Actor:** Conductor

**Precondiciones:**
- Talonario de boletos físicos asignado
- Operación en curso con boletos manuales

**Trigger:** 
Verificación periódica durante turno o antes de salida

**Flujo Principal:**
1. Conductor revisa talonario durante el turno:
   - En terminal entre vueltas
   - Durante pausas
   - Antes de iniciar nuevo servicio
2. Cuenta boletos restantes físicamente:
   - Separa boletos no usados
   - Cuenta cantidad disponible
3. Calcula boletos vendidos hasta el momento:
   - Boletos asignados - Boletos restantes = Vendidos
4. Evalúa si stock es suficiente:
   - Estima pasajeros en próximo servicio
   - Compara con boletos disponibles
5. Si stock es bajo (< 20% del talonario):
   - Alerta mental de reabastecimiento necesario
   - Planea solicitar más boletos
6. Si stock es crítico (< 10 boletos):
   - Al llegar a terminal, solicita nuevo talonario (CU-CON-R15)
   - Mientras tanto, puede:
     * Usar ticketera como respaldo (si tiene)
     * Limitar servicio hasta reabastecer
7. Verifica estado físico de boletos restantes:
   - No estén rotos o dañados
   - Numeración legible
   - Calidad aceptable para entregar
8. Si encuentra boletos defectuosos:
   - Separa para devolución
   - Ajusta conteo de stock disponible
   - Informa al cajero en próxima entrega

**Postcondiciones:**
- Stock de boletos monitoreado
- Necesidad de reabastecimiento identificada
- Boletos defectuosos separados
- Planificación de solicitud de reposición



### **CU-CON-R08: Reportar Fallas de Ticketera**

**ID:** CU-CON-R08

**Actor:** Conductor

**Precondiciones:**
- Ticketera instalada en unidad
- Falla técnica detectada durante operación
- Medio de comunicación disponible

**Trigger:** 
Ticketera deja de funcionar o presenta errores

**Flujo Principal:**
1. Conductor detecta problema en ticketera:
   - **No enciende**: sin energía o averiada
   - **No imprime**: papel atascado o agotado
   - **Error de sistema**: mensaje de error en pantalla
   - **No sincroniza**: sin conexión a servidor
   - **Botones no responden**: falla de hardware
2. Intenta solución básica:
   - Reinicia dispositivo
   - Verifica papel y reemplaza si es necesario
   - Confirma conexión eléctrica
   - Revisa cables sueltos
3. Si problema persiste:
   - Toma fotografía del error (si muestra mensaje)
   - Anota hora exacta de la falla
   - Registra último boleto vendido exitosamente
4. Comunica falla inmediatamente:
   - Llama/envía mensaje a central de operaciones
   - Informa:
     * Unidad afectada
     * Tipo de falla
     * Hora de inicio del problema
     * Ubicación actual
5. Recibe instrucciones de central:
   - Continuar con boletos físicos de respaldo
   - Dirigirse a terminal para cambio de ticketera
   - Completar servicio y reportar en terminal
6. Activa modo de contingencia:
   - Utiliza talonario de boletos físicos (CU-CON-R03)
   - Informa a pasajeros del cambio temporal
   - Continúa operación con venta manual
7. Al llegar a terminal:
   - Reporta falla al supervisor/cajero
   - Entrega ticketera para revisión técnica
   - Recibe ticketera de reemplazo (si disponible)
8. Sistema registra incidencia:
   - Tipo de falla
   - Unidad afectada
   - Tiempo sin servicio de ticketera
   - Solución aplicada

**Postcondiciones:**
- Falla reportada a central
- Modo de contingencia activado (boletos físicos)
- Servicio continúa sin interrupción
- Ticketera marcada para reparación
- Incidencia registrada en sistema



### **CU-CON-R09: Entregar Recaudo Parcial (Por Vuelta)**

**ID:** CU-CON-R09

**Actor:** Conductor

**Precondiciones:**
- Vuelta completada
- Efectivo acumulado en la vuelta
- Cajero disponible en terminal
- Caja del conductor abierta

**Trigger:** 
Conductor finaliza vuelta y llega a terminal

**Flujo Principal:**
1. Conductor completa vuelta y llega a terminal
2. Estaciona unidad en zona designada
3. Cuenta efectivo acumulado de la vuelta:
   - Separa billetes por denominación
   - Cuenta monedas
   - Calcula total
4. Se dirige a ventanilla del cajero
5. Se identifica: "Conductor Juan Pérez, Unidad BUS-245, Vuelta 3"
6. Entrega al cajero:
   
   **Con Ticketera:**
   - Efectivo recaudado
   - Informa: "Efectivo de vuelta: $85.00"
   - Cajero consulta reporte digital de producción
   
   **Con Boletos Físicos:**
   - Efectivo recaudado
   - Talonario para verificación de boletos vendidos
   - Informa boletos vendidos aproximadamente
   
7. Cajero cuenta efectivo recibido (CU-CAJ-002)
8. Cajero compara con producción (CU-CAJ-003/CU-CAJ-004/CU-CAJ-005)
9. Si hay diferencia, conductor justifica (CU-CON-R12)
10. Cajero registra entrega en sistema (CU-CAJ-006)
11. Cajero emite comprobante temporal de recepción
12. Conductor recibe copia y guarda
13. Si usó boletos físicos, cajero devuelve talonario
14. Conductor regresa a unidad para continuar operación

**Postcondiciones:**
- Efectivo de vuelta entregado al cajero
- Comprobante de entrega recibido
- Entrega registrada en sistema
- Conductor aliviado de carga de efectivo
- Listo para continuar siguiente vuelta



### **CU-CON-R10: Abrir Nueva Caja (Por Salida)**

**ID:** CU-CON-R10

**Actor:** Conductor

**Precondiciones:**
- Conductor trabaja múltiples salidas en el día
- Caja anterior cerrada
- Nueva salida programada

**Trigger:** 
Conductor inicia nueva salida después de descanso o cambio de turno

**Flujo Principal:**
1. Conductor finaliza primera salida del día
2. Cierra caja de esa salida (CU-CON-R11)
3. Toma descanso entre turnos
4. Antes de iniciar segunda salida:
   - Verifica nueva programación
   - Confirma unidad asignada (puede ser la misma u otra)
5. Abre nueva caja para segunda salida:
   - Accede al sistema
   - Selecciona "Abrir Nueva Caja"
   - Sistema ejecuta `ProcCajaGestionConductor @Indice=21`
6. Sistema genera nueva caja independiente:
   - Nuevo CodCaja único
   - Vinculada a la nueva salida
   - Hora de apertura registrada
   - Contadores en cero
7. Si cambia de unidad:
   - Sistema vincula nueva caja a nueva unidad
   - Actualiza asignación
8. Si usa misma unidad:
   - Nueva caja se vincula a misma unidad
   - Diferenciada por número de salida
9. Recibe nuevo talonario (si usa boletos físicos)
10. Inicializa ticketera nuevamente (si aplica)
11. Comienza recaudación de segunda salida independientemente

**Postcondiciones:**
- Nueva caja abierta para segunda salida
- Independiente de caja anterior
- Sistema diferencia producción por salida
- Conductor listo para operar nueva salida
- Trazabilidad por salida mantenida



### **CU-CON-R11: Cerrar Caja Temporal**

**ID:** CU-CON-R11

**Actor:** Conductor

**Precondiciones:**
- Caja abierta para salida actual
- Salida completada o pausada
- Producción acumulada en la caja

**Trigger:** 
Finalización de salida, descanso prolongado o fin de turno parcial

**Flujo Principal:**
1. Conductor decide cerrar caja temporal:
   - Terminó turno de mañana (trabaja también tarde)
   - Finaliza salida antes de descanso
   - Pausa operativa prolongada
2. Accede al sistema de caja:
   - Desde ticketera
   - Desde aplicación
   - Solicita a cajero cerrar por él
3. Selecciona opción "Cerrar Caja"
4. Sistema solicita confirmación:
   - "¿Cerrar caja actual?"
   - Muestra resumen de producción acumulada
5. Conductor confirma cierre
6. Sistema ejecuta `ProcCajaGestionConductor @Indice=31`:
   - Marca caja como CERRADA
   - Registra hora de cierre
   - Consolida producción total de esa caja
   - Genera reporte de la salida
7. Si usa ticketera:
   - Genera reporte automático:
     ```
     CAJA CERRADA
     Conductor: Juan Pérez
     Salida: Turno Mañana
     Hora cierre: 02:15 PM
     Producción: $245.00
     Transacciones: 98
     ```
8. Si usa boletos físicos:
   - Conductor calcula manualmente producción
   - Prepara entrega final al cajero
9. Entrega producción completa de esa caja al cajero
10. Cajero procesa como entrega final de esa salida
11. Sistema mantiene caja cerrada hasta liquidación

**Postcondiciones:**
- Caja temporal cerrada
- Producción consolidada
- Reporte de salida generado
- Lista para liquidación independiente
- Sistema listo para nueva caja (si aplica)



### **CU-CON-R12: Justificar Diferencias en Entregas**

**ID:** CU-CON-R12

**Actor:** Conductor

**Precondiciones:**
- Entrega parcial o final realizada
- Cajero detectó diferencia entre efectivo y producción
- Conductor presente en ventanilla

**Trigger:** 
Cajero informa de diferencia en recaudación (CU-CAJ-008)

**Flujo Principal:**
1. Cajero informa diferencia detectada:
   - **Faltante**: Efectivo < Producción esperada
   - **Sobrante**: Efectivo > Producción esperada
2. Cajero indica monto de diferencia:
   - "Faltante de $12.50" o "Sobrante de $5.00"
3. Conductor analiza posibles causas:
   
   **Para Faltantes:**
   - Vueltos mal calculados (dio más de lo debido)
   - Pasajeros que evadieron sin notarlo
   - Error al contar efectivo antes de entregar
   - Billetes que no guardó correctamente
   - Propinas/ayudas dadas a pasajeros
   
   **Para Sobrantes:**
   - Error de conteo de boletos (vendió más de lo registrado)
   - Vueltos no entregados que olvidó
   - Pasajeros que pagaron de más
   - Error en registro de ticketera
   
4. Conductor explica verbalmente al cajero:
   - Causa identificada o sospechada
   - Circunstancias especiales del servicio
   - Eventos relevantes durante la vuelta
5. Si la diferencia es pequeña (< $5.00):
   - Cajero registra como diferencia menor
   - Conductor firma justificación básica
   - Se acepta y cierra caso
6. Si la diferencia es significativa (≥ $5.00):
   - Cajero solicita justificación escrita
   - Conductor redacta explicación detallada
   - Puede incluir:
     * Hora aproximada del evento
     * Circunstancias específicas
     * Testigos si aplica
7. Conductor firma documento de justificación
8. Cajero evalúa si acepta explicación:
   - Si es razonable: acepta y registra
   - Si es dudosa: escala a supervisor
9. Sistema registra:
   - Tipo de diferencia (faltante/sobrante)
   - Monto
   - Justificación del conductor
   - Decisión del cajero
10. Si es faltante, puede descontarse de liquidación final

**Postcondiciones:**
- Diferencia justificada y documentada
- Explicación registrada en sistema
- Decisión tomada sobre aceptación
- Descuento aplicado (si corresponde)
- Caso cerrado o escalado



### **CU-CON-R13: Cerrar Caja Final de Turno**

**ID:** CU-CON-R13

**Actor:** Conductor

**Precondiciones:**
- Última salida del día completada
- Todas las vueltas finalizadas
- Producción total acumulada
- Efectivo total en posesión del conductor

**Trigger:** 
Finalización completa del turno diario

**Flujo Principal:**
1. Conductor completa última vuelta del día
2. Llega a terminal y estaciona unidad
3. Cierra caja final:
   - Accede al sistema
   - Selecciona "Cerrar Caja Final"
4. Sistema consolida producción total del día:
   - Suma todas las vueltas/salidas
   - Totaliza transacciones
   - Calcula producción bruta
5. Si usa ticketera:
   - Ejecuta cierre en dispositivo
   - Sistema genera reporte completo automáticamente:
     ```
     CIERRE FINAL DE TURNO
     Conductor: Juan Pérez
     Fecha: 07/12/2024
     Turno completo: 06:00 - 18:00
     
     Total salidas: 2
     Total vueltas: 8
     Total transacciones: 325
     Producción total: $812.50
     ```
6. Si usa boletos físicos:
   - Cuenta boletos restantes del último talonario
   - Calcula total vendidos del día
   - Estima producción total
7. Cuenta todo el efectivo acumulado:
   - Efectivo de última vuelta (si no entregó)
   - Vueltos restantes
8. Se dirige a ventanilla de liquidación
9. Entrega al cajero/liquidador:
   - Todo el efectivo del día
   - Talonario con boletos restantes (si aplica)
   - Informa producción total
10. Cajero procesa cierre y liquidación (CU-CAJ-010)
11. Sistema marca caja como CERRADA-FINAL

**Postcondiciones:**
- Caja final cerrada
- Producción total consolidada
- Efectivo total entregado
- Reporte completo generado
- Conductor en proceso de liquidación final



### **CU-CON-R14: Recibir Liquidación Final**

**ID:** CU-CON-R14

**Actor:** Conductor

**Precondiciones:**
- Caja final cerrada (CU-CON-R13)
- Cajero/Liquidador procesó liquidación (CU-CAJ-009)
- Cálculo de liquidación completado (CU-CAJ-011)
- Comprobante generado (CU-CAJ-012)

**Trigger:** 
Cajero/Liquidador finaliza cálculo y llama al conductor

**Flujo Principal:**
1. Cajero/Liquidador llama al conductor
2. Conductor se presenta en ventanilla de liquidación
3. Liquidador presenta desglose de liquidación:
   ```
   LIQUIDACIÓN FINAL
   Conductor: Juan Pérez
   Fecha: 07/12/2024
   
   Producción total: $812.50
   (-) Gastos administrativos: $45.00
   (=) Producción neta: $767.50
   
   Conductor 30%: $230.25
   (-) Anticipos: $50.00
   (-) Diferencias: $12.50
   (=) NETO A PAGAR: $167.75
   ```
4. Conductor revisa detalles:
   - Producción registrada
   - Gastos descontados
   - Porcentaje aplicado
   - Anticipos descontados
   - Diferencias restadas
5. Si está conforme:
   - Acepta liquidación
   - Procede a firma
6. Si tiene objeciones:
   - Cuestiona puntos específicos
   - Solicita aclaraciones
   - Puede escalar a Jefe de Liquidador (CU-JLI-005)
7. Una vez aceptado:
   - Liquidador entrega efectivo calculado: $167.75
   - Conductor cuenta dinero recibido
   - Confirma monto correcto
8. Conductor firma comprobante de liquidación:
   - Recibo de pago
   - Conformidad de cálculo
9. Liquidador entrega:
   - Original del comprobante
   - Desglose detallado (opcional)
10. Conductor guarda documentos
11. Sistema registra liquidación completada

**Postcondiciones:**
- Liquidación final recibida
- Pago en efectivo entregado
- Comprobante firmado y archivado
- Conductor satisfecho (o caso escalado)
- Turno completamente cerrado
- Sistema actualizado



### **CU-CON-R15: Solicitar Reposición de Boletos**

**ID:** CU-CON-R15

**Actor:** Conductor

**Precondiciones:**
- Stock de boletos físicos bajo o agotado
- Conductor operando con boletos manuales
- Cajero disponible en terminal

**Trigger:** 
Stock crítico de boletos (< 10 restantes) o agotado completamente

**Flujo Principal:**
1. Conductor detecta stock bajo de boletos (CU-CON-R07):
   - Cuenta boletos restantes
   - Identifica necesidad de reabastecimiento
2. Al llegar a terminal, se dirige al cajero
3. Presenta talonario casi agotado:
   - Muestra boletos restantes
   - Informa: "Necesito nuevo talonario, quedan solo 8 boletos"
4. Cajero verifica:
   - Identifica serie y rango del talonario actual
   - Confirma stock bajo
5. Cajero consulta disponibilidad:
   - Revisa tapers/bolsas preparados
   - Verifica si hay talonarios disponibles para esa unidad
6. Si hay talonarios disponibles:
   - Cajero entrega nuevo talonario (CU-CAJ-017)
   - Conductor recibe y verifica serie y rango
   - Firma recepción del nuevo talonario
7. Si NO hay talonarios disponibles:
   - Cajero contacta a Coordinador de Suministros
   - Coordinador prepara nuevo talonario urgentemente
   - O conductor espera hasta siguiente turno
8. Conductor devuelve boletos restantes del talonario anterior:
   - Cajero recibe y cuenta
   - Registra devolución parcial
9. Sistema registra:
   - Entrega de nuevo talonario
   - Devolución de talonario parcialmente usado
   - Continuidad de numeración
10. Conductor continúa operación con nuevo talonario

**Postcondiciones:**
- Nuevo talonario recibido
- Talonario anterior devuelto (sobrantes)
- Entrega registrada en sistema
- Conductor con stock suficiente
- Operación continúa sin interrupción



### **CU-CON-R16: Manejar Devoluciones**

**ID:** CU-CON-R16

**Actor:** Conductor

**Precondiciones:**
- Pasajero solicita devolución de pasaje
- Boleto válido del día
- Servicio no prestado o interrumpido

**Trigger:** 
Pasajero reclama devolución por servicio no completado

**Flujo Principal:**
1. Pasajero solicita devolución por:
   - Unidad no salió como estaba programado
   - Servicio interrumpido (avería, accidente)
   - Pasajero descendió antes de completar ruta por problema del servicio
   - Conductor rechazó servir la ruta completa
2. Conductor evalúa validez del reclamo:
   - Verifica boleto del día
   - Confirma que servicio no se prestó correctamente
   - Identifica causa justificada
3. Si la devolución es procedente:
   - Conductor solicita boleto al pasajero
   - Verifica autenticidad y vigencia
   - Anula boleto (marca con sello/firma si es físico)
4. Determina monto a devolver:
   - **Servicio no iniciado**: 100% del pasaje
   - **Servicio interrumpido a mitad**: 50% del pasaje
   - **Problema menor**: evaluación caso por caso
5. Devuelve efectivo al pasajero:
   - Cuenta dinero del monto correspondiente
   - Entrega al pasajero
   - Pasajero confirma recepción
6. Registra devolución:
   
   **Con Ticketera:**
   - Accede a función "Devolución"
   - Registra monto devuelto
   - Sistema resta de producción del día
   
   **Con Boletos Físicos:**
   - Anota mentalmente/en papel la devolución
   - Guarda boleto anulado como evidencia
   - Informará al cajero en entrega
   
7. Explica al cajero en entrega parcial/final:
   - "Tuve una devolución de $2.50 por servicio interrumpido"
   - Entrega boleto anulado como prueba
8. Cajero ajusta producción esperada considerando devolución
9. Sistema registra:
   - Devolución realizada
   - Motivo
   - Monto
   - Ajuste en producción

**Postcondiciones:**
- Devolución procesada
- Efectivo devuelto al pasajero
- Boleto anulado
- Devolución documentada
- Producción ajustada
- Evidencia guardada para justificación




## COORDINADOR SUMINISTROS

### **CU-COS-001: Planificar Distribución de Boletos**

**ID:** CU-COS-001

**Actor:** Coordinador de Suministros

**Precondiciones:**
- Coordinador autenticado en el sistema
- Programación de unidades del día siguiente disponible
- Stock de talonarios suficiente
- Sistema operativo disponible

**Trigger:** 
Día anterior a la operación (usualmente por la tarde/noche)

**Flujo Principal:**
1. Coordinador consulta programación del día siguiente:
   - Unidades que operarán
   - Rutas asignadas
   - Turnos programados
   - Conductores asignados
2. Revisa stock disponible de talonarios:
   - Series disponibles
   - Rangos de numeración
   - Estado de cada talonario
3. Para cada unidad programada:
   - Asigna talonario específico
   - Registra en sistema:
     * CodUnidad
     * NumSerie (A, B, C, etc.)
     * NumInicio
     * NumFin
     * Cantidad de boletos
4. Sistema valida:
   - No duplicar asignación de talonarios
   - Stock suficiente
   - Talonarios en buen estado
5. Genera lista de asignación:
   ```
   DISTRIBUCIÓN DÍA: 08/12/2024
   
   Unidad BUS-245 → Talonario Serie A: 001-100
   Unidad BUS-189 → Talonario Serie A: 101-200
   Unidad BUS-312 → Talonario Serie B: 001-100
   ...
   ```
6. Imprime o visualiza lista de distribución
7. Sistema marca talonarios como "Asignados-Pendiente entrega"

**Postcondiciones:**
- Distribución planificada para el día siguiente
- Talonarios asignados a unidades específicas
- Lista de distribución generada
- Sistema actualizado con asignaciones



### **CU-COS-002: Controlar Stock Central**

**ID:** CU-COS-002

**Actor:** Coordinador de Suministros

**Precondiciones:**
- Inventario de boletos en almacén central
- Sistema de control de stock operativo
- Talonarios organizados por series

**Trigger:** 
Revisión periódica de inventario o consulta de disponibilidad

**Flujo Principal:**
1. Coordinador accede a módulo de inventario central
2. Sistema muestra stock actual:
   - Por serie (A, B, C, D, etc.)
   - Total de talonarios disponibles
   - Talonarios asignados no entregados
   - Talonarios en uso
   - Talonarios devueltos
3. Revisa niveles de stock:
   - Stock actual vs stock mínimo
   - Proyección de consumo semanal
   - Alertas de reabastecimiento
4. Realiza conteo físico periódico:
   - Cuenta talonarios físicamente
   - Compara con registro del sistema
   - Identifica diferencias
5. Si encuentra diferencias:
   - Investiga causa (pérdida, robo, error registro)
   - Documenta hallazgo
   - Ajusta inventario en sistema
   - Notifica a supervisor si es significativo
6. Actualiza estado de talonarios:
   - Disponibles
   - Asignados
   - En uso
   - Agotados
   - Defectuosos
   - Anulados
7. Genera alertas si stock bajo:
   - Notifica necesidad de compra
   - Calcula cantidad a solicitar

**Postcondiciones:**
- Stock central actualizado
- Diferencias identificadas y ajustadas
- Alertas generadas si stock bajo
- Inventario físico concordante con sistema



### **CU-COS-003: Distribuir Boletos a Cajeros**

**ID:** CU-COS-003

**Actor:** Coordinador de Suministros

**Precondiciones:**
- Planificación de distribución completada (CU-COS-001)
- Talonarios preparados según asignación
- Tapers/bolsas disponibles
- Hora de preparación: madrugada (3-5 AM aprox.)

**Trigger:** 
Horas antes del inicio de operación (madrugada)

**Flujo Principal:**
1. Coordinador llega en la madrugada (3-4 AM)
2. Consulta lista de distribución planificada del día
3. Para cada unidad programada:
   - Localiza físicamente el talonario asignado
   - Verifica serie y rango (NumInicio - NumFin)
   - Inspecciona estado físico de boletos
4. Prepara empaque por unidad:
   - Introduce talonario en taper o bolsa
   - Etiqueta con:
     * Código de unidad (ej: BUS-245)
     * Serie y rango (ej: A: 001-100)
     * Fecha
   - Engrapa o sella bolsa para seguridad
5. Organiza tapers/bolsas:
   - Agrupa por orden de salida
   - Facilita acceso para cajeros
6. Espera llegada de cajeros (4-5 AM aproximadamente)
7. Entrega conjunto de tapers/bolsas a cada cajero:
   - Cajero recibe tapers de unidades de su zona/turno
   - Verifica cantidad recibida
8. Registra entrega en sistema:
   - Ejecuta registro de traspaso
   - Marca talonarios como "Entregados a cajero"
   - Registra:
     * Cajero receptor
     * Cantidad de tapers entregados
     * Hora de entrega
9. Cajero firma acta de recepción
10. Cajero almacena tapers hasta entrega a conductores

**Postcondiciones:**
- Talonarios organizados en tapers/bolsas por unidad
- Tapers entregados a cajeros correspondientes
- Entrega registrada en sistema
- Acta de recepción firmada
- Cajeros listos para entregar a conductores en sus salidas



### **CU-COS-004: Registrar Entregas**

**ID:** CU-COS-004

**Actor:** Coordinador de Suministros

**Precondiciones:**
- Talonarios entregados a cajeros o conductores
- Sistema de registro operativo
- Documentación de entrega disponible

**Trigger:** 
Confirmación de entrega de talonarios

**Flujo Principal:**
1. Coordinador accede a módulo de registro de entregas
2. Selecciona tipo de entrega:
   - A cajero (entrega masiva madrugada)
   - A conductor (entrega directa excepcional)
3. Para entrega a cajero:
   - Registra cajero receptor
   - Lista de talonarios entregados:
     * Serie, NumInicio, NumFin por cada talonario
     * Unidad asignada
   - Cantidad total de tapers/bolsas
   - Hora de entrega
4. Para entrega a conductor (excepcional):
   - Registra conductor receptor
   - Unidad asignada
   - Talonario específico entregado
   - Motivo de entrega directa
5. Sistema ejecuta `ProcAlmacenBoleto`:
   - Actualiza estado de talonarios
   - Vincula a responsable (cajero o conductor)
   - Registra trazabilidad
6. Genera comprobante de entrega:
   - Detalle de talonarios
   - Responsable receptor
   - Firma de conformidad
7. Archiva documentación:
   - Comprobante firmado
   - Registro digital en sistema
8. Actualiza inventario central:
   - Reduce stock "Disponible"
   - Incrementa stock "En circulación"

**Postcondiciones:**
- Entrega documentada en sistema
- Comprobante generado y firmado
- Trazabilidad completa establecida
- Inventario actualizado
- Responsable identificado



### **CU-COS-005: Recibir Devoluciones**

**ID:** CU-COS-005

**Actor:** Coordinador de Suministros

**Precondiciones:**
- Talonarios en circulación
- Conductor/cajero devuelve boletos
- Motivo de devolución identificado

**Trigger:** 
Devolución de talonarios no utilizados o defectuosos

**Flujo Principal:**
1. Conductor/cajero se presenta con talonario a devolver
2. Coordinador recibe talonario y pregunta motivo:
   - Boletos no utilizados (sobrante de día)
   - Boletos defectuosos (impresión mala, rotos)
   - Cambio de unidad
   - Fin de uso de serie
3. Realiza inspección física:
   - Cuenta boletos restantes
   - Verifica numeración correlativa
   - Identifica boletos dañados/defectuosos
4. Consulta en sistema registro original:
   - Serie y rango entregado originalmente
   - Boletos que debería tener
5. Calcula boletos utilizados:
   - Boletos entregados - Boletos devueltos = Boletos usados
6. Registra devolución en sistema:
   - Ejecuta `ProcAlmacenBoleto` para devolución
   - Marca boletos devueltos
   - Indica estado:
     * Reutilizables (buen estado)
     * Defectuosos (para destrucción)
   - Registra cantidad de boletos utilizados
7. Si hay boletos defectuosos:
   - Separa físicamente
   - Registra como "Para anulación"
   - Documenta cantidad y motivo
8. Actualiza inventario:
   - Retorna boletos buenos a stock disponible
   - Marca defectuosos para baja
9. Emite comprobante de devolución al conductor/cajero
10. Archiva documentación de trazabilidad

**Postcondiciones:**
- Devolución registrada en sistema
- Boletos reutilizables devueltos a stock
- Boletos defectuosos separados para baja
- Inventario actualizado
- Trazabilidad de uso completada
- Comprobante emitido



### **CU-COS-006: Generar Reportes de Movimiento**

**ID:** CU-COS-006

**Actor:** Coordinador de Suministros

**Precondiciones:**
- Movimientos de inventario registrados
- Período de reporte definido
- Sistema con datos consolidados

**Trigger:** 
Cierre diario, semanal o mensual de inventario

**Flujo Principal:**
1. Coordinador accede a módulo de reportes de inventario
2. Selecciona tipo de reporte:
   - **Reporte Diario**: movimientos del día
   - **Reporte de Entregas**: talonarios distribuidos
   - **Reporte de Devoluciones**: boletos retornados
   - **Reporte de Stock**: estado actual de inventario
   - **Reporte de Consumo**: boletos utilizados por período
3. Define parámetros:
   - Período (fecha inicio - fecha fin)
   - Serie específica (A, B, C) o todas
   - Tipo de movimiento (entradas/salidas)
4. Sistema genera reporte con:
   - **Entradas al inventario**:
     * Compras a proveedores
     * Devoluciones de conductores
   - **Salidas del inventario**:
     * Entregas a cajeros
     * Entregas directas a conductores
   - **Stock inicial del período**
   - **Stock final del período**
   - **Boletos utilizados** (vendidos)
   - **Boletos defectuosos** (dados de baja)
   - **Talonarios en circulación**
   - **Diferencias detectadas**
5. Incluye análisis:
   - Consumo promedio diario
   - Proyección de reabastecimiento
   - Series más utilizadas
   - Tasa de boletos defectuosos
6. Revisa y valida información
7. Exporta reporte (PDF, Excel)
8. Distribuye a:
   - Gerencia Operaciones
   - Jefe de Contabilidad
   - Jefe de Liquidador
9. Archiva reporte para auditoría

**Postcondiciones:**
- Reporte de movimientos generado
- Análisis de consumo disponible
- Información distribuida a stakeholders
- Archivo almacenado para control



### **CU-COS-007: Coordinar con Proveedores**

**ID:** CU-COS-007

**Actor:** Coordinador de Suministros

**Precondiciones:**
- Stock bajo o agotándose
- Proveedores autorizados registrados
- Presupuesto aprobado para compra

**Trigger:** 
Alerta de stock mínimo o planificación de reabastecimiento

**Flujo Principal:**
1. Coordinador detecta necesidad de reabastecimiento:
   - Alerta automática del sistema (stock < mínimo)
   - Proyección de consumo indica agotamiento
2. Calcula cantidad a solicitar:
   - Consumo promedio mensual
   - Stock de seguridad requerido
   - Capacidad de almacenamiento
3. Revisa especificaciones de boletos:
   - Series requeridas (A, B, C, etc.)
   - Rangos de numeración deseados
   - Características técnicas (papel, impresión, medidas)
4. Contacta a proveedores autorizados:
   - Solicita cotizaciones
   - Especifica cantidad y características
   - Consulta tiempos de entrega
5. Compara ofertas:
   - Precio por talonario/millar
   - Calidad ofrecida
   - Tiempo de entrega
   - Condiciones de pago
6. Selecciona proveedor y emite orden de compra:
   - Cantidad exacta
   - Especificaciones técnicas
   - Fecha de entrega requerida
   - Condiciones acordadas
7. Realiza seguimiento del pedido:
   - Confirma producción
   - Verifica avance
   - Coordina fecha de entrega
8. Recibe notificación de despacho del proveedor
9. Coordina recepción en almacén:
   - Fecha y hora
   - Personal para descarga
   - Espacio de almacenamiento
10. Registra orden de compra en sistema para control

**Postcondiciones:**
- Orden de compra emitida a proveedor
- Pedido en seguimiento
- Fecha de entrega coordinada
- Recepción planificada
- Registro en sistema actualizado



### **CU-COS-008: Validar Calidad de Boletos**

**ID:** CU-COS-008

**Actor:** Coordinador de Suministros

**Precondiciones:**
- Boletos recibidos de proveedor
- Orden de compra original disponible
- Especificaciones técnicas definidas

**Trigger:** 
Recepción de entrega de boletos del proveedor

**Flujo Principal:**
1. Coordinador recibe entrega del proveedor
2. Verifica documentación:
   - Guía de remisión
   - Factura
   - Orden de compra original
3. Confirma cantidad recibida:
   - Número de paquetes/cajas
   - Cantidad de talonarios
   - Total de boletos
4. Realiza inspección física de muestra:
   - Toma muestra aleatoria (10-20% de lote)
   - Verifica características:
     * **Calidad de papel**: grosor, resistencia
     * **Impresión**: claridad, legibilidad
     * **Numeración**: correlativa, sin duplicados
     * **Dimensiones**: según especificación
     * **Color**: según diseño aprobado
     * **Información impresa**: completa y correcta
5. Revisa integridad de talonarios:
   - Todos los boletos presentes
   - Numeración correlativa sin saltos
   - No hay boletos dañados en tránsito
6. Verifica series asignadas:
   - Coinciden con lo solicitado
   - No hay duplicación con stock existente
7. Si calidad es conforme:
   - Acepta recepción
   - Firma conformidad en guía
   - Registra ingreso en sistema
8. Si detecta problemas:
   - Documenta no conformidades (fotos, descripción)
   - Separa lote defectuoso
   - Notifica a proveedor
   - Inicia proceso de devolución o reposición
   - Registra incidencia
9. Almacena boletos aprobados:
   - Organiza por series
   - Etiqueta con fecha de recepción
   - Ubica en almacén según sistema
10. Actualiza inventario en sistema:
    - Ingresa nueva cantidad
    - Registra series y rangos
    - Actualiza stock disponible

**Postcondiciones:**
- Calidad de boletos validada
- Lote conforme almacenado y registrado
- No conformidades documentadas (si existen)
- Inventario actualizado con ingreso
- Trazabilidad de recepción completa
- Boletos listos para distribución



## INSPECTOR RECAUDO (si aplica)


### **CU-INR-001: Verificar Ventas en Ruta**

**ID:** CU-INR-001

**Actor:** Inspector de Recaudo

**Precondiciones:**
- Inspector autenticado y asignado a ruta
- Unidades operando en servicio
- Credenciales de identificación vigentes

**Trigger:** 
Inspector aborda unidad en servicio para supervisión

**Flujo Principal:**
1. Inspector aborda unidad en paradero autorizado
2. Se identifica ante conductor mostrando credencial
3. Observa proceso de cobranza durante recorrido:
   - Pasajeros que abordan
   - Conductor/cobrador solicitando pasaje
   - Entrega de boletos
   - Manejo de vueltos
4. Verifica método de cobro usado:
   - **Con ticketera**: funcionamiento correcto
   - **Boletos físicos**: entrega de talonario
5. Solicita revisar a pasajeros:
   - Boletos recibidos
   - Validez de boletos
   - Tarifas cobradas
6. Cuenta pasajeros en el vehículo
7. Cruza con boletos vendidos/validados:
   - Consulta contador de ticketera (si aplica)
   - Verifica boletos físicos entregados
8. Identifica discrepancias:
   - Pasajeros sin boleto
   - Boletos no entregados
   - Cobros no registrados
9. Registra observaciones en dispositivo móvil/libreta:
   - Hora de inspección
   - Unidad inspeccionada
   - Conductor
   - Hallazgos
10. Si detecta irregularidades, procede según CU-INR-005

**Postcondiciones:**
- Proceso de venta verificado
- Observaciones registradas
- Irregularidades identificadas (si existen)
- Conductor informado de inspección
- Reporte preliminar disponible



### **CU-INR-002: Controlar Tarifas Aplicadas**

**ID:** CU-INR-002

**Actor:** Inspector de Recaudo

**Precondiciones:**
- Inspector en ruta supervisando
- Tarifas oficiales vigentes conocidas
- Tipos de tarifa autorizados definidos

**Trigger:** 
Verificación de cobros durante inspección en ruta

**Flujo Principal:**
1. Inspector consulta tarifario oficial vigente:
   - Tarifa regular (adultos)
   - Tarifa universitaria
   - Tarifa escolar
   - Tarifa adulto mayor
   - Tarifa personas con discapacidad
2. Durante inspección, solicita a pasajeros:
   - Ver boleto recibido
   - Indicar monto pagado
3. Verifica tarifa cobrada:
   - Compara monto en boleto vs tarifa oficial
   - Confirma aplicación correcta de descuentos
4. Solicita documentación a pasajeros con tarifa especial:
   - Carnet universitario vigente
   - Carnet escolar
   - DNI (adulto mayor >65 años)
   - Carnet CONADIS (discapacidad)
5. Valida que descuentos aplicados sean legítimos:
   - Documentación vigente
   - Correspondencia con tarifa aplicada
6. Si detecta cobro incorrecto:
   - **Sobrecobro**: tarifa mayor a la oficial
   - **Descuento indebido**: aplicado sin documentación
7. Documenta hallazgo:
   - Pasajero afectado
   - Tarifa cobrada vs tarifa correcta
   - Diferencia de monto
8. Informa al conductor del error detectado
9. Si es error recurrente o intencional:
   - Registra como irregularidad
   - Escala según gravedad
10. Genera reporte de control de tarifas

**Postcondiciones:**
- Tarifas aplicadas verificadas
- Cobros incorrectos identificados
- Documentación de descuentos validada
- Conductor notificado de errores
- Reporte de tarifas generado



### **CU-INR-003: Detectar Evasión de Pago**

**ID:** CU-INR-003

**Actor:** Inspector de Recaudo

**Precondiciones:**
- Inspector realizando supervisión en ruta
- Unidad con pasajeros a bordo
- Capacidad para verificar boletos

**Trigger:** 
Inspección sorpresa en unidad operando

**Flujo Principal:**
1. Inspector aborda unidad en operación
2. Se identifica y anuncia inspección de boletos
3. Solicita a todos los pasajeros mostrar boleto:
   - Boleto físico
   - Validación en ticketera
   - Comprobante digital (si aplica)
4. Revisa cada boleto presentado:
   - Validez del boleto
   - Fecha y hora de emisión
   - Corresponde al servicio actual
5. Identifica pasajeros sin boleto válido:
   - No presenta boleto
   - Boleto de otro día/servicio
   - Boleto usado previamente
6. Para cada evasor detectado:
   - Solicita explicación
   - Verifica si abordó recientemente (no le dio tiempo de pagar)
   - Confirma intención de evasión
7. Aplica procedimiento según política:
   - Solicita pago inmediato del pasaje
   - Registra datos del evasor (DNI)
   - Emite papeleta de infracción (si aplica)
   - Puede solicitar descenso del pasajero
8. Calcula tasa de evasión:
   - Total pasajeros vs pasajeros con boleto válido
   - Porcentaje de evasión = (Evasores / Total) × 100
9. Registra en sistema:
   - Unidad inspeccionada
   - Hora y paradero
   - Cantidad de pasajeros
   - Cantidad de evasores
   - Monto de ingresos perdidos
   - Acción tomada
10. Si tasa de evasión es alta, investiga causas:
    - Conductor no solicita pago
    - Ticketera no funciona
    - Puerta trasera permite ingreso sin pago

**Postcondiciones:**
- Evasión detectada y cuantificada
- Evasores identificados y sancionados
- Tasa de evasión calculada
- Causas identificadas
- Reporte de evasión generado
- Seguimiento establecido para unidad/conductor



### **CU-INR-004: Auditar Ticketeras**

**ID:** CU-INR-004

**Actor:** Inspector de Recaudo

**Precondiciones:**
- Inspector con acceso técnico a ticketeras
- Unidad equipada con ticketera
- Credenciales de auditoría configuradas

**Trigger:** 
Auditoría programada o inspección de funcionamiento

**Flujo Principal:**
1. Inspector solicita al conductor acceso a ticketera
2. Verifica estado físico del equipo:
   - Pantalla funcional
   - Botones operativos
   - Lector de tarjetas (si aplica)
   - Impresora de boletos
3. Accede a modo auditoría con credenciales:
   - Ingresa código de inspector
   - Sistema muestra menú de auditoría
4. Consulta información de operación:
   - Total de transacciones del día
   - Monto acumulado
   - Última transacción registrada
   - Boletos vendidos por tipo de tarifa
5. Verifica sincronización:
   - Última sincronización con servidor central
   - Datos pendientes de envío
   - Errores de comunicación
6. Revisa configuración:
   - Tarifas programadas correctas
   - Fecha y hora del dispositivo
   - Número de unidad asignado
7. Realiza prueba de funcionamiento:
   - Simula venta de boleto
   - Verifica impresión correcta
   - Confirma registro en sistema
8. Revisa papel de impresión:
   - Nivel de papel suficiente
   - Calidad de impresión adecuada
9. Si detecta problemas:
   - **Técnicos**: falla de hardware/software
   - **Configuración**: datos incorrectos
   - **Sincronización**: datos no transmitidos
10. Documenta hallazgos:
    - Estado de ticketera (operativa/defectuosa)
    - Problemas encontrados
    - Acción correctiva requerida
11. Genera ticket de soporte (si requiere reparación)
12. Notifica a conductor y central de monitoreo

**Postcondiciones:**
- Ticketera auditada
- Funcionamiento verificado
- Problemas técnicos identificados
- Ticket de soporte generado (si aplica)
- Reporte de auditoría registrado
- Seguimiento establecido para reparación



### **CU-INR-005: Reportar Irregularidades**

**ID:** CU-INR-005

**Actor:** Inspector de Recaudo

**Precondiciones:**
- Inspector ha detectado irregularidad durante inspección
- Evidencia documentada (fotos, testimonios, datos)
- Sistema de reporte disponible

**Trigger:** 
Detección de fraude o mala práctica durante supervisión

**Flujo Principal:**
1. Inspector identifica tipo de irregularidad:
   - **Fraude en recaudación**: conductor no registra ventas
   - **Cobro indebido**: sobreprecio a pasajeros
   - **Evasión sistemática**: conductor permite abordaje sin pago
   - **Boletos falsos**: uso de boletos no autorizados
   - **Ticketera manipulada**: alteración de dispositivo
   - **Descuentos fraudulentos**: aplicación incorrecta
2. Recopila evidencia:
   - Fotografías del hecho
   - Registro de transacciones
   - Testimonios de pasajeros
   - Datos de ticketera
   - Boletos físicos como prueba
3. Accede a sistema de reportes desde dispositivo móvil
4. Crea reporte de irregularidad:
   - Tipo de irregularidad
   - Fecha, hora y ubicación
   - Unidad involucrada
   - Conductor/cobrador involucrado
   - Descripción detallada del hecho
5. Adjunta evidencia recopilada:
   - Fotos
   - Videos
   - Documentos escaneados
6. Clasifica gravedad:
   - **Leve**: error no intencional
   - **Moderada**: incumplimiento de procedimiento
   - **Grave**: fraude evidente
   - **Crítica**: fraude sistemático o monto significativo
7. Calcula impacto económico (si aplica):
   - Monto de ingresos no registrados
   - Pasajeros evadidos
   - Pérdida estimada
8. Registra acciones tomadas en campo:
   - Advertencia verbal al conductor
   - Suspensión temporal del servicio
   - Retención de boletos falsos
9. Envía reporte a:
   - Jefe de Inspectores
   - Jefe de Liquidador
   - Gerencia de Operaciones (si es grave)
10. Sistema genera número de caso único
11. Establece seguimiento del caso

**Postcondiciones:**
- Irregularidad documentada completamente
- Evidencia archivada en sistema
- Reporte enviado a autoridades correspondientes
- Número de caso asignado
- Seguimiento establecido
- Conductor/unidad marcado para investigación



### **CU-INR-006: Capacitar Personal**

**ID:** CU-INR-006

**Actor:** Inspector de Recaudo

**Precondiciones:**
- Inspector con experiencia y autorización para capacitar
- Personal a capacitar identificado (conductores, cobradores)
- Material de capacitación preparado
- Espacio y tiempo asignado

**Trigger:** 
Programa de capacitación o necesidad detectada de entrenamiento

**Flujo Principal:**
1. Inspector recibe asignación de capacitación:
   - Personal a capacitar (nuevos o con deficiencias)
   - Temas específicos a cubrir
   - Fecha y lugar
2. Prepara contenido de capacitación:
   - **Procedimientos de recaudo**:
     * Solicitud correcta de pasaje
     * Entrega de boletos
     * Manejo de vueltos
   - **Uso de ticketera**:
     * Encendido y apagado
     * Venta de boletos
     * Aplicación de tarifas especiales
     * Resolución de problemas básicos
   - **Boletos físicos**:
     * Control de talonarios
     * Registro de ventas
     * Devolución de sobrantes
   - **Tarifas diferenciadas**:
     * Tipos de tarifa
     * Validación de documentos
     * Aplicación correcta de descuentos
   - **Prevención de fraude**:
     * Detección de billetes falsos
     * Manejo de situaciones conflictivas
     * Evasión de pasajeros
3. Realiza sesión de capacitación:
   - Presentación teórica (normativa, procedimientos)
   - Demostración práctica (uso de ticketera, manejo de efectivo)
   - Ejercicios simulados (casos reales)
   - Sesión de preguntas y respuestas
4. Capacitación específica por tema:
   - **Nuevos conductores**: procedimientos completos
   - **Reforzamiento**: temas con deficiencias detectadas
   - **Actualización**: cambios en tarifas o procedimientos
5. Evalúa comprensión:
   - Preguntas de verificación
   - Ejercicio práctico evaluado
   - Simulación de situaciones
6. Proporciona material de referencia:
   - Manual de procedimientos
   - Tarifario vigente
   - Contactos de soporte
7. Registra capacitación en sistema:
   - Personal capacitado (nombre, DNI)
   - Temas cubiertos
   - Fecha de capacitación
   - Resultado de evaluación
   - Observaciones
8. Si personal no aprueba:
   - Programa re-capacitación
   - Identifica áreas de mejora
   - Notifica a supervisor
9. Emite certificado de capacitación (si aprueba)
10. Programa seguimiento en campo:
    - Inspección posterior para verificar aplicación
    - Retroalimentación adicional

**Postcondiciones:**
- Personal capacitado en procedimientos de recaudo
- Evaluación de comprensión completada
- Capacitación registrada en sistema
- Certificado emitido (si aprueba)
- Material de referencia entregado
- Seguimiento programado para verificar aplicación


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