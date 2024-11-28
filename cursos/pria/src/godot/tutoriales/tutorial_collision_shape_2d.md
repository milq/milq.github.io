# Tutorial para experimentar con `CollisionShape2D` en Godot

En este tutorial aprenderás a trabajar con `CollisionShape2D` en Godot creando un proyecto donde Niblo recogerá manzanas para ganar puntos. Sigue los pasos cuidadosamente para completar el proyecto.

## Paso 1: Configura el proyecto

1. Abre Godot y selecciona _New Project_. Asigna un nombre al proyecto y elige una carpeta donde guardarlo.
2. Haz clic en _Scene_ y selecciona _New Scene_.
3. Añade un nodo _Node2D_ como nodo raíz seleccionando _2D Scene_.
4. Renombra el nodo raíz como _MainScene_ y guarda la escena seleccionando _Scene → Save Scene_. Nómbrala como `main_scene.tscn`.
5. Cambia el fondo del proyecto a negro. Ve a _Project → Project Settings → General → Rendering → Environment_ y selecciona un color negro.

## Paso 2: Crea el personaje _Niblo_

1. Crea una nueva escena haciendo clic en _Scene_ y seleccionando _New Scene_.
2. Añade un nodo _CharacterBody2D_ como nodo raíz desde _Other Node → CharacterBody2D_.
3. Renombra el nodo raíz como _Niblo_ y guarda la escena como `niblo.tscn`.
4. Descarga el _sprite_ de _Niblo_ desde [aquí](https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/niblo.png) y colócalo en la carpeta de recursos (`res://`) en _FileSystem_.
5. Añade un nodo hijo _Sprite2D_ al nodo _Niblo_ haciendo clic con el botón derecho sobre el nodo _Niblo_ y seleccionando _Add Child Node_.
6. Selecciona el nodo _Sprite2D_ y asigna el _sprite_ descargado como textura. Arrastra el archivo `niblo.png` al campo _Texture_ en el _Inspector_.
7. Añade un nodo hijo _CollisionShape2D_ al nodo _Niblo_.
8. Selecciona el nodo _CollisionShape2D_ y en el campo _Shape_ elige una forma, como _CircleShape2D_.
9. Ajusta el tamaño de la _CollisionShape2D_ para que se adapte al _sprite_ de _Niblo_.
10. Selecciona el nodo _Niblo_ y haz clic en _Attach Script_ para añadir un _script_.
11. Usa este [_script_](https://github.com/milq/milq.github.io/blob/master/cursos/godot/scripts/player_eight_direction.gd) para permitir que _Niblo_ se mueva.

## Paso 3: Crea la escena de la manzana

1. Crea una nueva escena y añade un nodo _Area2D_ como nodo raíz.
2. Renombra el nodo raíz como _Manzana_ y guarda la escena como `manzana.tscn`.
3. Descarga el _sprite_ de la manzana desde [aquí](https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/manzana.png) y colócalo en la carpeta de recursos (`res://`).
4. Añade un nodo hijo _Sprite2D_ al nodo _Manzana_.
5. Asigna el _sprite_ descargado como textura para el nodo _Sprite2D_.
6. Añade un nodo hijo _CollisionShape2D_ al nodo _Manzana_.
7. Selecciona el nodo _CollisionShape2D_ y elige una forma, como _CircleShape2D_.
8. Ajusta el tamaño de la _CollisionShape2D_ para que se adapte al _sprite_ de la manzana.
9. Selecciona el nodo _Manzana_ y haz clic en _Attach Script_ para añadir un _script_.
10. Usa este [_script_](https://github.com/milq/milq.github.io/blob/master/cursos/pria/src/godot/scripts/area_2d_manzana.gd) para que se agregue al grupo _Manzanas_ y que se elimine el nodo cuando detecta una colisión con _Niblo_.

## Paso 4: Instancia las escenas en la escena principal

1. Abre `main_scene.tscn` y haz clic derecho en el nodo raíz _MainScene_.
2. Selecciona _Instantiate Child Scene_ y elige `niblo.tscn`. Repite el proceso para instanciar `manzana.tscn`.
3. Coloca _Niblo_ en el centro de la pantalla.
4. Coloca la manzana en una posición visible.
5. Duplica la manzana haciendo clic derecho sobre el nodo _Manzana_ y seleccionando _Duplicate_. Coloca las copias en diferentes posiciones.
6. Crea un total de ocho manzanas distribuidas por la escena.

## Paso 5: Añade un marcador de puntos

1. Añade un nodo hijo _Label_ al nodo _MainScene_ y renómbralo como _Puntos_.
2. Ajusta la posición de _Puntos_ en la esquina superior izquierda.
3. Añade un texto inicial a la propiedad _Text_ en el _Inspector_, como "Puntos: 0".
4. Descarga y descomprime la fuente [Press Start 2P](https://fonts.google.com/specimen/Press+Start+2P).
5. Arrastra el archivo `.ttf` de la fuente descargada a la carpeta de recursos (`res://`) en _FileSystem_.
6. Selecciona el nodo _Puntos_ y arrastra el archivo `.ttf` a _&lt;empty&gt;_ en la propiedad *Control → Theme Overrides → Fonts → Font*.
7. Aumenta el tamaño de la fuente a 24 px en _Control → Theme Overrides → Font Sizes → Font Size_.

## Paso 6: Agrega lógica al proyecto

1. Selecciona el nodo _MainScene_ y haz clic en _Attach Script_ para añadir un _script_.
2. Usa este [_script_](https://github.com/milq/milq.github.io/blob/master/cursos/pria/src/godot/scripts/contador_manzanas.gd) para actualizar el marcador de puntos cuando _Niblo_ recoja manzanas.

## Paso 7: Prueba y experimenta

1. Ejecuta `main_scene.tscn` para comprobar que _Niblo_ puede moverse y recoger manzanas.
2. Experimenta añadiendo más manzanas, modificando su posición y ajustando el comportamiento de _Niblo_.
3. Explora el uso de otros nodos y formas para seguir aprendiendo sobre Godot.
