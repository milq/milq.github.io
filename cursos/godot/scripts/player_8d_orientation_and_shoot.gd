extends CharacterBody2D

# Clase que controla el comportamiento del jugador

# Celeridad de movimiento del jugador
const CELERIDAD: float = 300.0

# Escena de la bala que se usará para disparar
var EscenaBala: PackedScene

func _ready() -> void:
    # Esta función se llama cuando la escena está lista
    # Cargamos la escena de la bala desde el archivo 'res://bala.tscn'
    EscenaBala = load("res://bala.tscn")

# Esta función se llama en cada fotograma
func _physics_process(_delta: float) -> void:

    # Inicializamos el vector de entrada a cero
    var vector_entrada: Vector2 = Vector2.ZERO

    # Comprobamos si se está presionando alguna tecla de movimiento
    if Input.is_action_pressed("ui_left"):
        # Si se presiona izquierda, restamos 1 al eje X
        vector_entrada.x -= 1.0
    if Input.is_action_pressed("ui_right"):
        # Si se presiona derecha, sumamos 1 al eje X
        vector_entrada.x += 1.0
    if Input.is_action_pressed("ui_up"):
        # Si se presiona arriba, restamos 1 al eje Y
        vector_entrada.y -= 1.0
    if Input.is_action_pressed("ui_down"):
        # Si se presiona abajo, sumamos 1 al eje Y
        vector_entrada.y += 1.0

    # Normalizamos el vector para tener una celeridad constante
    vector_entrada = vector_entrada.normalized()

    # Velocidad del jugador multiplicando 'vector_entrada' por la celeridad
    velocity = vector_entrada * CELERIDAD

    # Si el jugador se está moviendo, actualizamos su rotación
    if vector_entrada != Vector2.ZERO:
        # Rotamos el jugador en la dirección del movimiento
        rotation = vector_entrada.angle()

    # Movemos al jugador
    move_and_slide()

    # Comprobamos si el jugador ha presionado el botón de disparar
    if Input.is_action_just_pressed("ui_accept"):
        # Llamamos a la función para disparar
        disparar()

func disparar() -> void:
    # Esta función crea una bala y la lanza desde el jugador

    # Distancia desde el centro del jugador hasta donde aparece la bala
    const DISTANCIA_DESPLAZAMIENTO: float = 32.0

    # Calculamos el desplazamiento basado en la rotación actual del jugador
    var desplazamiento_bala: Vector2 = Vector2(DISTANCIA_DESPLAZAMIENTO, 0.0)
    desplazamiento_bala = desplazamiento_bala.rotated(rotation)

    # Instanciamos la bala desde la escena cargada
    var bala: Area2D = EscenaBala.instantiate() as Area2D

    # Posicionamos la bala en el punto frente al jugador
    bala.position = position + desplazamiento_bala

    # Rotamos la bala para que siga la dirección del jugador
    bala.rotation = rotation

    # Añadimos la bala al nodo raíz para que aparezca en el juego
    get_tree().root.add_child(bala)
