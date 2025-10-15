# CONDICIONALES EN PYTHON

# OPERADORES DE COMPARACIÓN

a = 5
b = 3

z = a == b   # Igual a                Resultado: False
z = a != b   # No igual a             Resultado: True
z = a > b    # Mayor que              Resultado: True
z = a >= b   # Mayor o igual a        Resultado: True
z = a < b    # Menor que              Resultado: False
z = a <= b   # Menor o igual a        Resultado: False

# Se pueden comparar dos cadenas también. Por ejemplo, verifica: 'Patricia' == 'Patricia' --> True
z = "Patricia" == "Patricia"  # True


# OPERADORES LÓGICOS

f = False
t = True

# Operador AND
z = f and f  # Resultado: False
z = f and t  # Resultado: False
z = t and f  # Resultado: False
z = t and t  # Resultado: True

# Operador OR
z = f or f   # Resultado: False
z = f or t   # Resultado: True
z = t or f   # Resultado: True
z = t or t   # Resultado: True

# Operador NOT
z = not f    # Resultado: True
z = not t    # Resultado: False

# COMBINACIÓN DE OPERADORES DE COMPARACIÓN Y LÓGICOS
z = not (a == b) or (a >= b and a != b)  # Resultado: True


# DECISIONES CON IF

entero = 7
edad = 30
calificacion = 9.5

mayor_que_cero = entero > 0  # Resultado: True

if mayor_que_cero:  # Sentencia if
    print("El número es positivo.")

if entero > 0:  # Sentencia if (alternativa más popular)
    print("El número es positivo.")

if edad >= 18:  # Sentencia if-else
    print("Eres mayor de edad.")
else:
    print("No eres mayor de edad.")

if calificacion < 5:  # Sentencia if-elif-else
    print("Suspenso.")
elif 5 <= calificacion < 7:
    print("Aprobado.")
elif 7 <= calificacion < 9:
    print("Notable.")
else:
    print("Excelente.")


# DECISIONES CON MATCH-CASE (equivalente al switch-case)

opcion = 3

match opcion:
    case 1:
        print("El número es 1.")
    case 2:
        print("El número es 2.")
    case 3:
        print("El número es 3.")
    case _:
        print("El número no es 1, 2 ni 3.")

fruta = "Manzana"

match fruta:
    case "Manzana":
        print("La fruta es 'Manzana'.")
    case "Plátano":
        print("La fruta es 'Plátano'.")
    case "Naranja":
        print("La fruta es 'Naranja'.")
    case _:
        print("No reconozco esa fruta.")


# EJEMPLO 1: Verificar si el año es bisiesto

year = 2000

if year % 4 == 0:
    if year % 100 == 0:
        if year % 400 == 0:
            print(f"{year} es un año bisiesto.")
        else:
            print(f"{year} no es un año bisiesto.")
    else:
        print(f"{year} es un año bisiesto.")
else:
    print(f"{year} no es un año bisiesto.")


# EJEMPLO 2: Convertidor de Fahrenheit a Celsius y viceversa

temperatura = "113.0F"

unidad = temperatura[-1]
valor = float(temperatura[:-1])

if unidad in ['C', 'c']:
    fahrenheit = (valor * 1.8) + 32
    print(f"{fahrenheit} ºF")
elif unidad in ['F', 'f']:
    celsius = (valor - 32) / 1.8
    print(f"{celsius} ºC")

# El operador 'in' se utiliza para comprobar si un elemento pertenece a
# una lista, tupla, cadena, etc. Devuelve True si el elemento se
# encuentra dentro de la colección y False en caso contrario.
# Ejemplo: if 'a' in ['a', 'b', 'c']:  --> True


# CONDICIONALES ESPECÍFICOS DE PYTHON

# Operador ternario
edad = 20
mensaje = "Mayor de edad" if edad >= 18 else "Menor de edad"
print(mensaje)

# Uso de any() y all()
valores = [False, True, False]

if any(valores):
    print("Al menos uno es True.")

if all(valores):
    print("Todos son True.")
else:
    print("No todos son True.")
