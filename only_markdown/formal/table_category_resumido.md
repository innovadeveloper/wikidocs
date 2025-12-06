
## CATEGORÍAS IDENTIFICADAS

### 1. GESTIÓN DE FLOTA Y UNIDADES (159 tablas)
**Propósito**: Control de vehículos, mantenimiento y seguimiento operacional

#### Subcategorías:

**1.1 Unidades Vehiculares (35 tablas)**
- TbUnidad (140 columnas) - Tabla maestra de vehículos
- TbUnidadActual (53 columnas)
- TbUnidadAuditoria (48 columnas)
- TbUnidadClase, TbUnidadTipo, TbUnidadVersion
- TbUnidadDatero, TbUnidadDateroNC, TbUnidadDateroSubControles
- TbUnidadKilometraje (23 columnas)
- TbUnidadKilometrajeHistorial
- TbUnidadOdometro
- TbUnidadTrack, TbUnidadTrackKilometraje, TbUnidadTrackSemana
- TbUnidadGrupo, TbUnidadNegocio
- TbUnidadPadronHistorico
- TbUnidadSituacionHistorial, TbUnidadSituacionTipo
- TbUnidadVencimiento
- TbUnidadVoladaColor
- TbUnidadesReporteFinalAux
- TB_UnidadEliminada
- Tb_Unidad (25 columnas)
- Tb_UnidadAuditor
- Tb_UnidadDispositivo
- Tb_UnidadKilometraje
- Tb_UnidadNominal
- Tb_UnidadRD
- Tb_UnidadRuta

**1.2 Mantenimiento y Repuestos (28 tablas)**
- TbRepuesto (28 columnas)
- TbRepuestoEstante, TbRepuestoSistema, TbRepuestoTipo, TbRepuestoUM, TbRepuestoDuracionTipo
- TbAlmacenRepuesto, TbAlmacenRepuestoSerie
- TbNeumatico (24 columnas)
- TbNeumaticoEstado, TbNeumaticoMarca, TbNeumaticoMedida, TbNeumaticoTipo
- TbNeumaticoHistorial
- TbUnidadNeumatico, TbUnidadNeumaticoHistorial
- TbOrdenTrabajo (25 columnas)
- TbOrdenTrabajoAtencion
- TbMantenimientoPlantilla, TbMantenimientoPlantillaDetalle
- TbDiagnosticoTaller (26 columnas)
- TbDiagnosticoTallerDetalle
- TbBitacoraIncidenciaMantenimiento

**1.3 Neumáticos (6 tablas)**
- TbNeumatico
- TbNeumaticoEstado, TbNeumaticoHistorial
- TbNeumaticoMarca, TbNeumaticoMedida, TbNeumaticoTipo

**1.4 Papeletas y Multas (5 tablas)**
- TbPapeletas (34 columnas)
- TbPapeletaDescarga, TbPapeletaDescargaDetalle
- TbUnidadPapeleta
- TbPersonaLicenciaPapeleta

**1.5 Restricciones (8 tablas)**
- TbUnidadRestriccion (25 columnas)
- TbUnidadRestriccionTipo
- TbCobranzaRestriccion
- TbRecorridoRestriccionAcceso
- TbVisorRestringir, TbVisorRestringirMotivo
- TbRutaRestriccionfaltaliquidacionEliminar

---

### 2. OPERACIONES Y SERVICIOS (193 tablas)
**Propósito**: Gestión de rutas, salidas, programación y control operativo

#### Subcategorías:

**2.1 Rutas y Recorridos (42 tablas)**
- TbRuta (98 columnas) - Tabla maestra de rutas
- TbRutaAuditoria, TbRutaJob
- TbRutaConfiguracion
- TbRutaTipo
- TbRecorrido (32 columnas)
- TbRecorridoAnillo
- TbRecorridoAuditoria
- TbRecorridoConcurrenteCP
- TbRecorridoDistorsionFrecuencia, TbRecorridoDistorsionFrecuenciaAuditoria
- TbRecorridoJob
- TbRecorridoVelocidadMaxima
- TbSubRecorrido
- Tb_Ruta (9 columnas)
- Tb_Recorrido (11 columnas)
- Tb_RecorridoCoords
- Tb_RecorridoXControl
- Tb_GeoRecorrido, Tb_GeoRecorridoDetalle
- PhoneList492 (Recorridos)

