# Tutorial: Crea un laberinto 3D procedural con jugador en 1ª persona

En este tutorial aprenderás a generar un laberinto 3D de forma procedimental usando ruido, y a controlar un jugador en primera persona que puede moverse, saltar y explorar el laberinto en tiempo real. El laberinto tendrá una salida marcada con un cubo rojo en una esquina, y el jugador comenzará en la esquina opuesta.

## Paso 1: Configura la escena principal

1. Abre Godot y crea un nuevo proyecto. Asegúrate de configurar el _Renderer_ como `Forward+` en la configuración del proyecto.
2. Crea un nodo _Node3D_ seleccionando _3D Scene_ como nodo raíz de la escena principal.
3. Renombra el nodo raíz como _World_ y guarda la escena seleccionando _Scene → Save Scene_. Nómbrala como `world.tscn`.
4. En _Project → Project Settings → General → Display → Window_ establece _Viewport Width_ en `1280` y _Viewport Height_ en `720`.
5. Recuerda los [controles de navegación del _viewport_][T01] para orbitar y desplazarte por la escena 3D.
6. Añade a la escena 3D un [sol][T02] (_Add Sun to Scene_) y luego un [entorno][T03] (_Add Environment to Scene_).
7. Haz clic en _Play Scene_ para verificar que la cámara muestra un horizonte donde el cielo azul claro se separa del suelo marrón.

[T01]: https://github.com/milq/milq.github.io/blob/master/cursos/godot/tutorials/3d_viewport_navigation_controls.md
[T02]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/add_sun_to_scene.png
[T03]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/add_environment_to_scene.png

## Paso 2: Crea el jugador en primera persona

1. Dentro de `World`, añade un `CharacterBody3D` y renómbralo como `Player`.
2. Añade los siguientes nodos como hijos de `Player`:
   - `Camera3D`
   - `CollisionShape3D` con un `CapsuleShape3D` como forma
4. Crea un _script_ para el jugador llamado `player.gd` y asígnalo al nodo `Player` con el siguiente contenido:

```gdscript
extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.1
@export var jump_force: float = 12.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
        $Camera3D.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
        $Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-90.0), \
                                                           deg_to_rad(90.0))
    elif event is InputEventKey and event.pressed:
        if event.keycode == KEY_ESCAPE:
            get_tree().quit()

func _physics_process(delta: float) -> void:
    var dir: Vector3 = Vector3.ZERO
    if Input.is_key_pressed(KEY_W):
        dir -= transform.basis.z
    if Input.is_key_pressed(KEY_S):
        dir += transform.basis.z
    if Input.is_key_pressed(KEY_A):
        dir -= transform.basis.x
    if Input.is_key_pressed(KEY_D):
        dir += transform.basis.x
    dir = dir.normalized()

    velocity.x = dir.x * speed
    velocity.z = dir.z * speed

    if is_on_floor():
        if Input.is_key_pressed(KEY_SPACE):
            velocity.y = jump_force
        else:
            velocity.y = 0.0
    else:
        velocity.y -= gravity * delta

    move_and_slide()
```

## Paso 3: Genera un terreno 3D de forma procedimental

1. Dentro de `World`, añade un nodo `Node3D` y nómbralo `MazeGenerator`.
2. Crea un nuevo _script_ llamado `maze_generator.gd` y asígnalo al nodo `MazeGenerator`.
3. Copia este código en el _script_:

