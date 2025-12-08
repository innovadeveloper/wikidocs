## JEFE DE SUMINISTRO

```sh
sequenceDiagram
    participant CS as 🎟️ Coordinador Suministros
    participant SYS as 💻 Sistema
    participant CAJ as 💰 Cajeros
    participant PROV as 🏪 Proveedores
    participant ALM as 📦 Almacén

    Note over CS,ALM: 📅 DÍA ANTERIOR (Tarde/Noche)
    
    CS->>SYS: 1. Consulta programación día siguiente
    SYS-->>CS: Unidades programadas (BUS-245, BUS-189, etc.)
    CS->>SYS: 2. Revisa stock disponible
    SYS-->>CS: Talonarios disponibles por serie
    CS->>SYS: 3. Asigna talonarios por unidad
    SYS-->>CS: ✅ Asignación confirmada
    CS->>CS: 4. Genera lista de distribución

    Note over CS,ALM: 🌙 MADRUGADA (3:00-5:00 AM)
    
    CS->>ALM: 5. Localiza talonarios asignados
    CS->>CS: 6. Prepara tapers/bolsas etiquetados
    CAJ->>CS: 7. Cajeros llegan (4-5 AM)
    CS->>CAJ: 8. Entrega tapers por zona/turno
    CAJ-->>CS: Firma acta de recepción
    CS->>SYS: 9. Registra entrega masiva
    SYS-->>CS: ✅ Talonarios marcados "En circulación"

    Note over CS,ALM: ☀️ DURANTE EL DÍA
    
    CAJ->>CS: 10. Devuelve talonarios sobrantes
    CS->>CS: 11. Inspecciona devolución
    CS->>SYS: 12. Registra devolución
    SYS-->>CS: Stock actualizado
    
    CS->>SYS: 13. Revisa nivel de stock
    SYS-->>CS: ⚠️ Alerta: Stock Serie A bajo
    
    Note over CS,PROV: 📞 COORDINACIÓN PROVEEDORES
    
    CS->>PROV: 14. Solicita cotización
    PROV-->>CS: Cotización recibida
    CS->>PROV: 15. Emite orden de compra
    PROV-->>CS: Confirma producción
    
    Note over CS,ALM: 📦 RECEPCIÓN DE PEDIDO
    
    PROV->>CS: 16. Notifica despacho
    CS->>CS: 17. Valida calidad y cantidad
    CS->>SYS: 18. Registra ingreso al almacén
    SYS-->>CS: ✅ Stock actualizado

    Note over CS,SYS: 📊 FIN DE PERÍODO
    
    CS->>SYS: 19. Genera reporte de movimientos
    SYS-->>CS: Reporte con análisis de consumo
```


## RECAUDADOR


```sh
sequenceDiagram
    participant CAJ as 💰 Cajero Principal (Recaudador/Liquidador)
    participant SYS as 💻 Sistema
    participant COS as 🎟️ Coordinador Suministros
    participant COND as 🚗 Conductor
    participant JLI as 📊 Jefe Liquidador
    participant BANCO as 🏦 Banco

    Note over CAJ,BANCO: 🌅 INICIO DE TURNO (4:00-5:00 AM)
    
    CAJ->>SYS: 1. Login y abrir caja de recaudo
    SYS-->>CAJ: ✅ Caja abierta (CodCaja generado)
    CAJ->>CAJ: 2. Registrar fondo inicial
    
    COS->>CAJ: 3. Entrega tapers/bolsas con talonarios
    CAJ->>CAJ: 4. Verifica contenido de tapers
    CAJ->>SYS: 5. Confirma recepción de talonarios
    SYS-->>CAJ: Talonarios registrados para distribución

    Note over CAJ,COND: ☀️ DURANTE EL DÍA (Entregas Parciales)
    
    loop Por cada vuelta del conductor
        COND->>CAJ: 6. Se presenta con efectivo de vuelta
        CAJ->>SYS: 7. Verifica identidad del conductor
        COND->>CAJ: 8. Entrega efectivo recaudado
        
        alt Unidad CON ticketera
            CAJ->>SYS: 9a. Consulta reporte digital de ticketera
            SYS-->>CAJ: Producción digital registrada
        else Unidad SIN ticketera (boletos físicos)
            COND->>CAJ: 9b. Entrega también talonario
            CAJ->>CAJ: Cuenta boletos vendidos manualmente
        end
        
        CAJ->>CAJ: 10. Cuenta efectivo recibido
        CAJ->>COND: 11. Emite comprobante temporal
        CAJ->>SYS: 12. Registra entrega parcial
        SYS-->>CAJ: ✅ Entrega registrada
        CAJ->>CAJ: 13. Guarda efectivo separado por conductor
    end

    Note over CAJ,COND: 🎫 ENTREGA DE TALONARIOS (Antes de salida)
    
    COND->>CAJ: 14. Solicita talonario para su unidad
    CAJ->>CAJ: 15. Busca taper de la unidad
    CAJ->>CAJ: 16. Verifica: serie, rango, estado físico
    CAJ->>SYS: 17. Registra entrega (ProcAlmacenBoleto)
    SYS-->>CAJ: Talonario marcado "Asignado"
    COND->>CAJ: 18. Firma recepción
    CAJ->>COND: 19. Entrega talonario físicamente
    
    Note over CAJ,COND: 🌆 FIN DE TURNO (Liquidación)
    
    COND->>CAJ: 20. Se presenta para liquidación final
    CAJ->>SYS: 21. Cierra caja del conductor
    
    alt CON ticketera
        SYS->>CAJ: 22a. Consolida producción digital
    else SIN ticketera
        CAJ->>SYS: 22b. Crea CCU manual (ProcRecaudoV2)
        CAJ->>SYS: Registra producción por conteo físico
    end
    
    CAJ->>SYS: 23. Consulta gastos administrativos
    SYS-->>CAJ: Gastos: combustible, peajes, multas, etc.
    
    CAJ->>SYS: 24. Calcula liquidación final
    SYS-->>CAJ: Desglose completo: Producción - Gastos = Neto
    
    CAJ->>COND: 25. Muestra desglose al conductor
    
    alt Conductor conforme
        COND-->>CAJ: ✅ Acepta liquidación
        CAJ->>SYS: 26. Genera comprobante
        SYS-->>CAJ: Comprobante en duplicado
        CAJ->>CAJ: 27. Imprime comprobante
        CAJ->>COND: 28. Entrega efectivo + comprobante
        COND->>CAJ: 29. Firma comprobante
    else Conductor en desacuerdo
        COND-->>CAJ: ❌ Rechaza liquidación
        CAJ->>JLI: 30. Escala conflicto al Jefe Liquidador
        JLI->>JLI: Revisa caso y media
        JLI-->>CAJ: Decisión final
    end

    Note over CAJ,COND: 🔄 DEVOLUCIONES DE BOLETOS
    
    COND->>CAJ: 31. Devuelve talonario sobrante
    CAJ->>CAJ: 32. Inspecciona estado (sobrantes/defectuosos)
    CAJ->>SYS: 33. Registra devolución
    SYS-->>CAJ: Stock actualizado

    Note over CAJ,BANCO: 🌙 CIERRE DE CAJA DIARIA
    
    CAJ->>CAJ: 34. Suma todo efectivo recibido
    CAJ->>CAJ: 35. Resta liquidaciones pagadas
    CAJ->>SYS: 36. Consulta total digital registrado
    SYS-->>CAJ: Total de entregas y pagos
    
    CAJ->>CAJ: 37. Cuenta físicamente la caja
    
    alt Caja cuadrada
        CAJ->>SYS: 38a. Registra cierre exitoso
    else Diferencia encontrada
        CAJ->>CAJ: 38b. Revisa transacción por transacción
        CAJ->>SYS: Documenta diferencia y justificación
    end
    
    CAJ->>CAJ: 39. Prepara efectivo para depósito
    CAJ->>CAJ: 40. Sella bolsa de seguridad
    CAJ->>BANCO: 41. Traslada y deposita efectivo
    BANCO-->>CAJ: Voucher de depósito
    CAJ->>SYS: 42. Registra depósito bancario
    SYS-->>CAJ: ✅ Depósito vinculado al cierre

    Note over CAJ,SYS: 📊 REPORTES Y ADMINISTRACIÓN
    
    CAJ->>SYS: 43. Genera reporte diario
    SYS-->>CAJ: Resumen de operaciones del día
    CAJ->>JLI: 44. Entrega reporte al Jefe Liquidador
    
    alt Caja chica requiere reposición
        CAJ->>SYS: 45. Solicita reposición de caja chica
        CAJ->>JLI: Presenta rendición con comprobantes
    end


```


## JEFE DE LIQUIDACION

