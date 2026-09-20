# Tutorial para realizar un movimiento básico de un _sprite_ con Vector2

1. Abre Godot y crea un nuevo proyecto; luego, haz clic en _Scene_ y selecciona _New Scene_.
1. Crea un nodo _Node2D_ (_2D Scene_) como nodo raíz de la escena (en _Create Root Node_).
1. Renombra la escena como _MainScene_ y guárdala (_Scene_ → _Save Scene_) como `main_scene.tscn`.
1. Pon el fondo negro con _Project → Project Settings → General → Rendering → Environment → Negro_.
1. Descarga el _sprite_ de [Niblo][A01] y arrástralo a la carpeta de recursos (`res://`) en _FileSystem_.
1. Añade un nodo hijo _Sprite2D_ (_Add Child Node..._) haciendo clic con el botón derecho a _MainScene_.
1. Selecciona _Sprite2D_ y asígnale una textura arrastrando _niblo.png_ al campo _Texture_ en el Inspector.
1. Renombra el _Sprite2D_ como _Niblo_ haciendo clic con el botón derecho en dicho nodo (o con F2).
1. Desde la [barra][A02] de herramientas del _viewport_, pulsa en _select_ (o tecla **Q**) y selecciona el nodo _Niblo_.
1. Luego, en dicha [barra][A02] pulsa en _Move_ (o tecla **W**) y mueve a _Niblo_ a la izquierda, centrado en vertical.
1. Otra opción es ir al Inspector y, en la propiedad _Position_ de _Transform_ de _Niblo_, cambiar sus valores.
1. Agrega este [_script_][A03] con clic derecho sobre el nodo _Niblo_ en el _Scene Tree_ y pulsando en _Attach Script..._.
1. Guarda el _script_ y regresa a la escena principal; haz clic en _Play_ para ejecutar el proyecto.
1. Observa cómo el _sprite_ se mueve horizontalmente; esto verifica una funcionalidad básica de [`Vector2`][A04].
1. Modifica la variable `direccion` a `Vector2(0, 100)` en el _script_ para cambiar la dirección vertical.
1. Guarda los cambios y ejecuta nuevamente; el _sprite_ ahora debería moverse hacia abajo.
1. Modifica la variable `direccion` a `Vector2(100, 100)` en el _script_ para cambiar la dirección.
1. Guarda y ejecuta; verifica que el _sprite_ se desplaza diagonalmente según los nuevos cálculos.
1. Multiplica el vector por un escalar actualizando la posición a `position = position + movimiento * 2`.
1. Observa cómo la velocidad de movimiento del _sprite_ se ha duplicado respecto a la anterior.
1. Intenta mover el _sprite_ en las ocho direcciones y experimenta con otros métodos de [`Vector2`][A04].
1. Experimenta con el código, agrega nuevos nodos, crea nuevos _scripts_ y explora nuevas posibilidades.

[A01]: https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/niblo.png
[A02]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/viewport_toolbar.png
[A03]: https://github.com/milq/milq.github.io/blob/master/cursos/pria/src/godot/scripts/movimiento_2d.gd
[A04]: https://docs.godotengine.org/en/stable/classes/class_vector2.html