**2.2 Salidas y Despachos (47 tablas)**
- TbSalida (38 columnas)
- TbSalidaBoletoDetalle
- TbSalidaConductor
- TbSalidaControl
- TbSalidaIncidencia
- TbSalidaInspectoria, TbSalidaInspectoriaNomina
- TbSalidaOperando
- TbSalidaProgramada (36 columnas)
- TbSalidaProgramadaAbeja
- TbSalidaProgramadaClon
- TbSalidaProgramadaDatagramaXTU
- TbSalidaProgramadaDetalle
- TbSalidaProgramadaDetalleDatero
- TbSalidaProgramadaDetalleHistorico
- TbSalidaProgramadaKilometraje
- TbSalidaProgramadaParadero
- TbSalidaProgramadaTipo
- TbSalidaProgramadaTrunco
- TbSalidaReal
- TbSalidaRecorrido
- TbSalidaTablaIncidencias, TbSalidaTablaIncidenciasMotivo
- TbSalidaTipo
- TbSalidaValidaBoleto
- TbProgramacionSalida (58 columnas)
- TbProgramacionSalidaAux
- TbProgramacionSalidaDetalle
- TbProgramacionSalidaIncidencia
- TbProgramacionSalidaIncidenciaImplicado
- TbProgramacionSalidaMaestro
- TbProgramacionSalidaPerdida
- TbProgramacionSalidaResumen
- TbProgramacionSalidaTrunco
- TbProgramacionSalidaUnidadReten
- Tb_SalidaUnidad (25 columnas)
- Tb_SalidaUnidad2, Tb_SalidaUnidad2_Aux
- Tb_SalidaUnidadHoraPaso (múltiples versiones)
- Tb_SalidaUnidadRD, Tb_SalidaUnidadRespaldo
- TbDespachoPendiente
- TbDespachoOcurrencia, TbDespachoOcurrenciaMotivo, TbDespachoOcurrenciaMotivoTipo

**2.3 Programación y Frecuencias (31 tablas)**
- TbProgramacionConfiguracion
- TbProgramacionDia (20 columnas)
- TbProgramacionDiaHora, TbProgramacionDiaHoraDetalle
- TbProgramacionDiaPlanificacion
- TbProgramacionDiaSeguimiento
- TbProgramacionInicial
- TbProgramacionInspector
- TbProgramacionPlantilla
- TbIntervaloFrecuencia (17 columnas)
- TbIntervaloFrecuenciaDetalle
- TbSubIntervaloFrecuencia, TbSubIntervaloFrecuenciaDetalle
- TbConfiguracionFrecuencia
- TbMapeoFrecuenciaDA, TbMapeoFrecuenciaDB, TbMapeoFrecuenciaLSA, TbMapeoFrecuenciaLSB
- Tb_IFrecuencia, Tb_IFrecuenciaDetalle
- Tb_IntervaloFrecuencia
- Tb_Pro_FrecuenciaDetalle, Tb_Pro_FrecuenciaDia
- Tb_Programacion
- Tb_ProgramacionParametro
- Tb_ProgramacionSalida
- Tb_ParametroProgramacionSalida
- Tb_TiemposProgramados_Aux

**2.4 Controles y GeoCercas (39 tablas)**
- TbControl (40 columnas)
- TbControlDatagrama
- TbControlDia (21 columnas)
- TbControlDiaHistorico (22 columnas)
- TbControlDiaHistoricoConfiguracion
- TbControlDiaHistoricoDetalle, TbControlDiaHistoricoDetalleAuditoria
- TbControlDiaHistoricoHora, TbControlDiaHistoricoHoraAuditoria
- TbControlDiaHistoricoHoraDetalle, TbControlDiaHistoricoHoraDetalleAuditoria
- TbControlDiaSub
- TbControlGrupo
- TbControlHistorico
- TbControlHora (15 columnas)
- TbControlHoraAuditoria
- TbControlHoraSub
- TbControlSub
- TbControlTipo
- Tb_Control (10 columnas)
- Tb_GeoCerca (16 columnas)
- Tb_GeoCercaDia, Tb_GeoCercaHora
- Tb_GeoCercaRegistro
- Tb_GeoCercaTipo
- Tb_DispositivoGeocerca
- Tb_UnidadGeoCerca
- TbBoletoTarifaControl, TbBoletoTarifaControlAux
- TbParadero (24 columnas)
- TbParaderoAux
- TbParaderoDia, TbParaderoHora
- TbParaderoTipo
- TbPuntoMarcacionDatero, TbPuntoMarcacionDateroHistorico
- VistaMarcacionControlesSegunRegistroTrack
- VistaControles

**2.5 Servicios y Turnos (15 tablas)**
- TbServicio, TbServicioDetalle
- Tb_Servicio, Tb_ServicioDetalle
- Tb_ServicioViajes
- Tb_VueltaViajes
- TbTipoServicio
- TbTurno (29 columnas)
- TbTurnoCorreteo
- TbHorario (12 columnas)
- TbHorarioPersona

**2.6 Operatividad y Productividad (5 tablas)**
- Operatividad (5 columnas)
- Productividad (4 columnas)
- TbProduccion (34 columnas)
- TbProduccionDetalle, TbProduccionDevolucionBoleto
- TbProduccionGasto, TbProduccionSaldo

---

### 3. PERSONAL Y RECURSOS HUMANOS (92 tablas)
**Propósito**: Gestión de empleados, conductores, cobradores y personal operativo

#### Subcategorías:

**3.1 Datos Personales (31 tablas)**
- TbPersona (97 columnas) - Tabla maestra de personas
- TbPersonaAuditoria (61 columnas)
- TbPersonaDireccion
- TbPersonaEstadoCivil
- TbPersonaGradoInstruccion
- TbPersonaOcupacion
- TbPersonaPerfil
- TbPersonaTipo (8 columnas)
- TbPersonaTipoDetalle
- TbPersonaTelefonoGPS
- TbPersonaVencimiento
- TbPersonaVacuna
- Tb_Persona
- Tb_Operador (30 columnas)
- Tb_Operador2
- Tb_OperadorCargo
- Tb_OperadorMonitoreo
- Tb_OperadorTx
- Tb_Operador_Capacitacion
- Tb_Operador_Empresa
- TbCargo
- TbPuesto

