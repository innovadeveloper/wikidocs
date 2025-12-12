# 📋 CASOS DE USO DETALLADOS - MÓDULO ADMINISTRATIVO RRHH + TI

---

## PROVEEDOR DE SISTEMAS

### **CU-PRS-001: Configurar Dispositivo GPS en Unidad**

**Actor:** Proveedor de Sistemas (técnico)

**Flujo:**
1. Recibe dispositivo GPS nuevo: MG-00523
2. Accede a T-REG > Enlace de Unidad (Virtual/GPS)
3. Busca unidad: 089 F1P-925
4. Ingresa datos dispositivo:
   - **ID Equipo:** MG-00523
   - **IMEI:** 356938035643809
   - **N° SIM:** 987654321
   - **Operador:** Claro
   - **Firmware:** v3.2.1
5. Configura parámetros transmisión:
   - Intervalo envío: 30 seg
   - Eventos: Ignición ON/OFF, exceso velocidad, geocerca
7. Prueba comunicación:
   - Envía comando test → Dispositivo responde
   - Verifica posición en mapa
8. Asocia en sistema:
   - TbEnlaceGPS (Unidad ↔ Dispositivo)
   - Estado: "Activo - Transmitiendo"
9. Unidad lista para monitoreo en tiempo real

**Desenlace (mantenimiento/cambio):**
- Misma opción, marca "Desenlazar"
- Libera dispositivo para otra unidad


---

## ADMINISTRADOR DE SISTEMAS

### **CU-ADM-001 – Crear Usuario del Sistema**

**Actor:** Administrador de Sistemas  
**Actor Secundario:** Jefe de área solicitante  
**Precondición:** Solicitud formal de nuevo usuario aprobada

**Flujo Principal:**
1. Jefe de área solicita: "Nuevo usuario para Despachador Juan Pérez"
2. Admin accede a T-REG > Usuarios
3. Click "Nuevo Usuario"
4. Selecciona empleado: "PÉREZ, JUAN" (debe existir en Personas)
5. Define parámetros:
   - **Tipo perfil:** Despachador
   - **Sucursal:** Terminal Chuquitanta
   - **Usuario:** jperez@empresa
   - **Clave temporal:** Auto-generada
6. Sistema valida:
   - ✓ Empleado no tiene usuario activo
   - ✓ Usuario no duplicado
7. Confirma creación
8. Sistema registra en `TbUsuario`:
   - Estado: "Activo - Primera vez"
   - Requiere cambio clave en primer login
9. Sistema envía credenciales a email/WhatsApp del empleado
10. Admin notifica a Jefe de área
11. Empleado inicia sesión, cambia clave obligatoriamente

**Postcondición:** Usuario operativo con perfil asignado

**Flujos Alternos:**

**FA1: Empleado no existe en Personas**
- Sistema alerta: "Empleado no registrado"
- Admin solicita a Analista Personal registrar primero
- Retoma proceso cuando esté disponible

**FA2: Usuario duplicado**
- Sistema detecta: "jperez@empresa ya existe"
- Genera alternativa: jperez2@empresa
- Admin confirma o modifica

---

### **CU-ADM-002 – Asignar Permisos por Perfil**

**Actor:** Administrador de Sistemas  
**Precondición:** Perfil de usuario configurado

**Flujo Principal:**
1. Admin accede a T-REG > Permisos
2. Selecciona perfil: "Despachador"
3. Sistema muestra matriz de módulos:

```
MÓDULO DESPACHO:
☑ Ver cola de despacho
☑ Autorizar salidas
☑ Registrar incidencias
☐ Modificar programación
☐ Anular despachos

MÓDULO RECAUDO:
☑ Consultar producción
☐ Modificar producción
☐ Anular registros

MÓDULO SUMINISTRO:
☑ Consultar asignaciones
☐ Suministrar boletos
☐ Transferir boletos
```

4. Admin ajusta permisos según necesidad operativa
5. Guarda configuración
6. Sistema actualiza `TbPermisos` para ese perfil
7. Todos los usuarios con ese perfil reciben cambios inmediatamente

**Postcondición:** Perfil con permisos actualizados

**Flujo Alterno:**

**FA1: Crear perfil personalizado**
- Click "Nuevo Perfil"
- Nombre: "Despachador Nocturno"
- Copia permisos base de "Despachador"
- Ajusta específicos (ej: sin permiso anular)
- Guarda perfil personalizado

---

### **CU-ADM-003 – Gestionar Claves de Acceso**

**Actor:** Administrador de Sistemas  
**Actor Secundario:** Usuario solicitante  
**Precondición:** Usuario registrado en sistema

**Flujo Principal:**

**Escenario 1: Usuario olvidó clave**
1. Usuario contacta: "Olvidé mi clave"
2. Admin accede a T-REG > Gestión de Claves
3. Busca usuario: jperez@empresa
4. Valida identidad (DNI, datos personales)
5. Click "Resetear Clave"
6. Sistema genera clave temporal
7. Envía a email/WhatsApp del usuario
8. Usuario recibe, ingresa, sistema fuerza cambio inmediato
9. Usuario define nueva clave permanente

**Escenario 2: Bloqueo por intentos fallidos**
1. Sistema detecta: 5 intentos fallidos - Usuario bloqueado
2. Usuario contacta Admin
3. Admin verifica:
   - ¿Fue el usuario legítimo? → Desbloquea
   - ¿Intento de intrusión? → Mantiene bloqueado, investiga
4. Si desbloquea: Resetea clave temporal
5. Registra en auditoría

**Escenario 3: Cambio de clave periódico (política)**
1. Sistema alerta: "Clave de jperez@empresa vence en 3 días"
2. Usuario cambia proactivamente
3. Si no cambia: Sistema bloquea al vencer
4. Usuario solicita reseteo a Admin

