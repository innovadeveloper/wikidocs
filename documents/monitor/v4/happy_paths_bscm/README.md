
#  Flujo completo en jOOQ (Happy Path)

## 1. Creación de empresas

```java
dsl.selectFrom(API.UPSERT_COMPANIES(
    new UpsertCompaniesInput(
        new CompanyItem[]{
            new CompanyItem(null, "20601234567", "AutoGroup Perú SAC", "AutoGroup", "Av. Javier Prado 123", "987654321", "contacto@autogroup.pe", "https://cdn.autogroup.pe/logo.png", true),
            new CompanyItem(null, "20456789012", "Logística Andina SAC", "LogAndina", "Av. La Marina 456", "912345678", "ventas@logandina.pe", null, true)
        }
    )
)).fetch();
```

---

## 2. Creación de tenant

```java
dsl.selectFrom(API.UPSERT_TENANT(
    new UpsertTenantInput(null, "AutoGroup Perú", true, new Integer[]{1, 2})
)).fetch();
```

---

## 3. Creación de usuarios (LDAP sync) (USER-PT 001)

```java
dsl.selectFrom(API.UPSERT_USERS(
    new UpsertUsersInput(
        new UserItem[]{
            new UserItem("uid=cmendoza,ou=users,dc=citectran,dc=com", "cmendoza", "carlos.mendoza@citectran.com", "Carlos Alberto Mendoza Pérez", true, 1, null),
            new UserItem("uid=atorres,ou=users,dc=citectran,dc=com", "atorres", "ana.torres@citectran.com", "Ana María Torres Villanueva", true, 1, null),
            new UserItem("uid=lgarcia,ou=users,dc=citectran,dc=com", "lgarcia", "luis.garcia@citectran.com", "Luis Fernando García Ramos", true, 1, null)
        }
    )
)).fetch();
```

---

## 4. Creación de persona (USER-PT 002)

```java
dsl.selectFrom(API.UPSERT_PERSON(
    new UpsertPersonInput(
        null, "12345678", "DNI",
        "Carlos Alberto", "Mendoza", "Pérez",
        "M", LocalDate.parse("1985-03-15"), "Peruana", "MARRIED", "O+",
        "carlos.mendoza@email.com", "987654321", null,
        "Rosa Pérez", "912345678",
        null, null
    )
)).fetch();
```

---

## 5. Asociación persona ↔ usuario (personnel) (USER-PT 003)

```java
dsl.selectFrom(API.UPSERT_PERSONNEL(
    new UpsertPersonnelInput(
        null, 1, 1, 1, null,
        "ADMIN", "Administrador",
        LocalDate.parse("2024-02-01"), null,
        "FULL_TIME", "ACTIVE",
        new BigDecimal("1800.00"), "MORNING", null
    )
)).fetch();
```

---

## 6. Creación de roles

```java
dsl.selectFrom(API.UPSERT_ROLE(
    new UpsertRoleInput(null, 1, "ADMIN", "Administrador General", 1, true, null)
)).fetch();

dsl.selectFrom(API.UPSERT_ROLE(
    new UpsertRoleInput(null, 1, "COUNTER", "Contador", 1, true, null)
)).fetch();
```

---

## 7. Asignación de permisos a roles

```java
dsl.selectFrom(API.SYNC_ROLE_PERMISSIONS(
    new SyncRolePermissionsInput(1, new RolePermissionItem[]{
        new RolePermissionItem(1, true),
        new RolePermissionItem(2, true),
        new RolePermissionItem(3, true),
        new RolePermissionItem(4, true)
    })
)).fetch();

dsl.selectFrom(API.SYNC_ROLE_PERMISSIONS(
    new SyncRolePermissionsInput(2, new RolePermissionItem[]{
        new RolePermissionItem(2, true)
    })
)).fetch();
```

---

## 8. Asignación de roles a usuario

```java
dsl.selectFrom(API.ASSIGN_ROLES_TO_USER(
    new AssignRolesToUserInput(
        1,
        new UserRoleItem[]{
            new UserRoleItem(1, null),
            new UserRoleItem(2, null),
            new UserRoleItem(3, null)
        },
        1
    )
)).fetch();
```

---

## 9. Listado de personas (paginado)

```java
dsl.selectFrom(API.GET_PEOPLE(
    new GetPeopleInput(1, 1, 20, null, true)
)).fetch();
```

---

## 10. Dirección de persona

```java
dsl.selectFrom(API.UPSERT_PERSON_ADDRESS(
    new UpsertPersonAddressInput(
        null, 1, "HOME",
        "Av. Los Pinos 234, Urb. Santa Rosa", "Dpto. 301",
        "San Borja", "Lima", "Lima",
        "15037", "PE",
        new BigDecimal("-12.09120000"), new BigDecimal("-76.99880000"),
        true, null
    )
)).fetch();

dsl.selectFrom(API.UPSERT_PERSON_ADDRESS(
    new UpsertPersonAddressInput(
        null, 1, "WORK",
        "Av. Javier Prado Este 4200", null,
        "Surco", "Lima", "Lima",
        "15023", null,
        null, null,
        true, null
    )
)).fetch();
```