```gdscript
extends Node3D

@export var width: int = 15
@export var height: int = 15
@export var cell_size: float = 4.0
@export var wall_height: float = 3.0

var maze: Array = []
var player_spawn: Vector3 = Vector3.ZERO
var exit_pos: Vector3 = Vector3.ZERO

func _ready() -> void:
    randomize()
    generate_maze()
    generate_floor()
    place_player()
    place_exit()

func generate_maze() -> void:
    maze.clear()
    for y: int in range(height):
        maze.append([])
        for x: int in range(width):
            maze[y].append(true)

    var stack: Array[Vector2i] = []
    var pos: Vector2i = Vector2i(1, 1)
    maze[pos.y][pos.x] = false
    stack.push_back(pos)

    var directions: Array[Vector2i] = [Vector2i(2, 0), Vector2i(-2, 0), \
                                       Vector2i(0, 2), Vector2i(0, -2)]

    while not stack.is_empty():
        pos = stack.back()
        var options: Array[Vector2i] = []

        for dir: Vector2i in directions:
            var nx: int = pos.x + dir.x
            var ny: int = pos.y + dir.y
            if nx > 0 and ny > 0 and nx < width - 1 and \
                                     ny < height - 1 and maze[ny][nx]:
                options.append(dir)

        if options:
            var chosen: Vector2i = options[randi() % options.size()]
            var between: Vector2i = pos + chosen / 2
            var next: Vector2i = pos + chosen
            maze[between.y][between.x] = false
            maze[next.y][next.x] = false
            stack.push_back(next)
        else:
            stack.pop_back()

    var wall_mesh: BoxMesh = BoxMesh.new()
    wall_mesh.size = Vector3(cell_size, wall_height, cell_size)

    for y: int in range(height):
        for x: int in range(width):
            if maze[y][x]:
                var wall: MeshInstance3D = MeshInstance3D.new()
                wall.mesh = wall_mesh
                wall.position = Vector3.ZERO

                var wall_body: StaticBody3D = StaticBody3D.new()
                wall_body.position = Vector3(x * cell_size, \
                                             wall_height / 2.0, y * cell_size)

                var collision: CollisionShape3D = CollisionShape3D.new()
                var box_shape: BoxShape3D = BoxShape3D.new()
                box_shape.size = Vector3(cell_size, wall_height, cell_size)
                collision.shape = box_shape

                wall_body.add_child(wall)
                wall_body.add_child(collision)
                add_child(wall_body)

func generate_floor() -> void:
    var floor_box_mesh: BoxMesh = BoxMesh.new()
    floor_box_mesh.size = Vector3(cell_size, 1.0, cell_size)

    for y: int in range(height):
        for x: int in range(width):
            if not maze[y][x]:
                var pos: Vector3 = Vector3(x * cell_size, 0.0, y * cell_size)

                var floor_mesh: MeshInstance3D = MeshInstance3D.new()
                floor_mesh.mesh = floor_box_mesh
                floor_mesh.position = Vector3.ZERO

                var floor_body: StaticBody3D = StaticBody3D.new()
                floor_body.position = pos

                var collision: CollisionShape3D = CollisionShape3D.new()
                var box_shape: BoxShape3D = BoxShape3D.new()
                box_shape.size = Vector3(cell_size, 1.0, cell_size)
                collision.shape = box_shape

                floor_body.add_child(floor_mesh)
                floor_body.add_child(collision)
                add_child(floor_body)

func place_player() -> void:
    var player: CharacterBody3D = get_parent().get_node("Player")
    for y: int in range(height):
        for x: int in range(width):
            if not maze[y][x]:
                player.global_position = Vector3(x * cell_size, \
                                         wall_height + 1, y * cell_size)
                return

func place_exit() -> void:
    for y: int in range(height - 1, 0, -1):
        for x: int in range(width - 1, 0, -1):
            if not maze[y][x]:
                var exit: MeshInstance3D = MeshInstance3D.new()
                var mesh: BoxMesh = BoxMesh.new()
                mesh.size = Vector3(2, 2, 2)
                exit.mesh = mesh
                exit.position = Vector3(x * cell_size, 3.0, y * cell_size)

                var mat: StandardMaterial3D = StandardMaterial3D.new()
                mat.albedo_color = Color(1.0, 0.0, 0.0)
                mesh.material = mat

                add_child(exit)
                return
```

## Paso 4: Ejecuta y explora tu mundo generado

1. Ejecuta el juego, deberías ver un laberinto 3D generada por procedimientos con un cubo rojo que representa la salida.
2. Puedes caminar con `WASD`, saltar con espacio, mirar alrededor con el ratón y si presionas `Esc`, el juego se cierra.
