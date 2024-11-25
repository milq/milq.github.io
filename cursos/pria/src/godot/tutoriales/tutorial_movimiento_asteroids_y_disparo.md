# Tutorial para crear un jugador con movimiento tipo Asteroids con disparos en Godot

En este tutorial aprenderás a crear un juego en Godot donde controlarás una nave espacial con movimiento al estilo del clásico juego [Asteroids][T01] (1979). La nave podrá rotar, acelerar en la dirección en la que apunta y disparar proyectiles. Aprenderás a utilizar `CharacterBody2D` para el control del jugador, `Area2D` para los proyectiles y a manejar escenas y _scripts_ para controlar el comportamiento.

## Paso 1: Configuración del proyecto

1. **Crea un nuevo proyecto**:
   - Abre Godot y crea un nuevo proyecto.
   - Asigna un nombre al proyecto (por ejemplo, *JuegoAsteroids*) y elige una carpeta donde guardarlo.
3. **Crea la escena principal**:
   - Haz clic en _Scene_ y selecciona _New Scene_.
   - Añade un nodo _Node2D_ como nodo raíz.
   - Renombra el nodo raíz como _MainScene_.
   - Guarda la escena seleccionando _Scene → Save Scene_ y guárdala como `MainScene.tscn` en la carpeta raíz del proyecto.
4. **Configura el tamaño de la ventana**:
   - Ve a _Project → Project Settings → General → Display → Window_.
   - Establece _Viewport Width_ en `1280` y _Viewport Height_ en `720` para una resolución HD estándar.
5. **Cambia el color de fondo**:
   - Ve a _Project → Project Settings → General → Rendering → Environment_.
   - Selecciona el color negro para simular el espacio.
6. **Configura el _renderizado_ para _pixel art_**:
   - Ve a _Project → Project Settings → General → Rendering → Textures_.
   - Establece _Default Texture Filter_ en _Nearest_ para que los píxeles de las texturas se vean nítidos.

## Paso 2: Creación del jugador con movimiento tipo Asteroids

1. **Crea una nueva escena**:
   - Haz clic en _Scene → New Scene_.
   - Añade un nodo _CharacterBody2D_ como nodo raíz.
2. **Renombra y guarda la escena**:
   - Renombra el nodo raíz como _Jugador_.
   - Guarda la escena como `jugador.tscn` en la carpeta raíz del proyecto.
3. **Añade el _sprite_ del jugador**:
   - Descarga el _sprite_ de la nave desde [aquí][T02] y colócalo en la carpeta `res://` de tu proyecto.
   - Añade un nodo hijo _Sprite2D_ al nodo _Jugador_.
   - En el Inspector, asigna la textura del _sprite_ descargado.
4. **Añade colisión al jugador**:
   - Añade un nodo hijo _CollisionShape2D_ al nodo _Jugador_.
   - En el Inspector, asigna una forma adecuada, como _RectangleShape2D_.
   - Ajusta su tamaño y posición para que coincida con el _sprite_.
5. **Comprueba las entradas de usuario**:
   - Ve a _Project → Project Settings → Input Map_ y activa _Show Built-in Actions_.
   - Comprueba y, si no existen, añade las siguientes acciones y asigna las teclas correspondientes:
     - `ui_left`: tecla del cursor _Izquierda_.
     - `ui_right`: tecla del cursor _Derecha_.
     - `ui_up`: tecla del cursor _Arriba_.
     - `ui_accept`: tecla _Espacio_.
6. **Añade un _script_ al jugador**:
   - Selecciona el nodo _Jugador_ y asígnale un _script_ denominado `jugador.gd`.
   - Escribe el código del _script_:

