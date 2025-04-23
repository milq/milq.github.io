# Tutorial: Crea un mapa 3D procedural con jugador en primera persona

En este tutorial aprenderás a generar un terreno 3D de forma procedimental usando ruido y a controlar un jugador en primera persona que puede moverse, saltar y explorar ese mundo en tiempo real.

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
2. Cambia su posición en el Inspector a `x = 100`, `y = 25`, `z = 100`.
3. Añade los siguientes nodos como hijos de `Player`:
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
    var direction: Vector3 = Vector3.ZERO
    if Input.is_key_pressed(KEY_W):
        direction -= transform.basis.z
    if Input.is_key_pressed(KEY_S):
        direction += transform.basis.z
    if Input.is_key_pressed(KEY_A):
        direction -= transform.basis.x
    if Input.is_key_pressed(KEY_D):
        direction += transform.basis.x

    direction = direction.normalized()
    velocity.x = direction.x * speed
    velocity.z = direction.z * speed

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

1. Dentro de `World`, añade un nodo `MultiMeshInstance3D` y nómbralo `Terrain`.
2. Crea un nuevo _script_ llamado `terrain_generator.gd` y asígnalo al nodo `Terrain`.
3. Copia este código en el _script_:

```gdscript
extends MultiMeshInstance3D

@export var size: int = 100
@export var scale_world: float = 2.0
@export var height: float = 10.0

func _ready() -> void:
    var box_mesh: BoxMesh = BoxMesh.new()
    box_mesh.size = Vector3(2, 2, 2)

    var mat: StandardMaterial3D = StandardMaterial3D.new()
    mat.albedo_color = Color(0.2, 0.8, 0.2)
    box_mesh.material = mat

    var mm: MultiMesh = MultiMesh.new()
    mm.mesh = box_mesh
    mm.transform_format = MultiMesh.TRANSFORM_3D
    mm.instance_count = size * size
    self.multimesh = mm

    var noise: FastNoiseLite = FastNoiseLite.new()
    noise.seed = randi()
    noise.frequency = 0.05

    for x: int in range(size):
        for z: int in range(size):
            var index: int = x * size + z
            var y: float = noise.get_noise_2d(x, z) * height
            var pos: Vector3 = Vector3(x * scale_world, y, z * scale_world)
            var transform_3d: Transform3D = Transform3D(Basis(), pos)
            mm.set_instance_transform(index, transform_3d)

            var static_body: StaticBody3D = StaticBody3D.new()
            static_body.position = pos

            var collision_shape: CollisionShape3D = CollisionShape3D.new()
            var box_shape: BoxShape3D = BoxShape3D.new()
            box_shape.size = Vector3(2, 2, 2)

            collision_shape.shape = box_shape
            static_body.add_child(collision_shape)
            get_parent().call_deferred("add_child", static_body)
```

4. Ejecuta el juego, deberías ver un mundo 3D generado por procedimientos con cubos verdes que forman un terreno irregular.
5. Puedes caminar con `WASD`, saltar con espacio, mirar alrededor con el ratón y si presionas `Esc`, el juego se cierra.
