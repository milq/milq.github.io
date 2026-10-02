# Tutorial para crear una escena 3D y transformar un cubo

En este tutorial crearás en Godot tu primera escena 3D, con cámara, sol, entorno y un plano, y trasladarás, rotarás y escalarás un cubo:

1. Abre Godot y crea un nuevo proyecto; asegúrate de que el _Renderer_ está configurado como `Forward+`.
1. Crea un nodo _Node3D_ (_3D Scene_) como nodo raíz de la escena principal (en _Create Root Node_).
1. Renombra la escena como _MainScene_ y guárdala (_Scene_ → _Save Scene_) como `main_scene.tscn`.
1. Domina a fondo los [controles][T01] de navegación del _viewport_ para orbitar y desplazarte por la escena 3D.
1. Agrega un nodo _Camera3D_ como hijo de _MainScene_ para poder visualizar la escena en 3D.
1. Añade a la escena 3D un [sol][T02] (_Add Sun to Scene_) y luego un [entorno][T03] (_Add environment to Scene_).
1. Haz clic en _Play Scene_ y [verifica][T04] que [ves][T05] un horizonte que separa el cielo azul claro del suelo marrón.
1. Agrega un nodo hijo en _MainScene_ de tipo _MeshInstance3D_ y renómbralo como _Plano_.
1. Recuerda que puedes seleccionar un nodo desde el _Scene Tree_ o con la herramienta [_Select_][T06] (tecla **Q**).
1. Selecciona _Plano_ y en el Inspector, asigna su propiedad _Mesh_ a [_PlaneMesh_][T07] para establecer un plano.
1. Selecciona _Plano_ y en el Inspector, en _Mesh_ pulsa en el plano y aumenta su [tamaño][T08] a 10x10 m.
1. Selecciona _Camera3D_ y en el Inspector, en _Transform_, cambia la propiedad de [posición][T09] de _y_ a 10 m.
1. Haz clic en _Play Scene_ y [verifica][T10] que se ve un plano en la zona inferior.
1. A continuación, agrega un nodo hijo en _MainScene_ de tipo _MeshInstance3D_ y renómbralo como _Cubo_.
1. Selecciona el nodo _Cubo_ y en el Inspector, asigna su propiedad _Mesh_ a _BoxMesh_ para crear el cubo.
1. Selecciona _Cubo_ y en el Inspector, cambia las propiedades de **_Transform_** a estos [valores][T11].
1. Haz clic en _Play Scene_ y [verifica][T12] que se ve un cubo encima del plano y proyectando una sombra.
1. Selecciona el nodo _Cubo_, pulsa la tecla **W** para utilizar la herramienta [_Move_][T06] y **trasladar** el cubo.
1. Traslada el cubo en los ejes X, Y o Z para mover el cubo en la dirección deseada dentro del _viewport_.
1. Selecciona el nodo _Cubo_, pulsa la tecla **E** para utilizar la herramienta [_Rotate_][T06] y **rotar** el cubo.
1. Rota el cubo en los ejes X, Y o Z para girar el cubo en la orientación deseada dentro del _viewport_.
1. Selecciona el nodo _Cubo_, pulsa la tecla **R** para utilizar la herramienta [_Scale_][T06] y **escalar** el cubo.
1. Escala el cubo en los ejes X, Y o Z para redimensionar el cubo al tamaño deseado dentro del _viewport_.
1. Experimenta con las propiedades de **_Transform_** y con las herramientas de transformación (**W**, **E** y **R**).

[T01]: https://github.com/milq/milq.github.io/blob/master/cursos/godot/tutorials/3d_viewport_navigation_controls.md
[T02]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/add_sun_to_scene.png
[T03]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/add_environment_to_scene.png
[T04]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/primera_escena_3d_1.png
[T05]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/primera_escena_3d_2.png
[T06]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/viewport_toolbar.png
[T07]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/primera_escena_3d_3.png
[T08]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/primera_escena_3d_4.png
[T09]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/primera_escena_3d_5.png
[T10]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/primera_escena_3d_6.png
[T11]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/primera_escena_3d_7.png
[T12]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/primera_escena_3d_8.png