```sh
sequenceDiagram
    participant JLI as 📊 Jefe de Liquidación
    participant SYS as 💻 Sistema
    participant CAJ as 💰 Cajero/Liquidador
    participant COND as 🚗 Conductor
    participant PROP as 🏠 Propietario
    participant GER as 👔 Gerencia

    Note over JLI,GER: 🌅 INICIO DE TURNO
    
    JLI->>SYS: 1. Login y acceso a dashboard
    SYS-->>JLI: Panel de supervisión de liquidaciones
    JLI->>SYS: 2. Revisa estado operativo del día
    SYS-->>JLI: Liquidadores activos, cajas abiertas
    
    Note over JLI,CAJ: ☀️ SUPERVISIÓN CONTINUA (Durante el día)
    
    loop Monitoreo en tiempo real
        JLI->>SYS: 3. Consulta dashboard de liquidaciones
        SYS-->>JLI: Estado actual: • En proceso: 5 • Completadas: 12 • Con alertas: 2
        
        JLI->>SYS: 4. Revisa indicadores clave
        SYS-->>JLI: KPIs en tiempo real: • Tiempo promedio: 8 min • Sin diferencias: 85% • Casos escalados: 3
        
        alt Detecta anomalía
            SYS->>JLI: ⚠️ Alerta: Diferencia significativa
            JLI->>SYS: 5. Investiga liquidación específica
            SYS-->>JLI: Detalle del caso
            JLI->>CAJ: 6. Solicita explicación
            CAJ-->>JLI: Justificación del caso
            
            alt Requiere intervención
                JLI->>JLI: 7. Analiza evidencia
                JLI->>CAJ: Ordena corrección
            else Justificación aceptable
                JLI->>SYS: Aprueba con observación
            end
        end
    end

    Note over JLI,COND: ⚖️ RESOLUCIÓN DE CONFLICTOS
    
    CAJ->>JLI: 8. Escala conflicto con conductor
    JLI->>SYS: 9. Revisa caso escalado
    SYS-->>JLI: Historial completo: • Liquidación cuestionada • Posición del conductor • Evidencia del liquidador
    
    JLI->>CAJ: 10. Convoca reunión de mediación
    JLI->>COND: Convoca al conductor
    
    rect rgb(255, 245, 220)
        Note over JLI,COND: REUNIÓN DE MEDIACIÓN
        COND->>JLI: 11. Expone su versión
        CAJ->>JLI: 12. Expone su versión
        JLI->>JLI: 13. Revisa evidencia: • Reportes ticketera • Boletos físicos • Gastos registrados
    end
    
    JLI->>SYS: 14. Consulta historial del conductor
    SYS-->>JLI: Patrones de producción histórica
    
    alt Decisión a favor del conductor
        JLI->>SYS: 15a. Autoriza ajuste de liquidación
        SYS-->>CAJ: Orden de corrección
        CAJ->>COND: Pago adicional
    else Decisión a favor del liquidador
        JLI->>COND: 15b. Explica razones, mantiene original
    else Solución intermedia
        JLI->>JLI: 15c. Negocia acuerdo
        JLI->>SYS: Registra ajuste parcial
    end
    
    JLI->>SYS: 16. Documenta resolución
    SYS-->>JLI: ✅ Conflicto cerrado

    Note over JLI,SYS: 📝 REGISTRO DE GASTOS ADMINISTRATIVOS
    
    JLI->>SYS: 17. Accede a módulo de gastos
    JLI->>JLI: 18. Procesa documentos recibidos: • Combustible • Mantenimiento • Multas • Peajes
    
    loop Por cada gasto
        JLI->>SYS: 19. Registra gasto administrativo
        JLI->>SYS: 20. Adjunta comprobante digitalizado
        JLI->>SYS: 21. Define responsable del descuento
        
        alt Monto normal
            SYS-->>JLI: ✅ Gasto registrado
        else Monto excesivo
            SYS->>JLI: ⚠️ Excede límite establecido
            JLI->>GER: 22. Solicita autorización especial
            GER-->>JLI: Aprobación gerencial
        end
        
        SYS->>SYS: 23. Vincula gasto a próxima liquidación
    end

    Note over JLI,CAJ: 🔍 REVISIÓN POST-LIQUIDACIÓN
    
    loop Auditoría de calidad
        JLI->>SYS: 24. Selecciona liquidaciones completadas
        SYS-->>JLI: Detalle de liquidaciones del día
        
        JLI->>JLI: 25. Verifica cálculos matemáticos
        JLI->>JLI: 26. Valida coherencia de datos
        
        alt Error encontrado
            JLI->>SYS: 27a. Marca para corrección
            JLI->>CAJ: Notifica al liquidador responsable
            CAJ-->>JLI: Corrección aplicada
        else Liquidación correcta
            JLI->>SYS: 27b. Aprueba y valida
            SYS-->>JLI: ✅ Liquidación validada
        end
    end

    Note over JLI,PROP: 💰 LIQUIDACIÓN A PROPIETARIOS
    
    JLI->>SYS: 28. Accede a módulo de propietarios
    JLI->>SYS: 29. Selecciona período (día/semana/mes)
    JLI->>SYS: 30. Selecciona unidad(es) del propietario
    
    SYS->>SYS: 31. Consolida datos: • Producción total • Gastos administrativos • Porcentaje propietario (70%)
    
    SYS-->>JLI: Cálculo preliminar: Producción: $2,500 Gastos: -$350 Neto: $2,150 Propietario (70%): $1,505
    
    JLI->>JLI: 32. Verifica gastos deducibles
    JLI->>SYS: 33. Genera desglose detallado
    
    JLI->>PROP: 34. Contacta al propietario
    JLI->>PROP: 35. Presenta resultados del período
    
    alt Propietario conforme
        PROP-->>JLI: ✅ Acepta liquidación
        JLI->>JLI: 36a. Coordina forma de pago
        JLI->>SYS: Programa fecha de pago
        JLI->>PROP: 37. Gestiona pago (efectivo/transferencia)
        PROP->>JLI: Firma conformidad
    else Propietario objeta
        PROP-->>JLI: ❌ Tiene objeciones
        JLI->>JLI: 36b. Documenta desacuerdos
        JLI->>SYS: Revisa en detalle cuestionamientos
        
        alt Objeción válida
            JLI->>SYS: Autoriza ajuste
        else Objeción no válida
            JLI->>PROP: Explica y justifica
        else Requiere escalamiento
            JLI->>GER: Escala a gerencia
        end
    end
    
    JLI->>SYS: 38. Archiva documentación completa
    SYS-->>JLI: ✅ Propietario liquidado

    Note over JLI,GER: 🚨 AUTORIZACIÓN DE AJUSTES ESPECIALES
    
    CAJ->>JLI: 39. Solicita ajuste excepcional
    JLI->>SYS: 40. Revisa documentación de respaldo
    SYS-->>JLI: Liquidación original + evidencia
    
    JLI->>JLI: 41. Valida necesidad del ajuste: • Error comprobado • Impacto económico • Plazo permitido
    
    alt Ajuste menor a límite
        JLI->>SYS: 42a. Autoriza directamente
        SYS->>SYS: Ejecuta ajuste automático
    else Ajuste excede límite
        JLI->>GER: 42b. Solicita aprobación gerencial
        GER-->>JLI: Decisión gerencial
        
        alt Gerencia aprueba
            JLI->>SYS: Autoriza ajuste excepcional
        else Gerencia rechaza
            JLI->>CAJ: Comunica rechazo con justificación
        end
    end
    
    JLI->>SYS: 43. Registra autorización completa
    SYS->>SYS: 44. Modifica liquidación original
    SYS->>SYS: 45. Genera nota de crédito/débito
    JLI->>CAJ: 46. Notifica ejecución del ajuste
    JLI->>COND: Notifica al conductor afectado

    Note over JLI,GER: 📊 REPORTES Y CIERRE DIARIO
    
    JLI->>SYS: 47. Genera reporte diario de liquidaciones
    SYS-->>JLI: Reporte consolidado: • Total liquidaciones: 45 • Producción total: $12,850 • Diferencias: 8% promedio • Conflictos resueltos: 3
    
    JLI->>SYS: 48. Exporta reportes (PDF/Excel)
    JLI->>GER: 49. Distribuye a Gerencia
    JLI->>SYS: 50. Distribuye a Contabilidad
    
    JLI->>JLI: 51. Analiza KPIs del día: • Eficiencia liquidadores • Calidad de procesos • Áreas de mejora
    
    JLI->>SYS: 52. Archiva reportes para auditoría
    SYS-->>JLI: ✅ Reportes almacenados
    
    JLI->>SYS: 53. Cierre de supervisión del día
    SYS-->>JLI: ✅ Día cerrado correctamente
```

## ANALISTA PERSONAL

```sh
sequenceDiagram
    participant ANP as 👤 Analista Personal
    participant SYS as 💻 Sistema
    participant CAND as 🚶 Candidato/ Conductor
    participant ESD as 📑 Especialista Documentos
    participant JRH as 📋 Jefe RRHH

    Note over ANP,JRH: 📝 PROCESO DE CONTRATACIÓN (Nuevo Conductor)
    
    CAND->>ANP: 1. Solicita empleo como conductor
    ANP->>SYS: 2. Crea nuevo registro de candidato
    SYS-->>ANP: Formulario de registro activado
    
    ANP->>CAND: 3. Solicita información personal
    CAND-->>ANP: Entrega datos personales y CV
    
    ANP->>SYS: 4. Registra datos básicos del candidato
    ANP->>SYS: Ingresa: • DNI/Identificación • Nombre completo • Dirección • Teléfonos • Experiencia laboral
    SYS-->>ANP: ✅ Candidato registrado (CodPersona)
    
    ANP->>CAND: 5. Solicita documentación obligatoria
    
    rect rgb(255, 245, 220)
        Note over ANP,CAND: DOCUMENTACIÓN REQUERIDA (14 documentos)
        CAND->>ANP: 6. Entrega documentos: • Licencia de conducir • Certificado médico • Antecedentes penales/policiales • Certificados laborales • Etc.
    end
    
    ANP->>ESD: 7. Deriva documentos para validación
    ESD->>SYS: 8. Verifica y valida cada documento
    
    alt Documentación completa y válida
        ESD-->>ANP: ✅ Documentación aprobada
        ANP->>SYS: 9. Actualiza estado: "Documentación OK"
    else Documentación incompleta
        ESD-->>ANP: ❌ Faltan documentos o tienen problemas
        ANP->>CAND: 10. Solicita documentos faltantes/correcciones
        CAND-->>ANP: Entrega documentos corregidos
        ANP->>ESD: Re-envía para validación
    end
    
    ANP->>SYS: 11. Genera expediente digital completo
    SYS-->>ANP: Expediente creado en TbPersona
    
    ANP->>JRH: 12. Envía expediente para aprobación
    JRH->>SYS: 13. Revisa expediente del candidato
    
    alt Jefe RRHH aprueba
        JRH->>SYS: 14a. Aprueba contratación
        SYS-->>ANP: ✅ Contratación autorizada
        ANP->>SYS: 15. Cambia estado a "ACTIVO"
        ANP->>CAND: 16. Notifica aprobación e inducción
    else Jefe RRHH rechaza
        JRH->>SYS: 14b. Rechaza contratación
        SYS-->>ANP: ❌ Contratación denegada
        ANP->>CAND: Notifica rechazo con motivos
    end

    Note over ANP,SYS: 📊 GESTIÓN DE PERSONAL ACTIVO
    
    loop Actualización de expedientes
        ANP->>SYS: 17. Accede a expediente de conductor
        
        alt Cambio de datos personales
            ANP->>SYS: 18a. Actualiza información: • Dirección • Teléfono • Estado civil • Contacto emergencia
            SYS->>SYS: Registra historial de cambios
            SYS-->>ANP: ✅ Datos actualizados
        
        else Renovación de documentos
            ANP->>ESD: 18b. Coordina renovación de doc.
            ESD->>SYS: Gestiona renovación
            SYS-->>ANP: Documento actualizado
        end
    end

    Note over ANP,CAND: 🏖️ ADMINISTRACIÓN DE VACACIONES Y PERMISOS
    
    COND->>ANP: 19. Solicita vacaciones/permiso
    ANP->>SYS: 20. Registra solicitud
    SYS-->>ANP: Días disponibles: 15 días
    
    ANP->>ANP: 21. Verifica disponibilidad: • Días acumulados • Operación no afectada • Reemplazos disponibles
    
    alt Solicitud aprobada
        ANP->>SYS: 22a. Aprueba vacaciones/permiso
        ANP->>SYS: Registra período: Inicio: 15/12/2024 Fin: 29/12/2024
        SYS-->>COND: ✅ Permiso aprobado
        
        ANP->>SYS: 23. Actualiza disponibilidad del conductor
        SYS-->>ANP: Conductor marcado como NO DISPONIBLE
        
    else Solicitud rechazada
        ANP->>COND: 22b. Explica motivo de rechazo
        ANP->>COND: Sugiere fechas alternativas
    end
    
    ANP->>SYS: 24. Genera reporte de permisos/vacaciones
    SYS-->>ANP: Reporte del período generado

    Note over ANP,JRH: 📈 REPORTES Y SEGUIMIENTO
    
    JRH->>ANP: 25. Solicita reporte de personal
    ANP->>SYS: 26. Genera reporte solicitado: • Conductores activos • Nuevas contrataciones • Bajas del período • Vacaciones programadas
    SYS-->>ANP: Reporte consolidado
    ANP->>JRH: 27. Entrega reporte
```

