-- Databricks notebook source
-- ============================================================
-- SEGURIDAD: GRANTS A USUARIO SOBRE CAPA GOLD
-- ============================================================

-- Acceso al schema Gold
GRANT USE SCHEMA ON SCHEMA santig_120781.gold 
    TO `est.eduin.gil@unimilitar.edu.co`;

-- Acceso al catalogo
GRANT USE CATALOG ON CATALOG santig_120781 
    TO `est.eduin.gil@unimilitar.edu.co`;

-- Acceso a la tabla maestra
GRANT SELECT ON TABLE santig_120781.gold.master_sales_report 
    TO `est.eduin.gil@unimilitar.edu.co`;

-- Acceso a la vista del dashboard
GRANT SELECT ON VIEW santig_120781.gold.vw_dashboard_ventas 
    TO `est.eduin.gil@unimilitar.edu.co`;

-- ============================================================
-- VERIFICACION DE GRANTS APLICADOS
-- ============================================================
SHOW GRANTS ON TABLE santig_120781.gold.master_sales_report;
SHOW GRANTS ON VIEW santig_120781.gold.vw_dashboard_ventas;

-- COMMAND ----------

-- ============================================================
-- SEGURIDAD: GRANTS A USUARIO SOBRE CAPA GOLD
-- ============================================================

-- Acceso al schema Gold
GRANT USE SCHEMA ON SCHEMA santig_120781.gold 
    TO `est.eduin.gil@unimilitar.edu.co`;

-- Acceso al catalogo
GRANT USE CATALOG ON CATALOG santig_120781 
    TO `est.eduin.gil@unimilitar.edu.co`;

-- Acceso a la tabla maestra
GRANT SELECT ON TABLE santig_120781.gold.master_sales_report 
    TO `est.eduin.gil@unimilitar.edu.co`;

-- Acceso a la vista del dashboard
GRANT SELECT ON VIEW santig_120781.gold.vw_dashboard_ventas 
    TO `est.eduin.gil@unimilitar.edu.co`;

-- ============================================================
-- VERIFICACION DE GRANTS APLICADOS
-- ============================================================
SHOW GRANTS ON TABLE santig_120781.gold.master_sales_report;
SHOW GRANTS ON VIEW santig_120781.gold.vw_dashboard_ventas;