**3.2 Control de Asistencia (13 tablas)**
- TbPersonaAsistencia (24 columnas)
- TbPersonaAsistenciaJustificacion
- TbPersonaAusencia
- TbPersonaAusenciaMotivo
- TbPersonaProgramacionAusencia
- TbPersonaProgramacionAusenciaTipo
- TbPersonaMarcacion
- TbPersonaHorario (29 columnas)
- TbPersonaHorarioDetalle
- TbPersonaHoraExtra
- TbPersonaHoraExtraMotivo
- TbDiaAtipico

**3.3 Biometría y Seguridad (7 tablas)**
- TbPersonaHuella (9 columnas)
- TbPersonaHuellaAuditoria
- TbPersonaHuellaAuditoriaDetalle
- TbPersonaHuellaAux
- TbDedo
- TbPersonaTarjeta (20 columnas)
- TbPersonaTarjetaHistorial

**3.4 Licencias y Documentación (6 tablas)**
- TbPersonaLicencia (14 columnas)
- TbPersonaLicenciaPapeleta
- TbDocumentoIdentidadTipo
- TbExpedienteTransito
- TbEnfermedad

**3.5 Remuneraciones y Pagos (20 tablas)**
- TbPersonaPago (22 columnas)
- TbPersonaSueldo
- TbPersonaCtaCte (26 columnas)
- TbPersonaDeuda (23 columnas)
- TbPersonaDeudaDetalle, TbPersonaDeudaPago
- TbPersonaMovimiento (25 columnas)
- TbPersonaMovimientoDetalle
- TbPersonaMovimientoTipo
- TbPersonaCuenta (26 columnas)
- TbPersonaCuentaProposito
- TbPersonaCuentaTipo
- TbPersonaLineaCredito
- TbEscalaSalarial
- TbHonorarioMonto
- TbAfp (8 columnas)
- TbAfpComisionTipo
- TbRegimenPensionario, TbRegimenPensionarioPeriodo
- TbRegimenSalud, TbRegimenSaludPeriodo

**3.6 Avales y Garantías (4 tablas)**
- TbPersonaAval
- TbPersonaAvalHistorico
- TbAvalConductorUnidad
- TbAvalConductorUnidadAuditoria

**3.7 Conceptos y Nómina (11 tablas)**
- TbConcepto (25 columnas)
- TbConceptoClase
- TbConceptoF, TbConceptoFormula
- TbConceptoGasto
- TbConceptoIncidencia
- TbConceptoRetencion
- TbConceptoTipo
- TbParametroReportePersonaMovimiento
- TbParametrosConceptos, TbParametrosConceptosDetalle

---

### 4. RECAUDACIÓN Y BOLETOS (87 tablas)
**Propósito**: Gestión de tarifas, boletos, validadores y recaudación

#### Subcategorías:

**4.1 Boletos y Tarifas (36 tablas)**
- TbBoleto (18 columnas)
- TbBoletoDuplicado
- TbBoletoFeriado
- TbBoletoNumeracion
- TbBoletoRuta (21 columnas)
- TbBoletoTarifa (25 columnas)
- TbBoletoTarifaControl, TbBoletoTarifaControlAux
- TbBoletoTarifaNormal
- TbBoletoTarifaParadero, TbBoletoTarifaParaderoAux
- TbBoletoTarifaPermanente (38 columnas)
- TbBoletoTarifaPromocion
- TbBoletoTarifaPromocionBeex
- TbBoletoTarifaTemporal
- TbBoletoTipo, TbBoletoTipoDia, TbBoletoTipoTarifa
- TbArticuloBoleto
- TbDevolucionBoleto, TbDevolucionBoletoDetalle
- TbAlmacenBoleto (22 columnas)
- TbAlmacenBoletoTipo
- TbMatrizBoletoTarifaAuditoria
- TbMotivoTarifa
- TbTransaccionBoleto
- VistaBoletoTransaccion

**4.2 Transacciones (11 tablas)**
- TbBoletoTransaccion (35 columnas)
- TbBoletoTransaccionLog
- TbBoletoTransaccionParadero
- TbBoletoTransaccionQr (54 columnas)
- TbBoletoTransaccionV2 (47 columnas)
- TbBoletoTransaccionYape (37 columnas)
- TbTransaccionOperacion
- TbTransaccionQR
- TbTransaccionYape
- TbQRYape
- TbQrTipo

**4.3 Validadores (20 tablas)**
- TbValidador (48 columnas)
- TbValidadorActualiza
- TbValidadorAlerta
- TbValidadorConexion
- TbValidadorDiseno
- TbValidadorIncidencia, TbValidadorIncidenciaTipo
- TbValidadorRegistroEncendido
- TbValidadorTipo
- TbValidadorUbicacion
- TbValidadorUsuario
- TbValidadorVersion (13 columnas)
- TbUnidadValidador (18 columnas)
- TbUnidadValidadorHistorico
- TbUnidadValidadorSituacion
- TbUnidadDatosValidadorActual
- TbPersonaValidadorAcceso
- TbLiquidacionValidador (38 columnas)
- TbLiquidacionValidadorTipo

