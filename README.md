# SmartRetail Analytics Platform

## Descripción
Pipeline de datos end-to-end construido sobre Azure Databricks que implementa 
la arquitectura Medallion (Bronze, Silver y Gold) para el análisis de datos de 
ventas de supermercado e e-commerce. El proyecto integra ingesta incremental 
desde Azure Data Lake Storage mediante Managed Identity, transformaciones de 
calidad con PySpark y Delta Lake, y visualización en Power BI.

---

## Características Principales
- Arquitectura Medallion completa (Bronze → Silver → Gold)
- Ingesta incremental de datos con detección automática de esquema
- Procesamiento de dos fuentes de datos independientes (Instacart + E-commerce)
- Conexión segura a Azure Data Lake Storage mediante Managed Identity
- Control de calidad de datos en cada capa
- Optimización de tablas Delta con Z-ORDER
- Seguridad granular con Unity Catalog (GRANTS por usuario)
- Orquestación automatizada con Databricks Workflows

---

## Arquitectura
```
Preparacion_Ambiente
        |
        |________________________
        |                       |
  Ingesta_Bronze         Ingesta_Ecommerce_Bronze
        |                       
  Ingesta_Incremental_Bronze    
        |________________________
                |               
              Silver             
                |               
          Silver_Ecommerce      
                |_______________|
                |               |
              Gold       Gold_Ecommerce_Report
                |_______________|
                        |
                   Seguridad
```
<img width="2244" height="865" alt="Estructura" src="https://github.com/user-attachments/assets/b0536f63-1974-47b7-b930-13cd99f5407e" />

---

## Capas del Pipeline

### Bronze — Ingesta Raw
- `Ingesta_Bronze`: Carga histórica completa del dataset Instacart desde ADLS
- `Ingesta_Incremental_Bronze`: Procesa archivos nuevos de la carpeta `ingesta_nueva`
- `Ingesta_Ecommerce_Bronze`: Ingesta del dataset E-commerce Sales

### Silver — Transformación y Limpieza
- `Silver`: Unificación, limpieza de duplicados y reconstrucción de fechas 
  para datos Instacart
- `Silver_Ecommerce`: Limpieza, conversión de tipos y cálculo de métricas 
  de negocio para datos E-commerce

### Gold — Capa de Negocio
- `Gold`: Construye `master_sales_report` y vista `vw_dashboard_ventas` 
  para análisis de comportamiento de compras
- `Gold_Ecommerce_Report`: Construye `ecommerce_report` y vista 
  `vw_dashboard_ecommerce` con KPIs de ventas y marketing

### Seguridad
- `Seguridad`: GRANTS de acceso sobre tablas y vistas Gold mediante Unity Catalog

<img width="1717" height="439" alt="Captura de pantalla 2026-02-21 112524" src="https://github.com/user-attachments/assets/81892796-5aff-46ae-8051-08ff008debce" />

<img width="1918" height="972" alt="orquestación supermercado run Timeline" src="https://github.com/user-attachments/assets/1b8d851c-af05-47d9-9806-edc454e465a2" />

---

## Estructura del Proyecto
```
SmartRetail Analytics Platform/
├── Preparacion_Ambiente.sql
├── Bronze/
│   ├── Bronze.py
│   ├── Ingesta_Incremental_Bronze.py
│   └── Ingesta_Ecommerce_Bronze.py
├── Silver/
│   ├── Silver.py
│   └── Silver_Ecommerce.py
├── Gold/
│   ├── Gold.py
│   └── Gold_Ecommerce_Report.py
├── Seguridad/
│   └── Seguridad.sql
├── Reversion/
│   ├── reversion.sql
│   └── reversion.py
└── .github/
    └── workflows/
        └── deploy.yml
```

---

## Tecnologías
- **Azure Databricks** — Plataforma de procesamiento distribuido
- **Apache Spark / PySpark** — Motor de procesamiento de datos
- **Delta Lake** — Formato de almacenamiento transaccional
- **Azure Data Lake Storage Gen2** — Almacenamiento de datos raw
- **Unity Catalog** — Gobernanza y seguridad de datos
- **Managed Identity** — Autenticación segura sin credenciales
- **Power BI** — Visualización y dashboards
- **GitHub Actions** — CI/CD

---

