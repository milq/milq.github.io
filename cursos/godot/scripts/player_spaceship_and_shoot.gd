extends CharacterBody2D

# Constantes
const ACELERACION: float = 200.0      # Aceleración al pulsar adelante
const VELOCIDAD_MAXIMA: float = 400.0 # Velocidad máxima del jugador
const ROTACION_VELOCIDAD: float = 3.0 # Velocidad de rotación
const FRICCION: float = 0.99          # Factor de fricción
const DISTANCIA_BALA: float = 32.0    # Desplazamiento de la bala desde jugador
const MARGEN_REAPARECER: float = 32.0 # Margen para el wrap-around

# Dirección base del 'sprite'. Se usa Vector2.UP porque el 'sprite'
# está orientado hacia el norte. Si estuviera orientado hacia la
# derecha, izquierda o abajo, usaríamos Vector2.RIGHT, LEFT o DOWN.
const ORIENTACION_SPRITE: Vector2 = Vector2.UP

# Escena de la bala que se usará para disparar
@export var EscenaBala: PackedScene

# Variable para almacenar la velocidad actual del jugador
var velocidad_actual: Vector2 = Vector2.ZERO

func _ready() -> void:
    # Se llama cuando la escena está lista
    # Cargamos la escena de la bala desde 'res://bala.tscn'
    EscenaBala = load("res://bala.tscn")

func _physics_process(delta: float) -> void:
    # Se llama en cada fotograma de física

    # Rotación del jugador
    if Input.is_action_pressed("ui_left"):
        # Giramos a la izquierda
        rotation -= ROTACION_VELOCIDAD * delta
    if Input.is_action_pressed("ui_right"):
        # Giramos a la derecha
        rotation += ROTACION_VELOCIDAD * delta

    # Aceleración del jugador
    if Input.is_action_pressed("ui_up"):
        # Aplicamos aceleración en la dirección actual
        var direccion: Vector2 = ORIENTACION_SPRITE.rotated(rotation)
        velocidad_actual += direccion * ACELERACION * delta
        # Limitamos la velocidad máxima
        if velocidad_actual.length() > VELOCIDAD_MAXIMA:
            velocidad_actual = velocidad_actual.normalized() * VELOCIDAD_MAXIMA

    # Movimiento del jugador
    position += velocidad_actual * delta

    # Simulamos fricción espacial
    velocidad_actual *= FRICCION  # Aplicamos el factor de fricción

    # Comprobamos si se ha presionado el botón de disparar
    if Input.is_action_just_pressed("ui_accept"):
        # Disparamos una bala
        disparar()

    # Envoltura de pantalla con margen para transición suave
    wrap_around_screen()

func disparar() -> void:
    # Crea una bala y la lanza desde el jugador con un desplazamiento

    # Instanciamos la bala desde la escena cargada
    var bala: Area2D = EscenaBala.instantiate() as Area2D

    # Calculamos el desplazamiento basado en la rotación actual
    var direccion: Vector2 = ORIENTACION_SPRITE.rotated(rotation)
    var offset: Vector2 = direccion * DISTANCIA_BALA

    # Posicionamos la bala con un pequeño desplazamiento desde el jugador
    bala.position = position + offset

    # Establecemos la rotación de la bala para que siga al jugador
    bala.rotation = rotation

    # Añadimos la bala al nodo raíz del árbol de escenas
    get_tree().root.add_child(bala)

func wrap_around_screen() -> void:
    # Hace que el jugador reaparezca suavemente al cruzar los límites

    # Obtenemos el tamaño de la pantalla
    var pantalla: Vector2 = get_viewport_rect().size

    # Reaparición horizontal con margen
    if position.x > pantalla.x + MARGEN_REAPARECER:
        position.x = -MARGEN_REAPARECER
    elif position.x < -MARGEN_REAPARECER:
        position.x = pantalla.x + MARGEN_REAPARECER

    # Reaparición vertical con margen
    if position.y > pantalla.y + MARGEN_REAPARECER:
        position.y = -MARGEN_REAPARECER
    elif position.y < -MARGEN_REAPARECER:
        position.y = pantalla.y + MARGEN_REAPARECER
