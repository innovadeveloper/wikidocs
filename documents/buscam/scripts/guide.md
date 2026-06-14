
---

### **15. catalog**

**Descripción:** Catálogo genérico tipo clave-valor para listas parametrizables (estados, tipos, categorías). Evita crear tablas para cada enumeración.

| Campo | Tipo | Restricciones | Descripción |
|-------|------|---------------|-------------|
| catalog_id | SERIAL | PRIMARY KEY | Identificador único |
| category | VARCHAR(50) | NOT NULL | Categoría (vehicle_status, trip_status) |
| code | VARCHAR(50) | NOT NULL | Código único en categoría |
| name | VARCHAR(100) | NOT NULL | Nombre descriptivo |
| description | TEXT | | Descripción detallada |
| display_order | INT | DEFAULT 0 | Orden de visualización |
| is_active | BOOLEAN | DEFAULT true | Valor activo |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Fecha de creación |

**Unique Constraint:** (category, code)

**Índices:**
- `idx_catalog_category` ON (category, is_active)

**Categorías típicas:**
```sql
-- Estados de vehículo
('vehicle_status', 'OPERATIONAL', 'Operativo')
('vehicle_status', 'MAINTENANCE', 'En mantenimiento')
('vehicle_status', 'OUT_OF_SERVICE', 'Fuera de servicio')

-- Estados de viaje
('trip_status', 'SCHEDULED', 'Programado')
('trip_status', 'IN_PROGRESS', 'En curso')
('trip_status', 'COMPLETED', 'Completado')

-- Tipos de combustible
('fuel_type', 'DIESEL', 'Diesel')
('fuel_type', 'GNV', 'Gas Natural Vehicular')
('fuel_type', 'ELECTRIC', 'Eléctrico')
```

**Notas:**
- Diseñado para listas que cambian raramente
- `display_order` controla orden en dropdowns
- Nuevas categorías se agregan vía migrations

Function : seed_catalog

---
