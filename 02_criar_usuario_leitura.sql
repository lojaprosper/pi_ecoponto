-- Execute como root (ou administrador) DEPOIS do 01_schema_e_dados.sql.
-- ATENÇÃO: este arquivo contém a senha do usuário da IA; ele está no .gitignore. Não envie ao GitHub.
CREATE USER IF NOT EXISTS 'ecoia_leitura'@'localhost' IDENTIFIED BY '134da8bded8e3b9dc441';
CREATE USER IF NOT EXISTS 'ecoia_leitura'@'127.0.0.1' IDENTIFIED BY '134da8bded8e3b9dc441';
GRANT SELECT ON ecopontos_sp.ecopontos TO 'ecoia_leitura'@'localhost';
GRANT SELECT ON ecopontos_sp.subprefeituras TO 'ecoia_leitura'@'localhost';
GRANT SELECT ON ecopontos_sp.ecopontos TO 'ecoia_leitura'@'127.0.0.1';
GRANT SELECT ON ecopontos_sp.subprefeituras TO 'ecoia_leitura'@'127.0.0.1';
FLUSH PRIVILEGES;
-- Conferência:
SHOW GRANTS FOR 'ecoia_leitura'@'localhost';
