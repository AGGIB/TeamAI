-- Create user if not exists
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'teamai_user') THEN
      CREATE ROLE teamai_user LOGIN PASSWORD 'teamai_pass';
   END IF;
END
$do$;

-- Create database
SELECT 'CREATE DATABASE teamai_db WITH OWNER teamai_user'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'teamai_db')\gexec

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE teamai_db TO teamai_user;
GRANT ALL PRIVILEGES ON DATABASE postgres TO postgres;