## ESPECIALISTA DOCUMENTOS

```sh
sequenceDiagram
    participant ESD as 📑 Especialista<br/>Documentos
    participant SYS as 💻 Sistema
    participant COND as 🚗 Conductor
    participant API as 🌐 APIs<br/>Externas
    participant AUT as 🏛️ Autoridades

    Note over ESD,AUT: 🔍 VERIFICACIÓN DE DOCUMENTACIÓN (Nuevo ingreso)
    
    ESD->>SYS: 1. Accede a expediente del conductor
    SYS-->>ESD: Lista de 14 documentos obligatorios
    
    loop Por cada documento (14 total)
        ESD->>ESD: 2. Recibe documento físico/digital
        
        alt Documento de Identidad (DNI)
            ESD->>SYS: 3a. Escanea DNI con OCR
            SYS->>API: Consulta RENIEC
            API-->>SYS: Datos verificados
            
            alt DNI válido
                SYS-->>ESD: ✅ DNI verificado
                ESD->>SYS: Marca como VÁLIDO
            else DNI inválido
                SYS-->>ESD: ❌ DNI no válido
                ESD->>COND: Solicita documento correcto
            end
            
        else Licencia de Conducir
            ESD->>SYS: 3b. Verifica licencia
            ESD->>ESD: Valida:<br/>• Categoría (A-IIa mínimo)<br/>• Vigencia<br/>• Puntos (mín. 75)
            SYS->>API: Consulta MTC
            API-->>SYS: Estado de licencia
            
            alt Licencia OK
                ESD->>SYS: Registra datos de licencia
                SYS-->>ESD: ✅ Licencia válida
            else Licencia con problemas
                ESD->>COND: Notifica problema:<br/>• Vencida<br/>• Puntos insuficientes<br/>• Categoría incorrecta
            end
            
        else Certificado Médico
            ESD->>ESD: 3c. Valida certificado médico
            ESD->>ESD: Verifica:<br/>• Fecha emisión<br/>• Vigencia (6 meses)<br/>• Centro autorizado<br/>• Resultados APTO
            
            alt Certificado válido
                ESD->>SYS: Registra fecha vencimiento
                SYS-->>ESD: ✅ Certificado registrado
                SYS->>SYS: Programa alerta: 30 días antes
            else Certificado inválido
                ESD->>COND: Solicita nuevo certificado
            end
            
        else Antecedentes Penales/Policiales
            ESD->>API: 3d. Consulta antecedentes
            API->>AUT: Consulta PNP/Poder Judicial
            AUT-->>API: Resultado de consulta
            API-->>ESD: Antecedentes recibidos
            
            alt Sin antecedentes
                ESD->>SYS: ✅ Antecedentes limpios
            else Con antecedentes
                ESD->>SYS: ⚠️ Registra antecedentes
                ESD->>ESD: Evalúa gravedad
                ESD->>SYS: Escala a Jefe RRHH
            end
        end
        
        ESD->>SYS: 4. Digitaliza documento
        SYS->>SYS: Almacena en expediente digital
        ESD->>SYS: 5. Actualiza estado del documento
    end
    
    ESD->>SYS: 6. Marca expediente como COMPLETO
    SYS-->>ESD: ✅ 14/14 documentos validados

    Note over ESD,SYS: ⚠️ GESTIÓN DE VENCIMIENTOS
    
    loop Monitoreo continuo (diario)
        SYS->>ESD: 7. Genera alertas automáticas
        SYS-->>ESD: Lista de documentos por vencer:<br/>• 30 días antes (amarillo)<br/>• 15 días antes (naranja)<br/>• 7 días antes (rojo)
        
        alt 30 días antes del vencimiento
            ESD->>COND: 8a. Notifica vencimiento próximo
            ESD->>COND: Email/SMS: "Tu licencia vence en 30 días"
            
        else 15 días antes
            ESD->>COND: 8b. Segunda notificación (urgente)
            ESD->>COND: "Renueva tu licencia - quedan 15 días"
            
        else 7 días antes
            ESD->>COND: 8c. Notificación crítica
            ESD->>SYS: Marca conductor como RIESGO
            ESD->>COND: "URGENTE: Renueva en 7 días o serás suspendido"
        end
    end

    Note over ESD,COND: 🔄 RENOVACIÓN DE DOCUMENTOS
    
    COND->>ESD: 9. Entrega documento renovado
    ESD->>ESD: 10. Valida nuevo documento
    
    alt Documento renovado correcto
        ESD->>SYS: 11a. Actualiza fecha de vencimiento
        SYS->>SYS: Cancela alertas anteriores
        SYS->>SYS: Programa nuevas alertas
        SYS-->>ESD: ✅ Documento actualizado
        ESD->>COND: Confirma renovación exitosa
        
    else Documento vencido/no renovado
        ESD->>SYS: 11b. Marca como VENCIDO
        SYS->>SYS: Bloquea conductor en sistema
        SYS-->>ESD: ⛔ Conductor SUSPENDIDO
        ESD->>COND: Notifica suspensión operativa
    end

    Note over ESD,AUT: 🏛️ COORDINACIÓN CON AUTORIDADES
    
    ESD->>AUT: 12. Gestiona trámite ante autoridad:<br/>• MTC (permisos operación)<br/>• PNP (papeletas, licencias)<br/>• MINSA (certificados salud)<br/>• Migraciones (extranjeros)
    
    AUT-->>ESD: 13. Recibe respuesta/documento
    ESD->>SYS: 14. Registra resultado del trámite
    ESD->>COND: 15. Notifica resultado
    
    ESD->>SYS: 16. Archiva documentación completa
    SYS-->>ESD: ✅ Expediente actualizado

    Note over ESD,SYS: 📊 REPORTES Y AUDITORÍA
    
    ESD->>SYS: 17. Genera reporte de vencimientos
    SYS-->>ESD: Reporte:<br/>• Docs. vencidos: 3<br/>• Por vencer (30d): 12<br/>• Por vencer (15d): 5<br/>• Vigentes: 180
    
    ESD->>SYS: 18. Genera reporte de cumplimiento
    SYS-->>ESD: % Cumplimiento documental: 94%
```

## JEFE OPERACIONES

