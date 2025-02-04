-- Script de creación de bases de datos para MySQL/MariaDB con ejemplos

DROP DATABASE IF EXISTS dwes_proyecto_4_gestion_transacciones;
CREATE DATABASE dwes_proyecto_4_gestion_transacciones;
USE dwes_proyecto_4_gestion_transacciones;

CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(10) NOT NULL CHECK (type IN ('income', 'expense')),
    amount DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL
);

-- Pon aquí debajo tus CREATE TABLE y restricciones adicionales necesarias

-- Pon aquí debajo tus INSERT INTO necesarias
