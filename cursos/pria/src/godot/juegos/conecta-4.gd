# ---------------------
# CONECTA 4 PARA DOS JUGADORES EN GDSCRIPT
# ---------------------
#
# Cómo usarlo (Godot 4):
# 1. Crea una escena nueva con un nodo 'Node2D' como raíz.
# 2. Adjunta este script al nodo.
# 3. Ejecuta la escena (F6).
#
# Controles:
# - Clic izquierdo sobre una columna: soltar una ficha en ella.
# - Tecla R (o clic cuando la partida ha terminado): reiniciar.

extends Node2D

# CONSTANTES

const COLUMNAS: int = 7
const FILAS: int = 6
const TAMANO_CASILLA: int = 80                   # Lado de cada casilla en píxeles
const MARGEN: Vector2 = Vector2(50, 100)         # Posición de la esquina del tablero

const VACIO: int = 0
const ROJO: int = 1
const AMARILLO: int = 2

# Direcciones en las que se puede formar una línea:
# horizontal, vertical y las dos diagonales
const DIRECCIONES: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, -1),
]

# Colores
const COLOR_FONDO: Color = Color(0.12, 0.12, 0.15)
const COLOR_TABLERO: Color = Color(0.15, 0.3, 0.75)
const COLOR_ROJO: Color = Color(0.95, 0.3, 0.3)
const COLOR_AMARILLO: Color = Color(1.0, 0.85, 0.2)

# VARIABLES DEL ESTADO DE LA PARTIDA

# Casillas del tablero guardadas en un array de FILAS * COLUMNAS elementos.
# La casilla (columna, fila) está en el índice fila * COLUMNAS + columna.
# La fila 0 es la de arriba.
var tablero: Array[int] = []
var turno: int = ROJO                     # Jugador al que le toca mover
var ganador: int = VACIO                  # Jugador que ha ganado (VACIO si nadie)
var partida_terminada: bool = false       # true si hay ganador o empate
var fichas_ganadoras: Array[Vector2i] = []  # Casillas de la línea ganadora


func _ready() -> void:
	reiniciar()


# Deja el tablero vacío y empieza una partida nueva
func reiniciar() -> void:
	tablero.clear()
	for i in range(FILAS * COLUMNAS):
		tablero.append(VACIO)
	turno = ROJO
	ganador = VACIO
	partida_terminada = false
	fichas_ganadoras.clear()
	queue_redraw()   # Pide a Godot que vuelva a llamar a _draw()


# Devuelve el contenido de una casilla, o -1 si está fuera del tablero
func obtener(pos: Vector2i) -> int:
	if pos.x < 0 or pos.x >= COLUMNAS or pos.y < 0 or pos.y >= FILAS:
		return -1
	return tablero[pos.y * COLUMNAS + pos.x]


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

		# Solo nos importa la columna: la ficha "cae" hasta abajo
		var x: float = get_local_mouse_position().x - MARGEN.x
		if x >= 0 and x < COLUMNAS * TAMANO_CASILLA:
			jugar(int(x / TAMANO_CASILLA))


# LÓGICA DEL JUEGO

func jugar(columna: int) -> void:
	# Buscamos la primera casilla vacía empezando por abajo
	for fila in range(FILAS - 1, -1, -1):
		var pos := Vector2i(columna, fila)
		if obtener(pos) == VACIO:
			tablero[fila * COLUMNAS + columna] = turno

			if hay_cuatro_en_linea(pos):
				ganador = turno
				partida_terminada = true
			elif not tablero.has(VACIO):
				partida_terminada = true   # Tablero lleno: empate
			else:
				turno = AMARILLO if turno == ROJO else ROJO

			queue_redraw()
			return
	# Si llegamos aquí, la columna estaba llena y no se hace nada


# Comprueba si la ficha recién colocada en 'origen' forma cuatro en línea.
# Para cada dirección contamos las fichas iguales hacia un lado y hacia el otro.
func hay_cuatro_en_linea(origen: Vector2i) -> bool:
	for direccion in DIRECCIONES:
		var linea: Array[Vector2i] = [origen]
		for sentido in [1, -1]:
			var pos: Vector2i = origen + direccion * sentido
			while obtener(pos) == turno:
				linea.append(pos)
				pos += direccion * sentido
		if linea.size() >= 4:
			fichas_ganadoras = linea
			return true
	return false


func nombre_jugador(jugador: int) -> String:
	return "Rojo" if jugador == ROJO else "Amarillo"


func texto_estado() -> String:
	if ganador != VACIO:
		return "¡Gana %s! (clic o R para reiniciar)" % nombre_jugador(ganador)
	if partida_terminada:
		return "¡Empate! (clic o R para reiniciar)"
	return "Turno de: %s" % nombre_jugador(turno)


# DIBUJO

# Centro de una casilla en píxeles
func centro_casilla(pos: Vector2i) -> Vector2:
	return MARGEN + (Vector2(pos) + Vector2(0.5, 0.5)) * TAMANO_CASILLA


func _draw() -> void:
	var fuente: Font = ThemeDB.fallback_font
	var radio: float = TAMANO_CASILLA * 0.4

	# Fondo
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), COLOR_FONDO)

	# Texto de estado, con el color del jugador al que le toca
	var color_texto: Color = COLOR_ROJO if turno == ROJO else COLOR_AMARILLO
	draw_string(fuente, Vector2(MARGEN.x, 60), texto_estado(),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 28, color_texto)

	# Tablero azul
	var tamano_tablero := Vector2(COLUMNAS, FILAS) * TAMANO_CASILLA
	draw_rect(Rect2(MARGEN, tamano_tablero), COLOR_TABLERO)

	# Agujeros y fichas
	for fila in range(FILAS):
		for columna in range(COLUMNAS):
			var pos := Vector2i(columna, fila)
			var color: Color = COLOR_FONDO
			if obtener(pos) == ROJO:
				color = COLOR_ROJO
			elif obtener(pos) == AMARILLO:
				color = COLOR_AMARILLO
			draw_circle(centro_casilla(pos), radio, color)

	# Resaltar las fichas ganadoras con un anillo blanco
	for pos in fichas_ganadoras:
		draw_arc(centro_casilla(pos), radio, 0, TAU, 48, Color.WHITE, 6)
