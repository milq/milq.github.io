# Tutorial: Crear un _tilemap_ en Godot dado un _tileset_

En este tutorial aprenderás a crear un _tilemap_ en Godot usando un _tileset_ ya proporcionado.

## Paso 1: Configurar el proyecto y descargar el _tileset_

1. **Descarga el _tileset_**:
   - Entra a [kenney.nl/assets/tiny-dungeon][T01] y descarga el _tileset_.
   - Extrae el archivo ZIP y busca la imagen `tilemap_packed.png` dentro de la carpeta `Tilemap`.

2. **Crea un proyecto nuevo en Godot**:
   - Abre Godot y crea un proyecto con una escena 2D (`Node2D`).
   - Dentro del proyecto, crea en `res://` una carpeta llamada `assets/` y copia allí el archivo `tilemap_packed.png`.

3. **Añade un nodo TileMapLayer**:
   - En el nodo raíz de la escena principal, presiona el botón `+` para añadir un nodo.
   - Busca y selecciona `TileMapLayer`.
   - Se habilitará la pestaña`TileMap` en la parte inferior de la pantalla.

## Paso 2: Crear el recurso _tileset_

1. **Crea un nuevo _tileset_ al nodo TileMapLayer**:
   - Selecciona el nodo _TileMapLayer_ y, en el *Inspector*, haz clic en **Tile Set > New TileSet**.
   - Se habilitará la pestaña `TileSet` en la parte inferior de la pantalla.

2. **Importa la imagen del _tileset_**:
   - Selecciona la pestaña de `Tileset` en la parte inferior de la pantalla.
   - A continuación, haz clic en el botón `+` y selecciona **Atlas**.
   - Selecciona el archivo `tilemap_packed.png` que está dentro de la carpeta `assets/`.
   - Cuando aparezca el mensaje _The atlas's texture was modified. Would you like to automatically create tiles in the atlas?_, haz clic en `Yes`. Esto permitirá que Godot detecte y cree automáticamente los _tiles_ en el _atlas_ basándose en la textura cargada (`tilemap_packed.png`).
   - Verifica que `Texture Region Size` esté a `16x16` (esta propiedad define el tamaño de cada _tile_ en píxeles, en este caso, 16x16 píxeles por _tile_), comprueba que `Margins` y `Separation` estén a `0x0` (`Margins` especifica el espacio vacío alrededor del borde de la imagen del _tileset_, y `Separation` indica el espacio entre los _tiles_ dentro del _tileset_; si no hay margen o separación, déjalos en `0x0`), y asegúrate de que `Use Texture Padding` esté en `On` (esta propiedad evita artefactos visuales en los bordes de los _tiles_ al renderizarse, añadiendo un pequeño relleno alrededor de cada _tile_).

## Paso 3: Pintar el mapa

1. **Selecciona el modo de pintura**:
   - Asegúrate de tener seleccionado el nodo _TileMapLayer_.
   - En la parte inferior de la pantalla, pulsa en la pestaña _TileMap_, elige el _tileset_ cargado y selecciona un _tile_.

2. **Dibuja el escenario**:
   - Usa la herramienta **Paint** (icono de lápiz) para colocar _tiles_ a tu gusto en el _viewport_.
   - Pulsa `clic izquierdo` para pintar y `clic derecho` para borrar.
   - Usa la herramienta **Rectangle** (icono de rectángulo) para definir un área rectangular que se rellenará automáticamente con el _tile_ seleccionado.
   - Usa la herramienta **Bucket** (icono de bote de pintura) para rellenar áreas grandes rápidamente.
   - Activa la opción de **azar** (icono de dado) y comprueba que sucede con la herramienta _Rectangle_. El _scattering_ agrega variación, ideal para decoración orgánica (hierba, rocas).

2. **Dibuja el escenario**:
   - Utiliza la herramienta **Paint** (icono de lápiz) para colocar _tiles_ en el _viewport_: `clic izquierdo` para pintar y `clic derecho` para borrar.
   - Con la herramienta **Rectangle** (icono de rectángulo) delimita un área que se rellenará automáticamente con el _tile_ seleccionado.
   - Emplea la herramienta **Bucket** (icono de bote de pintura) para rellenar rápidamente áreas extensas.
   - Activa la opción **azar** (icono de dado) y observa cómo el _scattering_ introduce variación, ideal para decoraciones orgánicas como hierba o rocas.
   - Además, puedes seleccionar múltiples _tiles_; al usar el **Rectangle**, se aplican simultáneamente y, con la opción **azar** activada, se elige al azar entre ellos.

3. **Prueba la escena con el _tilemap_**:
   - Dibuja un mapa de _tiles_ parecido a [éste][T02] o más sencillo pero sin personajes.
   - Ejecuta la escena (`F5`) para verificar que tu mapa de _tiles_ se muestra correctamente.