## Requisitos Previos
- Azure Subscription activa
- Azure Databricks workspace (tier Premium)
- Azure Data Lake Storage Gen2
- Managed Identity habilitada en el cluster de Databricks
- Rol **Storage Blob Data Contributor** asignado a la Managed Identity
- Power BI Desktop
- Git instalado localmente

---

## Instalación y Configuración

### 1. Clonar el Repositorio
```bash
git clone https://github.com/Gesscorr123/Proyecto-Databricks-Super-Market.git
cd Proyecto-Databricks-Super-Market
```

### 2. Configurar Databricks Token
1. Ir a Databricks Workspace
2. **User Settings** → **Developer** → **Access Tokens**
3. Click en **Generate New Token**
4. Configurar:
   - Comment: `GitHub CI/CD`
   - Lifetime: `90 days`

> **Advertencia:** Copiar y guardar el token, no se puede recuperar después.

### 3. Configurar GitHub Secrets
En tu repositorio: **Settings** → **Secrets and variables** → **Actions**

| Secret Name | Valor Ejemplo |
|---|---|
| DATABRICKS_HOST | https://adb-7405615832502229.9.azuredatabricks.net |
| DATABRICKS_TOKEN | dapi_xxxxxxxxxxxxxxxx |

### 4. Verificar Storage Configuration
```python
storage_account = "adlsmardata1307"
storage_path    = f"abfss://raw@{storage_account}.dfs.core.windows.net"
```

**Configuración completada.**

---

## Uso

### Despliegue Automático (Recomendado)
```bash
git add .
git commit -m "feat: mejoras en pipeline"
git push origin main
```

GitHub Actions ejecutará automáticamente:
- Deploy de notebooks a Databricks Workspace
- Creación del workflow `orquestacion_supermercado`
- Ejecución completa: Bronze → Silver → Gold
- Notificaciones de resultados

### Ejecución Manual desde GitHub
1. Ir al tab **Actions** en GitHub
2. Seleccionar **Deploy SmartRetail Pipeline**
3. Click en **Run workflow**
4. Seleccionar rama `main`
5. Click en **Run workflow**

### Ejecución Local en Databricks
Navegar a `SmartRetail Analytics Platform` y ejecutar en orden:
```
Preparacion_Ambiente.sql          → Crear schemas y configurar conexion
Bronze.py                         → Carga historica Instacart
Ingesta_Incremental_Bronze.py     → Carga incremental Instacart
Ingesta_Ecommerce_Bronze.py       → Ingesta E-commerce
Silver.py                         → Transformacion Instacart
Silver_Ecommerce.py               → Transformacion E-commerce
Gold.py                           → Capa Gold Instacart
Gold_Ecommerce_Report.py          → Capa Gold E-commerce
Seguridad.sql                     → GRANTS de acceso
```

---

## CI/CD

### Pipeline de GitHub Actions
```
Workflow: Deploy SmartRetail Pipeline
├── Deploy notebooks → Databricks Workspace
├── Eliminar workflow antiguo (si existe)
├── Buscar cluster configurado
├── Crear nuevo workflow con dependencias
├── Ejecutar pipeline automaticamente
└── Monitorear y notificar resultados
```

---

## Monitoreo

### En Databricks
- Ir a **Workflows** en el menú lateral
- Buscar `orquestacion_supermercado`
- Ver historial de ejecuciones y logs por tarea

### En GitHub Actions
- Tab **Actions** del repositorio
- Ver historial de workflows
- Click en ejecución específica para detalles

---

## KPIs del Dashboard E-commerce

| KPI | Formula | Descripcion |
|---|---|---|
| Ingresos Totales | `Price * Units_Sold` | Ventas brutas sin descuentos |
| Ingresos Netos | `Price * Units_Sold * (1 - Discount)` | Ingresos reales tras descuentos |
| ROI de Marketing | `net_revenue / Marketing_Spend` | Retorno por inversion en marketing |
| Ticket Promedio | `net_revenue / Units_Sold` | Valor promedio por unidad vendida |
| Descuento Promedio | `AVG(Discount) por categoria` | Nivel de descuento por categoria |
| Unidades por Segmento | `SUM(Units_Sold) por Customer_Segment` | Volumen por tipo de cliente |

---

## Autor
**Santiago Gil Corredor**  
Data Engineering | Azure Databricks | Delta Lake | PySpark

---

## Licencia
Este proyecto está bajo la Licencia MIT.
