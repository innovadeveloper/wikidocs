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
