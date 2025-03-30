extends CharacterBody3D

@export var speed: float = 5.0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
    _actor_setup.call_deferred()

func _physics_process(delta: float) -> void:
    if navigation_agent.is_navigation_finished():
        return
    var direction: Vector3 = global_position.direction_to(
        navigation_agent.get_next_path_position())
    velocity = direction * speed
    move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_LEFT:
            var camera: Camera3D = get_parent().get_node("Camera3D")
            var mouse_pos: Vector2 = event.position
            var ray_from: Vector3 = camera.project_ray_origin(mouse_pos)
            var ray_to: Vector3 = ray_from + (
                camera.project_ray_normal(mouse_pos) * 1000.0)
            var nav_point: Vector3 = (
                NavigationServer3D.map_get_closest_point_to_segment(
                    get_world_3d().navigation_map, ray_from, ray_to))
            _set_movement_target(nav_point)

func _actor_setup() -> void:
    await get_tree().physics_frame

func _set_movement_target(movement_target: Vector3) -> void:
    navigation_agent.set_target_position(movement_target)
