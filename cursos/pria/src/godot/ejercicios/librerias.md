## Librerías en GDScript

_Página creada por [Manuel Ignacio López Quintero][MILQ]. Todos los derechos reservados._

## Contenidos

1. [Librería][C01] (o biblioteca): [estándar][C02] o interna, de [terceros][C03] o externa y propia.
2. Funciones globales de [`@GlobalScope`][C04] y [`@GDScript`][C05]: matemáticas, redondeo, límites, etc.
3. Clases del motor: [`RandomNumberGenerator`][C06], [`FileAccess`][C07], [`JSON`][C08] y [`Time`][C09].
4. [Rutas][C10] `res://` (archivos del proyecto) y `user://` (datos del jugador, como las partidas).
5. Librerías propias: funciones [estáticas][C11] con [`class_name`][C12] o cargadas con [`preload()`][C13].
6. [_Autoloads_][C14]: _scripts_ o escenas globales que se cargan al iniciar y se usan desde cualquier sitio.
7. Librerías de terceros: [_Asset Library_][C15] (_addons_ en GDScript) y [GDExtension][C16] (C++, Rust, etc.).
8. Ejemplo comentado de librerías internas en GDScript: [código][C17].

## Ejercicios

Crea una escena _MainScene_ con un nodo [`Node2D`][C18], asígnale el _script_ `main.gd`, que empezará por `class_name Main extends Node2D`, y escribe en él todo lo que no pida otro archivo. Prueba cada actividad en [`_ready()`][C19] con `print()` y ejecuta la escena con _F6_:

1. **Matemáticas.** Calcula con [`atan2()`][C20] el ángulo que forman los vectores (5.45, 1.12) y (-3.86, 4.32), restando el ángulo de cada uno, y muéstralo en radianes y en grados con [`rad_to_deg()`][C21] (unos 2.097 rad o 120.17°). Comprueba el resultado con [`angle_to()`][C22].

<!-- -->

2. **Redondeo y límites.** Un golpe hace 12.7 de daño y un crítico lo multiplica por 1.35. Muestra el daño crítico con [`roundf()`][C23], [`floorf()`][C24] y [`ceilf()`][C25], limítalo entre 0 y 15 con [`clampf()`][C26] y redondéalo a una décima con [`snappedf()`][C27].

<!-- -->

3. **Aleatoriedad.** Con [`RandomNumberGenerator`][C06] y [`randi_range()`][C28], simula 10000 tiradas de 2D6 (dos dados de 6 caras que se suman), cuenta en un diccionario cuántas veces sale cada resultado del 2 al 12 y di cuál se repite más. Fija la [semilla][C29] con [`seed`][C30] y comprueba que dos ejecuciones dan lo mismo.

<!-- -->

4. **Botín.** Simula abrir 1000 cofres con [`rand_weighted()`][C31] (Godot 4.3 o superior), con botín común (70 %), raro (25 %) y legendario (5 %), y muestra cuántos salen de cada tipo. Después, baraja un mazo de 10 cartas con [`shuffle()`][C32] y roba una con [`pick_random()`][C33].

<!-- -->

5. **Archivos de texto.** Con [`FileAccess`][C07], guarda en `user://tiradas.txt` una línea por cada resultado de la actividad 3 (por ejemplo, "7: 1667"), léelo y muéstralo. Abre la carpeta con _Project_ → _Open User Data Folder_ y explica por qué se usa [`user://`][C10] y no `res://`.

<!-- -->

6. **JSON.** Crea un diccionario `partida` con `nombre`, `nivel`, `salud` e `inventario` (un _array_), conviértelo en texto con [`JSON.stringify()`][C34] y guárdalo en `user://partida.json`. Léelo con [`JSON.parse_string()`][C35], sube el nivel en 1 y vuelve a guardarlo. Comprueba que el cambio se conserva entre ejecuciones y fíjate en que los números vuelven como `float`.

<!-- -->

7. **Tiempo.** Añade a `partida` la fecha y hora del guardado con [`Time.get_datetime_string_from_system()`][C36]. Mide con [`Time.get_ticks_msec()`][C37] cuánto tarda en simular 1000000 de tiradas de 2D6 y compáralo con 10000.

<!-- -->

8. **Librería propia.** Crea `geometria.gd` con `class_name Geometria` y las funciones [estáticas][C11] `distancia(a, b)`, `punto_medio(a, b)` y `angulo_entre(a, b)`, que reciban `Vector2` (reutiliza la actividad 1). Úsalas desde `main.gd` sin crear objetos, como `Geometria.distancia(a, b)`, con 3 ejemplos de cada una.