```sh
sequenceDiagram
    participant JOP as 🎯 Jefe Operaciones
    participant SYS as 💻 Sistema
    participant ANO as 📊 Analista Operaciones
    participant SUP as 👮 Supervisor Terminal
    participant DESP as 🎛️ Despachador
    participant GER as 👔 Gerencia

    Note over JOP,GER: 🌄 PLANIFICACIÓN DIARIA (4:00-5:00 AM)
    
    JOP->>SYS: 1. Login y acceso a planificación operativa
    SYS-->>JOP: Dashboard del día: • Tipo de día • Recursos disponibles • Eventos especiales
    
    JOP->>SYS: 2. Consulta demanda proyectada
    SYS-->>JOP: Análisis histórico: • Mismo día semanas anteriores • Tendencias por franja horaria • Eventos que afectan demanda
    
    JOP->>SYS: 3. Revisa recursos disponibles
    SYS-->>JOP: Inventario: • Conductores: 45 activos • Unidades: 38 operativas • En mantenimiento: 4
    
    JOP->>JOP: 4. Define estrategia operativa
    
    rect rgb(255, 250, 240)
        Note over JOP: DECISIÓN ESTRATÉGICA
        JOP->>JOP: Selecciona esquema: • Normal • Reforzado (alta demanda) • Reducido (baja demanda) • Emergencia
    end
    
    loop Por cada ruta
        JOP->>SYS: 5. Asigna recursos por ruta
        JOP->>SYS: Define: • Unidades a operar • Conductores requeridos • Frecuencia objetivo • Horarios operación
        SYS-->>JOP: ✅ Asignación validada
    end
    
    JOP->>SYS: 6. Establece metas del día
    JOP->>SYS: Configura: • Servicios mínimos por ruta • Producción esperada • KPIs objetivo
    
    JOP->>SYS: 7. Confirma y aprueba plan operativo
    SYS->>SYS: 8. Registra plan en TbPlanOperativoDia
    
    SYS->>SUP: 9. Notifica plan aprobado a Supervisores
    SYS->>DESP: Notifica instrucciones a Despachadores
    SYS->>ANO: Notifica para seguimiento a Analista
    
    SYS-->>JOP: ✅ Plan operativo activado

    Note over JOP,DESP: ☀️ SUPERVISIÓN CONTINUA (Durante el día)
    
    loop Monitoreo cada 2 horas
        JOP->>SYS: 10. Consulta cumplimiento operativo
        SYS-->>JOP: Dashboard en tiempo real: • Rutas operando • Cumplimiento de frecuencias • Servicios ejecutados • Incidencias activas
        
        alt Desviación detectada
            SYS->>JOP: ⚠️ Alerta: Ruta 30 bajo meta
            JOP->>SYS: 11. Analiza causa de desviación
            SYS-->>JOP: Diagnóstico: • Unidad averiada • Congestión de tráfico • Conductor ausente
            
            JOP->>JOP: 12. Define acción correctiva
            
            alt Requiere recursos adicionales
                JOP->>SYS: 13a. Activa unidad de reserva
                JOP->>SUP: Instruye activar reemplazo
                SUP-->>JOP: Unidad activada
            else Ajuste de frecuencia
                JOP->>SYS: 13b. Ajusta frecuencia temporalmente
                JOP->>DESP: Instruye nuevo intervalo
            else Requiere decisión gerencial
                JOP->>GER: 13c. Escala situación crítica
                GER-->>JOP: Autorización/decisión
            end
            
            SYS->>SYS: 14. Registra acción correctiva
        end
    end

    Note over JOP,ANO: 📊 GESTIÓN DE RECURSOS OPERATIVOS
    
    alt Ausencia inesperada de conductor
        SYS->>JOP: 15. Alerta: Conductor no se presentó
        JOP->>SYS: 16. Busca conductor de reemplazo
        SYS-->>JOP: Conductores disponibles: • Turno libre • En descanso • Reserva
        
        JOP->>SYS: 17. Reasigna conductor a unidad
        SYS->>SYS: Actualiza asignaciones
        SYS->>SUP: Notifica cambio de conductor
        SYS-->>JOP: ✅ Recurso reasignado
        
    else Unidad sale de servicio
        SUP->>JOP: 18. Reporta falla de unidad
        JOP->>SYS: 19. Busca unidad de reemplazo
        SYS-->>JOP: Unidades disponibles en taller
        
        JOP->>SYS: 20. Asigna unidad alternativa
        JOP->>SYS: Reasigna conductor a nueva unidad
        SYS->>DESP: Notifica cambio en terminal
        SYS-->>JOP: ✅ Unidad reemplazada
    end

    Note over JOP,ANO: 📈 EVALUACIÓN DE PERFORMANCE
    
    JOP->>SYS: 21. Solicita evaluación de equipo
    JOP->>SYS: Selecciona período: última semana
    
    SYS-->>JOP: Indicadores por rol:  DESPACHADORES: • Eficiencia: 92% • Precisión: 95% • Incidencias: 3  MONITOREADORES: • Tiempo respuesta: 2.5 min • Alertas gestionadas: 47  SUPERVISORES: • Conflictos resueltos: 8 • Autorizaciones: 12
    
    JOP->>JOP: 22. Identifica áreas de mejora
    JOP->>JOP: Reconoce fortalezas del equipo
    
    JOP->>SYS: 23. Documenta observaciones
    JOP->>SYS: Programa acciones de mejora: • Capacitación específica • Ajustes de proceso • Reconocimientos

    Note over JOP,GER: 🔝 COORDINACIÓN CON GERENCIA
    
    alt Situación crítica
        JOP->>SYS: 24. Prepara informe para escalamiento
        SYS-->>JOP: Información contextual: • Estado operativo • KPIs del día • Incidencias relevantes
        
        JOP->>JOP: 25. Completa análisis: • Descripción situación • Opciones evaluadas • Recomendación • Urgencia
        
        JOP->>GER: 26. Envía coordinación a Gerencia
        GER->>GER: Evalúa situación
        GER-->>JOP: 27. Decisión gerencial
        
        JOP->>SYS: 28. Ejecuta decisión aprobada
        SYS->>SYS: Registra escalamiento y decisión
        
    else Reporte periódico
        JOP->>SYS: 29. Genera reporte operativo ejecutivo
        SYS-->>JOP: Reporte consolidado: • Cumplimiento de metas • Producción del período • Eficiencia operativa • Incidencias relevantes
        
        JOP->>GER: 30. Distribuye reporte a Gerencia
    end

    Note over JOP,ANO: 📋 ANÁLISIS Y MEJORA CONTINUA
    
    ANO->>JOP: 31. Presenta análisis de datos
    ANO->>JOP: Recomendaciones: • Optimización de rutas • Ajustes de frecuencia • Redistribución de recursos
    
    JOP->>JOP: 32. Evalúa recomendaciones
    
    alt Aprueba cambios
        JOP->>SYS: 33a. Autoriza implementación
        JOP->>ANO: Instruye ejecución de cambios
        ANO->>SYS: Actualiza configuraciones
        
    else Requiere más análisis
        JOP->>ANO: 33b. Solicita información adicional
        ANO->>ANO: Profundiza análisis
    end
    
    JOP->>SYS: 34. Documenta decisiones estratégicas
    SYS-->>JOP: ✅ Decisiones registradas

    Note over JOP,SYS: 🌙 CIERRE DE TURNO/DÍA
    
    JOP->>SYS: 35. Genera reporte de cierre
    SYS-->>JOP: Consolidado del día: • Servicios ejecutados: 856 • Cumplimiento global: 94% • Incidencias: 5 • Acciones correctivas: 3 • Recursos utilizados: 97%
    
    JOP->>JOP: 36. Evalúa desempeño del día
    JOP->>JOP: Identifica lecciones aprendidas
    
    JOP->>SYS: 37. Registra observaciones finales
    JOP->>SYS: Programa seguimiento para mañana
    
    JOP->>GER: 38. Envía reporte de cierre
    SYS-->>JOP: ✅ Día operativo cerrado
```

## ANALISTA OPERACIONES

