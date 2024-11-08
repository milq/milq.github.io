# Redondeo con decimales en Godot

En Godot, puedes redondear números de punto flotante a uno, dos o más decimales utilizando diferentes métodos.

Aquí se muestran dos opciones:

## 1. **Usando `round()` en combinación con multiplicación y división**

Este método usa la función `round()`:

```gdscript
var numero: float = 8.56839
var redondeado: float = round(numero * 100) / 100.0
```

Este código multiplica el número por 100, lo redondea al entero más cercano y luego divide por 100. Esto mantiene solo dos decimales.

## 2. **Usando el operador de formato de cadenas**

Para casos en los que quieras simplemente mostrar el número redondeado, puedes usar el operador de formato de cadenas:

```gdscript
var numero: float = 8.56839
var redondeado: String = "%.2f" % numero
```

Este método convierte el número en una cadena con dos decimales.

## ¿Cuál es el mejor?

- Si necesitas realizar cálculos con el número redondeado, el **método 1** (usando `round()`) es el más adecuado y flexible.
- Para presentar el número, **el método 2** es útil, especialmente si solo deseas mostrar el valor con dos decimales.

El método ideal depende del contexto y el uso específico en tu juego o aplicación.
