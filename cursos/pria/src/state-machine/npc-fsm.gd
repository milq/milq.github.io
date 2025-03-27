extends CharacterBody2D

enum State { IDLE, PATROL, LOOK_AROUND }

@export var speed: float = 100.0
@export var idle_time: float = 1.0
@export var patrol_time: float = 3.0
@export var rotation_speed: float = 2.0
@export var edge_margin: float = 40.0

var state: State = State.IDLE
var current_direction: Vector2 = Vector2.ZERO
var timer: float = 0.0
var should_escape: bool = false

func _physics_process(delta):
    match state:
        State.IDLE: _handle_idle(delta)
        State.PATROL: _handle_patrol(delta)
        State.LOOK_AROUND: _handle_look(delta)
    move_and_slide()

func _handle_idle(delta):
    velocity = Vector2.ZERO
    timer += delta
    if timer >= idle_time:
        current_direction = _escape_dir() if should_escape else _rand_dir()
        state = State.PATROL
        timer = 0

func _handle_patrol(delta):
    velocity = current_direction * speed
    timer += delta

    if _near_edge():
        should_escape = true
        current_direction = _escape_dir()
        state = State.IDLE
        timer = 0
    elif timer > patrol_time:
        should_escape = false
        state = State.LOOK_AROUND
        timer = 0

func _handle_look(delta):
    velocity = Vector2.ZERO
    rotate(delta * rotation_speed)
    timer += delta
    if timer > 1.0:
        state = State.IDLE
        timer = 0

func _rand_dir() -> Vector2:
    return Vector2(randi_range(-1,1), randi_range(-1,1)).normalized()

func _near_edge() -> bool:
    var view_rect = get_viewport().get_visible_rect()
    return !view_rect.grow(-edge_margin).has_point(global_position)

func _escape_dir() -> Vector2:
    var view_center = get_viewport().get_visible_rect().get_center()
    return (view_center - global_position).normalized()
