
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
