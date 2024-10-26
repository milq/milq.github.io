-- Ejemplo de script de implementación de BBDD (por ejemplo, 'modelo.sql')
-- Creamos y empezamos a usar la BBDD

DROP DATABASE IF EXISTS dwes_ejemplo_hash_y_cookies;
CREATE DATABASE dwes_ejemplo_hash_y_cookies;
USE dwes_ejemplo_hash_y_cookies;

DROP TABLE IF EXISTS usuarios;

-- Crear tabla usuarios
CREATE TABLE usuarios (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50),
    email VARCHAR(50),
    password VARCHAR(100),
    CONSTRAINT PK_usuario PRIMARY KEY (id),
    CONSTRAINT CK_usuario_1 UNIQUE (username),
    CONSTRAINT CK_usuario_2 UNIQUE (email)
);
