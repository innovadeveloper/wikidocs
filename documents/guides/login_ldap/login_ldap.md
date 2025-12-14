flowchart TB

    %% =====================
    %% Acceso por DNS
    %% =====================
    U[Usuario kbaltazar]

    DNS1[company001.kloubit.com]
    DNS2[company002.kloubit.com]

    U -->|Accede vía DNS| DNS1
    U -->|Accede vía DNS| DNS2

    %% =====================
    %% Autenticación
    %% =====================
    DNS1 --> WSO2[WSO2 Identity Server]
    DNS2 --> WSO2

    WSO2 --> LDAP[(LDAP)]

    %% =====================
    %% LDAP Contexto temporal
    %% =====================
    subgraph "LDAP - Año 2025"
        L2025U[kbaltazar]
        L2025G[memberOf: company001]
        L2025U --> L2025G
    end

    subgraph "LDAP - Año 2026"
        L2026U[kbaltazar]
        L2026G[memberOf: company001, company002]
        L2026U --> L2026G
    end

    LDAP -.-> L2025U
    LDAP -.-> L2026U

    %% =====================
    %% Token
    %% =====================
    WSO2 --> JWT[JWT Token Claims: - user_id - email - groups]

    %% =====================
    %% Backend
    %% =====================
    JWT --> BE[Backend API]

    %% =====================
    %% Autorización
    %% =====================
    BE --> PG[(PostgreSQL)]

    PG --> UP[identity.user_permission 'permisos granulares']

    %% =====================
    %% Resultado
    %% =====================
    BE --> OK[Acceso a módulos y funciones según permisos locales]
