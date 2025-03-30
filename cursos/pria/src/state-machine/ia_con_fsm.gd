extends CharacterBody3D

# Enumeración para los estados del enemigo
enum EnemyState {
    PATROL,
    ATTACK,
    RETREAT,
    REST,
    GUARD
}

# Estado actual del enemigo
var current_state: EnemyState

func _ready() -> void:
    # Estado inicial
    current_state = EnemyState.PATROL

func _process(_delta: float) -> void:
    # Lógica de la máquina de estados
    match current_state:
        EnemyState.PATROL:
            _patrol()
        EnemyState.ATTACK:
            _attack()
        EnemyState.RETREAT:
            _retreat()
        EnemyState.REST:
            _rest()
        EnemyState.GUARD:
            _guard()

func _patrol() -> void:
    # Lógica para el estado de patrulla:
    # Implementa la lógica para hacer que el enemigo patrulle

    # Lógica de las diferentes transiciones:
    # Implementa las transiciones que existan hacia otros estados
    pass

func _attack() -> void:
    # Lógica para el estado de ataque:
    # Implementa la lógica para hacer que el enemigo ataque al jugador

    # Lógica de las diferentes transiciones:
    # Implementa las transiciones que existan hacia otros estados
    pass

func _retreat() -> void:
    # Lógica para el estado de retirada:
    # Implementa la lógica para hacer que el enemigo se aleje del jugador

    # Lógica de las diferentes transiciones:
    # Implementa las transiciones que existan hacia otros estados
    pass

func _rest() -> void:
    # Lógica para el estado de descanso:
    # Implementa la lógica para hacer que el enemigo descanse y recupere vida

    # Lógica de las diferentes transiciones:
    # Implementa las transiciones que existan hacia otros estados
    pass

func _guard() -> void:
    # Lógica para el estado de guardia:
    # Implementa la lógica para hacer que el enemigo esté en guardia

    # Lógica de las diferentes transiciones:
    # Implementa las transiciones que existan hacia otros estados
    pass