```sh
sequenceDiagram
    participant ANO as 📊 Analista Operaciones
    participant SYS as 💻 Sistema
    participant JOP as 🎯 Jefe Operaciones
    participant DESP as 🎛️ Despachador
    participant GPS as 📡 GPS/Tracking

    Note over ANO,GPS: 📅 CREACIÓN DE PROGRAMACIÓN (Día anterior - tarde)
    
    ANO->>SYS: 1. Accede a módulo de programación
    SYS-->>ANO: Asistente de programación: • Fecha objetivo • Tipo de día • Eventos especiales
    
    ANO->>SYS: 2. Selecciona fecha a programar (mañana)
    SYS->>SYS: 3. Analiza demanda histórica
    SYS-->>ANO: Proyección de demanda: • Mismo día semanas anteriores • Patrones por franja horaria • Eventos que afectan demanda
    
    SYS-->>ANO: 4. Matriz de programación base sugerida
    
    rect rgb(240, 248, 255)
        Note over ANO: CONFIGURACIÓN POR RUTA
        loop Por cada ruta activa
            ANO->>ANO: 5. Revisa y ajusta programación: • Frecuencias por franja • Número de unidades • Restricciones operativas
            
            ANO->>SYS: 6. Define parámetros de ruta: • Primer despacho: 05:00 • Último despacho: 23:00 • Frecuencias variables • Tipo de servicio
            
            SYS->>SYS: 7. Calcula automáticamente: • Total servicios programados • Unidades requeridas • Conductores necesarios • Km total • Combustible estimado • Producción esperada
        end
    end
    
    SYS->>SYS: 8. Valida factibilidad
    
    alt Validación exitosa
        SYS-->>ANO: ✅ Recursos suficientes
    else Alertas de factibilidad
        SYS-->>ANO: ⚠️ Problemas detectados: • Faltan 3 conductores turno tarde • Frecuencia menor a ATU
        ANO->>ANO: 9. Ajusta programación
        ANO->>SYS: Re-valida
    end
    
    ANO->>SYS: 10. Genera horarios detallados
    SYS-->>ANO: Cronograma completo: • Salida por salida • Hora exacta • Unidad/Conductor sugerido • Terminal de salida
    
    ANO->>SYS: 11. Guarda programación
    SYS->>SYS: Registra en TbProgramacionSalida
    
    ANO->>JOP: 12. Envía para aprobación
    SYS->>SYS: Estado: "Pendiente Aprobación"
    
    JOP->>SYS: 13. Revisa programación
    
    alt Jefe aprueba
        JOP->>SYS: 14a. Aprueba programación
        SYS->>SYS: Estado: "Aprobada"
        SYS->>SYS: Configura sistema de despacho
        SYS->>DESP: 15. Notifica programación del día
    else Jefe solicita cambios
        JOP->>ANO: 14b. Solicita ajustes
        ANO->>ANO: Modifica programación
    end

    Note over ANO,GPS: 📈 OPTIMIZACIÓN DE FRECUENCIAS (Mensual)
    
    ANO->>SYS: 16. Accede a optimización de frecuencias
    ANO->>SYS: 17. Selecciona ruta a optimizar
    ANO->>SYS: 18. Configura período de análisis: • Últimos 90 días • Solo días laborables
    
    SYS->>GPS: 19. Extrae datos GPS históricos
    GPS-->>SYS: Datos de Tb_RegistroTrack
    
    SYS->>SYS: 20. Procesa información: • Demanda real por hora • Tiempos de viaje • Intervalos ejecutados • Ocupación promedio
    
    SYS-->>ANO: 21. Análisis de demanda por franja:  06:00-09:00: Alta (250 pax/hr) 09:00-12:00: Media (120 pax/hr) 12:00-14:00: Media-Alta (180 pax/hr) 14:00-18:00: Media (140 pax/hr) 18:00-21:00: Alta (230 pax/hr)
    
    ANO->>ANO: 22. Identifica patrones: • Picos de demanda • Valles de baja ocupación • Inconsistencias
    
    ANO->>SYS: 23. Propone nuevas frecuencias optimizadas
    
    rect rgb(255, 250, 240)
        Note over ANO: SIMULACIÓN DE IMPACTO
        SYS->>SYS: 24. Simula nuevo esquema: • Nivel de servicio • Utilización de flota • Costos operativos • Cumplimiento ATU
        
        SYS-->>ANO: Comparativa: Actual vs Propuesta • Servicios: +15% • Eficiencia: +12% • Costos: -8%
    end
    
    ANO->>JOP: 25. Presenta propuesta de optimización
    JOP->>JOP: Evalúa impacto operativo
    
    alt Jefe aprueba cambios
        JOP->>SYS: 26a. Autoriza implementación
        ANO->>SYS: 27. Actualiza TbIntervaloFrecuencia
        SYS-->>ANO: ✅ Frecuencias actualizadas
    else Requiere ajustes
        JOP->>ANO: 26b. Solicita modificaciones
    end

    Note over ANO,SYS: 📊 ANÁLISIS DE CUMPLIMIENTO OPERATIVO
    
    JOP->>ANO: 28. Solicita reporte de cumplimiento
    
    ANO->>SYS: 29. Genera análisis de cumplimiento
    ANO->>SYS: Selecciona período: última semana
    
    SYS->>SYS: 30. Compara programado vs ejecutado
    SYS-->>ANO: Resultados por ruta:  Ruta 25: 94% cumplimiento Ruta 30: 78% cumplimiento ⚠️ Ruta 12: 96% cumplimiento ✅
    
    ANO->>ANO: 31. Identifica causas de desviación: • Ruta 30: Tráfico en hora pico • Falta de unidades en turno tarde
    
    ANO->>SYS: 32. Documenta hallazgos
    ANO->>SYS: 33. Genera reporte detallado
    SYS-->>ANO: Reporte con gráficos y KPIs
    
    ANO->>JOP: 34. Presenta análisis y recomendaciones
    JOP-->>ANO: Feedback y aprobación de acciones

    Note over ANO,SYS: 🔍 IDENTIFICACIÓN DE CUELLOS DE BOTELLA
    
    ANO->>SYS: 35. Accede a análisis de operación
    SYS-->>ANO: Dashboard de puntos críticos
    
    ANO->>SYS: 36. Analiza tiempos de ciclo por ruta
    SYS-->>ANO: Detección de anomalías: • Punto X: Demora promedio 15 min • Terminal A: Congestión 7-9 AM • Ruta 30: Tiempos irregulares
    
    ANO->>ANO: 37. Investiga causas: • Infraestructura • Tráfico vehicular • Procesos internos • Recursos insuficientes
    
    ANO->>SYS: 38. Documenta cuello de botella
    ANO->>ANO: 39. Formula propuesta de mejora: • Ajustar rutas • Redistribuir recursos • Cambiar horarios
    
    ANO->>JOP: 40. Presenta propuesta de solución
    JOP->>JOP: Evalúa viabilidad
    
    alt Propuesta aprobada
        JOP->>ANO: 41a. Autoriza implementación
        ANO->>SYS: Configura cambios en sistema
    else Requiere más análisis
        JOP->>ANO: 41b. Solicita datos adicionales
    end

    Note over ANO,SYS: ⚙️ CONFIGURACIÓN DE PARÁMETROS DEL SISTEMA
    
    ANO->>SYS: 42. Accede a configuración operativa
    SYS-->>ANO: Panel de parámetros configurables
    
    loop Ajustes de configuración
        ANO->>SYS: 43. Modifica parámetros: • Tiempos de despacho • Frecuencias objetivo • Tolerancias de cumplimiento • Reglas de priorización
        
        SYS->>SYS: 44. Valida impacto del cambio
        
        alt Cambio válido
            SYS-->>ANO: ✅ Parámetro actualizado
        else Cambio genera conflicto
            SYS-->>ANO: ⚠️ Conflicto con regla existente
            ANO->>ANO: Ajusta configuración
        end
    end
    
    ANO->>SYS: 45. Guarda configuración
    SYS->>SYS: Registra cambios en TbConfiguracion
    SYS-->>ANO: ✅ Sistema reconfigurado

    Note over ANO,JOP: 📋 REPORTES Y SEGUIMIENTO CONTINUO
    
    loop Monitoreo diario
        ANO->>SYS: 46. Consulta KPIs del día
        SYS-->>ANO: Indicadores en tiempo real: • Cumplimiento: 91% • Servicios ejecutados: 456/500 • Incidencias: 3
        
        alt Desviación significativa detectada
            ANO->>JOP: 47. Alerta al Jefe de Operaciones
            ANO->>ANO: Analiza causa raíz
            ANO->>JOP: Propone acción correctiva
        end
    end
```
## SUPERVISOR TERMINAL

```sh
sequenceDiagram
    participant SUP as 👮 Supervisor Terminal
    participant SYS as 💻 Sistema
    participant DESP as 🎛️ Despachador
    participant COND as 🚗 Conductor
    participant JOP as 🎯 Jefe Operaciones
    participant AUT as 🏛️ Autoridades Externas

    Note over SUP,AUT: 🌅 INICIO DE TURNO
    
    SUP->>SYS: 1. Login y acceso a panel de supervisión
    SYS-->>SUP: Dashboard del turno: • Personal asignado • Unidades programadas • KPIs objetivo
    
    SUP->>SYS: 2. Verifica asistencia del personal
    SYS-->>SUP: Estado del equipo: • Despachadores: 3/3 ✅ • Monitoreadores: 2/2 ✅ • Personal apoyo: 4/5 ⚠️
    
    alt Personal ausente
        SUP->>SUP: 3. Gestiona reemplazo
        SUP->>SYS: Solicita conductor de reserva
        SYS->>JOP: Notifica necesidad de personal
    end
    
    SUP->>DESP: 4. Briefing de inicio de turno
    SUP->>DESP: Comunica: • Prioridades del día • Eventos especiales • Instrucciones específicas

    Note over SUP,COND: 🚨 RESOLUCIÓN DE EXCEPCIONES ESCALADAS
    
    DESP->>SUP: 5. Escala excepción de despacho
    SYS-->>SUP: Detalle del caso: • Unidad: BUS-245 • Conductor: Juan Pérez • Problema: Licencia vence en 5 días
    
    SUP->>SYS: 6. Revisa información completa: • Historial del conductor • Gravedad de la restricción • Impacto operativo
    
    rect rgb(255, 245, 235)
        Note over SUP: EVALUACIÓN DE CASO
        SUP->>SUP: 7. Analiza opciones: • Autorizar temporalmente • Rechazar despacho • Solicitar más información • Establecer condiciones
    end
    
    alt Decisión: AUTORIZAR
        SUP->>SYS: 8a. Autoriza despacho excepcional
        SUP->>SYS: Establece condiciones: • Válido solo este turno • Renovar licencia en 48h • Seguimiento obligatorio
        
        SYS->>SYS: 9. Genera código de autorización
        SYS->>DESP: Habilita despacho
        SYS->>COND: Notifica condiciones
        SYS->>SYS: 10. Programa alerta de seguimiento
        
    else Decisión: RECHAZAR
        SUP->>SYS: 8b. Rechaza despacho
        SUP->>SYS: Registra motivo: "Riesgo operativo alto"
        SYS->>DESP: Bloquea unidad
        SYS->>COND: Notifica rechazo
        SYS->>JOP: Alerta: unidad fuera de servicio
        
    else Decisión: SOLICITAR INFO
        SUP->>DESP: 8c. Requiere información adicional
        DESP->>COND: Solicita documentación
        COND-->>DESP: Entrega información
        DESP->>SUP: Presenta información adicional
        SUP->>SUP: Re-evalúa caso
    end
    
    SUP->>SYS: 11. Documenta decisión completa
    SYS->>SYS: Registra en auditoría

    Note over SUP,SYS: 📊 MONITOREO DE KPIs EN TIEMPO REAL
    
    loop Revisión cada 30 minutos
        SUP->>SYS: 12. Accede a dashboard de KPIs
        SYS-->>SUP: Indicadores en tiempo real:  ✅ Cumplimiento frecuencias: 92% ✅ Unidades operando: 38/40 ⚠️ Servicios ejecutados: 85% de meta ❌ Ruta 30: 65% cumplimiento
        
        alt KPI crítico bajo umbral
            SYS->>SUP: ⚠️ Alerta: Ruta 30 bajo meta
            SUP->>SYS: 13. Investiga causa
            SYS-->>SUP: Análisis: • 2 unidades con fallas • Congestión vehicular • Conductor retrasado
            
            SUP->>SUP: 14. Define acción correctiva
            
            alt Dentro de autoridad del supervisor
                SUP->>DESP: 15a. Instruye ajuste operativo: • Priorizar Ruta 30 • Reducir intervalo temporalmente
                DESP-->>SUP: Ejecuta instrucción
                
            else Requiere escalamiento
                SUP->>JOP: 15b. Escala situación crítica
                JOP-->>SUP: Autoriza recursos adicionales
                SUP->>DESP: Implementa solución
            end
            
            SUP->>SYS: 16. Registra acción correctiva
            SYS->>SYS: Programa verificación en 1 hora
        end
    end

    Note over SUP,DESP: 👥 GESTIÓN DE PERSONAL DEL TURNO
    
    alt Despachador reporta problema
        DESP->>SUP: 17. Reporta conflicto con conductor
        SUP->>SUP: 18. Escucha ambas partes
        SUP->>SYS: 19. Consulta historial del conductor
        SYS-->>SUP: Antecedentes y evaluaciones
        
        SUP->>SUP: 20. Media y toma decisión: • Amonestación verbal • Registro de incidencia • Escalamiento a RRHH
        
        SUP->>SYS: 21. Documenta incidencia
        
        alt Requiere acción disciplinaria
            SUP->>SYS: 22. Genera reporte para RRHH
        end
    end

    Note over SUP,AUT: 🏛️ COORDINACIÓN CON AUTORIDADES EXTERNAS
    
    alt Inspección de ATU
        AUT->>SUP: 23. Autoridad solicita información
        SUP->>SYS: 24. Recopila datos solicitados: • Frecuencias ejecutadas • Estado de unidades • Documentación operativa
        
        SYS-->>SUP: Información consolidada
        SUP->>AUT: 25. Presenta información oficial
        
        SUP->>SYS: 26. Registra visita de autoridad
        
    else Incidente con PNP
        AUT->>SUP: 27. Policía reporta infracción
        SUP->>SYS: 28. Consulta unidad y conductor
        SUP->>SYS: Documenta incidente
        SUP->>JOP: Notifica situación
    end

    Note over SUP,DESP: 🚀 AUTORIZACIÓN DE DESPACHOS ESPECIALES
    
    DESP->>SUP: 29. Solicita despacho fuera de programación
    DESP->>SUP: Motivo: Alta demanda en terminal
    
    SUP->>SYS: 30. Verifica disponibilidad de recursos
    SYS-->>SUP: Conductor y unidad disponibles
    
    SUP->>SUP: 31. Evalúa justificación
    
    alt Aprueba despacho especial
        SUP->>SYS: 32a. Autoriza salida especial
        SYS->>SYS: Registra como "Fuera de programación"
        SYS->>DESP: Habilita despacho
        
    else Rechaza solicitud
        SUP->>DESP: 32b. Explica motivo de rechazo
    end

    Note over SUP,JOP: 🆘 GESTIÓN DE INCIDENCIAS CRÍTICAS
    
    alt Emergencia operativa
        DESP->>SUP: 33. Reporta emergencia: Accidente de unidad en ruta
        
        SUP->>SUP: 34. Activa protocolo de emergencia
        SUP->>SYS: 35. Registra incidencia crítica
        
        SUP->>AUT: 36. Contacta servicios de emergencia
        SUP->>JOP: 37. Notifica a Jefe de Operaciones
        
        SUP->>DESP: 38. Instruye acciones inmediatas: • Suspender despachos de ruta • Enviar unidad de apoyo • Verificar estado del conductor
        
        SUP->>SYS: 39. Coordina reasignación de servicios
        SYS-->>SUP: Unidades alternativas asignadas
        
        SUP->>SYS: 40. Documenta gestión completa: • Cronología de eventos • Acciones tomadas • Recursos involucrados • Estado final
    end

    Note over SUP,JOP: 📋 REPORTE DE CIERRE DE TURNO
    
    SUP->>SYS: 41. Genera reporte de turno
    SYS-->>SUP: Consolidado del turno: • Servicios ejecutados • KPIs alcanzados • Excepciones gestionadas • Incidencias registradas • Personal del turno
    
    SUP->>SUP: 42. Agrega observaciones: • Eventos relevantes • Decisiones importantes • Recomendaciones • Pendientes para siguiente turno
    
    SUP->>JOP: 43. Envía reporte a Jefe de Operaciones
    SUP->>SYS: 44. Archiva documentación
    
    SYS-->>SUP: ✅ Turno cerrado correctamente
```
## DESPACHADOR

