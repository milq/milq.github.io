extends Node2D

# Obtiene el nodo del Sprite2D llamado 'Niblo'
@onready var niblo: Sprite2D = get_node("Niblo")

# Obtiene el nodo del Sprite2D llamado 'Mubbit'
@onready var mubbit: Sprite2D = get_node("Mubbit")

func _process(delta: float) -> void:
    # Vector desde la posición de Niblo hasta la posición de Mubbit
    var niblo_a_mubbit: Vector2 = mubbit.position - niblo.position

    # Ángulo que forma el vector 'niblo_a_mubbit' con respecto a el eje x
    var angulo_radianes: float = niblo_a_mubbit.angle()

    # Convertimos el ángulo de radianes a grados y lo redondeamos
    var angulo: float = round(rad_to_deg(angulo_radianes))

    print("Posición de Niblo: ", round(niblo.position))
    print("Posición de Mubbit: ", round(mubbit.position))
    print("Ángulo del vector 'niblo_a_mubbit' sobre el eje x: %dº" % [angulo])