---

## 11. Tipos de documento

```java
dsl.selectFrom(API.GET_DOCUMENT_TYPES(
    new GetDocumentTypesInputV2(true, "DRIVER", null, null, true, true)
)).fetch();
```

---

## 12. Documento de persona

```java
dsl.selectFrom(API.UPSERT_PERSON_DOCUMENT(
    new UpsertPersonDocumentInput(
        1, 5, "Q56789012",
        "MTC - Ministerio de Transportes",
        LocalDate.parse("2022-03-10"),
        LocalDate.parse("2027-03-10"),
        null, "VALID", null, null
    )
)).fetch();
```

---

## 13. Listado de roles

```java
dsl.selectFrom(API.GET_ROLES(
    new GetRolesInputV2(1, null, null, null, null)
)).fetch();
```

---

## 14. Scopes de permisos

```java
dsl.selectFrom(API.SYNC_ROLE_PERMISSION_SCOPES(
    new SyncRolePermissionScopesInput(
        1,
        new ScopeItem[]{
            new ScopeItem(1, null, 1, true),
            new ScopeItem(1, null, 2, true)
        }
    )
)).fetch();

dsl.selectFrom(API.SYNC_ROLE_PERMISSION_SCOPES(
    new SyncRolePermissionScopesInput(1, new ScopeItem[]{})
)).fetch();
```

---

## 15. Export de permisos (Redis/cache)

```java
dsl.selectFrom(API.EXPORT_ALL_USER_PERMISSIONS()).fetch();
```

---
# Flujo de vehículos y conductores en jOOQ

## 1. Creación de vehículo

```java
dsl.selectFrom(API.UPSERT_VEHICLE(
    new UpsertVehicleInput(
        null,
        1,
        "ABC-123",
        null,
        "Mercedes-Benz", "OF-1722",
        2020,
        "WDB9068351R123456",
        "OM906LA-001",
        "DIESEL",
        45, 30,
        "BLANCO", null,
        LocalDate.parse("2020-06-15"),
        null
    )
)).fetch();
```

---

## 2. Creación de propietario de vehículo

```java
dsl.selectFrom(API.UPSERT_VEHICLE_OWNER(
    new UpsertVehicleOwnerInput(
        null,
        1,
        null,
        "propietario@email.com",
        "987654321",
        "Av. Los Álamos 234, San Borja, Lima",
        "002-123456789012",
        null,
        null
    )
)).fetch();
```

---

## 3. Asignación de propiedad (ownership share)

```java
dsl.selectFrom(API.SET_VEHICLE_OWNERSHIP_SHARE(
    new SetVehicleOwnershipShareInput(
        1,
        1,
        new BigDecimal("100.00"),
        LocalDate.parse("2020-01-01"),
        null
    )
)).fetch();
```

---

## 4. Tipos de documentos (vehículo / conductor)

```java
dsl.selectFrom(API.GET_DOCUMENT_TYPES(
    new GetDocumentTypesInputV2(true, "DRIVER", "CRITICAL", null, true, true)
)).fetch();

dsl.selectFrom(API.GET_DOCUMENT_TYPES(
    new GetDocumentTypesInputV2(true, null, null, "soat", null, null)
)).fetch();
```

---

## 5. Documento de vehículo

```java
dsl.selectFrom(API.UPSERT_VEHICLE_DOCUMENT(
    new UpsertVehicleDocumentInput(
        1,
        18,
        "SOAT-2025-00123456",
        "La Positiva Seguros",
        LocalDate.parse("2025-01-15"),
        LocalDate.parse("2026-01-15"),
        null,
        "VALID",
        null,
        null
    )
)).fetch();
```

---

## 6. Creación de driver

```java
dsl.selectFrom(API.UPSERT_DRIVER(
    new UpsertDriverInput(
        null,
        1,
        null,
        1,
        "OWNER_OPERATOR", "ACTIVE",
        1,
        null,
        1,
        null,
        LocalDate.parse("2024-01-15"),
        null, null, null,
        "Conductor principal de la ruta RT-001"
    )
)).fetch();
```

---

## 7. Listado de vehículos

```java
dsl.selectFrom(API.GET_VEHICLES()).fetch();

dsl.selectFrom(API.GET_VEHICLES(
    new GetVehiclesInput(
        new Integer[]{1},
        null, null, null, null, null, null, null,
        1, 20
    )
)).fetch();

dsl.selectFrom(API.GET_VEHICLES(
    new GetVehiclesInput(
        new Integer[]{1,2,3},
        null, null, null, null, null, null, null,
        1, 20
    )
)).fetch();
```

---

## 8. Listado de conductores

```java
dsl.selectFrom(API.GET_DRIVERS()).fetch();

dsl.selectFrom(API.GET_DRIVERS(
    new GetDriversInput(
        null,
        new String[]{"ACTIVE"},
        null,
        true,
        null, null, null,
        1, 20
    )
)).fetch();
```

