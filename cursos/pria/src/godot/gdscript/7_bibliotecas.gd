# ------------------------------
# LIBRERÍAS INTERNAS EN GDSCRIPT
# ------------------------------

@tool
extends EditorScript

# A continuación se muestra el uso de algunas librerías internas de GDScript
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
    var exponencial: float = exp(x)      # e elevado a x
    var logaritmo: float = log(x)        # Logaritmo natural de x

    print("%f elevado a %f es %f" % [x, y, potencia])
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

    # ALEATORIEDAD
    print("\nALEATORIEDAD:")

    # Crea una nueva instancia del generador de números aleatorios
    var random = RandomNumberGenerator.new()

    # Inicializa el generador con una semilla basada en el tiempo actual
    random.randomize()

    # Número flotante aleatorio entre 0 y 1
    var numero_aleatorio: float = random.randf()
    print("\nNúmero aleatorio entre 0 y 1 → %f" % numero_aleatorio)

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

    # ESCRIBIR, LEER Y MOSTRAR ARCHIVOS DE TEXTO
    print("\nESCRIBIR, LEER Y MOSTRAR ARCHIVOS DE TEXTO:")

    var nombre_archivo: String = "texto.txt"
    var texto: String = "¡Hola, mundo!\n¡Esta es otra línea de texto!"

    # Escribir texto en un archivo nuevo o sobrescribir si existe
    var archivo = FileAccess.open(nombre_archivo, FileAccess.WRITE)
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
