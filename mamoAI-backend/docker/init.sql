-- Initialize monitoring system database schema
-- This file loads the main migration

-- Load the main migration file
\i /docker-entrypoint-initdb.d/001_create_base_tables.sql
