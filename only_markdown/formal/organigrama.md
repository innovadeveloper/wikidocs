flowchart TB

    %% --- Nodos externos ---
    AUT("Autoridad de Transporte")
    PROV("Proveedores")
    POL("Policía de Tránsito")
    PASAJ("Usuarios Pasajeros")

    %% --- Gerencia general ---
    AUT --> GG("Gerente General")
    PROV --> GG

    %% =======================
    %%      TI / SISTEMAS
    %% =======================
    GG --> GTI("Gerente de TI")

    GTI --> ATSIS("Administrador de Sistemas")

    %% =======================
    %%      RRHH
    %% =======================
    GG --> GRRHH("Gerente RRHH")
    GRRHH --> JRRHH("Jefe RRHH")

    JRRHH --> AP("Analista Personal")
    JRRHH --> EDOC("Especialista Documentos")
    JRRHH --> EPL("Especialista Planillas")
    JRRHH --> CCAP("Coordinador Capacitación")

    %% =======================
    %%      FINANZAS
    %% =======================
    GG --> GFIN("Gerente Financiero")

    %% Subárea: Contabilidad
    GFIN --> JCON("Jefe Contabilidad")
    JCON --> CGR("Contador General")
    JCON --> AFI("Analista Financiero")
    JCON --> AINT("Auditor Interno")

    %% Subárea: Liquidación
    GFIN --> JLIQ("Jefe de Liquidación")
    JLIQ --> CSUM("Coordinador Suministros")
    CSUM --> CP("Cajero Principal")

    %% Subárea: Almacén
    GFIN --> EALM("Encargado de Almacén")
    EALM --> CSUM

    %% =======================
    %%      OPERACIONES
    %% =======================
    GG --> GOP("Gerente Operaciones")
    GOP --> JOP("Jefe Operaciones")

    JOP --> ST("Supervisor Terminal")
    JOP --> DESP("Despachador")
    JOP --> MGPS("Monitoreador GPS")
    JOP --> AOP("Analista Operaciones")

    %% Flota
    GOP --> JFLOTA("Jefe Flota")

    JFLOTA --> COND("Conductores")
    JFLOTA --> COB("Cobradores")
    JFLOTA --> INSP("Inspectores Ruta")

    JFLOTA --> CMANT("Coordinador Mantenimiento")
    CMANT --> TTALL("Técnicos Taller")

    %% --- Relaciones externas adicionales ---
    POL -.-> JFLOTA
    PASAJ -.-> GOP

    %% =======================
    %%      Estilos
    %% =======================
    classDef naranjaClaro fill:#FFDAB9,stroke:#333,stroke-width:1px;
    class DESP,MGPS,AOP,JOP,ST naranjaClaro;
    class JFLOTA,INSP,COND naranjaClaro;
    class JLIQ,CSUM,CP naranjaClaro;
    class JRRHH,AP,EDOC naranjaClaro;
    class EALM naranjaClaro;
    class GTI,ATSIS naranjaClaro;

    classDef grisClaro fill:#E0E0E0,stroke:#333,stroke-width:1px;
    class AUT,PROV,POL,PASAJ grisClaro;