**4.4 Recaudación (20 tablas)**
- TbRecaudo (33 columnas)
- TbRecaudoBoleto (24 columnas)
- TbRecaudoBoletoDetalle
- TbRecaudoDetalle
- TbRecaudoGasto
- TbRecaudoGastoDia
- TbRecaudoGastosV2
- TbRecaudoJustificacion
- TbRecaudoPre
- TbRecaudoV2 (40 columnas)
- TbRecaudoValidador (26 columnas)
- TbLiquidacion (7 columnas)
- TbLiquidacionUnidad (28 columnas)
- TbLiquidacionUnidadConcepto
- TbLiquidacionValidadorApertura
- TbLiquidacionValidadorConcepto
- TbLiquidacionValidadorImpresion
- VistaLiquidacion
- TbPosTxpLiquidacion

---

### 5. CAJAS Y FINANZAS (35 tablas)
**Propósito**: Control de caja, movimientos financieros y gestión contable

#### Subcategorías:

**5.1 Cajas (20 tablas)**
- TbCaja (26 columnas)
- TbCajaConductorSinVenta
- TbCajaConsolidadoObservacion
- TbCajaDocumento
- TbCajaGestion (40 columnas)
- TbCajaGestionAuditoria
- TbCajaGestionBoveda
- TbCajaGestionCombustible
- TbCajaGestionConductor (39 columnas)
- TbCajaGestionConductorAuditoria
- TbCajaGestionConductorBloqueo, TbCajaGestionConductorBloqueoAuditoria
- TbCajaGestionConductorConcepto
- TbCajaGestionConductorDetalle
- TbCajaGestionConductorEdicion
- TbCajaGestionContometro
- TbCajaGestionMovimiento (24 columnas)
- TbCajaGestionMovimientoTipo
- TbCajaMovimiento
- TbCajaMovimientoPrecinto
- TbCajaProducto

**5.2 Control de Caja (8 tablas)**
- TbCajaRecuento
- TbCajaSerie (22 columnas)
- TbCajaSucursal
- TbCajaUsuario
- TbCajaVisacionPagoNeto
- TbDenominacion
- TbFormaPago
- TbGastoFormaPago

**5.3 Contabilidad (7 tablas)**
- TbCuentaContableEmpresa (17 columnas)
- TbCuentaContableGeneral
- TbPCGECuenta, TbPCGEDivisionaria, TbPCGESubCuenta, TbPCGESubDivisionaria
- TbTipoCuentaContable

---

### 6. ALMACÉN E INVENTARIOS (61 tablas)
**Propósito**: Gestión de almacenes, inventarios, artículos y movimientos

#### Subcategorías:

**6.1 Almacenes (19 tablas)**
- TbAlmacen (27 columnas)
- TbAlmacenEstante (24 columnas)
- TbAlmacenEstanteDetalle (24 columnas)
- TbAlmacenGrifo
- TbAlmacenGrifoCombustible
- TbAlmacenIngresoInventario (36 columnas)
- TbAlmacenIngresoInventarioDetalle
- TbAlmacenIngresoInventarioDetalleSerie
- TbAlmacenMovimiento (86 columnas)
- TbAlmacenMovimientoDetalle (57 columnas)
- TbAlmacenProducto, TbAlmacenProductoDetalle
- TbAlmacenSalidaConsumo (35 columnas)
- TbAlmacenSalidaConsumoDetalle
- TbAlmacenSalidaPedido (20 columnas)
- TbAlmacenSalidaPedidoDetalle, TbAlmacenSalidaPedidoDetalleSerie
- TbAlmacenTipo
- TbAlmacenTransferencia, TbAlmacenTransferenciaDetalle

**6.2 Artículos y Productos (22 tablas)**
- TbArticulo (32 columnas)
- TbArticuloDisponible
- TbArticuloMovimiento (29 columnas)
- TbArticuloMovimientoDetalle
- TbArticuloMovimientoMotivo
- TbArticuloStock
- TbArticuloTipo
- TbProducto (101 columnas)
- TbProductoClase, TbProductoFamilia, TbProductoSegmento
- TbProductoConfiguracionPCGE
- TbProductoEstante
- TbProductoFormula
- TbProductoHistorico (63 columnas)
- TbProductoMonedaCuenta
- TbProductoMovimiento
- TbProductoNumeracionCorrelativa
- TbProductoPrecioHistorico
- TbProductoProducto
- TbProductoStock
- TbProductoTipo, TbProductoTipoIngreso
- TbProductoUM

**6.3 Insumos (5 tablas)**
- TbInsumo (18 columnas)
- TbInsumoAlmacenMovimiento (23 columnas)
- TbInsumoAlmacenMovimientoDetalle
- TbInsumoSuministro

