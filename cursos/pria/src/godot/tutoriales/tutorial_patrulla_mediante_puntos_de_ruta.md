# Tutorial para crear un _bot_ que patrulla por _waypoints_ en Godot

En este tutorial, aprenderás a crear un _bot_ en Godot que patrulla a través de una serie de _waypoints_, girando suavemente al aproximarse a cada uno de ellos. El _bot_ utilizará un `AnimatedSprite2D` con un sprite específico y se moverá por 7 _waypoints_ definidos como nodos `Marker2D`. Una vez que alcance el último waypoint, volverá al primero, creando un circuito circular. Aprenderás a utilizar scripts y a manejar escenas para controlar el comportamiento del _bot_.

## Paso 1: Configuración del proyecto

1. **Crea un nuevo proyecto**:
   - Abre Godot y crea un nuevo proyecto.
   - Asigna un nombre al proyecto (por ejemplo, *Patrulla_bot_*) y elige una carpeta donde guardarlo.
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
   - Renombra el nodo raíz como __bot__.
   - Guarda la escena como `_bot_.tscn` en la carpeta raíz del proyecto.
3. **Añade el sprite del _bot_**:
   - Descarga el sprite del _bot_ desde [aquí](https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/sprites/enemigo.png) y colócalo en la carpeta `res://` de tu proyecto.
   - Selecciona el nodo __bot__ (que es un `AnimatedSprite2D`).
   - En el Inspector, abre la propiedad _Animation_ y luego _Sprite Frames_.
   - Haz clic en `<empty>`, selecciona _New SpriteFrames_, y pulsa en el nuevo valor creado llamado `SpriteFrames`.
   - Verifica que el texto de `SpriteFrames` se resalta en azul y que se abre debajo el panel correspondiente.
   - Arrastra `enemigo.png` a la zona de _Animation Frames_.
   - Si el sprite tiene múltiples frames para animación, puedes organizarlos en una animación llamada "default".
4. **Añade colisión al _bot_ (opcional)**:
   - Si deseas que el _bot_ tenga colisión, añade un nodo hijo _CollisionShape2D_ al nodo __bot__.
   - En el Inspector, asigna una forma adecuada, como _RectangleShape2D_ o _CircleShape2D_.
   - Ajusta su tamaño y posición para que coincida con el sprite.
5. **Añade un script al _bot_**:
   - Selecciona el nodo __bot__ y asígnale un script denominado `_bot_.gd`.
   - Escribe el código del script con tipado estático explícito:

```gdscript
extends AnimatedSprite2D

# Constantes para el movimiento y giro
const SPEED: float = 100.0  # Velocidad de movimiento en píxeles por segundo
const TURN_SPEED: float = 2.0  # Velocidad de giro en radianes por segundo
const START_TURN_DISTANCE: float = 50.0  # Distancia al waypoint para empezar a girar

# Array de _waypoints_ (se llenará en tiempo de ejecución)
var _waypoints_: Array[Vector2] = []

# Índice del waypoint actual
var current_waypoint_index: int = 0

# Nodo del waypoint actual
var current_waypoint: Vector2

func _ready() -> void:
    # Obtener la lista de _waypoints_ desde la escena principal
    var _waypoints__node: Node = get_parent().get_node("_waypoints_")
    for marker in _waypoints__node.get_children():
        if marker is Marker2D:
            _waypoints_.append(marker.position)
    # Establecer el primer waypoint
    current_waypoint = _waypoints_[current_waypoint_index]

func _physics_process(delta: float) -> void:
    # Vector hacia el waypoint actual
    var direction_to_waypoint: Vector2 = (current_waypoint - position).normalized()

    # Distancia al waypoint actual
    var distance_to_waypoint: float = position.distance_to(current_waypoint)

    # Calcular la rotación deseada hacia el waypoint
    var desired_angle: float = direction_to_waypoint.angle()

    # Interpolar suavemente la rotación actual hacia la rotación deseada
    rotation = lerp_angle(rotation, desired_angle, TURN_SPEED * delta)

    # Mover el _bot_ hacia adelante
    var velocity: Vector2 = Vector2(cos(rotation), sin(rotation)) * SPEED
    position += velocity * delta

    # Si estamos cerca del waypoint actual, pasar al siguiente
    if distance_to_waypoint < START_TURN_DISTANCE:
        current_waypoint_index = (current_waypoint_index + 1) % _waypoints_.size()
        current_waypoint = _waypoints_[current_waypoint_index]
```

**Explicación del código:**

- **Constantes:**
  - `SPEED`: controla la velocidad de movimiento del _bot_.
  - `TURN_SPEED`: determina qué tan rápido gira el _bot_ para alinearse con el siguiente waypoint.
  - `START_TURN_DISTANCE`: define a qué distancia del waypoint el _bot_ comienza a girar.

- **Variables:**
  - `_waypoints_`: almacenará las posiciones de los _waypoints_ obtenidos de la escena principal.
  - `current_waypoint_index`: índice del waypoint al que se dirige el _bot_.
  - `current_waypoint`: posición del waypoint actual.

- **Función `_ready()`:**
  - Obtiene el nodo `_waypoints_` de la escena principal.
  - Itera sobre sus hijos y agrega las posiciones de los `Marker2D` al array `_waypoints_`.
  - Establece el primer waypoint como objetivo.

- **Función `_physics_process(delta)`:**
  - Calcula el vector dirección hacia el waypoint actual.
  - Calcula la distancia al waypoint actual.
  - Calcula el ángulo deseado para mirar hacia el waypoint.
  - Interpola la rotación actual hacia el ángulo deseado usando `lerp_angle` para un giro suave.
  - Actualiza la posición del _bot_ moviéndolo hacia adelante en la dirección actual.
  - Si la distancia al waypoint es menor que `START_TURN_DISTANCE`, actualiza el índice al siguiente waypoint.

