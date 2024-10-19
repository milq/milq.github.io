extends Sprite2D

"""
Tipos de función Ease:
raw.githubusercontent.com/godotengine/godot-docs/master/img/ease_cheatsheet.png
"""

# Tipo de función de interpolación Ease
const TIPO_FUNCION_EASE: float = -3.5

# Velocidad de la animación (cuanto más alta, más rápida)
const VELOCIDAD: float = 0.5

# Posición inicial del nodo en pantalla
var posicion_inicial: Vector2 = Vector2(200, 300)

# Posición final del nodo en pantalla
var posicion_final: Vector2 = Vector2(900, 300)

# Progreso de la interpolación, varía de 0.0 a 1.0
var progreso_interpolacion: float = 0.0

func _ready() -> void:
    # Establece la posición inicial cuando el nodo está listo
    position = posicion_inicial

func _process(delta: float) -> void:
    # Incrementa el progreso de la interpolación según la velocidad y delta
    progreso_interpolacion = progreso_interpolacion + VELOCIDAD * delta

    # Reinicia el progreso si supera el valor máximo de 1.0
    if progreso_interpolacion > 1.0:
        progreso_interpolacion = 0.0

    # Aplica la función Ease al progreso de la interpolación
    var valor_ease: float = ease(progreso_interpolacion, TIPO_FUNCION_EASE)

    # Interpola la posición del sprite entre inicial y final usando Ease
    position = lerp(posicion_inicial, posicion_final, valor_ease)
