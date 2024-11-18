# Tutorial para exportar un juego de Godot a HTML y subirlo a *itch.io*

En este tutorial, aprenderás a exportar un juego desarrollado en Godot a formato HTML, subirlo a [*itch.io*][E02] y obtener su *Secret URL*. Esto te permitirá compartir tu juego de forma privada y probarlo sin hacerlo público.

## Paso 1: Instalar las plantillas de exportación en Godot

1. Abre tu proyecto en Godot.
2. Ve al menú **Editor → Manage Export Templates...**.
3. Observa a la derecha de **Current Version**; pueden aparecer dos opciones:

   - **Opción 1**: Texto en rojo que dice _Export templates are missing. Download them or install from a file_.
   - **Opción 2**: Texto en gris o azul que dice _Export templates are installed and ready to be used_.

4. Si ves la **Opción 1**, sigue estos pasos para descargar las plantillas de exportación:

   - Asegúrate de que en **Download from** esté seleccionado _Best available mirror_.
   - Haz clic en **Download and Install**.
   - Espera a que se complete la descarga e instalación.
   - Una vez instalado, debería aparecer el mensaje _Export templates are installed and ready to be used_.
   - Haz clic en **Close** para cerrar la ventana.

## Paso 2: Exportar el juego a HTML

1. En Godot, ve a **Project → Export...**.
2. En la sección **Presets**, verifica si existe una opción para **Web**:

   - Si no está presente, haz clic en **Add...** y selecciona **Web**.

3. Selecciona **Web (Runnable)** en los **Presets**.

   - Puedes agregar **Linux** o **Windows Desktop** si deseas exportar el juego en tu ordenador a estas plataformas.

4. Haz clic en **Export Project...**.

5. Elige una ruta para el proyecto exportado:

   - Crea una nueva carpeta (usa el botón con el icono de una carpeta y un "+" situado arriba a la derecha) para alojar los archivos exportados.
   - Entra en la carpeta creada
   - Renombra el archivo HTML a **_index.html_**.
   - Desactiva la opción **Export With Debug** para una versión optimizada.
   - Haz clic en **Save** para exportar el proyecto.

6. Una vez exportado, navega a la carpeta donde se ha exportado el juego.

7. Comprime todos los archivos dentro de esa carpeta en un solo archivo **ZIP**:

   - **Nota**: debes seleccionar y comprimir los archivos **dentro** de la carpeta (como **_index.html_** y otros archivos que comienzan con **index**), no la carpeta en sí.

## Paso 3: Subir el juego a *itch.io* y configurarlo

1. Accede a [*itch.io*][E02] e inicia sesión con tu cuenta.

2. En la esquina superior derecha, haz clic en la flecha que está a la derecha de tu nombre de usuario y selecciona **Upload a New Project**.

3. Completa los detalles del proyecto:

   - **Title**: Ingresa el título de tu juego.
   - **Project URL**: Establece una URL personalizada para tu juego.

4. En **Kind of Project**, selecciona **HTML**.

   ![Kind of Project][E03]

5. En la sección **Uploads**:

   - Haz clic en **Upload Files** y selecciona el archivo **ZIP** que creaste anteriormente.
   - Una vez subido, marca la casilla ***This file will be played in the browser***.

6. Configura las **Viewport Dimensions**:

   - Establece las dimensiones según las de tu juego en Godot.
   - Puedes encontrarlas en ***Project → Project Settings → General → Display → Window***, en **Width** y **Height**.

7. Activa la casilla **SharedArrayBuffer support**:

   - **¿Qué hace?** Esta opción permite que el juego utilice **SharedArrayBuffer**, lo que mejora el rendimiento y habilita características avanzadas en navegadores compatibles. Es esencial para que algunos juegos funcionen correctamente en el navegador.

8. Opcionalmente, activa la casilla **Fullscreen Button** para añadir un botón que permita al jugador cambiar a pantalla completa.

9. En **Visibility & Access**, asegúrate de que esté seleccionado **Draft**:

   - Esto significa que solo tú (y quienes tengan el enlace secreto) puedan ver el juego.
   
   ![Draft Mode][E04]

10. Haz clic en **Save** para guardar los cambios.

## Paso 4: Obtener y Probar la *Secret URL*

1. En la página de tu juego en *itch.io*, verás un botón que dice **DRAFT** y debajo un enlace que pone **Secret URL**.

2. Haz clic en **Secret URL**:

   - Se abrirá una nueva ventana con tu juego y una URL más larga y específica.
   - ![Secret URL][E05]

3. **¿Qué es la Secret URL?**

   - La **Secret URL** es un enlace privado que te permite compartir tu juego con otros sin publicarlo públicamente.
   - Cualquiera que tenga este enlace puede acceder y jugar tu juego sin necesidad de una cuenta en *itch.io*.
   - Es ideal para compartir con profesores, testers o amigos para recibir feedback antes del lanzamiento oficial.

4. Prueba la **Secret URL**:

   - Abre una ventana de navegación privada o modo incógnito en tu navegador.
   - Pega la **Secret URL** y verifica que puedes acceder al juego sin iniciar sesión.

5. Guarda la **Secret URL** para compartirla cuando sea necesario, por ejemplo, al incluirla en un PDF para evaluación.


[E02]: https://itch.io
[E03]: https://twinery.org/cookbook/starting/twine2/images/starting-itchio-project-type.jpg
[E04]: https://intfiction.org/uploads/default/original/2X/d/df483263aab3f4ae52ace475d887eb5e55ef2127.png
[E05]: https://64.media.tumblr.com/dcc25c825170c34cf2f61b614e672e63/b4d2a6d1c5b95e35-4d/s1280x1920/deb0342a1c397ee2118f171ffa3c69a4737c09bd.png
