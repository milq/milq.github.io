# Tutorial para experimentar con la función seno y el ángulo entre vectores en Godot

1. Abre Godot y crea un nuevo proyecto; luego, haz clic en _Scene_ y selecciona _New Scene_.
2. Crea un nodo _Node2D_ (_2D Scene_) como nodo raíz de la escena (en _Create Root Node_).
3. Renombra la escena como _MainScene_ y guárdala (_Scene_ → _Save Scene_) como `main_scene.tscn`.
4. Pon el fondo negro con _Project → Project Settings → General → Rendering → Environment → Negro_.
5. Descarga el _sprite_ de [Niblo][T01] y arrástralo a la carpeta de recursos (`res://`) en _FileSystem_.
6. Añade un nodo hijo _Sprite2D_ (_Add Child Node..._) haciendo clic con el botón derecho a _MainScene_.
7. Selecciona _Sprite2D_ y asígnale una textura arrastrando _niblo.png_ al campo _Texture_ en el Inspector.
8. Renombra el _Sprite2D_ como Niblo haciendo clic con el botón derecho en dicho nodo (o con F2).
9. Agrega este [_script_][T02] haciendo clic derecho sobre el nodo _Niblo_ y seleccionando _Attach Script..._.
10. Descarga el _sprite_ de [Mubbit][T03] y arrástralo a la carpeta de recursos (`res://`) en _FileSystem_.
11. Arrastra _mubbit.png_ al _viewport_ y observa cómo se añade un _Sprite2D_ con el nombre adecuado.
12. Agrega este [_script_][T04] haciendo clic derecho sobre el nodo _Mubbit_ y seleccionando _Attach Script..._.
13. Agrega este [_script_][T05] haciendo clic derecho sobre el nodo _MainScene_ y seleccionando _Attach Script..._.
14. Haz clic en _Play_ para ejecutar el proyecto y mira cómo funciona el seno y el ángulo entre vectores.
15. Experimenta con el código, agrega nuevos nodos, crea nuevos _scripts_ y explora nuevas posibilidades.

[T01]: https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/niblo.png
[T02]: https://github.com/milq/milq.github.io/blob/master/cursos/pria/src/godot/scripts/jugador_movimiento_8d_sprite_2d.gd
[T03]: https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/mubbit.png
[T04]: https://github.com/milq/milq.github.io/blob/master/cursos/godot/scripts/movement_sine_wave_horizontal.gd
[T05]: https://github.com/milq/milq.github.io/blob/master/cursos/pria/src/godot/scripts/angulo_entre_nodos.gd