<!-- -->

9. **`preload()`.** Crea `dados.gd` sin `class_name` y con una función estática `tirar(numero, caras)` que devuelva la suma de lanzar varios dados (por ejemplo, 3D8). Cárgalo en `main.gd` con `const Dados := preload("res://dados.gd")`, haz 3 tiradas y explica en qué se diferencia de usar `class_name`.

<!-- -->

10. **_Autoload_.** Crea `records.gd`, que herede de `Node`, con funciones para guardar y cargar un récord en `user://records.json`, y regístralo como [_autoload_][C14] con el nombre `Records` (_Project Settings_ → _Globals_). Descarga a [Niblo][C38] y a [Mubbit][C39] en `res://`, pon a Niblo en el centro y a Mubbit en una posición aleatoria dentro de [`get_viewport_rect()`][C40]. Mueve a Niblo con [`Input.get_vector()`][C41] y, cuando esté a menos de 32 píxeles de Mubbit según [`distance_to()`][C42], suma un punto y lleva a Mubbit a otra posición aleatoria. Muestra la puntuación y el récord con `print()`, guarda el récord con `Records` cada vez que lo superes y comprueba que se conserva al volver a ejecutar.

_Página creada por [Manuel Ignacio López Quintero][MILQ]. Todos los derechos reservados._

[C01]: https://en.wikipedia.org/wiki/Library_(computing)
[C02]: https://en.wikipedia.org/wiki/Standard_library
[C03]: https://en.wikipedia.org/wiki/Third-party_software_component
[C04]: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html
[C05]: https://docs.godotengine.org/en/stable/classes/class_%40gdscript.html
[C06]: https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html
[C07]: https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
[C08]: https://docs.godotengine.org/en/stable/classes/class_json.html
[C09]: https://docs.godotengine.org/en/stable/classes/class_time.html
[C10]: https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html
[C11]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#static-functions
[C12]: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#registering-named-classes
[C13]: https://docs.godotengine.org/en/stable/classes/class_%40gdscript.html#class-gdscript-method-preload
[C14]: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
[C15]: https://docs.godotengine.org/en/stable/community/asset_library/what_is_assetlib.html
[C16]: https://docs.godotengine.org/en/stable/engine_details/engine_api/gdextension/what_is_gdextension.html
[C17]: https://github.com/milq/milq.github.io/blob/master/cursos/pria/src/godot/gdscript/7_bibliotecas.gd
[C18]: https://docs.godotengine.org/en/stable/classes/class_node2d.html
[C19]: https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-private-method-ready
[C20]: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-method-atan2
[C21]: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-method-rad-to-deg
[C22]: https://docs.godotengine.org/en/stable/classes/class_vector2.html#class-vector2-method-angle-to
[C23]: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-method-roundf
[C24]: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-method-floorf
[C25]: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-method-ceilf
[C26]: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-method-clampf
[C27]: https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-method-snappedf
[C28]: https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html#class-randomnumbergenerator-method-randi-range
[C29]: https://en.wikipedia.org/wiki/Random_seed
[C30]: https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html#class-randomnumbergenerator-property-seed
[C31]: https://docs.godotengine.org/en/stable/classes/class_randomnumbergenerator.html#class-randomnumbergenerator-method-rand-weighted
[C32]: https://docs.godotengine.org/en/stable/classes/class_array.html#class-array-method-shuffle
[C33]: https://docs.godotengine.org/en/stable/classes/class_array.html#class-array-method-pick-random
[C34]: https://docs.godotengine.org/en/stable/classes/class_json.html#class-json-method-stringify
[C35]: https://docs.godotengine.org/en/stable/classes/class_json.html#class-json-method-parse-string
[C36]: https://docs.godotengine.org/en/stable/classes/class_time.html#class-time-method-get-datetime-string-from-system
[C37]: https://docs.godotengine.org/en/stable/classes/class_time.html#class-time-method-get-ticks-msec
[C38]: https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/niblo.png
[C39]: https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/mubbit.png
[C40]: https://docs.godotengine.org/en/stable/classes/class_canvasitem.html#class-canvasitem-method-get-viewport-rect
[C41]: https://docs.godotengine.org/en/stable/classes/class_input.html#class-input-method-get-vector
[C42]: https://docs.godotengine.org/en/stable/classes/class_vector2.html#class-vector2-method-distance-to

[MILQ]: https://milq.github.io