**Postcondición:** Usuario con acceso restaurado

---

### **CU-ADM-004 – Consultar Usuarios Conectados**

**Actor:** Administrador de Sistemas  
**Precondición:** Sistema operativo

**Flujo Principal:**
1. Admin accede a T-REG > Consulta de Usuarios
2. Sistema muestra usuarios activos:

```
USUARIOS CONECTADOS - 11/12/2025 15:45

Usuario          | Perfil        | Terminal      | Último acceso | IP
-----------------|---------------|---------------|---------------|-------------
jperez@empresa   | Despachador   | Chuquitanta   | 15:44:23     | 192.168.1.45
mluna@empresa    | Cajero        | Villa Salvador| 15:43:10     | 192.168.2.30
rgarcia@empresa  | Supervisor    | Chuquitanta   | 15:40:05     | 192.168.1.50
```

3. Admin puede:
   - Filtrar por perfil, terminal, fecha
   - Ver última consulta realizada por usuario
   - Detectar sesiones inactivas
   - Cerrar sesión remotamente (si necesario)

4. Identifica sesión sospechosa:
   - IP no reconocida
   - Acceso fuera de horario
   - Usuario en 2 lugares simultáneamente
5. Investiga y toma acción (cerrar sesión, bloquear usuario)

**Postcondición:** Monitoreo de accesos activo

---
### **CU-ADM-005 – Desactivar Usuario**

**Flujo Principal (continuación):**
3. Busca usuario: jperez@empresa
4. Verifica no tiene sesiones activas
5. Click "Cambiar Estado"
6. Opciones:
   - **Suspender temporalmente** (licencia, vacaciones)
   - **Desactivar permanente** (cese laboral)
7. Selecciona: "Desactivar permanente"
8. Registra motivo: "Cese laboral - 11/12/2025"
9. Sistema ejecuta:
   - Cierra sesiones activas
   - TbUsuario: Estado "Inactivo"
   - Bloquea acceso inmediato
   - **NO elimina registro** (auditoría)
10. Mantiene histórico de operaciones del usuario
11. Notifica a jefes de área

**Postcondición:** Usuario sin acceso, datos preservados para auditoría

---

### **CU-ADM-006 – Auditar Actividad de Usuarios**

**Actor:** Administrador de Sistemas  
**Precondición:** Sistema con logs habilitados

**Flujo Principal:**
1. Admin accede a Sistema > Auditoría > Logs
2. Define filtros:
   - Usuario: jperez@empresa
   - Fecha: 01/12 - 11/12/2025
   - Módulo: Todos
3. Sistema muestra:

```
FECHA/HORA       | USUARIO       | ACCIÓN               | MÓDULO    | IP
-----------------|---------------|----------------------|-----------|-------------
11/12 14:30:15   | jperez        | Autorizó salida U-089| Despacho  | 192.168.1.45
11/12 14:25:10   | jperez        | Consultó cola        | Despacho  | 192.168.1.45
11/12 10:15:03   | jperez        | Login exitoso        | Sistema   | 192.168.1.45
10/12 22:30:45   | jperez        | Modificó programación| Despacho  | 192.168.1.45 ⚠️
```

4. Detecta anomalía:
   - Modificó programación (sin permiso)
5. Investiga, escala a Jefe Operaciones
6. Exporta reporte para evidencia

**Postcondición:** Trazabilidad completa de acciones

---

### **CU-ADM-007 – Configurar Parámetros del Sistema**

**Actor:** Administrador de Sistemas

**Flujo Principal:**
1. Accede a Sistema > Configuración General
2. Ajusta parámetros técnicos:
   - Tiempo sesión inactiva: 30 min
   - Intentos fallidos antes bloqueo: 5
   - Vigencia clave: 90 días
   - Backup automático: Diario 02:00 AM
   - Retención logs: 365 días
3. Guarda configuración
4. Sistema aplica cambios globalmente

---

Nota :
- Todo usuario requiere empleado existente en TbPersonas (Registro Inmutable de Creaciones para auditar)
- Flujo de Aprobación Dual (Admin + Jefe de operaciones)

---

## JEFE RRHH

### **CU-JRH-001: Aprobar Contratación de Conductores**

**ID:** CU-JRH-001

**Actor:** Jefe RRHH

**Precondiciones:**
- El Jefe RRHH debe estar autenticado en el sistema
- Debe existir al menos una solicitud de contratación de conductor en estado "Pendiente de Aprobación"
- El Analista Personal debe haber completado el proceso de evaluación del candidato
- La documentación obligatoria del candidato debe estar completa y validada
- Los resultados de las evaluaciones (técnica, psicológica, médica) deben estar disponibles en el sistema

**Trigger:** 
El Analista Personal envía una solicitud de contratación al Jefe RRHH después de completar el proceso de evaluación de un candidato a conductor.

**Flujo Principal:**
1. El Jefe RRHH accede al módulo de Gestión de Contrataciones
2. El sistema muestra la lista de solicitudes pendientes de aprobación con:
   - Datos del candidato (nombre, DNI, edad)
   - Fecha de solicitud
   - Analista responsable
   - Estado actual del proceso
3. El Jefe RRHH selecciona una solicitud específica para revisar
4. El sistema despliega el expediente completo del candidato:
   - Datos personales y de contacto
   - Experiencia laboral previa
   - Referencias laborales verificadas
   - Documentación validada (14 documentos obligatorios)
   - Resultados de evaluación técnica de conducción
   - Resultados de examen psicosomático
   - Resultados de verificación de antecedentes
   - Historial de infracciones de tránsito