**6.4 Suministros (7 tablas)**
- TbSuministro (13 columnas)
- TbSuministroDetalle (17 columnas)
- TbSuministroEntidad
- TbSuministroGestion
- VistaSuministro (56 columnas)

**6.5 Categorías y Clasificación (8 tablas)**
- TbCategoria
- TbCategoriaMarca
- TbCategoriaProducto
- TbProductoSegmentoTipo
- TbUM (Unidades de medida)

---

### 7. COMPRAS Y PROVEEDORES (18 tablas)
**Propósito**: Gestión de compras, cotizaciones, órdenes y proveedores

#### Subcategorías:

**7.1 Proceso de Compras (12 tablas)**
- TbCompra (24 columnas)
- TbCompraCotizacion (26 columnas)
- TbCompraCotizacionDetalle
- TbCompraOrden (22 columnas)
- TbCompraPedido (20 columnas)
- TbCompraPedidoDetalle
- TbOrdenCompra (31 columnas)
- TbOrdenCompraDetalle
- TbPedido (29 columnas)
- TbPedidoDetalle
- TbTipoCompra

**7.2 Proveedores (3 tablas)**
- TbProveedor (19 columnas)
- TbRequerimiento (17 columnas)
- TbRequerimientoAux

**7.3 Cotizaciones y Requisiciones (3 tablas)**
- TbRequerimientoDetalle, TbRequerimientoDetalleAux
- TbRequerimientoPersona, TbRequerimientoPersonaDetalle

---

### 8. VENTAS Y FACTURACIÓN (38 tablas)
**Propósito**: Gestión de ventas, facturación electrónica y documentos tributarios

#### Subcategorías:

**8.1 Ventas (15 tablas)**
- TbVenta (110 columnas)
- TbVentaCondicion (21 columnas)
- TbVentaCondicionPeriodo
- TbVentaCuota, TbVentaCuotaDetalle
- TbVentaDetalle (37 columnas)
- TbVentaDeuda (20 columnas)
- TbVentaDeudaPago (28 columnas)
- TbVentaDeudaPagoDetalle
- TbVentaDeudaTransferencia, TbVentaDeudaTransferenciaDetalle
- TbVentaFormaPago (18 columnas)
- TbProforma (34 columnas)
- TbProformaDetalle

**8.2 Documentos y Facturación (14 tablas)**
- TbDocumento (40 columnas)
- TbDocumentoBaja (19 columnas)
- TbDocumentoBajaDetalle
- TbDocumentoNumeracion
- TbNotaCreditoDebito (38 columnas)
- TbNotaCreditoDebitoDetalle (16 columnas)
- TbNotaCreditoDebitoTipo
- TbComprobanteTipo (6 columnas)
- TbComprobanteTipoAfectacion
- TbResumenComprobante (18 columnas)
- TbResumenComprobanteDetalle (21 columnas)
- TbGuiaRemision (26 columnas)
- TbGuiaRemisionDetalle
- TbVentaGuiaRemision, TbVentaGuiaRemisionDetalle

**8.3 Tributación SUNAT (9 tablas)**
- TbRespuestaSunat
- TbDetraccionBienServicio
- TbDetraccionMedioPago
- TbTipoTributo (6 columnas)
- TbTipoDocumento
- TbTrasladoModalidad, TbTrasladoMotivo
- TbFacturacionProceso

---

### 9. GASTOS Y EGRESOS (16 tablas)
**Propósito**: Control de gastos operativos y administrativos

#### Subcategorías:

**9.1 Gastos Generales (10 tablas)**
- TbGasto (37 columnas)
- TbGastoCompra (13 columnas)
- TbGastoCompraDetalle
- TbGastoConcepto
- TbGastoConceptoTipo (5 columnas)
- TbGastoLibramiento (18 columnas)
- TbGastoMovimiento (24 columnas)
- TbGastoMovimientoMotivo
- TbGastoMovimientoMultiple (21 columnas)
- TbGastoMovimientoMultipleDetalle

**9.2 Gastos de Unidades (6 tablas)**
- TbUnidadGastoSinOperar (16 columnas)
- TbUnidadGastoSinOperarConcepto
- TbUnidadConcepto (15 columnas)
- TbUnidadConceptoGasto, TbUnidadConceptoGastoHistorico
- TbGastoMovimientoTipo

---

### 10. RASTREO GPS Y DISPOSITIVOS (45 tablas)
**Propósito**: Seguimiento vehicular, telemetría y comunicaciones

#### Subcategorías:

**10.1 Dispositivos GPS (18 tablas)**
- TbDispositivo (67 columnas)
- Tb_Dispositivo (43 columnas)
- TbDispositivoConsumo
- TbDispositivoModelo, TbDispositivoTipo, TbDispositivoVersion
- TbDispositivoUnidad
- TbUnidadDispositivoHistorico
- TbUnidadDispositivoSituacion
- TbUnidadGps (18 columnas)
- TbDataLost
- TbExceptionDevice