```sh
sequenceDiagram
    participant DESP as 🎛️ Despachador
    participant SYS as 💻 Sistema
    participant COND as 🚗 Conductor
    participant SUP as 👮 Supervisor
    participant GPS as 📡 GPS/Tracking

    Note over DESP,GPS: 🌅 INICIO DE TURNO
    
    DESP->>SYS: 1. Login en terminal asignada
    SYS-->>DESP: Dashboard de despacho: • Cola actual • Programación del día • Rutas asignadas
    
    DESP->>SYS: 2. Verifica programación del día
    SYS-->>DESP: Cronograma de salidas: • Horarios programados • Frecuencias objetivo • Metas de servicios
    
    DESP->>DESP: 3. Revisa estado de terminal: • Unidades en cola • Conductores disponibles • Condiciones operativas

    Note over DESP,COND: 📋 CONSULTA DE COLA DE DESPACHO
    
    loop Monitoreo continuo
        DESP->>SYS: 4. Consulta cola de despacho
        SYS-->>DESP: Lista de unidades en espera:  1. BUS-245 | Ruta 25 | 05:15 2. BUS-189 | Ruta 30 | 05:18 3. BUS-312 | Ruta 12 | 05:20 4. BUS-078 | Ruta 25 | 05:22 ⚠️
        
        DESP->>DESP: 5. Identifica próximo despacho
    end

    Note over DESP,COND: ✅ AUTORIZACIÓN DE DESPACHO NORMAL
    
    COND->>DESP: 6. Conductor solicita despacho
    COND->>DESP: "Unidad BUS-245, Ruta 25, lista para salir"
    
    DESP->>SYS: 7. Selecciona unidad en cola
    SYS->>SYS: 8. Ejecuta validaciones automáticas: • 14 documentos del conductor • Estado técnico de unidad • Boletos asignados • Cumplimiento de frecuencia • Geocerca (ubicación correcta)
    
    alt Todas las validaciones OK
        SYS-->>DESP: ✅ Unidad habilitada para despacho
        
        DESP->>SYS: 9. Autoriza despacho
        SYS->>SYS: 10. Registra salida en Tb_SalidaUnidad: • Fecha y hora exacta • Conductor • Unidad • Ruta • Despachador • Terminal
        
        SYS->>GPS: 11. Activa monitoreo GPS
        GPS-->>SYS: Tracking iniciado
        
        SYS-->>DESP: ✅ Despacho autorizado #12345
        DESP->>COND: 12. Confirma salida al conductor
        DESP->>COND: "Autorizado, buen viaje"
        
        SYS->>SYS: 13. Actualiza KPIs en tiempo real: • Servicios ejecutados: +1 • Cumplimiento de frecuencia • Cola de espera actualizada
        
    else Validaciones con problemas
        SYS-->>DESP: ⚠️ Restricciones detectadas: • Licencia vence en 5 días • Stock de boletos bajo
        
        DESP->>DESP: 14. Evalúa gravedad de restricciones
        
        alt Excepción menor (puede gestionar)
            DESP->>COND: 15a. Solicita aclaración
            COND-->>DESP: "Renovando licencia mañana"
            
            DESP->>SYS: 16. Documenta excepción
            DESP->>SYS: Autoriza con observación
            SYS-->>DESP: ✅ Despacho autorizado con alerta
            
        else Excepción mayor (requiere supervisor)
            DESP->>SUP: 15b. Escala caso al supervisor
            DESP->>SUP: "BUS-245 con licencia por vencer"
            
            SUP->>SYS: Revisa caso completo
            SUP-->>DESP: Decisión del supervisor
            
            alt Supervisor autoriza
                DESP->>SYS: 16a. Ejecuta despacho autorizado
            else Supervisor rechaza
                DESP->>COND: 16b. Informa rechazo
                DESP->>COND: "No autorizado, regularizar documento"
            end
        end
    end

    Note over DESP,SYS: 📅 EJECUCIÓN DE PROGRAMACIÓN PREDEFINIDA
    
    alt Empresa CON programación
        SYS->>DESP: 17. Alerta de salida programada: "05:30 - Ruta 25 - BUS-245"
        
        DESP->>SYS: 18. Verifica unidad en cola
        
        alt Unidad presente y lista
            DESP->>SYS: 19a. Ejecuta despacho programado
            SYS-->>DESP: ✅ Servicio según programación
            
        else Unidad no disponible
            DESP->>SYS: 19b. Busca unidad alternativa
            DESP->>SUP: Notifica desviación de programación
            SUP-->>DESP: Autoriza unidad sustituta
        end
        
    else Empresa SIN programación
        DESP->>DESP: 20. Despacha por criterio propio: • Orden de llegada • Prioridad por demanda • Experiencia operativa
        
        DESP->>SYS: 21. Verifica cumplimiento de frecuencia
        SYS-->>DESP: Última salida Ruta 25: hace 8 min Frecuencia objetivo: 10 min ✅ Dentro de intervalo
    end

    Note over DESP,SYS: 🔄 REORGANIZACIÓN DE COLA POR PRIORIDADES
    
    alt Alta demanda detectada
        SYS->>DESP: 22. Alerta: Alta demanda en Ruta 30
        
        DESP->>SYS: 23. Reorganiza cola de despacho
        DESP->>SYS: Prioriza unidades de Ruta 30
        
        SYS->>SYS: 24. Reordena cola automáticamente
        SYS-->>DESP: Cola actualizada con prioridades
        
    else Servicio especial solicitado
        SUP->>DESP: 25. Autoriza despacho fuera de turno
        DESP->>SYS: Inserta salida especial en cola
    end

    Note over DESP,SUP: 📝 REGISTRO DE INCIDENCIAS
    
    alt Incidencia en terminal
        DESP->>DESP: 26. Detecta situación anormal: • Conductor no se presenta • Unidad con falla • Congestión en terminal
        
        DESP->>SYS: 27. Registra incidencia operativa
        DESP->>SYS: Describe: • Tipo de incidencia • Hora de ocurrencia • Unidades/personal afectado • Acciones tomadas
        
        alt Incidencia crítica
            DESP->>SUP: 28. Escala al supervisor
            SUP-->>DESP: Instrucciones de manejo
        end
        
        DESP->>SYS: 29. Actualiza estado de incidencia
    end

    Note over DESP,COND: 💬 COMUNICACIÓN CON CONDUCTORES
    
    loop Interacción continua
        alt Conductor consulta
            COND->>DESP: 30. "¿Cuándo es mi próximo despacho?"
            DESP->>SYS: Consulta posición en cola
            SYS-->>DESP: "Tercer lugar, aprox. 15 minutos"
            DESP->>COND: Informa tiempo de espera
            
        else Cambio de última hora
            DESP->>COND: 31. Notifica cambio de ruta/horario
            COND-->>DESP: Confirma recepción
        end
    end

    Note over DESP,SYS: ⏰ CONTROL DE CUMPLIMIENTO DE HORARIOS
    
    loop Verificación de frecuencias
        DESP->>SYS: 32. Consulta cumplimiento de frecuencias
        SYS-->>DESP: Estado por ruta:  Ruta 25: ✅ 95% cumplimiento Ruta 30: ⚠️ 78% cumplimiento Ruta 12: ✅ 92% cumplimiento
        
        alt Frecuencia fuera de rango
            SYS->>DESP: ⚠️ Ruta 30: Última salida hace 18 min Frecuencia objetivo: 10 min
            
            DESP->>DESP: 33. Acelera despachos de Ruta 30
            DESP->>SYS: Prioriza próximas salidas
            
            alt Problema persiste
                DESP->>SUP: 34. Reporta desviación sistemática
                SUP-->>DESP: Autoriza ajuste temporal
            end
        end
    end

    Note over DESP,SUP: 🔺 ESCALAMIENTO DE CASOS COMPLEJOS
    
    alt Situación compleja
        DESP->>DESP: 35. Identifica caso que excede autoridad: • Conductor con sanción activa • Unidad sin SOAT vigente • Conflicto entre conductores
        
        DESP->>SUP: 36. Escala caso al supervisor
        DESP->>SUP: Proporciona contexto completo
        
        SUP->>SYS: 37. Revisa información
        SUP-->>DESP: 38. Decisión del supervisor
        
        DESP->>SYS: 39. Ejecuta decisión recibida
        DESP->>SYS: Documenta resolución
    end

    Note over DESP,SYS: 🌙 ACTIVIDADES DE CIERRE
    
    DESP->>SYS: 40. Consulta resumen del turno
    SYS-->>DESP: Consolidado: • Despachos autorizados: 156 • Excepciones gestionadas: 8 • Casos escalados: 2 • Cumplimiento promedio: 91% • Incidencias registradas: 3
    
    DESP->>SYS: 41. Registra observaciones finales
    DESP->>SUP: 42. Entrega reporte al supervisor
    
    SYS-->>DESP: ✅ Turno cerrado
```
## MONITOREADOR GPS

