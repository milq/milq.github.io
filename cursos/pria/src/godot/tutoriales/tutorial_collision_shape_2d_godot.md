# Tutorial para experimentar con `CollisionShape2D` en Godot

En este tutorial aprenderás a trabajar con `CollisionShape2D` en Godot creando un proyecto donde un personaje recogerá manzanas para ganar puntos. Sigue los pasos cuidadosamente para completar el proyecto.

## Paso 1: Configura el proyecto

1. Abre Godot y crea un nuevo proyecto.
2. Haz clic en *Scene* y selecciona *New Scene* para crear una nueva escena.
3. Añade un nodo raíz de tipo *Node2D* seleccionando *2D Scene*. Renombra este nodo como *MainScene*.
4. Guarda la escena como `main_scene.tscn` desde *Scene → Save Scene*.
5. Cambia el color de fondo a negro accediendo a *Project → Project Settings → General → Rendering → Environment* y configurándolo en negro.

## Paso 2: Crea el personaje principal

1. Crea una nueva escena haciendo clic en *Scene → New Scene*.
2. Añade un nodo raíz de tipo *CharacterBody2D* desde *Other Node*. Renómbralo como *Niblo*.
3. Guarda la escena como `niblo.tscn`.
4. Descarga el *sprite* de [Niblo](https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/niblo.png) y arrástralo a la carpeta de recursos en el panel *FileSystem*.
5. Añade un nodo hijo *Sprite2D* al nodo *Niblo*. Arrastra el *sprite* descargado al campo *Texture* en el panel *Inspector*.
6. Añade un nodo hijo de tipo *CollisionShape2D* al nodo *Niblo*.
7. Configura la propiedad *Shape* en el panel *Inspector*, seleccionando una forma como *CircleShape2D*. Ajusta su tamaño para que coincida con el *sprite* de *Niblo*.

## Paso 3: Crea las manzanas

1. Crea una nueva escena y añade un nodo raíz de tipo *Area2D*. Renómbralo como *Manzana*.
2. Guarda la escena como `manzana.tscn`.
3. Descarga el *sprite* de la [manzana](https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/manzana.png) y arrástralo a la carpeta de recursos.
4. Añade un nodo hijo *Sprite2D* al nodo *Manzana* y asigna el *sprite* descargado como textura.
5. Añade un nodo hijo de tipo *CollisionShape2D* al nodo *Manzana*. Configura la propiedad *Shape* con una forma como *CircleShape2D* y ajusta su tamaño al *sprite*.

## Paso 4: Integra las escenas

1. Abre la escena `main_scene.tscn`. Instancia las escenas `niblo.tscn` y `manzana.tscn` como nodos hijos del nodo raíz:
   - Haz clic derecho sobre el nodo *MainScene* y selecciona *Instantiate Child Scene...*.
   - Elige las escenas *niblo.tscn* y *manzana.tscn*, una por una.
2. Ajusta las posiciones de *Niblo* y *Manzana*. Coloca *Niblo* en el centro de la pantalla y posiciona *Manzana* en un lugar visible.
3. Duplica el nodo *Manzana* una vez haciendo clic derecho sobre él y seleccionando *Duplicate*. Coloca la copia en una posición distinta.
4. Repite el paso anterior para duplicar *Manzana* seis veces más, obteniendo un total de ocho nodos *Manzana*. Distribúyelos en diferentes lugares de la escena.

## Paso 5: Añade un sistema de puntuación

1. Añade un nodo hijo de tipo *Label* al nodo *MainScene*. Renómbralo como *Puntos* y colócalo en una esquina de la pantalla.
2. Descarga la fuente [Press Start 2P](https://fonts.google.com/specimen/Press+Start+2P) y arrástrala a la carpeta de recursos.
3. Selecciona el nodo *Puntos* y asigna la fuente desde *Control → Theme Overrides → Fonts → Font*.
4. Configura el tamaño de la fuente desde *Control → Theme Overrides → Font Sizes → Font Size*, ajustándolo a 24 px.

## Paso 6: Agrega scripts

1. Añade un script al nodo *Niblo*. Haz clic derecho sobre el nodo y selecciona *Attach Script...*. Usa este [script](https://github.com/milq/milq.github.io/blob/master/cursos/godot/scripts/player_eight_direction.gd) como base.
2. Añade un script al nodo *Manzana* desde *Attach Script...*. Usa este [script](https://github.com/milq/milq.github.io/blob/master/cursos/pria/src/godot/scripts/area_2d_manzana.gd).
3. Agrega un script al nodo raíz *MainScene*. Puedes usar este [script](https://github.com/milq/milq.github.io/blob/master/cursos/pria/src/godot/scripts/contador_manzanas.gd) como referencia.

## Paso 7: Ejecuta y experimenta

1. Ejecuta la escena *MainScene* para comprobar que *Niblo* puede moverse, recoger manzanas y acumular puntos.
2. Experimenta añadiendo nuevos tipos de nodos, personalizando las interacciones o creando código adicional.
