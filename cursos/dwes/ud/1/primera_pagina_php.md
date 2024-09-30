# Tutorial - Primera página web en PHP usando XAMPP

## Requisitos

1. XAMPP instalado en tu computadora.
2. Un editor de texto o un IDE. Por ejemplo: [Visual Studio Code](https://code.visualstudio.com/), Notepad++, Geany, etc.

## Paso 1: Inicia XAMPP

### En Windows:

1. Abre XAMPP desde el acceso directo en el escritorio o desde el menú de inicio.
2. En el Panel de Control de XAMPP, verás varios módulos como **Apache**, **MySQL**, etc.
3. Haz clic en el botón **Start** junto a **Apache** para iniciar el servidor web.

### En GNU/Linux:

1. Abre una terminal.
2. Navega a la carpeta donde instalaste XAMPP. Generalmente está en `/opt/lampp/`:
    ```bash
    cd /opt/lampp
    ```
3. Inicia XAMPP ejecutando el siguiente comando:
    ```bash
    sudo ./xampp start
    ```
4. Verás que el servidor Apache se inicia junto con otros servicios, si los tienes activados.

## Paso 2: Crea tu carpeta de proyecto

1. Ve a la carpeta donde está instalado XAMPP:
   - **Windows**: Generalmente está en `C:\xampp`.
   - **GNU/Linux**: Generalmente está en `/opt/lampp`.
   
2. Dentro de la carpeta `htdocs`, crea una nueva carpeta para tu proyecto. Por ejemplo, llámala `mi_primera_pagina_php`.

   - **Windows**: Ruta: `C:\xampp\htdocs\mi_primera_pagina_php`
   - **GNU/Linux**: Ruta: `/opt/lampp/htdocs/mi_primera_pagina_php`

## Paso 3: Crea la página web en PHP

1. Abre tu editor de texto y crea un nuevo archivo.
2. Copia y pega el siguiente código PHP:

    ```php
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mi Primera Página en PHP</title>
    </head>
    <body>
        <h1>¡Hola, mundo!</h1>
        <p>Esta es mi primera página en PHP.</p>
        <?php
            echo "<p>¡Este texto está generado por PHP!</p>";
        ?>
    </body>
    </html>
    ```

3. Guarda este archivo como `index.php` dentro de la carpeta `mi_primera_pagina_php`.

   - **Windows**: Ruta: `C:\xampp\htdocs\mi_primera_pagina_php\index.php`
   - **GNU/Linux**: Ruta: `/opt/lampp/htdocs/mi_primera_pagina_php/index.php`

## Paso 4: Ejecuta tu página web PHP

1. Abre tu navegador web.
2. En la barra de direcciones, escribe la siguiente URL para acceder a tu página PHP:

    ```
    http://localhost/mi_primera_pagina_php/index.php
    ```

3. Deberías ver la página con el texto "¡Hola, mundo!" y otro mensaje generado por PHP que dice "¡Este texto está generado por PHP!".

## Paso 5: Detén Apache

### En Windows:
Vuelve al panel de XAMPP y haz clic en **Stop** junto a **Apache** para detener el servidor.

### En GNU/Linux:
Abre la terminal y navega nuevamente a `/opt/lampp`, luego ejecuta:
```bash
sudo ./xampp stop
```
