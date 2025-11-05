-- Create database if needed
SELECT 'CREATE DATABASE teamai'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'teamai')\gexec

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE postgres TO postgres;
