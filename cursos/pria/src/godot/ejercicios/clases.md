# Clases en GDScript

_Página creada por [Manuel Ignacio López Quintero][MILQ]. Todos los derechos reservados._

**Contenidos**

1. [Clase][C01], [objeto][C02], [herencia][C03], [polimorfismo][C04], [sobrescritura][C05] de métodos y abstractos ([clases][C06] y [métodos][C07]).
2. GDScript: clases [internas][C08], [constructor][C09], [_setters_][C10] y [_getters_][C10], [herencia][C11], [sobrescritura][C11] y [abstractos][C12].
3. Clases con nombre global mediante [`class_name`][C13]; sin `extends`, heredan de [`RefCounted`][C14].
4. [Recursos][C15] propios con propiedades [exportadas][C16] para guardar los datos del juego.
5. El _script_ de un nodo es una clase que hereda de su tipo (por ejemplo: `extends` [`Sprite2D`][C17]).
6. En un _script_ de un nodo se suelen [sobrescribir][C18] funciones del motor como [`_ready()`][C19] y [`_process()`][C20].
7. Ejemplo comentado de clases en GDScript: [código][C21].

**Actividades de iniciación**

Haz todas las actividades en un único archivo. Crea una escena _MainScene_ con un nodo [`Node2D`][C22], asígnale el _script_ `main.gd`, que empezará por `class_name Main extends Node2D`, y escribe cada clase como clase [interna][C08]. Prueba cada actividad en [`_ready()`][C19] con `print()` y ejecuta la escena con _F6_:

1. **Clase y objeto.** Crea una clase `Arma` con las propiedades `nombre` y `daño`, un [constructor][C09] y un método `describir()` que devuelva un texto como "Espada: 8 de daño". Crea 3 objetos (una espada, un arco y una varita) y muestra su descripción.

<!-- -->

2. **_Setters_ y _getters_.** Crea una clase `Heroe` con `nombre` y `salud`, cuyo [_setter_][C10] la limite entre 0 y 100 con [`clampi()`][C23]. Añade una propiedad `esta_vivo` con un _getter_ que devuelva `salud > 0` y los métodos `recibir_daño()` y `curar()`. Comprueba que la salud nunca baja de 0 ni pasa de 100.

<!-- -->

3. **Herencia.** Crea una clase `Enemigo` con `nombre`, `salud`, un constructor y un método `atacar()` que devuelva 1. Crea la clase `Slime`, que [herede][C11] de `Enemigo` y llame a su constructor con `super()`. Crea un _slime_ y comprueba que ataca sin haber escrito `atacar()` en `Slime`.

<!-- -->

4. **Sobrescritura.** Crea la clase `Esqueleto`, que herede de `Enemigo` y [sobrescriba][C11] `atacar()` para devolver 5. Crea un esqueleto y un _slime_ y compara el daño que hace cada uno.

<!-- -->

5. **`super` e `is`.** Crea la clase `Jefe`, que herede de `Esqueleto` y cuyo `atacar()` devuelva el doble que el de su padre usando `super.atacar()`. Comprueba con el operador [`is`][C24] que un `Jefe` también es un `Esqueleto` y un `Enemigo`.

<!-- -->

6. **Polimorfismo.** Guarda un _slime_, un esqueleto y un jefe en un [_array_ tipado][C25] `Array[Enemigo]`, recórrelo llamando a `atacar()` y muestra el daño total: el mismo método hace algo distinto en cada enemigo.

<!-- -->

7. **Abstractos.** Marca la clase `Enemigo` y su método `atacar()` con [`@abstract`][C12] (Godot 4.5 o superior) y corrige los errores que aparezcan. Intenta crear un enemigo con `Enemigo.new()` y explica por qué Godot no te deja.

<!-- -->

