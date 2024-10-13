# -------------------------
# CONDICIONALES EN GDSCRIPT
# -------------------------

@tool
extends EditorScript

func _run() -> void:

    # OPERADORES DE COMPARACIÓN

    var a: int = 5
    var b: int = 3

    var z: bool = a == b   # Igual a                 Resultado: false
    z = a != b             # No igual a              Resultado: true
    z = a > b              # Mayor que               Resultado: true
    z = a >= b             # Mayor o igual a         Resultado: true
    z = a < b              # Menor que               Resultado: false
    z = a <= b             # Menor o igual a         Resultado: false

    # Comparación de cadenas
    z = "Patricia" == "Patricia"  # Resultado: true

    # OPERADORES LÓGICOS

    var f: bool = false
    var t: bool = true

    # Operador AND
    z = f and f    # Resultado: false
    z = f and t    # Resultado: false
    z = t and f    # Resultado: false
    z = t and t    # Resultado: true

    # Operador OR
    z = f or f     # Resultado: false
    z = f or t     # Resultado: true
    z = t or f     # Resultado: true
    z = t or t     # Resultado: true

    # Operador NOT
    z = not f      # Resultado: true
    z = not t      # Resultado: false

    # COMBINACIÓN DE OPERADORES
    z = not (a == b) or (a >= b and a != b)    # Resultado: true

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

    var year: int = 2000

    if year % 4 == 0:
        if year % 100 == 0:
            if year % 400 == 0:
                print(str(year) + " es bisiesto.")
            else:
                print(str(year) + " no es bisiesto.")
        else:
            print(str(year) + " es bisiesto.")
    else:
        print(str(year) + " no es bisiesto.")

    # EJEMPLO 2: Convertidor de Fahrenheit a Celsius

    var temperatura: String = "113.0F"
    var unidad: String = temperatura[-1]
    var valor: float = float(temperatura.substr(0, temperatura.length() - 1))

    if unidad == "C" or unidad == "c":
        var fahrenheit: float = valor * 1.8 + 32
        print(str(fahrenheit) + " ºF.")
    elif unidad == "F" or unidad == "f":
        var celsius: float = (valor - 32) / 1.8
        print(str(celsius) + " ºC.")
