
## 🔄 FLUJOS OPERATIVOS POR MODALIDAD

### **🎫 FLUJO BOLETOS FÍSICOS**

#### **1. Preparación**
```
CAJERO → Asigna talonario al conductor (A001-A100)
       → Registra entrega en sistema (ProcAlmacenBoleto @Indice=20)
       → Conductor recibe: Serie + NumInicio + NumFin
```

#### **2. Operación**
```
CONDUCTOR → Abre caja (ProcCajaGestionConductor @Indice=21)
         → Vende boletos manualmente durante ruta
         → Registra números de serie vendidos
         → Acumula efectivo recibido
```

#### **3. Entrega**
```
CONDUCTOR → Cierra caja (@Indice=31)
         → Entrega: Efectivo + Talonario restante
         ↓
CAJERO    → Cuenta boletos vendidos físicamente
         → Calcula: Boletos vendidos × Precio = Producción esperada
         → Compara vs. efectivo entregado
         → Registra diferencias (ProcRecaudo @Indice=20)
```

### **💻 FLUJO BOLETOS ELECTRÓNICOS**

#### **1. Activación**
```
CONDUCTOR → Abre caja (ProcCajaGestionConductor @Indice=21)
         → Activa validador en unidad
         → Sistema valida dispositivo operativo
```

#### **2. Operación**
```
PASAJERO → Paga en validador
        ↓
SISTEMA  → Registra transacción automáticamente (ProcBoletoTransaccion @Indice=21)
        → Acumula producción en tiempo real
        → Genera correlativo automático
```

#### **3. Cierre**
```
CONDUCTOR → Cierra caja (@Indice=31)
         → Sistema genera reporte automático
         → Entrega efectivo recaudado
         ↓
CAJERO    → Recibe reporte digital de producción
         → Compara vs. efectivo entregado
         → Registra en sistema (ProcRecaudoValidador @Indice=20)
```