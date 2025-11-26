# PostgreSQL Backup & Restore - Guía Rápida

## 📦 Instalación de Cliente PostgreSQL

### macOS
```bash
# Cliente completo
brew install postgresql@13

# Solo cliente psql (sin servidor)
brew install libpq
brew link --force libpq
```

### Linux
```bash
# Ubuntu/Debian
sudo apt install postgresql-client-13

# RHEL/CentOS
sudo yum install postgresql13
```

### Verificar instalación
```bash
psql --version
```

---

## 💾 Exportar Backup Full Custom

```bash
# Formato custom comprimido (recomendado)
PGPASSWORD="tu_password" pg_dump -h localhost -U usuario -d nombre_db \
  -Fc -f full_backup.dump

# Ejemplo real
PGPASSWORD="kloubit" pg_dump -h localhost -U kloubit -d kloubitdb \
  -Fc -f full_backup.dump
```

---

## 🔄 Restaurar Full Custom (Limpio)

### Método recomendado: Drop y recrear
```bash
PGPASSWORD="kloubit" dropdb -h localhost -U kloubit kloubitdb
PGPASSWORD="kloubit" createdb -h localhost -U kloubit kloubitdb
PGPASSWORD="kloubit" pg_restore -h localhost -U kloubit -d kloubitdb \
  --no-owner --no-acl full_backup.dump
```

### Alternativa: Clean en BD existente
```bash
PGPASSWORD="kloubit" pg_restore -h localhost -U kloubit -d kloubitdb \
  --clean --if-exists --no-owner --no-acl full_backup.dump
```

---

## 🔧 Flags importantes

| Flag | Descripción |
|------|-------------|
| `-Fc` | Formato custom comprimido |
| `--clean` | DROP objetos antes de crear |
| `--if-exists` | No falla si objeto no existe |
| `--no-owner` | Ignora propietarios (evita errores de permisos) |
| `--no-acl` | Ignora permisos (evita errores de privilegios) |

---

## ⚠️ Solución a errores comunes

**Error: `transaction_timeout` no reconocido**
```bash
# Agregar flags de compatibilidad
pg_restore --no-owner --no-acl full_backup.dump
```