# Tutorial: Crear un _tilemap_ en Godot dado un _tileset_

En este tutorial aprenderás a crear un _tilemap_ en Godot usando un _tileset_ ya proporcionado.

## Paso 1: Configurar el proyecto y descargar el _tileset_

1. **Descarga el _tileset_**:
   - Entra a [kenney.nl/assets/tiny-dungeon](https://kenney.nl/assets/tiny-dungeon) y descarga el _tileset_.
   - Extrae el archivo ZIP y busca la imagen `tilemap_packed.png` dentro de la carpeta `Tilemap`.

2. **Crea un proyecto nuevo en Godot**:
   - Abre Godot y crea un proyecto con una escena 2D (`Node2D`).
   - Dentro del proyecto, crea en `res://` una carpeta llamada `assets/` y copia allí el archivo `tilemap_packed.png`.

3. **Añade un nodo TileMapLayer**:
   - En la escena principal, presiona el botón `+` para añadir un nodo.
   - Busca y selecciona **TileMapLayer**.
   - Se habilitará la pestaña`TileMap` en la parte inferior de la pantalla.

## Paso 2: Crear el recurso _tileset_

1. **Crea un nuevo _tileset_ al nodo TileMapLayer**:
   - Selecciona el nodo _TileMapLayer_ y, en el *Inspector*, haz clic en **Tile Set > New TileSet**.
   - Se habilitará la pestaña `TileSet` en la parte inferior de la pantalla.

2. **Importa la imagen del _tileset_**:
   - Selecciona la pestaña de `Tileset` en la parte inferior de la pantalla.
   - A continuación, haz clic en el botón `+` y selecciona **Atlas**.
   - Selecciona el archivo `tilemap_packed.png` que está dentro de la carpeta `assets/`.
   - Cuando aparezca el mensaje _The atlas's texture was modified. Would you like to automatically create tiles in the atlas?_, haz clic en `Yes`. Esto permitirá que Godot detecte y cree automáticamente los _tiles_ en el _atlas_ basándose en la textura cargada (`tilemap_packed.png`).
   - Verifica que `Texture Region Size` esté a `16x16` (esta propiedad define el tamaño de cada _tile_ en píxeles, en este caso, 16x16 píxeles por _tile_), comprueba que `Margins` y `Separation` estén a `0x0` (`Margins` especifica el espacio vacío alrededor del borde de la imagen del _tileset_, y `Separation` indica el espacio entre los _tiles_ dentro del _tileset_; si no hay margen o separación, déjalos en `0x0`), y asegúrate de que `Use Texture Padding` esté en `On` (esta propiedad evita artefactos visuales en los bordes de los _tiles_ al renderizarse, añadiendo un pequeño relleno alrededor de cada _tile_).

## Paso 3: Pintar el mapa

1. **Selecciona el modo de pintura**:
   - Asegúrate de tener seleccionado el nodo _TileMapLayer_.
   - En el panel inferior (_TileMap_), elige el _tileset_ cargado y selecciona un _tile_.

2. **Dibuja el escenario**:
   - Usa la herramienta **Paint** (icono de pincel) para colocar tiles en el _viewport_.
   - Mantén `clic izquierdo` para pintar y `clic derecho` para borrar.
   - Usa la herramienta **Bucket** (icono de balde) para rellenar áreas grandes rápidamente.

3. **Prueba la capa base**:
   - Ejecuta la escena (`F5`) para verificar que los tiles se muestran correctamente.

## Paso 4: Añadir colisiones y detalles
1. **Activa colisiones para tiles sólidos**:
   - En el editor de _tileset_, selecciona tiles como paredes o rocas.
   - Ve a la pestaña **Physics Layers** y dibuja un polígono de colisión sobre el tile.

2. **Agrega capas adicionales**:
   - En el nodo TileMap, ve al *Inspector* y haz clic en **Layers > Add Layer** para crear capas como "Decoración" o "Objetos".
   - Selecciona una capa y pinta tiles que no bloqueen al jugador (ej: hierba o antorchas).

3. **Ordena las capas**:
   - Ajusta el **Z Index** en el *Inspector* para que las capas superiores (ej: techos) se dibujen encima del personaje.

## Paso 5: Optimizar y guardar
1. **Guarda el _tileset_**:
   - En el editor de _tileset_, haz clic en **Save** y guarda el recurso como `dungeon__tileset_.tres`.

2. **Reutiliza el _tileset_**:
   - Si creas otra escena, arrastra el archivo `dungeon__tileset_.tres` a la propiedad **_tileset_** de un nuevo nodo TileMap.

¡Listo! Ahora tienes un tilemap funcional con el estilo retro de Tiny Dungeon. Experimenta combinando tiles y capas para diseñar niveles más elaborados.
