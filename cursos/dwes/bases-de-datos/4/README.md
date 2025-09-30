# 4. PHP Data Objects (PDO) ([↑](../README.md))

_Contenido creado por Manuel Ignacio López Quintero_

PHP Data Objects (**PDO**) es una extensión de PHP diseñada para interactuar con bases de datos mediante una **interfaz unificada**. Esta extensión permite ejecutar operaciones como consultas y actualizaciones de datos utilizando una misma sintaxis, independientemente del tipo de base de datos. PDO soporta múltiples **controladores** de bases de datos, como [MySQL](https://en.wikipedia.org/wiki/MySQL), [MariaDB](https://en.wikipedia.org/wiki/MariaDB), [PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL), [SQLite](https://en.wikipedia.org/wiki/SQLite), [Microsoft SQL Server](https://en.wikipedia.org/wiki/Microsoft_SQL_Server), [Oracle Database](https://en.wikipedia.org/wiki/Oracle_Database), y más, facilitando la portabilidad del código. Para utilizar PDO, se crea una instancia de la clase `PDO`, pasando como parámetros el DSN (Data Source Name), el nombre de usuario y la contraseña.

PDO ofrece **ventajas destacadas** frente a [MySQLi](https://www.php.net/manual/book.mysqli.php), como el soporte para múltiples bases de datos (MySQL, PostgreSQL, SQLite, SQL Server, Oracle, entre otras), lo que brinda portabilidad del código mediante una API unificada y facilita la migración entre SGBD. También incorpora un manejo robusto de excepciones que mejora la gestión y depuración de errores, optimizando la interacción con bases de datos. En general, se recomienda usar PDO en lugar de MySQLi, salvo en casos muy específicos. Por ejemplo, cuando se requiere la funcionalidad más reciente y particular de MySQL o MariaDB.

Estudiar la [documentación oficial de PDO](https://www.php.net/manual/book.pdo.php) permite comprender en profundidad el uso de esta extensión para interactuar con bases de datos en PHP.  Es muy importante dominar las clases [`PDO`](https://www.php.net/manual/class.pdo.php) y [`PDOStatement`](https://www.php.net/manual/class.pdostatement.php) para aprovechar al máximo sus funcionalidades. La clase `PDO` proporciona métodos para conectarse a bases de datos y gestionar esas conexiones, ofreciendo una interfaz unificada para diferentes Sistemas Gestores de Bases de Datos. Por otro lado, la clase `PDOStatement` se utiliza para preparar y ejecutar sentencias SQL, así como para obtener y manipular los resultados de las consultas, mejorando la seguridad y eficiencia de las interacciones con la base de datos.

## Secciones

4.1. [Conexión a la base de datos](4.1.md)<br />
4.2. [Preparación y ejecución de consultas](4.2.md)<br />
4.3. [Obtención y manejo de resultados](4.3.md)<br />
4.4. [Manejo de transacciones](4.4.md)<br />

_Contenido creado por Manuel Ignacio López Quintero_