```gdscript
extends CharacterBody2D

# Velocidad máxima del jugador
var max_speed: float = 300.0

# Fuerza de aceleración del jugador
var acceleration: float = 200.0

# Velocidad de rotación en grados por segundo
var rotation_speed: float = 180.0

var BulletScene: PackedScene

func _ready() -> void:
    print(position)
    # Precargar la escena de la bala ubicada en res://bullet.tscn
    BulletScene = load("res://bala.tscn")
    print(position)

func _physics_process(delta: float) -> void:
    # Entrada del jugador
    var turn_left: bool = Input.is_action_pressed("ui_left")
    var turn_right: bool = Input.is_action_pressed("ui_right")
    var thrust: bool = Input.is_action_pressed("ui_up")
    var shoot: bool = Input.is_action_just_pressed("ui_accept")

    # Rotar a la izquierda
    if turn_left:
        rotation -= deg_to_rad(rotation_speed * delta)
    # Rotar a la derecha
    if turn_right:
        rotation += deg_to_rad(rotation_speed * delta)

    # Acelerar hacia adelante
    if thrust:
        var forward: Vector2 = Vector2.RIGHT.rotated(rotation)
        velocity += forward * acceleration * delta
        # Limitar a velocidad máxima
        if velocity.length() > max_speed:
            velocity = velocity.normalized() * max_speed

    # Mover al jugador según su velocidad
    position += velocity * delta

    # Aplicar fricción para desacelerar
    velocity *= 0.99  # Reduce la velocidad un 1% cada frame

    # Disparar balas al presionar "shoot"
    if shoot:
        shoot_bullets()

func shoot_bullets() -> void:
    # Distancia de offset desde el centro del jugador
    var offset_distance: float = 32.0  # Ajustar según sea necesario

    # Calcular offsets hacia las esquinas
    var offset1: Vector2 = Vector2(offset_distance, -offset_distance)
    var offset2: Vector2 = Vector2(offset_distance, offset_distance)

    # Rotar offsets según la rotación del jugador
    offset1 = offset1.rotated(rotation)
    offset2 = offset2.rotated(rotation)

    # Instanciar primera bala en la esquina superior izquierda
    var bullet1: Area2D = BulletScene.instantiate() as Area2D
    bullet1.position = position + offset1
    bullet1.rotation = rotation
    get_parent().add_child(bullet1)

    # Instanciar segunda bala en la esquina superior derecha
    var bullet2: Area2D = BulletScene.instantiate() as Area2D
    bullet2.position = position + offset2
    bullet2.rotation = rotation
    get_parent().add_child(bullet2)
```

## Paso 3: Creación de las balas

1. **Crea una nueva escena**:
   - Haz clic en _Scene → New Scene_.
   - Añade un nodo _Area2D_ como nodo raíz.
2. **Renombra y guarda la escena**:
   - Renombra el nodo raíz como _Bala_.
   - Guarda la escena como `bala.tscn` en la carpeta raíz del proyecto.
3. **Añade el _sprite_ de la bala**:
   - Descarga el _sprite_ de la bala desde [aquí][T03] y colócalo en la carpeta `res://` de tu proyecto.
   - Añade un nodo hijo _Sprite2D_ al nodo _Bala_.
   - En el Inspector, asigna la textura del sprite descargado.
4. **Añade colisión a la bala**:
   - Añade un nodo hijo _CollisionShape2D_ al nodo _Bala_.
   - En el Inspector, asigna una forma adecuada, como _RectangleShape2D_.
   - Ajusta su tamaño y posición para que coincida con el sprite.
5. **Añade un _script_ a la bala**:
   - Selecciona el nodo _Bala_ y asígnale un _script_ denominado `bala.gd`.
   - Escribe el código del _script_:

```gdscript
extends Area2D

# Velocidad de la bala
var speed: float = 500.0

# Margen para detectar salida de la pantalla
var MARGIN: float = 50.0

func _physics_process(delta: float) -> void:
    # Mover la bala hacia adelante
    position += Vector2.RIGHT.rotated(rotation) * speed * delta

    # Obtener el tamaño de la pantalla
    var screen_size: Vector2 = get_viewport_rect().size

    # Comprobar si la bala está fuera de la pantalla con margen
    if position.x < -MARGIN or position.x > screen_size.x + MARGIN \
    or position.y < -MARGIN or position.y > screen_size.y + MARGIN:
        queue_free()  # Eliminar la bala de la escena
```

## Paso 4: Añadir el jugador a la escena principal

1. **Abre la escena principal e instancia al jugador**:
   - Abre `MainScene.tscn`.
   - Haz clic derecho en el nodo _MainScene_ y pulsa en _Instantiate Child Scene_ y selecciona `jugador.tscn`.
2. **Posiciona al jugador**:
   - Selecciona el nodo _Jugador_.
   - En el Inspector, establece la posición en _Position_ a `(640, 360)` para centrarlo en la pantalla.

## Paso 5: Probar el juego

1. **Configura la escena principal como escena de inicio**:
   - Ve a _Project → Project Settings → General → Application → Run → Main Scene_.
   - Asegúrate de que esté establecido a `res://main_scene.tscn`.
2. **Ejecuta el proyecto**:
   - Presiona la tecla `F5` o pulsa en _Run Project_ para ejecutar el juego.
