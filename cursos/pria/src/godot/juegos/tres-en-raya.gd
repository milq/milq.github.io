# ---------------------
# TRES EN RAYA (TIC-TAC-TOE) PARA DOS JUGADORES EN GDSCRIPT
# ---------------------
#
# Cómo usarlo (Godot 4):
# 1. Crea una escena nueva con un nodo 'Node2D' como raíz.
# 2. Adjunta este script al nodo.
# 3. Ejecuta la escena (F6).
#
# Controles:
# - Clic izquierdo: marcar una casilla.
# - Tecla R (o clic cuando la partida ha terminado): reiniciar.

extends Node2D

# CONSTANTES

const TAMANO_CASILLA: int = 150                  # Lado de cada casilla en píxeles
const MARGEN: Vector2 = Vector2(50, 100)         # Posición de la esquina del tablero

const VACIO: int = 0
const JUGADOR_X: int = 1
const JUGADOR_O: int = 2

# Todas las combinaciones de casillas que forman una línea ganadora.
# Las casillas se numeran así:
#  0 | 1 | 2
#  3 | 4 | 5
#  6 | 7 | 8
const LINEAS_GANADORAS: Array = [
	[0, 1, 2], [3, 4, 5], [6, 7, 8],   # Filas
	[0, 3, 6], [1, 4, 7], [2, 5, 8],   # Columnas
	[0, 4, 8], [2, 4, 6],              # Diagonales
]

# Colores
const COLOR_FONDO: Color = Color(0.12, 0.12, 0.15)
const COLOR_REJILLA: Color = Color(0.85, 0.85, 0.85)
const COLOR_X: Color = Color(0.95, 0.35, 0.35)
const COLOR_O: Color = Color(0.35, 0.65, 0.95)
const COLOR_LINEA_GANADORA: Color = Color(1.0, 0.85, 0.2)

# VARIABLES DEL ESTADO DE LA PARTIDA

var tablero: Array[int] = []           # 9 casillas: VACIO, JUGADOR_X o JUGADOR_O
var turno: int = JUGADOR_X             # Jugador al que le toca mover
var ganador: int = VACIO               # Jugador que ha ganado (VACIO si nadie)
var partida_terminada: bool = false    # true si hay ganador o empate
var linea_ganadora: Array = []         # Casillas de la línea ganadora


func _ready() -> void:
	reiniciar()


# Deja el tablero vacío y empieza una partida nueva
func reiniciar() -> void:
	tablero.clear()
	for i in range(9):
		tablero.append(VACIO)
	turno = JUGADOR_X
	ganador = VACIO
	partida_terminada = false
	linea_ganadora = []
	queue_redraw()   # Pide a Godot que vuelva a llamar a _draw()


# ENTRADA DEL USUARIO

func _unhandled_input(event: InputEvent) -> void:
	# Reiniciar con la tecla R
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		reiniciar()
		return

	# Clic izquierdo del ratón
	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		if partida_terminada:
			reiniciar()
			return

		var casilla: int = casilla_en_posicion(get_local_mouse_position())
		if casilla != -1:
			jugar(casilla)


# Devuelve el índice de la casilla (0-8) bajo una posición, o -1 si está fuera
func casilla_en_posicion(posicion: Vector2) -> int:
	var relativa: Vector2 = posicion - MARGEN
	var columna: int = int(relativa.x / TAMANO_CASILLA)
	var fila: int = int(relativa.y / TAMANO_CASILLA)

	if relativa.x < 0 or relativa.y < 0 or columna > 2 or fila > 2:
		return -1
	return fila * 3 + columna


# LÓGICA DEL JUEGO

func jugar(casilla: int) -> void:
	if tablero[casilla] != VACIO:
		return   # Casilla ocupada: no hacemos nada

	tablero[casilla] = turno

	ganador = comprobar_ganador()
	if ganador != VACIO or not tablero.has(VACIO):
		partida_terminada = true   # Hay ganador o el tablero está lleno (empate)
	else:
		# Cambiar de turno
		turno = JUGADOR_O if turno == JUGADOR_X else JUGADOR_X

	queue_redraw()


# Devuelve el jugador que tiene tres en raya, o VACIO si no hay ninguno
func comprobar_ganador() -> int:
	for linea in LINEAS_GANADORAS:
		var primera: int = tablero[linea[0]]
		if primera != VACIO and primera == tablero[linea[1]] \
				and primera == tablero[linea[2]]:
			linea_ganadora = linea
			return primera
	return VACIO


func nombre_jugador(jugador: int) -> String:
	return "X" if jugador == JUGADOR_X else "O"


func texto_estado() -> String:
	if ganador != VACIO:
		return "¡Gana %s! (clic o R para reiniciar)" % nombre_jugador(ganador)
	if partida_terminada:
		return "¡Empate! (clic o R para reiniciar)"
	return "Turno de: %s" % nombre_jugador(turno)


# DIBUJO

# Centro de una casilla en píxeles
func centro_casilla(casilla: int) -> Vector2:
	var columna: int = casilla % 3
	var fila: int = int(casilla / 3.0)
	return MARGEN + Vector2(columna + 0.5, fila + 0.5) * TAMANO_CASILLA


func _draw() -> void:
	var fuente: Font = ThemeDB.fallback_font
	var lado: float = TAMANO_CASILLA * 3
	var radio: float = TAMANO_CASILLA * 0.32

	# Fondo
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), COLOR_FONDO)

	# Texto de estado
	draw_string(fuente, Vector2(MARGEN.x, 60), texto_estado(),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color.WHITE)

	# Rejilla: dos líneas verticales y dos horizontales
	for i in range(1, 3):
		var d: float = i * TAMANO_CASILLA
		draw_line(MARGEN + Vector2(d, 0), MARGEN + Vector2(d, lado), COLOR_REJILLA, 6)
		draw_line(MARGEN + Vector2(0, d), MARGEN + Vector2(lado, d), COLOR_REJILLA, 6)

	# Fichas
	for i in range(9):
		var centro: Vector2 = centro_casilla(i)
		if tablero[i] == JUGADOR_X:
			draw_line(centro + Vector2(-radio, -radio), centro + Vector2(radio, radio), COLOR_X, 10)
			draw_line(centro + Vector2(radio, -radio), centro + Vector2(-radio, radio), COLOR_X, 10)
		elif tablero[i] == JUGADOR_O:
			draw_arc(centro, radio, 0, TAU, 48, COLOR_O, 10)

	# Línea que marca el tres en raya
	if ganador != VACIO:
		draw_line(centro_casilla(linea_ganadora[0]), centro_casilla(linea_ganadora[2]),
				COLOR_LINEA_GANADORA, 12)
