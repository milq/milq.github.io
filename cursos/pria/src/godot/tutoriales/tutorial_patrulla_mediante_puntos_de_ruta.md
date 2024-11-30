# Tutorial para crear un _bot_ que patrulla por _waypoints_ en Godot

En este tutorial, aprenderás a crear un _bot_ en Godot que patrulla a través de una serie de _waypoints_ (puntos de ruta), girando suavemente al aproximarse a cada uno de ellos. El _bot_ se moverá por 7 _waypoints_ definidos como nodos `Marker2D`. Una vez que alcance el último _waypoint_, volverá al primero, creando un circuito circular.

## Paso 1: Configuración del proyecto

1. **Crea un nuevo proyecto**:
   - Abre Godot y crea un nuevo proyecto.
   - Asigna un nombre al proyecto (por ejemplo, *Waypoints*) y elige una carpeta donde guardarlo.
2. **Crea la escena principal**:
   - Haz clic en _Scene_ y selecciona _New Scene_.
   - Añade un nodo _Node2D_ como nodo raíz.
   - Renombra el nodo raíz como _MainScene_.
   - Guarda la escena seleccionando _Scene → Save Scene_ y guárdala como `MainScene.tscn` en la carpeta raíz del proyecto.
3. **Configura el tamaño de la ventana**:
   - Ve a _Project → Project Settings → General → Display → Window_.
   - Establece _Viewport Width_ en `1280` y _Viewport Height_ en `720` para una resolución HD estándar.
4. **Cambia el color de fondo**:
   - Ve a _Project → Project Settings → General → Rendering → Environment_.
   - Selecciona el color negro para simular el espacio o un color de fondo que prefieras.
5. **Configura el _renderizado_ para _pixel art_ (si es necesario)**:
   - Ve a _Project → Project Settings → General → Rendering → Textures_.
   - Establece _Default Texture Filter_ en _Nearest_ para que los píxeles de las texturas se vean nítidos (opcional, dependiendo del estilo gráfico).

## Paso 2: Creación del _bot_ que patrulla por _waypoints_

1. **Crea una nueva escena**:
   - Haz clic en _Scene → New Scene_.
   - Añade un nodo _AnimatedSprite2D_ como nodo raíz.
2. **Renombra y guarda la escena**:
   - Renombra el nodo raíz como _Bot_.
   - Guarda la escena como `_bot_.tscn` en la carpeta raíz del proyecto.
3. **Añade el _sprite_ del _bot_**:
   - Descarga el _sprite_ del _bot_ desde [aquí][T01] y arrástralo a la carpeta `res://` de tu proyecto.
   - Selecciona el nodo _Bot_ (que es un _AnimatedSprite2D_).
   - En el Inspector, abre la propiedad _Animation_ y luego _Sprite Frames_.
   - Haz clic en `<empty>`, selecciona _New SpriteFrames_, y pulsa en el nuevo valor creado llamado `SpriteFrames`.
   - Verifica que el texto de `SpriteFrames` se resalta en azul y que se abre debajo el panel correspondiente.
   - Arrastra `enemigo.png` a la zona de _Animation Frames_.
   - Recuerda, si quieres animar _sprites_ en 2D en Godot, puedes estudiar este [tutorial][T02].
4. **Añade un _script_ al _bot_**:
   - Selecciona el nodo _Bot_ y asígnale un _script_ denominado `bot.gd`.
   - Ponle el siguiente código de GDScript:

```gdscript
extends AnimatedSprite2D

const ORIENTACION_SPRITE: Vector2 = Vector2.UP
const VELOCIDAD: float = 300.0
const DISTANCIA_GIRO: float = 10.0
const SUAVIDAD_GIRO: float = 0.1

var waypoints: Array[Marker2D] = []
var indice_waypoint: int = 0

func _ready() -> void:
    var nodo_waypoints: Node = get_parent().get_node("Waypoints")
    for waypoint: Marker2D in nodo_waypoints.get_children():
        waypoints.append(waypoint)

func _process(delta: float) -> void:
    var objetivo: Vector2 = waypoints[indice_waypoint].global_position
    var direccion: Vector2 = (objetivo - global_position).normalized()
    global_position += direccion * VELOCIDAD * delta
    if global_position.distance_to(objetivo) < DISTANCIA_GIRO:
        indice_waypoint = (indice_waypoint + 1) % waypoints.size()
    var angulo_objetivo: float = direccion.angle() - ORIENTACION_SPRITE.angle()
    rotation = lerp_angle(rotation, angulo_objetivo, SUAVIDAD_GIRO)
```

## Paso 3: Configuración de los _waypoints_ en la escena principal

1. **Agrupa los _waypoints_ en un nodo**:
   - Abre `main_scene.tscn`, añade un nodo de tipo _Node_ como hijo de _MainScene_ y renómbralo como _Waypoints_.
2. **Crea los _waypoints_**:
   - Añade un nodo de tipo _Marker2D_ como hijo de _Waypoints_ y renómbralo como _Waypoint1_.
   - Duplica _Waypoint1_ (`Ctrl` + `D`) seis veces.
   - Asegúrate de que _Waypoint1_, _Waypoint2_, y los demás sean hijos de _Waypoints_ y del tipo _Marker2D_.
4. **Posiciona los _waypoints_**:
   - Selecciona cada _waypoint_ y posiciónalo en el escenario donde desees que el _bot_ patrulle.
   - Por ejemplo, distribúyelos en diferentes puntos para formar una ruta cerrada.

## Paso 4: Añadir el _bot_ a la escena principal

1. **Instancia el _bot_ en `MainScene`**:
   - Haz clic derecho en el nodo `MainScene` y selecciona _Instance Child Scene_.
   - Selecciona `bot.tscn` para instanciar el _bot_.
2. **Posiciona el _bot_**:
   - Selecciona el nodo _Bot_.
   - En el Inspector, establece la posición inicial:
     - Establece la posición en la misma que _Waypoint1_.
     - O en otra posición según prefieras.

## Paso 5: Probar el movimiento del _bot_

1. **Configura la escena principal como escena de inicio**:
   - Ve a _Project → Project Settings → General → Application → Run → Main Scene_.
   - Asegúrate de que esté establecido en `res://main_scene.tscn`.
2. **Ejecuta el proyecto**:
   - Presiona la tecla `F5` o haz clic en _Run Project_ para ejecutar el juego.
3. **Observa el comportamiento del _bot_**:
   - El _bot_ debería moverse hacia el primer _waypoint_.
   - Al acercarse a él, comenzará a girar suavemente hacia el siguiente _waypoint_.
   - Continuará este proceso para todos los _waypoints_ en orden, y después volverá al primero, creando un bucle continuo.

## Paso 6: Mejoras y experimentación (opcional)

Ahora que tienes un _bot_ patrullando por _waypoints_, puedes añadir funcionalidades adicionales:

- **Añadir más _bots_**: crea más _bots_ y haz que patrullen en diferentes rutas o en la misma ruta pero en diferentes celeridades.
- **Interacción con el jugador**: crea un jugador y haz que los _bots_ reaccionen al jugador, por ejemplo, persiguiéndolo si se acerca demasiado.
- **Animaciones**: usa diferentes animaciones según el estado del _bot_ o del jugador.
- **Detección de colisiones**: añade colisiones al _bot_ para que pueda interactuar con otros objetos en la escena.
- **Efectos visuales y de sonido**: añade partículas o efectos de sonido cuando el _bot_ cambia de dirección o llega a un _waypoint_.

[T01]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/sprites/enemigo.png
[T02]: https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html