3. **Verifica el movimiento**:
   - Usa las teclas de flecha para rotar y acelerar la nave.
   - Presiona la tecla de disparo, _Espacio_, para disparar balas.
4. **Observa el comportamiento**:
   - La nave debería rotar suavemente y moverse en la dirección en la que apunta.
   - Las balas deberían dispararse desde la posición de la nave en la dirección correcta.

## Paso 6: Añadir envolvimiento de pantalla para el jugador y las balas

Ya hemos implementado el envolvimiento de pantalla en los scripts del jugador y las balas. Esto significa que cuando el jugador o las balas salen por un lado de la pantalla, reaparecen por el lado opuesto, simulando un espacio infinito.

## Paso 7: Añadir asteroides (opcional)

Para hacer el juego más interesante, puedes añadir asteroides que el jugador debe evitar o destruir.

### 1. Crear la escena del asteroide

1. **Crear una nueva escena**:
   - Haz clic en **Scene → New Scene**.
   - Añade un nodo **RigidBody2D** como nodo raíz.
2. **Renombrar y guardar la escena**:
   - Renombra el nodo raíz como **Asteroide**.
   - Guarda la escena como `Asteroide.tscn`.
3. **Añadir el sprite del asteroide**:
   - Descarga o crea un sprite para el asteroide y colócalo en la carpeta `res://`.
   - Añade un nodo hijo **Sprite2D** al nodo **Asteroide**.
   - En el Inspector, asigna la textura del sprite del asteroide.
4. **Añadir colisión al asteroide**:
   - Añade un nodo hijo **CollisionShape2D** al nodo **Asteroide**.
   - En el Inspector, asigna una forma adecuada y ajusta su tamaño.

### 2. Escribir el script del asteroide

1. **Añadir un script al asteroide**:
   - Selecciona el nodo **Asteroide**.
   - Haz clic en **Attach Script** y guarda el script como `Asteroide.gd`.
2. **Escribir el código del script**:

```gdscript
extends RigidBody2D

func _ready() -> void:
    # Asignar una velocidad y dirección aleatoria al asteroide
    var direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
    var speed = rand_range(50, 150)
    linear_velocity = direction * speed

func _physics_process(delta: float) -> void:
    # Envolvimiento de pantalla
    var screen_size: Vector2 = get_viewport_rect().size
    if position.x < 0:
        position.x = screen_size.x
    elif position.x > screen_size.x:
        position.x = 0
    if position.y < 0:
        position.y = screen_size.y
    elif position.y > screen_size.y:
        position.y = 0

func _on_Asteroide_area_entered(area):
    if area.is_in_group("Balas"):
        # Destruir el asteroide y la bala al colisionar
        queue_free()
        area.queue_free()
```

3. **Configurar grupos y señales**:
   - Añade al nodo **Bala** al grupo **Balas**. Selecciona el nodo **Bala**, ve a **Node → Groups** y añade el grupo **Balas**.
   - Conecta la señal `area_entered` del **Asteroide** al método `_on_Asteroide_area_entered` en su script.

### 3. Añadir asteroides a la escena principal

1. **Instanciar asteroides**:
   - Abre `MainScene.tscn`.
   - Instancia varios asteroides en la escena principal colocando instancias de `Asteroide.tscn`.
   - Distribúyelos en posiciones aleatorias o predefinidas.

## Paso 8: Mejoras y experimentación

Ahora que tienes la base del juego funcionando, puedes añadir mejoras y características adicionales:

- **Sistema de puntuación**: Añade un marcador que aumente cada vez que destruyes un asteroide.
- **Vidas del jugador**: Implementa un sistema de vidas o salud para el jugador.
- **Niveles de dificultad**: Aumenta la cantidad y velocidad de los asteroides con el tiempo.
- **Efectos de sonido y música**: Añade efectos de sonido para disparos, explosiones y música de fondo.
- **Animaciones**: Crea animaciones para la explosión de asteroides y la nave del jugador.

## Conclusión

Has aprendido a crear un jugador con movimiento tipo Asteroids que puede disparar en Godot. Este tutorial cubrió la creación y configuración de escenas, la escritura de scripts para el movimiento y disparo, y cómo manejar la envoltura de pantalla. Continúa explorando y ampliando el juego para añadir más funcionalidades y hacerlo más completo y divertido.

[T01]: https://en.wikipedia.org/wiki/Asteroids_(video_game)
[T02]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/sprites/jugador.png
[T03]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/sprites/bala_jugador.png
