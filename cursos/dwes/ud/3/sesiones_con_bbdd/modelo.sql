-- Ejemplo de script de implementación de BBDD (por ejemplo, 'modelo.sql')
-- Creamos y empezamos a usar la BBDD

DROP DATABASE IF EXISTS dwes_ejemplo_bbdd_y_sesiones;
CREATE DATABASE dwes_ejemplo_bbdd_y_sesiones;
USE dwes_ejemplo_bbdd_y_sesiones;

DROP TABLE IF EXISTS mensajes;
DROP TABLE IF EXISTS usuarios;

-- Implementación en SQL del modelo de base de datos

CREATE TABLE usuarios (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50),
    password VARCHAR(100),
    role VARCHAR(10),
    CONSTRAINT PK_usuario PRIMARY KEY (id),
    CONSTRAINT CK_usuario UNIQUE (username)
);

CREATE TABLE mensajes (
    id INT NOT NULL AUTO_INCREMENT,
    asunto VARCHAR (100),
    cuerpo VARCHAR (100),
    fecha DATE NOT NULL,
    id_usuario INT,
    CONSTRAINT PK_mensaje PRIMARY KEY (id),
    CONSTRAINT FK_mensaje_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
);

-- Tenemos que saber también añadir ejemplos

INSERT INTO usuarios VALUES
('1', 'pepe', '1234', 'admin'),
('2', 'luis', 'ABCD', 'user'),
('3', 'juan', 'abcd', 'user'),
('4', 'pedro', '2a1B', 'user'),
('5', 'pablo', 'b3A4', 'user');

INSERT INTO mensajes(asunto, cuerpo, fecha, id_usuario) VALUES
('A', 'Texto.', '2021-04-24', '1'),
('B', 'Texto.', '2020-03-23', '2'),
('C', 'Texto.', '2021-05-22', '1'),
('D', 'Texto.', '2020-02-21', '4'),
('E', 'Texto.', '2021-06-19', '3'),
('F', 'Texto.', '2020-01-18', '1'),
('G', 'Texto.', '2021-07-17', '1'),
('H', 'Texto.', '2020-09-16', '5'),
('I', 'Texto.', '2021-08-15', '3'),
('J', 'Texto.', '2020-09-20', '3');
