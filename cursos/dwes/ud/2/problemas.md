# Ejercicios de modelado e implementación de bases de datos

## Problema 1: Sistema de gestión de tiendas

### Descripción

Una cadena de tiendas minoristas necesita gestionar la información relacionada con sus **tiendas** y los **productos** que venden. Cada **tienda** está identificada de manera única por un **ID** numérico y posee atributos como **nombre**, **dirección** y **teléfono**. Por otro lado, cada **producto** también cuenta con un **ID** numérico único, además de atributos como **nombre**, **descripción**, **precio** y **_stock_ disponible**. Una **tienda** puede tener múltiples **productos** disponibles para la venta. Sin embargo, cada **producto** está asociado únicamente a una **tienda** específica.

**Ejercicio:**

Implementa el modelo de base de datos en SQL, inserta datos de ejemplo y almacena el _script_ en `modelo_1.sql`.

## Problema 2: Plataforma de cursos en línea

**Descripción:**

Una plataforma de cursos en línea requiere gestionar la información relacionada con sus **estudiantes**, **cursos** ofrecidos y las **inscripciones** realizadas. Cada **estudiante** está identificado de manera única por un **ID** numérico y posee atributos como **nombre**, **apellido**, **correo electrónico** y **fecha de registro**. Los **cursos** disponibles en la plataforma también cuentan con un **ID** numérico único, además de atributos como **título**, **descripción**, **categoría**, **fecha de inicio** y **fecha de fin**. Un **estudiante** puede inscribirse en múltiples **cursos**, y cada **curso** puede tener varios **estudiantes** inscritos. La **inscripción** también debe registrar la **fecha de inscripción**.

**Ejercicio:**

Implementa el modelo de base de datos en SQL, inserta datos de ejemplo y almacena el _script_ en `modelo_2.sql`.

## Problema 3: Gestión de restaurantes

**Descripción:**

Una cadena de restaurantes necesita gestionar la información relacionada con sus establecimientos, las mesas disponibles en cada uno y los empleados que trabajan en los diferentes locales. Cada **restaurante** está identificado de manera única por un **ID** numérico y posee atributos como **nombre**, **dirección** y **teléfono**. Dentro de cada restaurante, existen múltiples **mesas**, cada una identificada por un **ID** numérico único, con atributos como **número de mesa** y **capacidad** que indica cuántas personas pueden sentarse en ella. Además, la cadena emplea a numerosos **empleados**, cada uno con un **ID** numérico único, y atributos como **nombre**, **apellido**, y **correo electrónico**. Un **restaurante** puede tener múltiples **empleados**, y un **empleado** puede trabajar en varios **restaurantes**. Asimismo, cada **mesa** está asociada únicamente a un **restaurante** específico.

**Ejercicio:**

Implementa el modelo de base de datos en SQL, inserta datos de ejemplo y almacena el _script_ en `modelo_3.sql`.