8. **Recursos.** Crea una clase `Estadisticas` que herede de [`Resource`][C26], con `velocidad` y `ataque`, y añade a `Enemigo` una propiedad `estadisticas`. Haz que dos enemigos compartan el mismo objeto `Estadisticas`, cambia su velocidad una sola vez y comprueba que cambia en los dos.

<!-- -->

9. **El _script_ es una clase.** Descarga a [Niblo][C27] y a [Mubbit][C28] en `res://`. En `_ready()`, crea un [`Sprite2D`][C17] con la textura de Niblo usando [`load()`][C29], guárdalo en una propiedad `niblo` de `Main` y añádelo a la escena con [`add_child()`][C30]. Añade a `Main` la propiedad [`@export`][C16] `var velocidad: float = 200.0` y sobrescribe [`_process()`][C20] para mover a Niblo con [`Input.get_vector()`][C31] y las flechas del teclado. Sobrescribe también [`_unhandled_input()`][C32] para que la tecla R reinicie la escena con [`reload_current_scene()`][C33]. Cambia la velocidad desde el _Inspector_.

<!-- -->

10. **Nodos propios.** Crea la clase `Perseguidor`, que herede de `Sprite2D`, con las propiedades `objetivo` y `velocidad` y un método `mover(delta)` que avance hacia él con [`move_toward()`][C34], y sobrescribe su `_process()` para que llame a `mover()`. Después, crea la clase `Zigzag`, que herede de `Perseguidor` y sobrescriba `mover()` sumando un desplazamiento lateral con [`sin()`][C35]. Añade a la escena 2 perseguidores y 1 zigzag con la textura de Mubbit, a Niblo como objetivo y velocidades distintas para que no se solapen.

_Página creada por [Manuel Ignacio López Quintero][MILQ]. Todos los derechos reservados._

[C01]: https://en.wikipedia.org/wiki/Class_(computer_programming)
[C02]: https://en.wikipedia.org/wiki/Object_(computer_science)
[C03]: https://en.wikipedia.org/wiki/Inheritance_(object-oriented_programming)
[C04]: https://en.wikipedia.org/wiki/Polymorphism_(computer_science)
[C05]: https://en.wikipedia.org/wiki/Method_overriding
[C06]: https://en.wikipedia.org/wiki/Abstract_type
[C07]: https://en.wikipedia.org/wiki/Method_(computer_programming)#Abstract_methods
[C08]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#inner-classes
[C09]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#class-constructor
[C10]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#properties-setters-and-getters
[C11]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#inheritance
[C12]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#abstract-classes-and-methods
[C13]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#registering-named-classes
[C14]: https://docs.godotengine.org/en/stable/classes/class_refcounted.html
[C15]: https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
[C16]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
[C17]: https://docs.godotengine.org/en/stable/classes/class_sprite2d.html
[C18]: https://docs.godotengine.org/en/stable/tutorials/scripting/overridable_functions.html
[C19]: https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-private-method-ready
[C20]: https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-private-method-process
[C21]: https://github.com/milq/milq.github.io/blob/master/cursos/pria/src/godot/gdscript/6_clases.gd
[C22]: https://docs.godotengine.org/en/stable/classes/class_node2d.html
[C23]: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-method-clampi
[C24]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#operators
[C25]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#typed-arrays
[C26]: https://docs.godotengine.org/en/stable/classes/class_resource.html
[C27]: https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/niblo.png
[C28]: https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/mubbit.png
[C29]: https://docs.godotengine.org/en/stable/classes/class_%40gdscript.html#class-gdscript-method-load
[C30]: https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-add-child
[C31]: https://docs.godotengine.org/en/stable/classes/class_input.html#class-input-method-get-vector
[C32]: https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-private-method-unhandled-input
[C33]: https://docs.godotengine.org/en/stable/classes/class_scenetree.html#class-scenetree-method-reload-current-scene
[C34]: https://docs.godotengine.org/en/stable/classes/class_vector2.html#class-vector2-method-move-toward
[C35]: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-method-sin

[MILQ]: https://milq.github.io