---
# Flujo de rutas y checkpoints en jOOQ

## 1. Creación de rutas

```java
dsl.selectFrom(API.UPSERT_ROUTE(
    new UpsertRouteInput(
        null,
        1,
        "RT-001",
        "Naranjal - Matellini",
        "LINEAR",
        new BigDecimal("18.50"),
        65,
        null
    )
)).fetch();

dsl.selectFrom(API.UPSERT_ROUTE(
    new UpsertRouteInput(
        null,
        1,
        "RT-002",
        "Ruta Circular Centro",
        "CIRCULAR",
        null,
        null,
        null
    )
)).fetch();
```

---

## 2. Definición de checkpoints (ruta LINEAR)

```java
dsl.selectFrom(API.SYNC_CHECKPOINTS(
    new SyncCheckpointsInput(
        1,
        new SyncCheckpointItem[]{
            new SyncCheckpointItem(null, "CP-IDA-01", "Terminal Naranjal", "terminal", true, "IDA", 1, new BigDecimal("-12.02831400"), new BigDecimal("-77.08765200"), new BigDecimal("0.00"), 1, 150),
            new SyncCheckpointItem(null, "CP-IDA-02", "Paradero Universitaria", "bus_stop", false, "IDA", 2, new BigDecimal("-12.03210000"), new BigDecimal("-77.08120000"), new BigDecimal("1.20"), 3, null),
            new SyncCheckpointItem(null, "CP-IDA-03", "Control Plaza Norte", "checkpoint", false, "IDA", 3, new BigDecimal("-12.04100000"), new BigDecimal("-77.07800000"), new BigDecimal("3.50"), 8, 100),
            new SyncCheckpointItem(null, "CP-IDA-04", "Paradero Izaguirre", "bus_stop", false, "IDA", 4, new BigDecimal("-12.05300000"), new BigDecimal("-77.07200000"), new BigDecimal("5.80"), 14, null),
            new SyncCheckpointItem(null, "CP-IDA-05", "Terminal Matellini", "terminal", true, "IDA", 5, new BigDecimal("-12.06500000"), new BigDecimal("-77.06500000"), new BigDecimal("10.20"), 25, 150),

            new SyncCheckpointItem(null, "CP-VTA-01", "Terminal Matellini", "terminal", true, "VUELTA", 1, new BigDecimal("-12.06500000"), new BigDecimal("-77.06500000"), new BigDecimal("0.00"), 1, 150),
            new SyncCheckpointItem(null, "CP-VTA-02", "Paradero Reducto", "bus_stop", false, "VUELTA", 2, new BigDecimal("-12.05100000"), new BigDecimal("-77.07100000"), new BigDecimal("2.10"), 5, null),
            new SyncCheckpointItem(null, "CP-VTA-03", "Control Benavides", "checkpoint", false, "VUELTA", 3, new BigDecimal("-12.04200000"), new BigDecimal("-77.07900000"), new BigDecimal("5.30"), 13, 100),
            new SyncCheckpointItem(null, "CP-VTA-04", "Terminal Naranjal", "terminal", true, "VUELTA", 4, new BigDecimal("-12.02831400"), new BigDecimal("-77.08765200"), new BigDecimal("10.20"), 25, 150)
        }
    )
)).fetch();
```

---

## 3. Definición de checkpoints (ruta CIRCULAR)

```java
dsl.selectFrom(API.SYNC_CHECKPOINTS(
    new SyncCheckpointsInput(
        2,
        new SyncCheckpointItem[]{
            new SyncCheckpointItem(null, "CIR-01", "Terminal Villa El Salvador", "terminal", true, "CIRCULAR", 1, new BigDecimal("-12.21300000"), new BigDecimal("-76.93500000"), new BigDecimal("0.00"), 1, 150),
            new SyncCheckpointItem(null, "CIR-02", "Paradero Atocongo", "bus_stop", false, "CIRCULAR", 2, new BigDecimal("-12.19800000"), new BigDecimal("-76.98200000"), new BigDecimal("3.40"), 7, null),
            new SyncCheckpointItem(null, "CIR-03", "Control Angamos", "checkpoint", false, "CIRCULAR", 3, new BigDecimal("-12.11200000"), new BigDecimal("-77.00500000"), new BigDecimal("9.80"), 22, 100),
            new SyncCheckpointItem(null, "CIR-04", "Paradero Benavides", "bus_stop", false, "CIRCULAR", 4, new BigDecimal("-12.12700000"), new BigDecimal("-77.01800000"), new BigDecimal("12.30"), 28, null)
        }
    )
)).fetch();
```

---

## 4. Listado de rutas

```java
dsl.selectFrom(API.GET_ROUTES()).fetch();

dsl.selectFrom(API.GET_ROUTES(
    new GetRoutesInput(
        new Integer[]{1,2},
        null,
        null,
        null,
        false
    )
)).fetch();
```
