# -----------------------
# BIBLIOTECAS EN GDSCRIPT
# -----------------------
# Una biblioteca o librería es un conjunto de funciones y clases ya escritas
# que tu programa usa sin saber cómo están hechas por dentro.

@tool
extends EditorScript

# TU PROPIA BIBLIOTECA
# Una clase con funciones estáticas ('static func') se usa sin crear objetos,
# con el nombre de la clase: Azar.probabilidad(25.0). En su propio archivo,
# como azar.gd, empezaría por 'class_name Azar' y se podría usar desde
# cualquier 'script' del proyecto.
class Azar:
    # Con 25, devuelve true una de cada cuatro veces
    static func probabilidad(porcentaje: float) -> bool:
        return randf() * 100.0 < porcentaje

    static func tirar_dado(caras: int) -> int:
        return randi_range(1, caras)

# A continuación se muestra el uso de algunas bibliotecas internas de GDScript
func _run() -> void:
    # MATEMÁTICAS
    print("MATEMÁTICAS:\n")

    # Variables de punto flotante
    var x: float = 5.0
    var y: float = 2.0
    var z: float = 7.5

    # Constantes matemáticas
    print("Constante π: ", PI)
    print("Constante τ: ", TAU)

    # Operaciones matemáticas
    var potencia: float = pow(x, y)      # x elevado a y
    var raiz: float = sqrt(x)            # Raíz cuadrada de x
    var exponencial: float = exp(x)      # e elevado a x
    var logaritmo: float = log(x)        # Logaritmo natural de x

    print("%f elevado a %f es %f" % [x, y, potencia])
    print("La raíz cuadrada de %f es %f" % [x, raiz])
    print("e elevado a %f es %f" % [x, exponencial])
    print("Logaritmo natural de %f es %f" % [x, logaritmo])

    # Valor absoluto
    var valor_absoluto: float = abs(-x)
    print("Valor absoluto de %f es %f" % [-x, valor_absoluto])

    # Redondeo
    var redondeo_al_entero_mas_cercano: float = round(z)
    var redondeo_hacia_abajo: float = floor(z)
    var redondeo_hacia_arriba: float = ceil(z)

    print("%f redondeado es %f" % [z, redondeo_al_entero_mas_cercano])
    print("El redondeo hacia abajo de %f es %f" % [z, redondeo_hacia_abajo])
    print("El redondeo hacia arriba de %f es %f" % [z, redondeo_hacia_arriba])

    # Funciones trigonométricas (ángulos en radianes)
    var seno: float = sin(x)
    var coseno: float = cos(x)
    var tangente: float = tan(x)
    var arco_tangente: float = atan(x)
    var arco_tangente2: float = atan2(y, x)

    print("Seno de %f es %f" % [x, seno])
    print("Coseno de %f es %f" % [x, coseno])
    print("Tangente de %f es %f" % [x, tangente])
    print("Arcotangente de %f es %f" % [x, arco_tangente])
    print("Arcotangente2 de (%f, %f) es %f" % [y, x, arco_tangente2])

    # Máximo y mínimo
    var maximo: float = max(x, y)
    var minimo: float = min(x, y)

    print("El máximo entre %f y %f es %f" % [x, y, maximo])
    print("El mínimo entre %f y %f es %f" % [x, y, minimo])
    print("El máximo de 3, 9 y 4 es ", max(3, 9, 4))  # Admiten varios valores

    # Limitar un valor entre un mínimo y un máximo
    print("12 limitado entre 0 y 10 es ", clamp(12, 0, 10))  # 10

    # Versiones con tipo, mejores con tipado estático: terminan en 'f' para
    # los reales y en 'i' para los enteros
    var absoluto_real: float = absf(-7.5)       # 7.5
    var absoluto_entero: int = absi(-7)         # 7
    var limitado: int = clampi(15, 0, 10)       # 10
    var redondeado: int = roundi(2.6)           # 3
    print(absoluto_real, " ", absoluto_entero, " ", limitado, " ", redondeado)

    # ALEATORIEDAD
    print("\nALEATORIEDAD:")

    # Crea una nueva instancia del generador de números aleatorios
    var random := RandomNumberGenerator.new()

    # Con una semilla fija, el generador repite siempre la misma secuencia:
    # así se puede repetir una partida o encontrar un error que depende del azar
    random.seed = 42
    var dado_1: int = random.randi_range(1, 6)
    var dado_2: int = random.randi_range(1, 6)
    print("\nCon la semilla 42, siempre salen %d y %d" % [dado_1, dado_2])

    # Inicializa el generador con una semilla al azar
    random.randomize()

    # Número flotante aleatorio entre 0 y 1
    var numero_aleatorio: float = random.randf()
    print("Número aleatorio entre 0 y 1 → %f" % numero_aleatorio)

    # Número entero aleatorio entre dos valores, ambos incluidos
    var min_val: int = -3
    var max_val: int = 10
    var entero_aleatorio: int = random.randi_range(min_val, max_val)
    print("Número entero aleatorio entre %d y %d → %d"
            % [min_val, max_val, entero_aleatorio])

    # Número flotante aleatorio entre dos valores, ambos incluidos
    var numero_aleatorio_flotante: float = random.randf_range(
            float(min_val), float(max_val))
    print("Número flotante aleatorio entre %f y %f → %f"
            % [min_val, max_val, numero_aleatorio_flotante])

    # Para el azar sencillo hay funciones globales, sin crear un generador
    print("randf() → %f" % randf())
    print("randi_range(1, 6) → %d" % randi_range(1, 6))
    print("randf_range(0.0, 100.0) → %f" % randf_range(0.0, 100.0))

    # Las funciones estáticas de Azar, la biblioteca propia del principio,
    # se llaman con el nombre de la clase
    print("¿Sale con un 25 por ciento? ", Azar.probabilidad(25.0))
    print("Dado de 20 caras → ", Azar.tirar_dado(20))

    # ESCRIBIR, LEER Y MOSTRAR ARCHIVOS DE TEXTO
    print("\nESCRIBIR, LEER Y MOSTRAR ARCHIVOS DE TEXTO:")

    # Las rutas empiezan por 'res://', la carpeta del proyecto, o por
    # 'user://', una carpeta propia de cada jugador (se abre con Project →
    # Open User Data Folder). Lo que cambia al jugar se guarda en 'user://'
    var nombre_archivo: String = "user://texto.txt"
    var texto: String = "¡Hola, mundo!\n¡Esta es otra línea de texto!"

    # Escribir texto en un archivo nuevo o sobrescribir si existe
    var archivo := FileAccess.open(nombre_archivo, FileAccess.WRITE)
    archivo.store_string(texto)
    archivo.close()

    var contenido: String = ""

    # Verificar si el archivo existe antes de leer
    if FileAccess.file_exists(nombre_archivo):
        archivo = FileAccess.open(nombre_archivo, FileAccess.READ)
        contenido = archivo.get_as_text()
        archivo.close()
    else:
        print("El archivo %s no existe." % nombre_archivo)

    print("\nContenido del archivo de texto:\n%s" % contenido)

    # Atajo: get_file_as_string() abre, lee y cierra el archivo de una vez
    print("\nOtra vez:\n", FileAccess.get_file_as_string(nombre_archivo))

    # GUARDAR Y LEER DATOS EN JSON
    print("\nGUARDAR Y LEER DATOS EN JSON:")

    # JSON es un formato de texto estándar. JSON.stringify() convierte un
    # diccionario en texto, y JSON.parse_string(), el texto en datos
    var partida: Dictionary = {
        "nombre": "Niblo",
        "nivel": 3,
        "inventario": ["espada", "poción"]
    }
    var ruta_partida: String = "user://partida.json"
    archivo = FileAccess.open(ruta_partida, FileAccess.WRITE)
    archivo.store_string(JSON.stringify(partida))
    archivo.close()

    var texto_leido: String = FileAccess.get_file_as_string(ruta_partida)
    var partida_leida: Dictionary = JSON.parse_string(texto_leido)
    print("Partida leída: ", partida_leida)
    # JSON no distingue enteros de reales: los números vuelven como float
    print("Nivel: ", partida_leida["nivel"])  # 3.0

# AUTOLOADS
# Un 'autoload' es un 'script' que hereda de Node y que Godot crea al arrancar
# el juego, antes que la escena principal, y mantiene aunque cambies de
# escena. Se registra en Project → Project Settings → Globals con un nombre,
# como Global, y cualquier 'script' lo usa por ese nombre: Global.puntos += 1.
# Sirve para los datos de toda la partida, como la puntuación o el récord.