**Nota:** El uso de `lerp_angle` permite una interpolación suave entre ángulos, manejando correctamente la transición entre 0 y 2π radianes.

## Paso 3: Configuración de los _waypoints_ en la escena principal

1. **Agrupa los _waypoints_ en un nodo**:
   - En `MainScene.tscn`, añade un nodo `Node2D` como hijo de `MainScene` y renómbralo como `_waypoints_`.
2. **Añade los _waypoints_**:
   - Añade 7 nodos hijos al nodo `_waypoints_`, cada uno de tipo `Marker2D`.
   - Renombra cada `Marker2D` como `Waypoint1`, `Waypoint2`, ..., `Waypoint7`.
3. **Posiciona los _waypoints_**:
   - Selecciona cada `Marker2D` y posiciónalos en el escenario donde desees que el _bot_ patrulle.
   - Por ejemplo, distribúyelos en diferentes puntos para formar una ruta cerrada.
4. **Verifica la estructura de la escena**:
   - Deberías tener algo como:

```
MainScene
├── _waypoints_
│   ├── Waypoint1 (Marker2D)
│   ├── Waypoint2 (Marker2D)
│   ├── Waypoint3 (Marker2D)
│   ├── Waypoint4 (Marker2D)
│   ├── Waypoint5 (Marker2D)
│   ├── Waypoint6 (Marker2D)
│   └── Waypoint7 (Marker2D)
```

## Paso 4: Añadir el _bot_ a la escena principal

1. **Instancia el _bot_ en `MainScene`**:
   - En `MainScene.tscn`, haz clic derecho en el nodo `MainScene` y selecciona _Instance Child Scene_.
   - Selecciona `_bot_.tscn` para instanciar el _bot_.
2. **Posiciona el _bot_**:
   - Selecciona el nodo `_bot_`.
   - En el Inspector, establece la posición inicial. Puede ser en el primer waypoint:
     - Establece la posición en la misma que `Waypoint1`.
     - O en otra posición según prefieras.
3. **Verifica la estructura final**:
   - La escena debería verse así:

```
MainScene
├── _bot_ (AnimatedSprite2D)
├── _waypoints_
│   ├── Waypoint1 (Marker2D)
│   ├── Waypoint2 (Marker2D)
│   ├── Waypoint3 (Marker2D)
│   ├── Waypoint4 (Marker2D)
│   ├── Waypoint5 (Marker2D)
│   ├── Waypoint6 (Marker2D)
│   └── Waypoint7 (Marker2D)
```

## Paso 5: Probar el movimiento del _bot_

1. **Configura la escena principal como escena de inicio**:
   - Ve a _Project → Project Settings → General → Application → Run → Main Scene_.
   - Asegúrate de que esté establecido en `res://MainScene.tscn`.
2. **Ejecuta el proyecto**:
   - Presiona la tecla `F5` o haz clic en _Run Project_ para ejecutar el juego.
3. **Observa el comportamiento del _bot_**:
   - El _bot_ debería moverse hacia el primer waypoint.
   - Al acercarse a él, comenzará a girar suavemente hacia el siguiente waypoint.
   - Continuará este proceso para todos los _waypoints_ en orden, y después volverá al primero, creando un bucle continuo.

## Paso 6: Ajustar parámetros para el giro suave (opcional)

Puedes experimentar con las constantes definidas en el script del _bot_ para ajustar su comportamiento:

- **`SPEED`**: modifica la velocidad de movimiento del _bot_.
- **`TURN_SPEED`**: ajusta la rapidez con la que el _bot_ gira hacia el siguiente waypoint. Un valor mayor hará que el _bot_ gire más rápido.
- **`START_TURN_DISTANCE`**: cambia la distancia a la que el _bot_ comienza a girar hacia el próximo waypoint. Un valor mayor hará que empiece a girar antes.

Prueba diferentes valores para lograr el efecto deseado de suavidad en el giro y en el movimiento del _bot_.

## Paso 7: Mejoras y experimentación (opcional)

Ahora que tienes un _bot_ patrullando por _waypoints_, puedes añadir funcionalidades adicionales:

- **Añadir más _bot_s**: instancia múltiples _bot_s y haz que patrullen diferentes rutas o la misma ruta en diferentes direcciones.
- **Interacción con el jugador**: si tienes un jugador en la escena, puedes hacer que los _bot_s reaccionen al jugador, por ejemplo, persiguiéndolo si se acerca demasiado.
- **Animaciones**: si tu sprite tiene animaciones, puedes configurarlas en el `AnimatedSprite2D` y reproducir diferentes animaciones según el estado del _bot_.
- **Detección de colisiones**: añade colisiones al _bot_ para que pueda interactuar con otros objetos en la escena.
- **Efectos visuales y de sonido**: añade partículas o efectos de sonido cuando el _bot_ cambia de dirección o llega a un waypoint.

## Recursos adicionales

- **Interpolación de ángulos con `lerp_angle`**: consulta la documentación oficial de Godot sobre [Interpolación lineal](https://docs.godotengine.org/es/stable/tutorials/math/interpolation.html) para entender cómo funciona la interpolación de ángulos y posiciones.
- **Uso de `Marker2D`**: los nodos `Marker2D` son útiles para definir puntos en el espacio 2D sin representar nada visualmente. Puedes usarlos para definir rutas y puntos de interés.
- **Optimización del código**: si tienes muchos _bot_s o _waypoints_, considera optimizar tu código para mejorar el rendimiento.
