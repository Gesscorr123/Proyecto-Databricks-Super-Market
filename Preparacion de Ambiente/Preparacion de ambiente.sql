-- Databricks notebook source
-- MAGIC %python
-- MAGIC spark.conf.set(
-- MAGIC   "fs.azure.account.auth.type.adlsmardata1307.dfs.core.windows.net",
-- MAGIC   "OAuth"
-- MAGIC )
-- MAGIC
-- MAGIC spark.conf.set(
-- MAGIC   "fs.azure.account.oauth.provider.type.adlsmardata1307.dfs.core.windows.net",
-- MAGIC   "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider"
-- MAGIC )
-- MAGIC
-- MAGIC spark.conf.set(
-- MAGIC   "fs.azure.account.oauth2.client.id.adlsmardata1307.dfs.core.windows.net",
-- MAGIC   "<application-id>"
-- MAGIC )
-- MAGIC
-- MAGIC spark.conf.set(
-- MAGIC   "fs.azure.account.oauth2.client.secret.adlsmardata1307.dfs.core.windows.net",
-- MAGIC   "<client-secret>"
-- MAGIC )
-- MAGIC
-- MAGIC spark.conf.set(
-- MAGIC   "fs.azure.account.oauth2.client.endpoint.adlsmardata1307.dfs.core.windows.net",
-- MAGIC   "https://login.microsoftonline.com/<tenant-id>/oauth2/token"
-- MAGIC )
-- MAGIC

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # ============================================================
-- MAGIC # CONFIGURACION DE CONEXION CON MANAGED IDENTITY
-- MAGIC # ============================================================
-- MAGIC
-- MAGIC storage_account = "adlsmardata1307"
-- MAGIC
-- MAGIC spark.conf.set(
-- MAGIC     f"fs.azure.account.auth.type.{storage_account}.dfs.core.windows.net",
-- MAGIC     "OAuth"
-- MAGIC )
-- MAGIC spark.conf.set(
-- MAGIC     f"fs.azure.account.oauth.provider.type.{storage_account}.dfs.core.windows.net",
-- MAGIC     "org.apache.hadoop.fs.azurebfs.oauth2.ManagedIdentity"
-- MAGIC )
-- MAGIC
-- MAGIC # Verificar conexion
-- MAGIC base_path = f"abfss://raw@{storage_account}.dfs.core.windows.net/"
-- MAGIC
-- MAGIC try:
-- MAGIC     files = dbutils.fs.ls(base_path)
-- MAGIC     print("Conexion exitosa con Managed Identity.")
-- MAGIC     print(f"Archivos encontrados: {len(files)}")
-- MAGIC except Exception as e:
-- MAGIC     print(f"Error de conexion: {e}")
-- MAGIC     print("Verifica que el cluster tenga Managed Identity habilitada y acceso al storage.")

-- COMMAND ----------

-- MAGIC %md
-- MAGIC Estructura de carpetas (Medallion)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC base_path = "abfss://raw@adlsmardata1307.dfs.core.windows.net/retail"
-- MAGIC
-- MAGIC
-- MAGIC dbutils.fs.mkdirs(f"{base_path}/bronze")
-- MAGIC dbutils.fs.mkdirs(f"{base_path}/silver")
-- MAGIC dbutils.fs.mkdirs(f"{base_path}/gold")
-- MAGIC

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Storage config
-- MAGIC storage_account = "adlsmardata1307"
-- MAGIC container = "raw"
-- MAGIC
-- MAGIC # Base path
-- MAGIC base_path = "abfss://raw@adlsmardata1307.dfs.core.windows.net/retail"
-- MAGIC
-- MAGIC # Medallion paths
-- MAGIC bronze_path = f"{base_path}/bronze"
-- MAGIC silver_path = f"{base_path}/silver"
-- MAGIC gold_path   = f"{base_path}/gold"
-- MAGIC

-- COMMAND ----------

-- MAGIC %python
-- MAGIC display(dbutils.fs.ls(base_path))
-- MAGIC

-- COMMAND ----------

CREATE SCHEMA IF NOT EXISTS santig_120781.Ingesta_nueva_bronze;
CREATE SCHEMA IF NOT EXISTS santig_120781.bronze;
CREATE SCHEMA IF NOT EXISTS santig_120781.silver;
CREATE SCHEMA IF NOT EXISTS santig_120781.gold;

-- COMMAND ----------

-- MAGIC %python
-- MAGIC spark.conf.set("spark.sql.sources.default", "delta")
-- MAGIC #Configurar formato Delta por defecto

-- COMMAND ----------

DROP SCHEMA IF EXISTS santig_120781.retail_supermarket CASCADE;

-- COMMAND ----------