**10.2 Registros de Tracking (15 tablas)**
- Tb_RegistroTrack (23 columnas)
- Tb_RegistroTrackRecuperar
- Tb_RegistroTrack_Diario
- TbRegistroTrackHistorico
- TbTracksConfirmados, TbTracksConfirmadosManual
- TbTracksIncidencia
- Tb_RegistroAlerta
- TbTrackOperacion
- TbDemoCoord (Demo)
- TbDemoSalidaDispositivo (Demo)
- VistaTGA

**10.3 Datagramas y Comunicación (12 tablas)**
- TbDatagrama (14 columnas)
- TbDatagramaComunicacion
- TbDatagramaHistorico, TbDatagramaHistoricoBK
- TbDatagramaTipo
- TbDatagramaXTU, TbDatagramaXTUHistorico
- TbComunicacionDestino
- TbComunicacionDual, TbComunicacionDualDetalle
- TbMensaje, TbMensajePredeterminado

---

### 11. ALERTAS Y EVENTOS (29 tablas)
**Propósito**: Gestión de alertas, eventos e infracciones

#### Subcategorías:

**11.1 Alertas (13 tablas)**
- TbAlerta (14 columnas)
- Tb_Alerta (5 columnas)
- TbAlertaInspectoria (22 columnas)
- TbAlertaSolicitud
- TbAlertaSolicitudValidador (22 columnas)
- Tb_AlertaRecepcion (14 columnas)
- TbUnidadAlerta (38 columnas)
- TbUnidadAlertaActual (23 columnas)
- TbUnidadAlertaControlActual
- VistaAlertasPorEmpreas, VistaAlertasPorEmpresa

**11.2 Eventos e Incidencias (16 tablas)**
- Tb_Eventos (46 columnas)
- Tb_Eventos_Auditoria, Tb_Eventos_Detalle
- TbIncidencia (41 columnas)
- TbIncidenciaCategoria
- TbIncidenciaCovid
- TbIncidenciaEmpresa (32 columnas)
- TbIncidenciaEmpresaConcepto
- TbIncidenciaEmpresaHistorial
- TbIncidenciaEmpresaImagen
- TbIncidenciaTipo (14 columnas)
- Tb_NominaInfraccionEvento
- Tb_AmbitoInfraccionEvento
- Tb_SancionInfraccionEvento
- Tb_TipoInfraccionEvento
- TbSATInfraccion

---

### 12. EMPRESAS Y ORGANIZACIÓN (23 tablas)
**Propósito**: Estructura empresarial, sucursales y entidades

#### Subcategorías:

**12.1 Empresas (8 tablas)**
- TbEmpresa (53 columnas)
- Tb_Empresa (13 columnas)
- TbEmpresaDireccion
- TbConcesionario
- TbConsorcio
- Tb_Consorcio
- TbAccionista
- Tb_Accionista

**12.2 Sucursales y Ubicaciones (8 tablas)**
- TbSucursal (20 columnas)
- TbSucursalVenta
- TbBahia (12 columnas)
- TbArea, TbAreaInterdistrital
- TbZona (23 columnas)
- TbDistrito
- Tb_Distrito

**12.3 Geografía (7 tablas)**
- TbPais (7 columnas)
- TbUbigeoDepartamento
- TbUbigeoDistrito
- TbUbigeoProvincia
- TbPuntoCardinal
- TbMunicipalidad

---

### 13. USUARIOS Y SEGURIDAD (28 tablas)
**Propósito**: Control de acceso, perfiles y auditoría

#### Subcategorías:

**13.1 Usuarios (15 tablas)**
- TbUsuario (47 columnas)
- Tb_Usuario (12 columnas)
- TbUsuarioContabilidadEmpresa
- TbUsuarioDespacho
- TbUsuarioMenuAccion
- TbUsuarioPerfil (8 columnas)
- TbUsuarioPerfilAccion
- TbUsuarioSucursalHistorico
- TbUsuarioTipo (22 columnas)
- TbUsuarioTipoRecorrido
- TbUsuarioTipoRuta
- TbUsuarioTipoUnidad
- TbUsuarioUnidad
- Tb_UsuarioUnidad
- Tb_SistemaUsuario

**13.2 Perfiles y Menús (8 tablas)**
- TbMenu (42 columnas)
- Tb_Menu (5 columnas)
- TbMenuAccion
- TbMenuGrupo
- Tb_Perfil
- Tb_PerfilMenu
- TbSistemaModulo

**13.3 Auditoría y Sesiones (5 tablas)**
- Audit (11 columnas)
- TbAuditoria (10 columnas)
- TbAuditoriaLogueo
- TbAuditoriaTipo
- TbSesion (29 columnas)
- Tb_Sesion (24 columnas)

---

### 14. COMBUSTIBLE (15 tablas)
**Propósito**: Gestión de combustible y consumos

- TbCombustible (23 columnas)
- TbCombustibleCategoria
- TbCombustiblePrecio (7 columnas)
- TbSurcursalCombustiblePrecio
- TbSurcursalCombustiblePrecioAuditoria
- TbSurtidor (13 columnas)
- TbSurtidorCombustible (14 columnas)
- TbSurtidorCombustibleAuditoria
- TbSurtidorConsumo (15 columnas)

---

### 15. INSPECTORÍA Y SUPERVISIÓN (12 tablas)
**Propósito**: Control de inspectores y supervisión operativa