5. El Jefe RRHH revisa cada sección del expediente
6. El Jefe RRHH evalúa si el candidato cumple con los requisitos mínimos:
   - Licencia de conducir vigente categoría adecuada
   - Puntos de licencia >= 75
   - Antecedentes penales limpios
   - Examen psicosomático aprobado
   - Experiencia mínima requerida
7. El Jefe RRHH registra observaciones y comentarios sobre el candidato
8. El Jefe RRHH selecciona la opción "Aprobar Contratación"
9. El sistema solicita confirmación de la decisión
10. El Jefe RRHH confirma la aprobación
11. El sistema actualiza el estado de la solicitud a "Aprobada"
12. El sistema genera automáticamente:
    - Notificación al Analista Personal para proceder con la contratación
    - Notificación al candidato sobre su aprobación
    - Registro en el log de auditoría de la decisión
13. El sistema crea el perfil del conductor en estado "Pre-contratado"
14. El sistema muestra mensaje de confirmación de aprobación exitosa

**Postcondiciones:**
- La solicitud de contratación queda registrada como "Aprobada" en el sistema
- El perfil del conductor es creado en estado "Pre-contratado" en la tabla TbPersona
- Se genera una notificación automática al Analista Personal para continuar con el proceso de incorporación
- Se envía notificación al candidato informando su aprobación
- Queda registrada la decisión en el log de auditoría con fecha, hora y usuario
- El candidato puede proceder a la siguiente fase (firma de contrato, inducción)

---

### **CU-JRH-004: Autorizar Cambios Salariales**

**ID:** CU-JRH-004

**Actor:** Jefe RRHH

**Precondiciones:**
- El Jefe RRHH debe estar autenticado en el sistema con permisos de autorización salarial
- Debe existir una solicitud de cambio salarial en estado "Pendiente de Autorización"
- El Especialista Planillas debe haber ingresado y justificado el cambio salarial
- El conductor solicitante debe estar en estado "Activo" en el sistema
- Debe existir historial salarial previo del conductor en TbPersonaPago

**Trigger:**
El Especialista Planillas envía una solicitud de ajuste salarial para un conductor, o el sistema detecta un evento automático que requiere ajuste salarial (antigüedad, cambio de categoría, bonificación especial).

**Flujo Principal:**
1. El Jefe RRHH accede al módulo de Gestión Salarial
2. El sistema muestra la lista de solicitudes de cambios salariales pendientes
3. El Jefe RRHH selecciona una solicitud específica
4. El sistema despliega la información detallada del cambio salarial
5. El Jefe RRHH revisa el cumplimiento de políticas salariales de la empresa
6. El Jefe RRHH evalúa la justificación presentada
7. El Jefe RRHH registra sus observaciones en el campo de comentarios
8. El Jefe RRHH selecciona "Autorizar Cambio Salarial"
9. El sistema solicita confirmación indicando el impacto presupuestal
10. El Jefe RRHH confirma la autorización
11. El sistema actualiza el estado y registros correspondientes
12. El sistema genera notificaciones automáticas
13. El sistema muestra confirmación de autorización exitosa

**Postcondiciones:**
- El cambio salarial queda autorizado y registrado en el sistema
- Se actualiza la tabla TbPersonaPago con el nuevo salario y fecha efectiva
- El Especialista Planillas recibe notificación para aplicar el cambio en la próxima nómina
- El conductor recibe notificación del ajuste salarial aprobado
- Queda registrado en auditoría la autorización
- El nuevo salario aplica a partir de la fecha efectiva establecida

---

### **CU-JRH-007: Generar Reportes Gerenciales de RRHH**

**ID:** CU-JRH-007

**Actor:** Jefe RRHH

**Precondiciones:**
- El Jefe RRHH debe estar autenticado en el sistema con permisos de generación de reportes
- Debe existir información histórica de personal en el sistema (mínimo 1 mes de datos)
- Las tablas relacionadas deben contener datos actualizados
- El módulo de reportes debe estar operativo

**Trigger:**
El Jefe RRHH necesita preparar informes ejecutivos para la Gerencia General o para reuniones de planificación estratégica, o el sistema tiene programado un reporte periódico mensual/trimestral.

**Flujo Principal:**
1. El Jefe RRHH accede al módulo de Reportes Gerenciales de RRHH
2. El sistema muestra el catálogo de reportes disponibles
3. El Jefe RRHH selecciona el tipo de reporte a generar
4. El sistema solicita los parámetros del reporte
5. El Jefe RRHH configura los parámetros deseados
6. El Jefe RRHH hace clic en "Generar Reporte"
7. El sistema procesa la solicitud y calcula indicadores clave
8. El sistema muestra una vista previa del reporte generado
9. El Jefe RRHH revisa el contenido del reporte
10. El Jefe RRHH selecciona "Exportar Reporte"
11. El sistema genera el archivo final en el formato seleccionado
12. El sistema registra en el log la generación del reporte
13. El sistema descarga automáticamente el archivo

**Postcondiciones:**
- El reporte gerencial es generado exitosamente en el formato solicitado
- Queda registrado en el log del sistema la generación del reporte
- El archivo queda disponible para descarga o es enviado por email
- El Jefe RRHH cuenta con información actualizada para toma de decisiones estratégicas

---

## ANALISTA PERSONAL

### **CU-ANP-001: Registrar Nuevo Conductor**

**ID:** CU-ANP-001

**Actor:** Analista Personal

**Precondiciones:**
- El Analista Personal debe estar autenticado en el sistema con permisos de registro de personal
- El sistema debe tener configurados los campos obligatorios para el registro de conductores
- Deben estar disponibles los catálogos necesarios

**Trigger:**
Un candidato a conductor se presenta en las oficinas de RRHH para iniciar su proceso de postulación, o se recibe una solicitud de empleo completa por canal digital.

