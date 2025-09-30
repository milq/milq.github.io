# 5. Seguridad en las bases de datos ([↑](../README.md))

_Contenido creado por Manuel Ignacio López Quintero_

La **seguridad en bases de datos** permite proteger la información sensible contra accesos no autorizados y ataques. Un riesgo común es la **inyección SQL**, que permite a atacantes ejecutar comandos maliciosos en la base de datos. Para prevenirlo, se deben usar consultas preparadas, limitar los privilegios de las cuentas, utilizar procedimientos almacenados y establecer sistemas de registro y monitoreo para detectar actividades sospechosas.

Otro tipo de ataque es el Cross-Site Scripting (**XSS**), donde se inserta código malicioso en páginas web y es ejecutado cuando otros usuarios las visitan. La defensa contra XSS incluye la sanitización y validación de las entradas según el tipo de dato esperado, además de implementar una Content Security Policy (**CSP**) que restringe los recursos que el navegador puede cargar para la página web.

Existen más **medidas adicionales** para asegurar una base de datos, como el uso de `PDOException` para manejar errores, variables de entorno para almacenar configuraciones sensibles, cifrado de datos sensibles y _hashing_ de contraseñas. También es importante mantener PHP y el SGBD actualizado, usar HTTPS para las comunicaciones, evitar inserciones masivas de datos realizadas por _bots_ y hacer copias de seguridad regularmente. Estas medidas, entre otras, refuerzan la protección de la base de datos contra diversas amenazas.

## Secciones

5.1. [Prevención de inyección SQL](5.1.md)<br />
5.2. [Defensa contra Cross-Site Scripting (XSS)](5.2.md)<br />
5.3. [Medidas de protección adicionales](5.3.md)

_Contenido creado por Manuel Ignacio López Quintero_