- TbInspectorAbordajeUnidad (15 columnas)
- TbInspectorLocalizacion
- TbInspectoria (16 columnas)
- TbProgramacionInspector
- TbRegularInspectoria
- TbSesionInspector, TbSesionInspectorDetalle

---

### 16. TRANSBORDO Y TRANSFERENCIAS (7 tablas)
**Propósito**: Gestión de transbordos entre unidades

- TbTransbordo (21 columnas)
- TbTransbordoDetalle
- TbTransbordoOperacion
- TbTransferencia (36 columnas)
- TbTransferenciaDetalle, TbTransferenciaDetalleSerie
- TbTrasladoProduccionAuditoria

---

### 17. TARJETAS Y MEDIOS DE PAGO (17 tablas)
**Propósito**: Gestión de tarjetas de pago electrónico

#### Subcategorías:

**17.1 Tarjetas (9 tablas)**
- TbTarjeta (40 columnas)
- TbTarjetaEntrega
- TbTarjetaHistorial
- TbTarjetaLiquidacion
- TbTarjetaRecarga
- TbTarjetaRegistroProduccion
- TbTarjetaTipo

**17.2 Pagos Electrónicos (8 tablas)**
- TbPosTxp (9 columnas)
- TbPosTxpPersona
- TbVisa
- TbNiubizDataDetalle, TbNiubizDataMaestro
- TbUnidadQr, TbUnidadQrBeex
- TbUnidadQrActivoAuditoria

---

### 18. ENTIDADES FINANCIERAS (5 tablas)
**Propósito**: Gestión de bancos y cuentas financieras

- TbEntidad
- TbEntidadFinanciera
- TbEntidadFinancieraCuenta (13 columnas)
- TbEntidadFinancieraCuentaTipo
- TbCuentaProposito

---

### 19. REPORTES Y VISTAS (22 tablas + vistas)
**Propósito**: Reportes, consultas y análisis

#### Subcategorías:

**19.1 Configuración de Reportes (5 tablas)**
- TbReporte (27 columnas)
- TbReporteGrupo
- TbPropiedadReporte
- TbReporteCobranzaPorServicio, TbReporteCobranzaPorServicioDetalle
- tmpTbReporte

**19.2 Reportes de Velocidad (4 tablas)**
- TbReporteVelocidad, TbReporteVelocidad2
- TbReporteVelocidadPromedio, TbReporteVelocidadPromedio2

**19.3 Vistas de Análisis (13 vistas)**
- VistaControles
- VistaErrorLogueo
- VistaErrorSalidaUnidad
- VistaIMEIEmpresa
- VistaUnidadesCelular
- VistaUnidadesTGA
- VistaVerificacionSalidaUnidad
- VstaFlotaBus

---

### 20. CONFIGURACIÓN Y PARÁMETROS (21 tablas)
**Propósito**: Configuraciones del sistema y parámetros generales

- TbConfiguracion (170 columnas)
- TbConfiguracionAuditoria (168 columnas)
- TbGrupoConfiguracion
- Tb_ParametroConfiguracion
- Tb_ParametrosGeneral
- TbParametro
- TbEstado (6 columnas)
- Tb_Estado
- TbEstadoRequerimiento
- TbRegistroTipo
- TbSituacion
- TbTiempoMaximoViaje
- Tb_TablaGeneral
- TbFeriado (28 columnas)
- TbFeriadoFijo
- TbDia
- Tb_Dia
- Tb_Sistema

---

### 21. SANCIONES Y MULTAS (11 tablas)
**Propósito**: Gestión de sanciones automáticas y penalidades

- TbSancionesAutomaticas (19 columnas)
- TbSancionesAutomaticasAuditoria
- TbSancionesAutomaticasDetalle
- TbSancionesAutomaticasDetalleAuditoria
- TbSancionesAutomaticasDetalleReemplazar
- TbSancionesAutomaticasMatriz
- TbDescuentoCargo

---

### 22. SUBSIDIOS Y PROGRAMAS ESPECIALES (4 tablas)
**Propósito**: Gestión de subsidios y programas de apoyo

- TbSubsidioATU (31 columnas)
- TbSubsidioATUMaestro
- TbConfiabilidadAbeja
- TbConfiabilidadConcepto

---

### 23. UNIDADES DE COLA Y DESPACHO (7 tablas)
**Propósito**: Control de colas de despacho

- TbUnidadColaDespacho (32 columnas)
- TbUnidadColaDespachoBK
- TbGestionColaDespachoHistorico
- TbLogProcColaDespacho

---

### 24. SISTEMAS LEGACY Y TEMPORALES (21 tablas)
**Propósito**: Tablas temporales, de prueba y sistemas antiguos

#### Subcategorías:

**24.1 ASP.NET State (2 tablas)**
- ASPStateTempApplications
- ASPStateTempSessions

**24.2 Tablas de Prueba y Log (10 tablas)**
- TB_PRUEBAPROGRAMACION
- TBMENSAJEBENJAMIN2020
- TbLogAdrian, TbLogDaniel, TbLogElias, TbLogFabi, TbLogJohan
- TbLogCierreSesionValidador
- TbERROR