```sh
sequenceDiagram
    participant MON as 📡 Monitoreador GPS
    participant SYS as 💻 Sistema
    participant GPS as 🛰️ GPS/Tracking
    participant COND as 🚗 Conductor
    participant SUP as 👮 Supervisor
    participant JOP as 🎯 Jefe Operaciones

    Note over MON,JOP: 🌅 INICIO DE TURNO
    
    MON->>SYS: 1. Login con perfil GPS activo
    SYS-->>MON: Dashboard de monitoreo: • Rutas asignadas • Geocercas activas • Umbrales de alertas
    
    SYS->>GPS: 2. Consulta posiciones activas
    GPS-->>SYS: Últimos 60 segundos de tracking
    
    SYS-->>MON: 3. Dashboard en tiempo real: • Unidades monitoreadas: 42 • En ruta: 38 ✅ • Detenidas: 2 ⚠️ • Con alertas: 2 🚨

    Note over MON,GPS: 🗺️ MONITOREO EN TIEMPO REAL
    
    loop Actualización cada 30 segundos
        GPS->>SYS: 4. Envía posiciones GPS actualizadas
        SYS->>SYS: 5. Procesa datos de tracking
        
        SYS-->>MON: 6. Actualiza mapa: • Posiciones de unidades • Velocidades • Direcciones • Estado de conexión
        
        rect rgb(240, 248, 255)
            Note over MON: VISUALIZACIÓN POR UNIDAD
            MON->>MON: Revisa estado: • BUS-245: 45 km/h, Norte • Última actualización: 12 seg • Próximo control: 1.2 km • Estado: Verde (sin alertas)
        end
        
        SYS->>SYS: 7. Analiza patrones anómalos: • Unidades detenidas >10 min • Velocidades inusuales • Desviaciones de ruta
    end

    Note over MON,COND: 🚨 GESTIÓN DE ALERTAS AUTOMÁTICAS
    
    alt Alerta: Velocidad excesiva
        GPS->>SYS: 8. Detecta: BUS-189 a 95 km/h
        SYS->>SYS: 9. Evalúa umbral: >80 km/h
        
        SYS->>MON: 10. 🚨 ALERTA CRÍTICA: • Unidad: BUS-189 • Problema: Velocidad 95 km/h • Ubicación: Av. Principal km 15 • Tiempo respuesta objetivo: <2 min
        
        MON->>MON: 11. Prioriza alerta (alta criticidad)
        
        MON->>COND: 12. Contacto por radio: "Central a BUS-189, URGENTE"
        COND-->>MON: "BUS-189, adelante Central"
        
        MON->>COND: 13. "Reduce velocidad inmediato, estás a 95 km/h, límite 60"
        COND-->>MON: "Entendido, reduciendo"
        
        MON->>SYS: 14. Registra acción correctiva
        SYS->>SYS: 15. Marca unidad para seguimiento
        
        loop Seguimiento 30 minutos
            GPS->>SYS: Monitorea velocidad de BUS-189
            
            alt Velocidad normalizada
                SYS-->>MON: ✅ Velocidad: 55 km/h (normal)
                MON->>SYS: 16. Cierra alerta
            else Velocidad sigue alta
                SYS->>MON: ⚠️ Persiste problema
                MON->>SUP: 17. Escala a supervisor
            end
        end
        
    else Alerta: Fuera de ruta
        GPS->>SYS: 18. Detecta: BUS-312 a 800m de ruta
        SYS->>SYS: Evalúa umbral: >500m
        
        SYS->>MON: 19. ⚠️ ALERTA MEDIA: • Fuera de ruta autorizada • Desviación: 800m
        
        MON->>COND: 20. "BUS-312, estás fuera de ruta"
        COND-->>MON: "Desvío por bloqueo vial"
        
        MON->>MON: 21. Verifica justificación
        MON->>SYS: Registra: "Desvío autorizado - bloqueo"
        MON->>SYS: Ajusta ruta temporalmente
        
    else Alerta: Parada prolongada
        GPS->>SYS: 22. Detecta: BUS-078 sin movimiento 18 min
        
        SYS->>MON: 23. ⚠️ ALERTA MEDIA: • Parada prolongada: 18 min • Última posición: Terminal B
        
        MON->>COND: 24. Contacta para verificar estado
        
        alt Conductor responde
            COND-->>MON: "Esperando pasajeros, salgo en 5 min"
            MON->>SYS: Registra: "Parada normal"
            
        else Conductor NO responde
            MON->>MON: 25. Intenta contacto alternativo: • Radio (3 intentos) • Celular (2 intentos) • App móvil
            
            alt Aún sin respuesta
                MON->>SUP: 26. Escala: Unidad sin contacto
                SUP->>SYS: Activa protocolo de búsqueda
            end
        end
        
    else Alerta: GPS sin señal
        GPS->>SYS: 27. Pérdida de señal >5 min
        
        SYS->>MON: 28. ⚠️ ALERTA: BUS-245 sin señal
        SYS-->>MON: Última posición conocida: • Coordenadas • Hora: 10:15 AM • Velocidad: 40 km/h
        
        MON->>COND: 29. Intenta contacto urgente
        
        alt Conductor responde
            COND-->>MON: "GPS con falla, todo OK"
            MON->>SYS: Registra incidente técnico
            MON->>SYS: Genera orden de revisión GPS
            
        else Sin respuesta
            MON->>MON: 30. Activa protocolo de búsqueda: • Revisa ruta que seguía • Envía inspector a zona • Considera contacto autoridades
            
            MON->>SUP: 31. Escalamiento crítico
        end
    end

    Note over MON,COND: 💬 COMUNICACIÓN CON CONDUCTORES
    
    alt Comunicación rutinaria
        MON->>COND: 32. "BUS-245, ¿cómo va tu servicio?"
        COND-->>MON: "Todo normal, llegando Terminal A"
        MON->>SYS: Registra verificación de rutina
        
    else Instrucción operativa
        JOP->>MON: 33. "Prioriza despachos Ruta 30"
        MON->>COND: 34. Contacta conductores Ruta 30
        MON->>COND: "Acelera servicio, alta demanda"
        COND-->>MON: "Entendido, ajustando"
        
    else Conductor solicita apoyo
        COND->>MON: 35. "Central, BUS-189, falla mecánica"
        MON->>COND: "¿Ubicación y tipo de falla?"
        COND-->>MON: "Av. Lima altura 800, sobrecalentamiento"
        
        MON->>SYS: 36. Registra incidencia
        MON->>SUP: 37. Coordina apoyo: • Unidad de reemplazo • Mecánico al lugar
        SUP-->>MON: Recursos despachados
        MON->>COND: "Apoyo en camino, 15 minutos"
    end

    Note over MON,SYS: ✅ VALIDACIÓN DE CUMPLIMIENTO DE RUTAS
    
    loop Verificación continua
        MON->>SYS: 38. Solicita análisis de cumplimiento
        SYS->>GPS: Compara trayectoria vs ruta autorizada
        
        SYS-->>MON: 39. Resultado por unidad: • BUS-245: 98% adherencia ✅ • BUS-312: 85% adherencia ⚠️ • BUS-078: 92% adherencia ✅
        
        alt Baja adherencia detectada
            MON->>COND: 40. "BUS-312, estás desviándote mucho"
            COND-->>MON: Explica motivo
            MON->>SYS: Documenta justificación
        end
    end

    Note over MON,SUP: 🆘 COORDINACIÓN DE EMERGENCIAS
    
    alt Emergencia reportada
        COND->>MON: 41. 🚨 "EMERGENCIA, accidente de tránsito"
        
        MON->>MON: 42. Activa protocolo de emergencia
        MON->>SYS: 43. Registra emergencia CRÍTICA
        
        MON->>COND: 44. "Calmado, ¿hay heridos?"
        COND-->>MON: "Sí, 2 pasajeros heridos"
        
        MON->>MON: 45. Contacta servicios de emergencia: • Ambulancia • Policía de tránsito
        
        MON->>GPS: 46. Comparte ubicación exacta GPS
        MON->>SUP: 47. Notifica emergencia a supervisor
        MON->>JOP: Notifica a Jefe de Operaciones
        
        MON->>COND: 48. Instruye acciones: • Asegurar zona • Atender heridos • No mover unidad
        
        MON->>SYS: 49. Coordina: • Unidad de reemplazo • Inspector al lugar • Reasignación de servicios
        
        MON->>SYS: 50. Documenta cronología completa: • Hora de alerta • Acciones tomadas • Recursos despachados • Evolución del incidente
        
    else Pérdida de unidad
        SYS->>MON: 51. Alerta: BUS-245 sin señal >10 min
        
        MON->>MON: 52. Ejecuta protocolo búsqueda: • Última posición conocida • Ruta probable • Contactos alternativos
        
        MON->>COND: Intenta contacto (sin respuesta)
        
        MON->>SUP: 53. Escala: Posible robo de unidad
        SUP->>MON: Autoriza contacto con autoridades
        
        MON->>SYS: 54. Contacta PNP con datos GPS
        MON->>SYS: Activa seguimiento especial
    end

    Note over MON,SYS: 📊 REPORTES Y CONFIGURACIÓN
    
    MON->>SYS: 55. Genera reporte de turno
    SYS-->>MON: Consolidado: • Unidades monitoreadas: 42 • Alertas gestionadas: 18 • Comunicaciones: 47 • Incidencias: 3 • Tiempo respuesta promedio: 2.8 min
    
    MON->>MON: 56. Agrega observaciones: • Eventos destacados • Recomendaciones • Pendientes siguiente turno
    
    MON->>SUP: 57. Entrega reporte a supervisor
    MON->>JOP: Envía resumen a Jefe de Operaciones
    
    alt Necesidad de ajustar parámetros
        MON->>SYS: 58. Accede a configuración
        MON->>SYS: 59. Ajusta geocercas y alertas: • Nuevos umbrales • Zonas modificadas • Alertas personalizadas
        SYS-->>MON: ✅ Configuración actualizada
    end
    
    SYS-->>MON: ✅ Turno cerrado correctamente
```
## CONDUCTOR (despacho , recaudo)

