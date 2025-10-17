# 5. Creación de servicios web ([↑](../README.md))

_Contenido creado por Manuel Ignacio López Quintero_

La **creación de servicios web** implica desarrollar y exponer funcionalidades o recursos mediante interfaces accesibles a través del protocolo [HTTP](https://en.wikipedia.org/wiki/HTTP). Estos servicios pueden implementarse mediante diferentes arquitecturas, siendo [REST](https://en.wikipedia.org/wiki/REST) y [SOAP](https://en.wikipedia.org/wiki/SOAP) las más comunes en la actualidad, debido a su facilidad de integración y amplio soporte en diversos lenguajes y plataformas.

Al crear un servicio web, es fundamental definir claramente su **estructura** y especificaciones, incluyendo la definición de los **recursos**, **URLs** (rutas), **métodos HTTP** (GET, POST, PUT, DELETE), y los **parámetros de entrada y salida**. Una buena documentación es esencial para facilitar el consumo por parte de clientes externos, ya sea mediante documentos explícitos como archivos WSDL en SOAP o mediante estándares y convenciones en REST.

La creación de servicios web permite que diferentes aplicaciones y sistemas interactúen fácilmente compartiendo funcionalidades o datos específicos, tales como información de usuarios, acceso a bases de datos, operaciones comerciales, autenticación, entre otros.

La implementación práctica de servicios web con HTTP puede realizarse utilizando lenguajes como PHP, JavaScript (Node.js), Python, Java, entre otros, aprovechando _frameworks_ y bibliotecas que facilitan enormemente esta tarea.

## Secciones

5.1. [Implementación de un servicio web con SOAP en PHP](5.1.md)<br />
5.2. [Implementación de un servicio web con REST en PHP](5.2.md)<br />
5.3. [Implementación de un servicio web con Laravel](5.3.md)

## Recursos

Si deseas profundizar tus conocimientos sobre la creación de servicios web con PHP, existen diversos recursos en línea muy recomendables para ampliar tu comprensión y experiencia práctica. Un excelente punto de partida es la [documentación oficial de PHP sobre SOAP](https://www.php.net/manual/en/book.soap.php) y la [documentación oficial de PHP sobre servidores web integrados](https://www.php.net/manual/en/features.commandline.webserver.php), que ofrecen una referencia detallada y ejemplos para implementar servicios web basados en SOAP y REST.

Para un enfoque más completo sobre la definición de interfaces y arquitecturas, la especificación de [WSDL](https://www.w3.org/TR/wsdl) proporciona la base para describir en detalle los métodos, mensajes y protocolos en servicios web SOAP, mientras que la lectura sobre la [arquitectura REST](https://en.wikipedia.org/wiki/Representational_state_transfer) ayuda a comprender los principios detrás de la creación de servicios modernos y ligeros.

Finalmente, _frameworks_ como [Laravel](https://laravel.com/docs) ofrecen herramientas robustas para construir servicios web RESTful de forma ágil y segura, incorporando características de validación, enrutamiento avanzado y autenticación, entre otras. Además de la documentación oficial, la comunidad de Laravel mantiene tutoriales y foros de discusión muy activos que pueden ser de gran ayuda al desarrollar APIs en este framework.

_Contenido creado por Manuel Ignacio López Quintero_
