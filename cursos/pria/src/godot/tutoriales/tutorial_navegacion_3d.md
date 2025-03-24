# Tutorial de Navegación 3D en Godot

En este tutorial aprenderás a configurar un sistema básico de navegación 3D utilizando `NavigationRegion3D` y `NavigationAgent3D`. Aprenderás a crear mallas de navegación y mover personajes de forma inteligente en entornos tridimensionales.

La navegación en 3D permite a los personajes moverse evitando obstáculos en entornos complejos. Godot ofrece un sistema robusto con:
- `NavigationRegion3D`: Define áreas navegables
- `NavigationMesh`: Genera superficies transitables
- `NavigationAgent3D`: Calcula rutas y controla el movimiento

## Paso 1: Configura la escena principal

1. Abre Godot y crea un nuevo proyecto. Asegúrate de configurar el _Renderer_ como `Forward+` en la configuración del proyecto.
2. Haz clic en _Scene_ y selecciona _New Scene_.
3. Crea un nodo _Node3D_ seleccionando _3D Scene_ como nodo raíz de la escena principal.
4. Renombra el nodo raíz como _MainScene_ y guarda la escena seleccionando _Scene → Save Scene_. Nómbrala como `main_scene.tscn`.
5. Recuerda los [controles de navegación del _viewport_][T01] para orbitar y desplazarte por la escena 3D.
6. Agrega un nodo _Camera3D_ como hijo de _MainScene_ para poder visualizar la escena.
7. Añade a la escena 3D un [sol][T02] (_Add Sun to Scene_) y luego un [entorno][T03] (_Add Environment to Scene_).
8. Haz clic en _Play Scene_ para verificar que la cámara muestra un horizonte donde el cielo azul claro se separa del suelo marrón.

[T01]: https://github.com/milq/milq.github.io/blob/master/cursos/godot/tutorials/3d_viewport_navigation_controls.md
[T02]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/add_sun_to_scene.png
[T03]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/add_environment_to_scene.png

## Paso 2: Configura la malla de navegación

1. Añade un nodo `NavigationRegion3D` como nodo hijo de _MainScene_.
2. Selecciona tu nodo `NavigationRegion3D`
3. En el Inspector, crea un nuevo `NavigationMesh` para este nodo:

![Navmesh Setup](https://docs.godotengine.org/en/stable/_images/nav_3d_min_setup_step1.png)

4. Añade un nodo `MeshInstance3D` como hijo del nodo `NavigationRegion3D`.
5. Selecciona el nodo `MeshInstance3D` y, en el Inspector, crea un nuevo `PlaneMesh` en el campo _Mesh_ como tipo de malla.
6. Selecciona dicha malla de tipo `PlaneMesh` y establece un tamaño de 10 m en el eje `x` y 10 m en el eje `y`.
7. Selecciona el nodo `NavigationRegion3D` y pulsa en el botón `Bake Navmesh` que está en la barra superior:

![Bake Navmesh](https://docs.godotengine.org/en/stable/_images/nav_3d_min_setup_step2.png)

8. Ahora verás una malla de navegación semitransparente que flota a cierta distancia por encima del `PlaneMesh`:

![Baked Navmesh](https://docs.godotengine.org/en/stable/_images/nav_3d_min_setup_step3.png)

9. Por último, selecciona el nodo `Camera3D` y muévelo y gíralo para que se vea el plano con cierta distancia.
10. Haz clic en _Play Scene_ para verificar que la cámara muestra dicho plano con cierta distancia.

## Paso 3: Configurar y mover el personaje

1. Añade un nodo `CharacterBody3D` como nodo hijo de _MainScene_.
2. Luego, añade a `CharacterBody3D` los siguientes nodos como hijos:
    - Un nodo `MeshInstance3D` con una nueva malla de cápsula (`CapsuleMesh`)
    - Un nodo `CollisionShape3D` con una forma (_shape_) de cápsula (`CapsuleShape3D`) que se ajuste a la malla creada anteriormente.
3. Selecciona el nodo `CharacterBody3D` y muévelo verticalmente en el eje `y` para que se sitúe encima del plano.
4. A continuación, agrega un nodo `NavigationAgent3D` como hijo de `CharacterBody3D`.
5. Selecciona el nodo `NavigationAgent3D` y, en el Inspector, ajusta el valor de `Path Height Offset` en la sección `Pathfinding` a `-0.5` m.
6. Por último, adjunta este _script_ al nodo `CharacterBody3D`:

```gdscript
extends CharacterBody3D

var movement_speed: float = 2.0
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
    # These values need to be adjusted for the actor's speed
    # and the navigation layout.
    navigation_agent.path_desired_distance = 0.5
    navigation_agent.target_desired_distance = 0.5

    # Make sure to not await during _ready.
    actor_setup.call_deferred()

func actor_setup():
    # Wait for the first physics frame so the NavigationServer can sync.
    await get_tree().physics_frame

    # Now that the navigation map is no longer empty, set the movement target.
    set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector3):
    navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
    if navigation_agent.is_navigation_finished():
        return

    var current_agent_position: Vector3 = global_position
    var next_path_position: Vector3 = navigation_agent.get_next_path_position()

    velocity = current_agent_position.direction_to(next_path_position) * movement_speed
    move_and_slide()
```

## Paso 4: Ejecución del proyecto

1. Ejecuta el proyecto y comprueba cómo el `CharacterBody3D` se mueve hasta la posición `movement_target_position`.
   - Prueba a mover manualmente el nodo de `CharacterBody3D` en el editor.
   - Cambia los valores de `movement_target_position` en el _script_ para ver cómo el personaje actualiza su ruta en tiempo de ejecución.

## Paso 5: Añadir movimiento mediante clic del ratón

1. Añade la siguiente función en el _script_ del nodo `CharacterBody3D`:

```gdscript
func _unhandled_input(event: InputEvent) -> void:
    var camera_3d: Camera3D = $"../Camera3D"
    var _cam_rotation := 0.0
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        # Get closest point on navmesh for the current mouse cursor position.
        var mouse_cursor_position: Vector2 = event.position
        var camera_ray_length := 1000.0
        var camera_ray_start := camera_3d.project_ray_origin(mouse_cursor_position)
        var ray_direction := camera_3d.project_ray_normal(mouse_cursor_position)
        var ray_scaled := ray_direction * camera_ray_length
        var camera_ray_end := camera_ray_start + ray_scaled

        var closest_point_on_navmesh := NavigationServer3D.map_get_closest_point_to_segment(
                get_world_3d().navigation_map,
                camera_ray_start,
                camera_ray_end
        )
        set_movement_target(closest_point_on_navmesh)

    elif event is InputEventMouseMotion:
        if event.button_mask & (MOUSE_BUTTON_MASK_MIDDLE + MOUSE_BUTTON_MASK_RIGHT):
            _cam_rotation += event.relative.x * 0.005
            $CameraBase.set_rotation(Vector3.UP * _cam_rotation)
```
2. Ejecuta el proyecto, haz clic en una posición del plano y verifica cómo el `CharacterBody3D` se desplaza hacia el punto seleccionado.