**Flujo Principal:**
1. El Analista Personal accede al módulo de Gestión de Personal
2. El Analista Personal selecciona "Registrar Nuevo Conductor"
3. El sistema presenta el formulario de registro con secciones
4. El Analista Personal completa todas las secciones requeridas
5. El sistema valida automáticamente los datos ingresados
6. El Analista Personal adjunta documentos digitalizados
7. El Analista Personal hace clic en "Guardar"
8. El sistema genera un código único de conductor
9. El sistema muestra mensaje de confirmación
10. El sistema envía email automático al candidato

**Postcondiciones:**
- El perfil del conductor queda creado en el sistema con estado "Candidato"
- Se genera un código único de conductor que lo identificará en todo el sistema
- Se crea automáticamente un expediente digital del conductor
- El candidato recibe email de confirmación
- Queda registrada la acción en el log de auditoría

---

### **CU-ANP-003: Actualizar Expedientes de Personal**

**ID:** CU-ANP-003

**Actor:** Analista Personal

**Precondiciones:**
- El Analista Personal debe estar autenticado con permisos de edición
- Debe existir al menos un conductor registrado
- Los cambios a realizar deben estar justificados

**Trigger:**
El conductor solicita actualización de sus datos personales, o se detecta información desactualizada durante una revisión periódica.

**Flujo Principal:**
1. El Analista Personal accede al módulo de Gestión de Personal
2. El Analista Personal busca al conductor
3. El sistema muestra el expediente completo
4. El Analista Personal modifica la información necesaria
5. El Analista Personal registra el motivo de actualización
6. El Analista Personal hace clic en "Guardar Cambios"
7. El sistema actualiza el registro y mantiene historial
8. El sistema genera notificaciones correspondientes

**Postcondiciones:**
- La información del conductor queda actualizada en el sistema
- Se mantiene un registro histórico del cambio
- El conductor recibe notificación de actualización

---

### **CU-ANP-008: Administrar Vacaciones y Permisos**

**ID:** CU-ANP-008

**Actor:** Analista Personal

**Precondiciones:**
- El Analista Personal debe estar autenticado con permisos de gestión de ausencias
- Debe existir una solicitud de vacaciones o permiso de un conductor
- El conductor debe estar en estado "Activo"

**Trigger:**
El conductor presenta una solicitud de vacaciones o permiso.

**Flujo Principal:**
1. El Analista Personal accede al módulo de Gestión de Ausencias
2. El Analista Personal registra la solicitud
3. El sistema muestra disponibilidad del conductor
4. El Analista Personal evalúa la viabilidad operativa
5. El Analista Personal aprueba o rechaza la solicitud
6. El sistema actualiza calendarios y genera notificaciones

**Postcondiciones:**
- La solicitud queda registrada en el sistema
- El saldo de días de vacaciones se actualiza
- Se generan notificaciones a las partes involucradas

---
### **CU-ANP-009: Registrar Personal General**

**Actor:** Analista Personal  
**Alcance:** Inspectores, ayudantes, administrativos, mecánicos

**Flujo:**
1. Accede a T-REG > Personas > Nuevo
2. Selecciona tipo: Inspector / Ayudante / Administrativo / Mecánico
3. Ingresa datos básicos:
   - DNI, nombres, apellidos, fecha nacimiento
   - Contacto: celular, email, dirección
   - Datos laborales: fecha ingreso, área, cargo
4. Adjunta documentos según tipo:
   - **Inspector:** Certificación ATU, capacitación
   - **Ayudante:** Examen médico, capacitación
   - **Administrativo:** CV, certificados estudios
5. Sistema genera código empleado automático
6. Guarda en TbPersonas con TipoPersona específico
7. Habilita para creación de usuario (CU-ADM-001)

**Diferencia con conductores:** Menos documentos obligatorios (no requieren 14 docs).


---

## ESPECIALISTA DOCUMENTOS

### **CU-ESD-001: Verificar Documentación Conductor**

**ID:** CU-ESD-001

**Actor:** Especialista Documentos

**Precondiciones:**
- El Especialista Documentos debe estar autenticado en el sistema con permisos de verificación documental
- Debe existir un conductor registrado con documentos pendientes de verificación
- Los 14 tipos de documentos obligatorios deben estar definidos en TbVencimientoConcepto
- El sistema debe tener acceso a APIs de validación de entidades gubernamentales

**Trigger:**
El Analista Personal registra un nuevo conductor y genera alerta de verificación documental, o se cargan documentos renovados por un conductor activo.

**Flujo Principal:**
1. El Especialista Documentos accede al módulo de Gestión Documental
2. El sistema muestra el tablero con alertas de documentos pendientes
3. El Especialista Documentos selecciona un conductor específico
4. El sistema despliega el expediente documental con los 14 documentos obligatorios
5. Para cada documento, el Especialista realiza la verificación visual y digital
6. El Especialista consulta validaciones externas (RENIEC, MTC, PNP)
7. El Especialista registra observaciones específicas por documento
8. El Especialista marca el estado de cada documento (Aprobado/Observado/Rechazado)
9. El Especialista genera el resumen final
10. El sistema actualiza TbPersonaVencimiento
11. El sistema genera notificaciones automáticas
12. Si todos los documentos están aprobados, el conductor puede continuar

**Postcondiciones:**
- Todos los documentos quedan con estado de verificación registrado
- Se genera un reporte de verificación documental completo
- El conductor recibe notificación del resultado
- Se establecen alertas automáticas para renovaciones futuras

---

### **CU-ESD-002: Gestionar Renovación Documentos**

**ID:** CU-ESD-002

**Actor:** Especialista Documentos

**Precondiciones:**
- El Especialista Documentos debe estar autenticado
- Debe existir al menos un documento próximo a vencer
- El sistema debe tener configurados los plazos de alerta

