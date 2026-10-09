# -------------------------
# CONDICIONALES EN GDSCRIPT
# -------------------------

@tool
extends EditorScript

func _run() -> void:

    # OPERADORES DE COMPARACIÓN

    var a: int = 5
    var b: int = 3

    print("a == b: ", a == b)   # Igual a                 Resultado: false
    print("a != b: ", a != b)   # Distinto de             Resultado: true
    print("a > b: ", a > b)     # Mayor que               Resultado: true
    print("a >= b: ", a >= b)   # Mayor o igual que       Resultado: true
    print("a < b: ", a < b)     # Menor que               Resultado: false
    print("a <= b: ", a <= b)   # Menor o igual que       Resultado: false

    # Comparación de cadenas
    print("Patricia == Patricia: ", "Patricia" == "Patricia")  # true

    # OPERADORES LÓGICOS

    var f: bool = false
    var t: bool = true

    # Operador AND: true solo si los dos son true
    print("f and f: ", f and f)    # Resultado: false
    print("f and t: ", f and t)    # Resultado: false
    print("t and f: ", t and f)    # Resultado: false
    print("t and t: ", t and t)    # Resultado: true

    # Operador OR: true si al menos uno es true
    print("f or f: ", f or f)      # Resultado: false
    print("f or t: ", f or t)      # Resultado: true
    print("t or f: ", t or f)      # Resultado: true
    print("t or t: ", t or t)      # Resultado: true

    # Operador NOT: invierte el valor
    print("not f: ", not f)        # Resultado: true
    print("not t: ", not t)        # Resultado: false

    # 'and' y 'or' van en cortocircuito: si el primer operando ya decide el
    # resultado, el segundo no se evalúa. En 'f and t', 't' ni se mira.

    # COMBINACIÓN DE OPERADORES
    var z: bool = not (a == b) or (a >= b and a != b)
    print("Combinación: ", z)      # Resultado: true

    # CONDICIONALES

    var entero: int = 7
    var edad: int = 30
    var calificacion: float = 9.5

    var mayor_que_cero: bool = entero > 0

    if mayor_que_cero:
        print("El número es positivo.")

    if edad >= 18:
        print("Eres mayor de edad.")
    else:
        print("No eres mayor de edad.")

    if edad >= 18 and edad < 65:
        print("Adulto en edad laboral.")

    # Las condiciones se comprueban en orden y solo se ejecuta la primera que
    # se cumple: en el primer 'elif' ya se sabe que no es menor que 5.0
    if calificacion < 5.0:
        print("Suspenso.")
    elif calificacion < 7.0:
        print("Aprobado.")
    elif calificacion < 9.0:
        print("Notable.")
    else:
        print("Excelente.")

    # MATCH

    var opcion: int = 3

    match opcion:
        1:
            print("El número es 1.")
        2:
            print("El número es 2.")
        3:
            print("El número es 3.")
        _:
            print("Otro valor diferente a 1, 2 y 3.")

    var fruta: String = "Manzana"

    match fruta:
        "Manzana":
            print("Es una manzana.")
        "Plátano":
            print("Es un plátano.")
        "Naranja":
            print("Es una naranja.")
        _:
            print("Otro valor diferente a 'Manzana', 'Plátano' y 'Naranja'.")

    var letra: String = "a"

    match letra:
        "a", "e", "i", "o", "u":
            print("Es una vocal.")
        _:
            print("No es una vocal.")

    # OPERADOR TERNARIO

    var num_entero: int = 7
    var resultado: String = "Es par." if num_entero % 2 == 0 else "Es impar."
    print(resultado)

    # EJEMPLO 1: Verificar si el año es bisiesto

    var año: int = 2000

    if año % 4 == 0:
        if año % 100 == 0:
            if año % 400 == 0:
                print(str(año) + " es bisiesto.")
            else:
                print(str(año) + " no es bisiesto.")
        else:
            print(str(año) + " es bisiesto.")
    else:
        print(str(año) + " no es bisiesto.")

    # EJEMPLO 2: Convertidor de Fahrenheit a Celsius

    var temperatura: String = "113.0F"
    var unidad: String = temperatura[-1]   # El último carácter: "F"
    # substr(inicio, longitud) devuelve un trozo del texto: aquí, sin la unidad
    var valor: float = float(temperatura.substr(0, temperatura.length() - 1))

    if unidad == "C" or unidad == "c":
        var fahrenheit: float = valor * 1.8 + 32
        print(str(fahrenheit) + " °F.")
    elif unidad == "F" or unidad == "f":
        var celsius: float = (valor - 32) / 1.8
        print(str(celsius) + " °C.")
