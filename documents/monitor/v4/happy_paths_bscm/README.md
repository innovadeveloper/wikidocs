
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