**Trigger:**
El sistema genera alerta automática de documentos próximos a vencer (30 días antes).

**Flujo Principal:**
1. El Especialista Documentos accede al módulo de Gestión de Renovaciones
2. El sistema muestra dashboard de renovaciones por criticidad
3. El Especialista selecciona un conductor específico
4. El sistema despliega detalle del documento a renovar
5. El Especialista genera notificación de renovación al conductor
6. El sistema envía notificaciones por múltiples canales
7. El Especialista programa recordatorios automáticos
8. Cuando el conductor presenta documento renovado, el Especialista lo verifica
9. El Especialista aprueba el documento renovado
10. El sistema actualiza TbPersonaVencimiento con nuevos datos
11. El sistema programa nuevas alertas de renovación

**Postcondiciones:**
- El documento renovado queda registrado con nueva fecha de vencimiento
- Se eliminan alertas del documento anterior
- Se programan nuevas alertas para el nuevo período

---

### **CU-ESD-003: Archivar Documentación Personal**

**ID:** CU-ESD-003

**Actor:** Especialista Documentos

**Precondiciones:**
- El Especialista Documentos debe estar autenticado
- Debe existir documentación del personal que requiere archivo
- El sistema de gestión documental debe estar operativo

**Trigger:**
Se recibe documentación nueva de un conductor.

**Flujo Principal:**
1. El Especialista Documentos accede al módulo de Gestión de Archivos
2. El sistema muestra las opciones de archivo
3. El Especialista selecciona "Archivar Documentos Nuevos"
4. El Especialista identifica al conductor
5. El Especialista selecciona la categoría correspondiente
6. El Especialista ingresa los datos del documento
7. El Especialista escanea o carga el documento
8. El sistema genera metadatos automáticos
9. El Especialista verifica la calidad del archivo
10. El sistema registra el documento en TbPersonaDocumento
11. El sistema aplica políticas de retención

**Postcondiciones:**
- El documento queda archivado físicamente y digitalmente
- Se registra toda la información del archivo
- El expediente digital del conductor se actualiza

---

### **CU-ESD-004: Validar Certificados Médicos**

**ID:** CU-ESD-004

**Actor:** Especialista Documentos

**Precondiciones:**
- El Especialista Documentos debe estar autenticado
- Debe existir un certificado médico presentado
- Deben estar registrados los centros de salud autorizados

**Trigger:**
Un conductor presenta su examen psicosomático.

**Flujo Principal:**
1. El Especialista Documentos accede al módulo de Validación Médica
2. El sistema muestra certificados pendientes de validación
3. El Especialista selecciona al conductor
4. El sistema muestra expediente médico del conductor
5. El Especialista verifica autenticidad del certificado
6. El Especialista revisa resultados del examen (físico y psicológico)
7. El Especialista verifica cumplimiento de requisitos mínimos
8. El Especialista consulta con centro de salud si es necesario
9. El Especialista registra restricciones o condicionamientos
10. El Especialista aprueba, observa o rechaza el certificado
11. El sistema actualiza TbPersonaVencimiento
12. Si hay restricciones, se registran en TbPersonaRestriccion

**Postcondiciones:**
- El certificado médico queda validado y registrado
- Las restricciones médicas quedan documentadas
- El conductor recibe notificación del resultado

---

### **CU-ESD-005: Controlar Antecedentes Penales**

**ID:** CU-ESD-005

**Actor:** Especialista Documentos

**Precondiciones:**
- El Especialista Documentos debe estar autenticado
- Debe existir conductor que requiere verificación
- El conductor debe haber autorizado la consulta

**Trigger:**
Se registra un nuevo conductor y requiere validación inicial de antecedentes.

**Flujo Principal:**
1. El Especialista Documentos accede al módulo de Control de Antecedentes
2. El sistema muestra alertas de verificaciones pendientes
3. El Especialista identifica al conductor
4. El sistema muestra expediente de antecedentes
5. El Especialista verifica tres tipos: Policiales, Penales y de Tránsito
6. Para cada tipo, el Especialista valida autenticidad
7. El Especialista evalúa relevancia de antecedentes encontrados
8. El Especialista consolida resultados
9. El Especialista registra decisión final (Aprobado/Observado/Rechazado)
10. El sistema actualiza registros correspondientes
11. El sistema genera alertas según resultado

**Postcondiciones:**
- Los tres tipos de antecedentes quedan verificados
- El resultado queda documentado con fecha y observaciones
- Si fue rechazado, el conductor queda bloqueado

---

### **CU-ESD-006: Gestionar Documentos de Identidad**

**ID:** CU-ESD-006

**Actor:** Especialista Documentos

**Precondiciones:**
- El Especialista Documentos debe estar autenticado
- Debe existir conductor con documento de identidad presentado
- El sistema debe tener acceso a API de RENIEC

**Trigger:**
Un conductor presenta su DNI o carnet de extranjería.

**Flujo Principal:**
1. El Especialista Documentos accede al módulo de Gestión de Identidad
2. El Especialista indica el tipo de documento
3. El Especialista escanea o carga el documento
4. El sistema aplica OCR y extrae datos
5. El Especialista verifica autenticidad visual del documento
6. El Especialista realiza validación en línea con RENIEC/Migraciones
7. El Especialista compara datos y fotografía
8. El Especialista valida fechas y datos complementarios
9. El Especialista toma decisión (Válido/Observado/Rechazado)
10. Si es válido, el sistema actualiza TbPersona con datos completos
11. El sistema genera notificaciones correspondientes

**Postcondiciones:**
- El documento de identidad queda validado y registrado
- Los datos quedan verificados contra fuente oficial
- Si fue rechazado, queda bloqueado hasta subsanar

---

### **CU-ESD-007: Notificar Vencimientos**