```sh
sequenceDiagram
    participant COND as 🚗 Conductor
    participant SYS as 💻 Sistema
    participant DESP as 🎛️ Despachador
    participant GPS as 🛰️ GPS/Tracking
    participant CAJ as 💰 Cajero/Liquidador
    participant MON as 📡 Monitoreador

    Note over COND,MON: 🌅 INICIO DE TURNO
    
    COND->>COND: 1. Llega a terminal (4:00-5:00 AM)
    COND->>SYS: 2. Se presenta en cola de despacho
    SYS-->>COND: Posición en cola: #5
    
    alt Recibe boletos físicos
        CAJ->>COND: 3a. Entrega talonario físico Serie A: 001-100
        COND->>COND: Verifica talonario recibido
        COND->>CAJ: Firma acta de recepción
        SYS->>SYS: Registra entrega (ProcAlmacenBoleto)
        
    else Unidad con ticketera
        COND->>SYS: 3b. Abre caja digital
        SYS->>SYS: Ejecuta ProcCajaGestionConductor @Indice=21
        SYS-->>COND: ✅ Caja abierta, listo para operar
    end

    Note over COND,DESP: 🚦 PROCESO DE DESPACHO
    
    COND->>DESP: 4. Solicita autorización de despacho
    DESP->>SYS: 5. Consulta validaciones
    
    SYS->>SYS: 6. Ejecuta validaciones: • 14 documentos conductor • Estado técnico unidad • Boletos asignados • GPS activo
    
    alt Validaciones OK
        SYS-->>DESP: ✅ Unidad habilitada
        DESP->>COND: 7. Autoriza salida: "Buen viaje"
        
        SYS->>SYS: 8. Registra despacho (Tb_SalidaUnidad)
        SYS->>GPS: 9. Activa tracking GPS
        GPS-->>SYS: Monitoreo iniciado
        
    else Restricción detectada
        SYS-->>DESP: ⚠️ Problema detectado
        DESP->>DESP: Evalúa gravedad
        DESP->>COND: Espera, revisando situación
    end

    Note over COND,MON: 🚌 OPERACIÓN EN RUTA
    
    COND->>COND: 10. Inicia recorrido autorizado
    
    loop Durante el recorrido
        GPS->>MON: 11. Transmite posición cada 30 seg
        MON->>SYS: Verifica cumplimiento de ruta
        
        rect rgb(240, 255, 240)
            Note over COND: VENTA DE BOLETOS
            
            alt CON ticketera electrónica
                COND->>SYS: 12a. Pasajero paga en validador
                SYS->>SYS: Registra transacción automática
                SYS->>SYS: Acumula producción en tiempo real
                
            else SIN ticketera (boletos físicos)
                COND->>COND: 12b. Cobra efectivo
                COND->>COND: Entrega boleto físico (A-045)
                COND->>COND: Guarda dinero en caja personal
                COND->>COND: Control mental: • Vendidos: A-001 a A-045 • Efectivo acumulado: $112.50
            end
        end
        
        alt Alerta GPS detectada
            GPS->>SYS: 13. Detecta velocidad excesiva
            SYS->>MON: ⚠️ Alerta: 95 km/h
            MON->>COND: 14. "BUS-245, reduce velocidad"
            COND-->>MON: "Entendido, reduciendo"
        end
    end

    Note over COND,CAJ: 💰 ENTREGA PARCIAL (Durante el día)
    
    COND->>COND: 15. Completa vuelta, llega a terminal
    
    alt CON ticketera
        COND->>SYS: 16a. Cierra vuelta en sistema
        SYS-->>COND: Producción de vuelta: $125.00
        COND->>CAJ: 17. Entrega efectivo
        CAJ->>CAJ: Cuenta efectivo recibido
        CAJ->>SYS: Registra entrega parcial
        CAJ->>COND: Emite comprobante temporal
        
    else SIN ticketera
        COND->>CAJ: 16b. Entrega efectivo acumulado
        COND->>CAJ: "Vendí boletos A-001 a A-045"
        CAJ->>CAJ: Calcula: 45 boletos × $2.50 = $112.50
        CAJ->>CAJ: Cuenta efectivo entregado
        CAJ->>SYS: Registra entrega parcial
    end
    
    COND->>COND: 18. Continúa operación con nueva vuelta

    Note over COND,CAJ: 🌆 FIN DE TURNO - LIQUIDACIÓN
    
    COND->>COND: 19. Finaliza último servicio del turno
    
    alt CON ticketera
        COND->>SYS: 20a. Cierra caja digital
        SYS->>SYS: Ejecuta ProcCajaGestionConductor @Indice=31
        SYS-->>COND: Resumen de turno: • Servicios: 8 vueltas • Transacciones: 250 • Producción total: $625.00 • Efectivo: $375.00 • Tarjeta: $250.00
        
        COND->>CAJ: 21. Se presenta para liquidación
        COND->>CAJ: Entrega efectivo: $375.00
        
        CAJ->>SYS: 22. Consulta producción digital
        SYS-->>CAJ: Producción verificada: $625.00
        
    else SIN ticketera
        COND->>CAJ: 20b. Entrega al final del turno: • Efectivo total recaudado • Talonario con boletos restantes
        
        COND->>CAJ: "Vendí A-001 a A-084"
        COND->>CAJ: "Sobrantes: A-085 a A-100"
        
        CAJ->>CAJ: 21. Cuenta boletos sobrantes físicamente
        CAJ->>CAJ: Calcula: (084-001+1) = 84 boletos vendidos
        CAJ->>CAJ: Producción esperada: 84 × $2.50 = $210.00
        CAJ->>CAJ: Cuenta efectivo entregado
        
        CAJ->>SYS: 22. Crea CCU manual (ProcRecaudoV2)
        CAJ->>SYS: Registra producción por conteo físico
    end
    
    CAJ->>SYS: 23. Consulta gastos administrativos
    SYS-->>CAJ: Gastos del día: • Combustible: $30.00 • Peajes: $15.00
    
    CAJ->>SYS: 24. Calcula liquidación final
    SYS-->>CAJ: Desglose completo:  Producción: $625.00 (-) Gastos: $45.00 (=) Neto: $580.00 Conductor (30%): $174.00 (-) Anticipos: $50.00 (=) A pagar: $124.00
    
    CAJ->>COND: 25. Presenta liquidación
    
    alt Conductor conforme
        COND-->>CAJ: ✅ Acepta liquidación
        CAJ->>SYS: 26. Genera comprobante
        CAJ->>COND: 27. Entrega efectivo: $124.00
        CAJ->>COND: Entrega comprobante firmado
        COND->>CAJ: 28. Firma conformidad
        
    else Conductor objeta
        COND-->>CAJ: ❌ No estoy de acuerdo
        CAJ->>CAJ: Intenta explicar cálculos
        
        alt Desacuerdo persiste
            CAJ->>SYS: Escala a Jefe de Liquidación
        end
    end

    Note over COND,MON: 📝 SITUACIONES ESPECIALES
    
    alt Incidencia en ruta
        COND->>MON: 29. Reporta: "Falla mecánica"
        COND->>MON: "Ubicación: Av. Lima altura 800"
        
        MON->>SYS: 30. Registra incidencia crítica
        MON->>MON: 31. Coordina apoyo: • Unidad de reemplazo • Mecánico
        MON->>COND: "Apoyo en camino, 15 minutos"
        
        COND->>COND: 32. Espera apoyo, asegura pasajeros
        
    else Devolución a pasajero
        COND->>COND: 33. Pasajero solicita devolución
        
        alt CON ticketera
            COND->>SYS: 34a. Registra devolución en sistema
            SYS->>SYS: Resta de producción
            
        else SIN ticketera
            COND->>COND: 34b. Anota devolución manual
            COND->>COND: Guarda boleto anulado
            COND->>COND: "Informaré al cajero"
        end
        
        COND->>COND: 35. Devuelve efectivo al pasajero
        
    else Alerta de seguridad
        COND->>MON: 36. 🚨 "EMERGENCIA - Asalto en curso"
        
        MON->>MON: 37. Activa protocolo emergencia
        MON->>MON: Contacta PNP con ubicación GPS
        MON->>COND: "No resistas, sigue instrucciones"
        MON->>SYS: Documenta incidente crítico
    end

    Note over COND,SYS: 🏁 CIERRE Y DOCUMENTACIÓN
    
    COND->>SYS: 38. Consulta resumen del día
    SYS-->>COND: Tu turno hoy: • Horas trabajadas: 8h • Servicios completados: 8 • Producción generada: $625.00 • Tu liquidación: $124.00 • Incidencias: 0
    
    COND->>COND: 39. Revisa documentos para mañana: • Licencia vigente ✅ • Certificado médico: vence en 45 días • SOAT vigente ✅
    
    SYS-->>COND: Todo en orden para operar mañana ✅
```