## Paso 4: Crea un personaje para que se mueva en tu _tilemap_

1. **Crea una escena de tipo _CharacterBody2D_**:
   - Crea una nueva escena haciendo clic en _Scene_ y seleccionando _New Scene_.  
   - Añade un nodo _CharacterBody2D_ como nodo raíz desde _Other Node → CharacterBody2D_.  
   - Renombra el nodo raíz como _Player_ y guarda la escena como `player.tscn`.  
   - Añade un nodo hijo _AnimatedSprite2D_ al nodo _Player_ y asígnale un _sprite_ de un personaje de tu _atlas_.  
   - Añade un nodo hijo _CollisionShape2D_ al nodo _Player_ para asignarle una colisión.
   - Selecciona el nodo _Player_ y asígnale un _script_ denominado `player.gd`.
   - Ponle el siguiente código de GDScript:

```gdscript
extends CharacterBody2D

const SPEED: float = 150.0

func _physics_process(delta: float) -> void:
    var horizontal: float = Input.get_axis("ui_left", "ui_right")
    var vertical: float = Input.get_axis("ui_up", "ui_down")
    var direction: Vector2 = Vector2(horizontal, vertical).normalized()

    velocity = direction * SPEED

    move_and_slide()
```

2. **Asígnale movimiento al personaje y comprueba**:

   - Guarda los cambios y, a continuación, instancia la escena _Player_ en la escena principal donde está tu mapa de _tiles_.
   - Ejecuta el proyecto y comprueba que el jugador se mueve por el mapa, pero no colisiona con las paredes.  

## Paso 5: Añade colisiones a _tiles_ específicos

1. **Activa la capa física para las colisiones**
   - Selecciona el nodo _TileMapLayer_ de tu escena.
   - En el *Inspector*, pulsa en el campo `TileSet` de la propieda `Tile Set` para abrir la configuración del _tileset_.
   - Dentro de la ventana del _tileset_, dirígete al apartado _Physics Layers_.
   - Pulsa en `Add Element` para añadir una [capa física][T03].

2. **Selecciona la herramienta de pintura y la capa física**  
   - En la parte inferior de la ventana, haz clic en la pestaña **TileMap** *(1 en la [imagen][T04])*.  
   - Asegúrate de tener elegida la opción **Paint** *(2 en la [imagen][T04])*.  
   - En el panel de la derecha, en la sección **Paint Properties**, selecciona **Physics Layer 0** *(3 en la [imagen][T04])*. Esto indica que los _tiles_ que pintes o edites se asignarán a esa capa de colisión.  

3. **Marca los _tiles_ que tendrán colisión**  
   - Localiza en el _atlas_ (el recuadro con todos los _tiles_) aquellos que deseas que tengan colisión *(4 en la [imagen][T04])*.  
   - Al pasar el cursor sobre cada _tile_, haz **clic izquierdo** para seleccionarlo. Si Godot ya detectó una forma de colisión por defecto, verás que ese _tile_ se resalta en un tono azulado al activarle la colisión.  

4. **Ajusta la forma de colisión para cada _tile_ (opcional)**  
   - Si necesitas modificar la forma de colisión de un _tile_, haz clic en **︙** elige **Reset to default tile shape** *(5 en la [imagen][T04])* para restaurar la forma automática que Godot generó, o bien **Clear** si quieres eliminarla por completo.  

5. **Comprueba las colisiones en el juego**  
   - Gaurda la escena, cierra la ventana de configuración del _TileSet_ y regresa a la escena principal.  
   - Ejecuta la escena. Ahora, cuando tu nodo _Player_ (que tiene un _CollisionShape2D_) intente atravesar los _tiles_ a los que has asignado colisión, deberá toparse con ellos y no podrá pasar a través de las paredes, confirmando que la colisión funciona correctamente.  

Con esto, habrás asignado colisiones únicamente a los _tiles_ que lo requieran (como muros, pilares o cofres) y tu personaje ya no podrá atravesarlos. Continúa afinando la distribución de _tiles_ y las formas de colisión hasta que tu mapa refleje la jugabilidad deseada.

## Paso 5: Optimizar y guardar

1. **Guarda el _tileset_**:
   - En el editor de _tileset_, haz clic en **Save** y guarda el recurso como `dungeon__tileset_.tres`.

2. **Reutiliza el _tileset_**:
   - Si creas otra escena, arrastra el archivo `dungeon__tileset_.tres` a la propiedad **_tileset_** de un nuevo nodo TileMap.

[T01]: https://kenney.nl/assets/tiny-dungeon
[T02]: https://kenney.nl/media/pages/assets/tiny-dungeon/331078e148-1674742412/sample.png
[T03]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/tutorial_crear_tilemap_1.png
[T04]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/tutorial_crear_tilemap_2.png