**ID:** CU-ESD-007

**Actor:** Especialista Documentos

**Precondiciones:**
- El Especialista Documentos debe estar autenticado
- Debe existir documentos próximos a vencer
- El sistema debe tener configurados períodos de alerta

**Trigger:**
El sistema ejecuta proceso automático diario de revisión de vencimientos.

**Flujo Principal:**
1. El Especialista Documentos accede al módulo de Control de Vencimientos
2. El sistema muestra dashboard por criticidad
3. El Especialista selecciona una sección
4. El sistema despliega lista de conductores afectados
5. El Especialista selecciona conductores a notificar
6. El Especialista hace clic en "Generar Notificaciones"
7. El sistema presenta vista previa de notificación
8. El Especialista selecciona canales de envío
9. El Especialista personaliza el mensaje si es necesario
10. El sistema procesa envío de notificaciones
11. El sistema registra cada notificación en TbNotificacionDocumento
12. El sistema genera reporte de envío

**Postcondiciones:**
- Las notificaciones son enviadas exitosamente
- Queda registrado cada envío con resultado
- Se programan recordatorios automáticos

---

### **CU-ESD-008: Coordinar con Autoridades**

**ID:** CU-ESD-008

**Actor:** Especialista Documentos

**Precondiciones:**
- El Especialista Documentos debe estar autenticado
- Debe existir necesidad de coordinación con autoridades
- Deben estar registrados contactos de instituciones

**Trigger:**
Se requiere obtener o renovar documento oficial ante entidad gubernamental.

**Flujo Principal:**
1. El Especialista Documentos accede al módulo de Gestión de Trámites
2. El Especialista selecciona "Nuevo Trámite con Autoridad"
3. El Especialista selecciona tipo de trámite e institución
4. El Especialista identifica conductor(es) involucrado(s)
5. El Especialista completa información del trámite
6. El Especialista coordina con la institución (presencial/virtual/agente)
7. El Especialista registra datos del trámite en el sistema
8. El Especialista programa seguimiento
9. Cuando llega respuesta, el Especialista verifica documento
10. El Especialista actualiza sistema con documento obtenido
11. El sistema genera notificaciones de finalización

**Postcondiciones:**
- El trámite queda registrado con código único
- Se mantiene expediente digital completo
- El documento obtenido queda digitalizado y archivado

---

### **CU-ESD-009 – Configurar Reglas de Restricción Documental**

**Actor:** Especialista Documentos

**Flujo:**
1. Accede a T-REG > Configuración General > Restricciones Documentales
2. Define umbrales por tipo documento:

```
DOCUMENTO          | ALERTA 1  | ALERTA 2  | RESTRICCIÓN
-------------------|-----------|-----------|-------------
Licencia conducir  | 30 días   | 15 días   | 7 días
Certificado médico | 30 días   | 15 días   | 5 días
SOAT               | 45 días   | 20 días   | 10 días
Revisión técnica   | 60 días   | 30 días   | 15 días
Antecedentes       | 90 días   | 60 días   | 30 días
```

3. Configura acciones automáticas:
   - **30 días:** Email/SMS conductor
   - **15 días:** Notificación supervisor
   - **7 días:** Alerta crítica + restricción sugerida
4. Define severidad restricción:
   - **Advertencia:** Despacho con observación
   - **Bloqueo parcial:** Solo turnos diurnos
   - **Bloqueo total:** No puede ser despachado
5. Guarda configuración en TbConfigRestriccion
6. Sistema activa monitoreo automático diario

**El sistema sugiere, Jefe Operaciones ejecuta (CU-ESD-009).**

---

## ESPECIALISTA PLANILLAS

### **CU-ESP-001: Calcular Liquidación Conductor**

**ID:** CU-ESP-001

**Actor:** Especialista Planillas

**Precondiciones:**
- El Especialista Planillas debe estar autenticado
- Debe existir información completa del conductor
- Debe haber producción registrada en el período
- Las tarifas deben estar configuradas

**Trigger:**
El conductor finaliza su turno y entrega producción al cajero.

**Flujo Principal:**
1. El Especialista Planillas accede al módulo de Liquidación
2. El sistema muestra conductores pendientes de liquidar
3. El Especialista selecciona un conductor
4. El sistema recupera información de producción
5. El sistema muestra resumen de producción
6. El sistema recupera gastos operativos
7. El sistema aplica fórmula de liquidación según esquema
8. El sistema calcula descuentos y bonificaciones
9. El sistema genera cálculo final con detalle
10. El Especialista revisa el cálculo
11. El Especialista procesa la liquidación
12. El sistema registra en TbPersonaPago
13. El sistema genera comprobante de liquidación

**Postcondiciones:**
- La liquidación queda registrada con todos los detalles
- Se genera comprobante oficial
- El conductor queda habilitado para cobrar

---

### **CU-ESP-002: Generar Reportes Nómina**

**ID:** CU-ESP-002

**Actor:** Especialista Planillas

**Precondiciones:**
- El Especialista Planillas debe estar autenticado
- Debe existir liquidaciones procesadas
- El sistema de reportes debe estar operativo

**Trigger:**
Se cierra el período de nómina o la Gerencia solicita reporte.

**Flujo Principal:**
1. El Especialista accede al módulo de Reportes de Nómina
2. El sistema muestra catálogo de reportes
3. El Especialista selecciona tipo de reporte
4. El sistema solicita parámetros
5. El Especialista configura parámetros
6. El sistema procesa y calcula indicadores
7. El sistema genera reporte estructurado
8. El Especialista revisa contenido
9. El Especialista exporta el reporte
10. El sistema registra generación en log

**Postcondiciones:**
- El reporte queda generado en formato solicitado
- Queda registrado en auditoría
- El archivo queda disponible para descarga

