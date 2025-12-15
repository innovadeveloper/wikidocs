
### **Schema: `identity`**
```
1.  user
2.  user_session
3.  permission
4.  user_permission
5.  permission_template
6.  permission_template_detail
7.  activity_log
8.  login_attempt
```

### **Schema: `shared`**
```
9.   company                    -- RUC, razón social del operador
10.  concession                 -- Concesión otorgada por autoridad
11.  concessionaire             -- Concesionario (puede = company)
12.  authority                  -- ATU, Municipalidad
13.  terminal                   -- Puntos operativos (Lado A/B)
14.  catalog                    -- Catálogos genéricos
15.  document_type              -- 14 tipos documentos obligatorios
16.  configuration              -- Parámetros globales
17.  notification_template      -- Templates de notificaciones
18.  file_storage               -- Archivos adjuntos (S3/MinIO)
```

### **Schema: `core_operations`**
```
19.  route                      -- Ruta (asignada a company)
20.  route_polyline             -- Geometría visualización
21.  route_side                 -- Lado A / Lado B (IDA/VUELTA)
22.  stop                       -- Paraderos
23.  checkpoint                 -- Controles de paso
24.  speed_zone                 -- Zonas velocidad máxima
25.  geofence                   -- Geocercas (ruta, paradero, terminal)
26.  geofence_type              -- Tipos de geocerca
27.  geofence_event             -- Eventos de geocerca
28.  frequency_schedule         -- Frecuencias objetivo por horario
29.  operational_restriction    -- Restricciones (conductor/vehículo)
30.  restriction_type           -- Tipos de restricción
31.  dispatch_schedule          -- Programación de salidas
32.  dispatch_schedule_detail   -- Detalle horarios programados
33.  dispatch_queue             -- Cola de despacho
34.  dispatch                   -- Despachos autorizados
35.  dispatch_exception         -- Excepciones autorizadas
36.  trip                       -- Viajes/servicios ejecutados
37.  trip_event                 -- Eventos en ruta (paradas, checkpoints)
38.  incident                   -- Incidencias operativas
39.  incident_type              -- Tipos de incidencia
40.  alert                      -- Alertas automáticas
41.  alert_type                 -- Tipos de alerta
```

### **Schema: `core_finance`**
```
42.  fare                       -- Tarifas por tipo boleto
43.  ticket_type                -- Tipos de boleto (DIRECTO, URBANO, etc)
44.  ticket_inventory           -- Almacén boletos físicos
45.  ticket_batch               -- Lotes de talonarios
46.  ticket_batch_assignment    -- Salida almacén → cajero
47.  ticket_supply              -- Suministro cajero → conductor
48.  validator                  -- Ticketeras/validadores electrónicos
49.  validator_assignment       -- Asignación validador → vehículo
50.  trip_production            -- Producción por viaje
51.  partial_delivery           -- Entregas parciales en ruta
52.  cashier_box                -- Caja del cajero
53.  cashier_box_movement       -- Movimientos de caja
54.  settlement                 -- Liquidación conductor
55.  settlement_detail          -- Detalle boletos vendidos
56.  settlement_adjustment      -- Ajustes autorizados
57.  owner_settlement           -- Liquidación a propietario
58.  administrative_expense     -- Gastos administrativos
59.  payment                    -- Pagos a conductores/propietarios
60.  financial_report           -- Reportes financieros
```

### **Schema: `fleet`**
```
61.  vehicle                    -- Unidades vehiculares
62.  vehicle_document           -- Documentos de vehículo (SOAT, revisión)
63.  vehicle_owner              -- Propietarios de unidades
64.  vehicle_owner_share        -- Porcentajes de participación
65.  vehicle_assignment         -- Asignación conductor → vehículo
66.  gps_device                 -- Dispositivos GPS/trackers
67.  beacon                     -- BLE beacons
68.  beacon_pairing_request     -- Solicitudes de emparejamiento
69.  vehicle_beacon             -- Beacon asignado a vehículo
70.  maintenance_type           -- Tipos de mantenimiento
71.  maintenance_schedule       -- Plan de mantenimiento
72.  maintenance_record         -- Registros de mantenimiento
73.  fuel_load                  -- Cargas de combustible
74.  gps_raw_event              -- Eventos GPS brutos (particionada)
75.  gps_processed_location     -- Ubicaciones procesadas
```

### **Schema: `hr`**
```
76.  person                     -- Personas (base)
77.  person_document            -- Documentos personales
78.  person_address             -- Direcciones
79.  person_contact             -- Contactos
80.  driver                     -- Conductores (extiende person)
81.  driver_license             -- Licencias de conducir
82.  driver_infraction          -- Papeletas/infracciones
83.  inspector                  -- Inspectores de campo
84.  personnel                  -- Personal general (admin, mecánicos)
85.  medical_exam               -- Exámenes psicosomáticos
86.  background_check           -- Antecedentes penales/policiales
87.  employment_contract        -- Contratos laborales
88.  attendance                 -- Asistencia/marcaciones
89.  absence                    -- Ausencias/permisos
90.  vacation                   -- Vacaciones
91.  payroll_period             -- Períodos de nómina
92.  payroll_record             -- Registros de planilla
93.  payroll_concept            -- Conceptos (sueldo, bono, descuento)
94.  payroll_detail             -- Detalle por concepto
95.  loan                       -- Préstamos/anticipos
96.  loan_installment           -- Cuotas de préstamo
97.  training_program           -- Programas de capacitación
98.  training_attendance        -- Asistencia a capacitaciones
99.  biometric_fingerprint      -- Huellas dactilares
100. access_card                -- Tarjetas de acceso
```

### **Schema: `inspection`**
```
101. field_inspection           -- Inspecciones de campo
102. route_verification         -- Verificaciones de cumplimiento ruta
103. frequency_check            -- Control de frecuencias
104. vehicle_inspection         -- Inspección estado de unidades
105. inspection_finding         -- Hallazgos/observaciones
106. inspection_evidence        -- Evidencias (fotos/videos)
107. inspection_report          -- Reportes consolidados
```

### **Schema: `audit`**
```
108. change_log                 -- Cambios en registros críticos
109. data_retention_policy      -- Políticas de retención
110. archived_data              -- Datos archivados
```

---
