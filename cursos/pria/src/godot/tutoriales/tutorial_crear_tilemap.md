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
   - A continuación, haz clic en el botón "+" y selecciona **Add Atlas**.
   - En la nueva sección que aparece, haz clic en **Texture > Load** y selecciona `tilemap_packed.png`.
   - Ajusta el **Atlas Grid Size** a `16x16` para que Godot detecte automáticamente cada tile.

4. **Configura los tiles necesarios**:
   - Selecciona un tile en la vista previa del atlas.
   - Si el tile debe tener colisión (ej: paredes), ve a la pestaña **Physics** y crea un *Physics Polygon* para definir su forma.

## Paso 3: Pintar el mapa
1. **Selecciona el modo de pintura**:
   - Asegúrate de tener seleccionado el nodo TileMap.
   - En el panel inferior (*TileMap*), elige el _tileset_ cargado y selecciona un tile de la lista.

2. **Dibuja el escenario**:
   - Usa la herramienta **Paint** (icono de pincel) para colocar tiles en la ventana 2D.
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