---

### **CU-ESP-004: Generar Comprobantes de Pago**

**ID:** CU-ESP-004

**Actor:** Especialista Planillas

**Precondiciones:**
- El Especialista Planillas debe estar autenticado
- Debe existir liquidación procesada
- La plantilla de comprobante debe estar configurada

**Trigger:**
Se procesa una liquidación de conductor.

**Flujo Principal:**
1. El Especialista accede al módulo de Emisión de Comprobantes
2. El sistema muestra opciones de emisión
3. El Especialista selecciona liquidación
4. El sistema recupera información
5. El sistema muestra vista previa del comprobante
6. El Especialista revisa y confirma
7. El sistema genera número correlativo
8. El sistema registra en TbComprobanteNomina
9. El sistema genera archivo PDF
10. El sistema permite acciones adicionales (imprimir, enviar email)

**Postcondiciones:**
- El comprobante queda generado y registrado
- Se asigna número correlativo único
- El archivo PDF queda almacenado

---

### **CU-ESP-005: Calcular Prestaciones Sociales**

**ID:** CU-ESP-005

**Actor:** Especialista Planillas

**Precondiciones:**
- El Especialista Planillas debe estar autenticado
- Debe existir conductor con antigüedad
- Deben estar configuradas fórmulas de prestaciones

**Trigger:**
Se cumple período de prestaciones o conductor solicita cálculo.

**Flujo Principal:**
1. El Especialista accede al módulo de Prestaciones Sociales
2. El Especialista identifica al conductor
3. El sistema recupera historial laboral
4. El sistema calcula vacaciones acumuladas
5. El sistema calcula CTS (Compensación por Tiempo de Servicios)
6. El sistema calcula gratificaciones
7. El sistema genera resumen de prestaciones
8. El Especialista revisa y aprueba
9. El sistema registra en TbPersonaPrestaciones

**Postcondiciones:**
- Las prestaciones quedan calculadas y registradas
- Se genera comprobante de prestaciones
- Queda documentado para fines legales

---

### **CU-ESP-006: Administrar Préstamos y Anticipos**

**ID:** CU-ESP-006

**Actor:** Especialista Planillas

**Precondiciones:**
- El Especialista Planillas debe estar autenticado
- El conductor debe estar activo
- Deben estar definidas políticas de préstamos

**Trigger:**
El conductor solicita préstamo o anticipo.

**Flujo Principal:**
1. El Especialista accede al módulo de Préstamos
2. El Especialista registra solicitud del conductor
3. El sistema evalúa capacidad de pago
4. El sistema calcula cuotas según monto
5. El Especialista aprueba o rechaza solicitud
6. Si aprueba, el sistema genera cronograma de pagos
7. El sistema registra en TbPersonaPrestamo
8. El sistema programa descuentos automáticos

**Postcondiciones:**
- El préstamo queda registrado con cronograma
- Se programan descuentos automáticos en liquidaciones
- Queda documentado para seguimiento

---

### **CU-ESP-007: Procesar Liquidaciones Finales**

**ID:** CU-ESP-007

**Actor:** Especialista Planillas

**Precondiciones:**
- El Especialista Planillas debe estar autenticado
- Debe existir conductor con proceso de retiro
- Deben estar completos todos los datos laborales

**Trigger:**
El conductor renuncia, es despedido o finaliza contrato.

**Flujo Principal:**
1. El Especialista accede al módulo de Liquidación Final
2. El Especialista identifica al conductor
3. El sistema recupera historial laboral completo
4. El sistema calcula prestaciones pendientes
5. El sistema calcula compensaciones por tiempo de servicios
6. El sistema calcula vacaciones no gozadas
7. El sistema calcula indemnizaciones (si aplica)
8. El sistema calcula descuentos pendientes
9. El sistema genera liquidación final total
10. El Especialista revisa y aprueba
11. El sistema genera finiquito oficial

**Postcondiciones:**
- La liquidación final queda procesada
- Se genera finiquito oficial
- El conductor puede cobrar su liquidación final

---

## COORDINADOR CAPACITACIÓN

### **CU-COC-007: Mantener Registro de Capacitaciones**

**ID:** CU-COC-007

**Actor:** Coordinador Capacitación

**Precondiciones:**
- El Coordinador debe estar autenticado
- Debe existir capacitación realizada
- El conductor debe haber asistido

**Trigger:**
Se completa una sesión de capacitación.

**Flujo Principal:**
1. El Coordinador accede al módulo de Registro de Capacitaciones
2. El Coordinador selecciona la capacitación realizada
3. El sistema muestra lista de asistentes
4. El Coordinador registra asistencia y calificaciones
5. El Coordinador carga certificado de capacitación
6. El sistema actualiza TbPersonaCapacitacion
7. El sistema genera certificado para el conductor

**Postcondiciones:**
- La capacitación queda registrada en expediente
- Se genera certificado oficial
- El historial del conductor se actualiza

---

## SISTEMA (Automatizaciones RRHH)

### **CU-SIS-RH01: Gestionar Expedientes Digitales**

**ID:** CU-SIS-RH01

**Actor:** Sistema

**Precondiciones:**
- El sistema debe estar operativo
- Deben existir conductores registrados

**Trigger:**
Se crea o actualiza información de un conductor.

**Flujo Principal:**
1. El sistema detecta cambio en datos de conductor
2. El sistema actualiza expediente digital
3. El sistema organiza documentos por categorías
4. El sistema indexa para búsquedas
5. El sistema genera backup automático

**Postcondiciones:**
- El expediente digital queda actualizado
- Los documentos están organizados
- El backup está disponible

---

### **CU-SIS-RH02: Generar Alertas de Vencimientos**

**ID:** CU-SIS-RH02

**Actor:** Sistema

