-- Ejemplo de script de implementación de BBDD (por ejemplo, 'modelo.sql')
-- Creamos y empezamos a usar la BBDD

DROP DATABASE IF EXISTS dwes_ejemplo_mensajes;
CREATE DATABASE dwes_ejemplo_mensajes;
USE dwes_ejemplo_mensajes;

DROP TABLE IF EXISTS mensajes;
DROP TABLE IF EXISTS usuarios;

-- Implementación en SQL del modelo de base de datos

CREATE TABLE usuarios (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50),
    password VARCHAR(100),
    CONSTRAINT PK_usuario PRIMARY KEY (id),
    CONSTRAINT CK_usuario UNIQUE (username)
);

CREATE TABLE mensajes (
    id INT NOT NULL AUTO_INCREMENT,
    asunto VARCHAR (100),
    cuerpo VARCHAR (100),
    fecha DATE NOT NULL,
    id_usuario INT NOT NULL,
    CONSTRAINT PK_mensaje PRIMARY KEY (id),
    CONSTRAINT FK_mensaje_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
);

-- Tenemos que saber también añadir ejemplos

INSERT INTO usuarios VALUES
('1', 'pepe', '1234'),
('2', 'luis', '4321'),
('3', 'juan', '1122'),
('4', 'pedro', '2211'),
('5', 'pablo', '3344');

INSERT INTO mensajes(asunto, cuerpo, fecha, id_usuario) VALUES
('Saludo', 'Hola Pepe, ¿cómo estás?', '2023-10-18', '1'),
('Agenda semanal', 'Reunión el viernes', '2023-10-12', '2'),
('Invitación', 'Fiesta de cumpleaños', '2023-10-10', '1'),
('Reporte octubre', 'Reporte mensual adjunto', '2023-10-05', '4'),
('Evento especial', 'Invitación al evento del año', '2023-09-30', '3'),
('Promoción exclusiva', 'Oferta especial para ti', '2023-09-24', '1'),
('Invitación requerida', 'Confirmación de asistencia', '2023-09-20', '1'),
('Recuerdos viaje', 'Tus fotos del viaje', '2023-09-18', '5'),
('Tu opinión importa', 'Encuesta de satisfacción', '2023-09-12', '3'),
('Nueva actualización', 'Actualización de software disponible', '2023-09-10', '3');