**24.3 Tablas Temporales (9 tablas)**
- TbTmpReporteFondo
- Tb_TemporalRegistrosDuplicados
- Tb_Tmp
- TmpTbGastoCompra, TmpTbGastoCompraDetalle
- TmpTbGastoLibramiento
- TbDetalleEliminar, TbDetalleEliminarAux
- TbEliminar

---

### 25. MENSAJERÍA Y COMUNICACIONES (13 tablas)
**Propósito**: Gestión de mensajes y comunicaciones

- TbMensajeMasivo (13 columnas)
- TbMensajeER
- TbMensajeJohan
- TbMensajeLOG
- TbRecordatorio (12 columnas)
- TbLlamadasRTC (11 columnas)
- TbLlamadasRTCDetalle
- TbLlamadasRTCTipo
- TbUnidadLlamada (21 columnas)
- TbUnidadMensajeTipo

---

### 26. MARCAS Y FABRICANTES (7 tablas)
**Propósito**: Catálogos de marcas y fabricantes

- TbMarca (10 columnas)
- TbFabricante
- TbMarcacionTipo
- TbInstaladorTipo
- TbFormatoImpresion
- TbFuente

---

### 27. VARIAS Y MISCELÁNEAS (15 tablas)
**Propósito**: Tablas de soporte y utilidades

- TbContratoTipo
- TbArchivoTipo
- TbImagen (11 columnas)
- TbIndice
- TbGenerarCodigo
- TbGeoMapa
- TbGestionClaveHistorial
- TbMotivo (10 columnas)
- TbMotivoDesenlace
- TbMotivoGeneraDeuda
- TbMotivoJustificacion
- TbJustificacionTipo
- TbMoneda (18 columnas)
- TbMonedaTipoCambio (23 columnas)
- TbNacionalidad

---

### 28. SISTEMA Y UTILIDADES (4 tablas)
**Propósito**: Tablas del sistema

- sysdiagrams (5 columnas) - Diagramas de SQL Server
- TbActualiza
- TbActualizarHojaRutaManual
- TbDatoAndroid

---

### 29. ERRORES Y LOGS (5 tablas)
**Propósito**: Registro de errores del sistema

- TbErrorGeneral (7 columnas)
- TbErrorGeneralQr
- TbErrorLog98
- UsuariosApp

---

### 30. CLIENTES (3 tablas)
**Propósito**: Gestión de clientes

- TbCliente (20 columnas)
- TbCupo, TbCupoAccionista, TbCupoAccionistaCedido
- TbCupoHistorial

---

### 31. GRUPOS Y MATRICES (6 tablas)
**Propósito**: Agrupaciones y configuraciones matriciales

- TbGrupo (10 columnas)
- TbMatrizProgramacionCobranza
- TbMatrizProgramacionCobranzaDetalle
- TbMapeoOperacional

---

### 32. ACCESO Y PERMISOS (4 tablas)
**Propósito**: Control de accesos específicos

- Tb_Usuario_Acceso
- Tb_Usuario_Consulta
- Tb_Usuario_Descarga
- Tb_Usuario_Recarga
- TbPermisoHistorico

---

### 33. INTEGRACIÓN INSPECCIÓN TÉCNICA (1 tabla)
**Propósito**: Integración con sistemas de inspección vehicular

- TbCronogramaInspeccionTecnicaVehicular

---

### 34. HISTORIAL Y AUDITORÍA ADICIONAL (8 tablas)
**Propósito**: Tablas de respaldo y auditoría adicional

- TbNotaCreditoDebito_BK_03062025
- TbNotaCreditoDebitoDetalle_BK_03062025
- TbUnidadQrBK
- TbRequerimientoAux, TbRequerimientoDetalleAux
- TbProgramacionSalidaAux
- Tb_SalidaUnidad2_Aux
- Tb_SalidaUnidadHoraPaso2_Aux

---

## ANÁLISIS CUANTITATIVO POR CATEGORÍA

| Categoría | Cantidad Tablas | % Total |
|-----------|----------------|---------|
| 1. Gestión de Flota y Unidades | 159 | 18.5% |
| 2. Operaciones y Servicios | 193 | 22.5% |
| 3. Personal y RRHH | 92 | 10.7% |
| 4. Recaudación y Boletos | 87 | 10.1% |
| 5. Cajas y Finanzas | 35 | 4.1% |
| 6. Almacén e Inventarios | 61 | 7.1% |
| 7. Compras y Proveedores | 18 | 2.1% |
| 8. Ventas y Facturación | 38 | 4.4% |
| 9. Gastos y Egresos | 16 | 1.9% |
| 10. Rastreo GPS y Dispositivos | 45 | 5.2% |
| 11. Alertas y Eventos | 29 | 3.4% |
| 12. Empresas y Organización | 23 | 2.7% |
| 13. Usuarios y Seguridad | 28 | 3.3% |
| 14. Combustible | 15 | 1.8% |
| 15. Inspectoría y Supervisión | 12 | 1.4% |
| Otras categorías (16-34) | 106 | 12.4% |
| **TOTAL** | **857** | **100%** |