**Precondiciones:**
- El sistema debe estar configurado
- Deben existir documentos con fechas de vencimiento

**Trigger:**
Se ejecuta proceso automático diario.

**Flujo Principal:**
1. El sistema revisa todos los documentos
2. El sistema identifica documentos próximos a vencer
3. El sistema genera alertas según criticidad
4. El sistema envía notificaciones automáticas
5. El sistema registra alertas generadas

**Postcondiciones:**
- Las alertas quedan generadas y enviadas
- Los responsables reciben notificaciones
- Queda registro de alertas

---

### **CU-SIS-RH03: Calcular Nómina Automáticamente**

**ID:** CU-SIS-RH03

**Actor:** Sistema

**Precondiciones:**
- El sistema debe tener configuradas reglas de nómina
- Debe existir producción registrada

**Trigger:**
Se cierra período de nómina configurado.

**Flujo Principal:**
1. El sistema recupera todas las liquidaciones del período
2. El sistema aplica fórmulas configuradas
3. El sistema calcula totales por conductor
4. El sistema genera resumen consolidado
5. El sistema notifica a Especialista Planillas

**Postcondiciones:**
- La nómina queda calculada
- Los reportes están disponibles
- El Especialista recibe notificación

---

### **CU-SIS-RH04: Validar Documentación Digital**

**ID:** CU-SIS-RH04

**Actor:** Sistema

**Precondiciones:**
- El sistema debe tener acceso a APIs gubernamentales
- Debe existir documento a validar

**Trigger:**
Se carga un documento nuevo.

**Flujo Principal:**
1. El sistema extrae datos del documento (OCR)
2. El sistema consulta API correspondiente
3. El sistema valida autenticidad
4. El sistema registra resultado
5. El sistema notifica resultado al Especialista

**Postcondiciones:**
- La validación queda registrada
- El Especialista recibe notificación
- El documento queda marcado como validado/rechazado

---

### **CU-SIS-RH05: Generar Reportes de RRHH**

**ID:** CU-SIS-RH05

**Actor:** Sistema

**Precondiciones:**
- El sistema debe estar configurado
- Debe existir información histórica

**Trigger:**
Se programa generación automática de reportes.

**Flujo Principal:**
1. El sistema ejecuta query configurado
2. El sistema procesa datos
3. El sistema genera gráficos
4. El sistema genera archivo PDF/Excel
5. El sistema envía reporte por email

**Postcondiciones:**
- El reporte queda generado
- El archivo queda almacenado
- Los destinatarios reciben el reporte

---

### **CU-SIS-RH06: Controlar Acceso por Perfiles**

**ID:** CU-SIS-RH06

**Actor:** Sistema

**Precondiciones:**
- El sistema debe tener configurados perfiles
- Debe existir usuario intentando acceder

**Trigger:**
Un usuario intenta acceder a una función.

**Flujo Principal:**
1. El sistema verifica credenciales
2. El sistema consulta perfil del usuario
3. El sistema valida permisos
4. El sistema permite o deniega acceso
5. El sistema registra en log de auditoría

**Postcondiciones:**
- El acceso es controlado según perfil
- Queda registro de intentos de acceso
- La seguridad del sistema se mantiene

---

### **CU-SIS-RH07: Sincronizar con Entidades Externas**

**ID:** CU-SIS-RH07

**Actor:** Sistema

**Precondiciones:**
- El sistema debe tener configuradas conexiones
- Las APIs externas deben estar disponibles

**Trigger:**
Se programa sincronización automática.

**Flujo Principal:**
1. El sistema conecta con API externa
2. El sistema envía/recibe datos
3. El sistema valida información
4. El sistema actualiza base de datos local
5. El sistema registra resultado de sincronización

**Postcondiciones:**
- Los datos quedan sincronizados
- Queda registro de la sincronización
- Las inconsistencias se reportan

---

### **CU-SIS-RH08: Gestionar Workflow de Aprobaciones**

**ID:** CU-SIS-RH08

**Actor:** Sistema

**Precondiciones:**
- El sistema debe tener configurados workflows
- Debe existir solicitud pendiente

**Trigger:**
Se crea una solicitud que requiere aprobación.

**Flujo Principal:**
1. El sistema identifica tipo de solicitud
2. El sistema consulta workflow configurado
3. El sistema identifica aprobadores
4. El sistema envía notificaciones
5. El sistema registra cada aprobación/rechazo
6. El sistema ejecuta acción final según resultado

**Postcondiciones:**
- El workflow queda ejecutado
- Todas las aprobaciones quedan registradas
- La acción final se ejecuta automáticamente

---

## SISTEMA (Automatizaciones RRHH)

**CU-SIS-RH01**: Gestionar Expedientes Digitales  
Mantener archivo digital integrado de documentos y datos del personal.

**CU-SIS-RH02**: Generar Alertas de Vencimientos  
Notificar automáticamente sobre próximos vencimientos de documentos críticos.

**CU-SIS-RH03**: Calcular Nómina Automáticamente  
Procesar cálculos salariales basados en parámetros y reglas configuradas.

**CU-SIS-RH04**: Validar Documentación Digital  
Verificar autenticidad de documentos mediante sistemas gubernamentales.

**CU-SIS-RH05**: Generar Reportes de RRHH  
Crear automáticamente informes de indicadores de gestión humana.

**CU-SIS-RH06**: Controlar Acceso por Perfiles  
Gestionar permisos de acceso según roles y responsabilidades.

**CU-SIS-RH07**: Sincronizar con Entidades Externas  
Integrar datos con SENA, RUNT, Policía Nacional y otras instituciones.

**CU-SIS-RH08**: Gestionar Workflow de Aprobaciones  
Automatizar flujos de aprobación para contrataciones y cambios.