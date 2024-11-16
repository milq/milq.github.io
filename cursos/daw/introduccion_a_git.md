# Introducción a Git

## ¿Qué es un **control de versiones**?

Un control de versiones es un sistema que te permite registrar los cambios realizados en un archivo o conjunto de archivos a lo largo del tiempo. Es útil para **rastrear modificaciones**, volver a versiones anteriores o colaborar sin perder el historial de los cambios.

## ¿Qué es un **sistema de control de versiones**?

Un sistema de control de versiones automatiza el seguimiento de cambios en archivos. Así, puedes trabajar en equipo sin preocuparte por perder información, ya que cada versión está registrada y accesible.

## ¿Qué es un **sistema de control de versiones distribuido**?

A diferencia de los sistemas centralizados, los sistemas distribuidos, como **Git**, permiten que cada usuario tenga una copia completa del historial del proyecto en su máquina. Esto elimina la dependencia de un servidor central para trabajar o guardar el historial.

## ¿Qué es **Git**?

**Git** es un sistema de control de versiones distribuido, rápido, flexible y ampliamente utilizado. Es ideal para gestionar proyectos de cualquier tamaño, desde pequeños trabajos personales hasta grandes proyectos colaborativos.

## ¿Cómo funciona Git?

Git opera en tres niveles principales:

1. **Workspace (Área de trabajo):** Aquí trabajas en los archivos de tu proyecto.
2. **Staging Area (Área de preparación):** Aquí preparas los cambios antes de confirmarlos (commit).
3. **Repository (Repositorio):** Aquí se almacenan los cambios confirmados y el historial completo.

## Diagrama básico del flujo de trabajo de Git:

1. Modifica archivos en el Workspace
2. Añade cambios al Staging Area con `git add .`
3. Confirma los cambios al Repository con `git commit`
4. Sincroniza con un repositorio remoto usando `git push` (si trabajas con uno)

## Instalación y configuración Git

1. Descarga Git desde su [página oficial](https://git-scm.com/).
2. Instálalo según las instrucciones de tu sistema operativo.
3. Verifica que está correctamente instalado ejecutando en la terminal:
   ```bash
   git --version
   ```
   Deberías ver la versión instalada.

4. Configura tu nombre de usuario y correo:
   ```bash
   git config --global user.name "Tu Nombre"
   git config --global user.email "tu.email@ejemplo.com"
   ```

## Práctica guiada con Git

### Paso 1: Crea un directorio de trabajo

1. Crea una carpeta y entra en ella:
   ```bash
   mkdir practica-git
   cd practica-git
   ```

2. Inicializa un repositorio Git en el directorio:
   ```bash
   git init
   ```
   Verás un mensaje confirmando la creación del repositorio.

### Paso 2: Añade un archivo al repositorio y confírmalo

1. Crea un archivo llamado `archivo.txt`:
   ```bash
   echo "Hola, este es mi primer archivo en Git" > archivo.txt
   ```

2. Verifica el estado del repositorio:
   ```bash
   git status
   ```
   Verás el archivo en rojo, lo que indica que no está rastreado.

3. Añade el archivo al área de preparación (staging):
   ```bash
   git add archivo.txt
   ```

4. Confirma los cambios con un mensaje de commit:
   ```bash
   git commit -m "Añadir archivo inicial"
   ```

### Paso 3: Modifica un archivo y confirma los cambios

1. Edita el archivo agregando una nueva línea:
   ```bash
   echo "Añadiendo más texto al archivo." >> archivo.txt
   ```

2. Verifica el estado del repositorio:
   ```bash
   git status
   ```
   Verás que el archivo está marcado como modificado.

3. Visualiza las diferencias entre el archivo actual y el último commit:
   ```bash
   git diff
   ```

4. Añade los cambios usando un comando global para todos los archivos modificados:
   ```bash
   git add .
   ```

5. Confirma los cambios:
   ```bash
   git commit -m "Actualizar contenido del archivo"
   ```

### Paso 4: Trabaja con ramas

1. Crea una nueva rama llamada `feature`:
   ```bash
   git branch feature
   ```

2. Cámbiate a la rama `feature`:
   ```bash
   git checkout feature
   ```

3. Edita el archivo en la nueva rama:
   ```bash
   echo "Este cambio está en la rama feature." >> archivo.txt
   ```

4. Añade y confirma los cambios:
   ```bash
   git add .
   git commit -m "Añadir línea en la rama feature"
   ```

5. Regresa a la rama principal (`main` o `master`):
   ```bash
   git checkout main
   ```

6. Combina los cambios de la rama `feature` en la rama principal:
   ```bash
   git merge feature
   ```

### Paso 5: Explora el historial de commits

1. Revisa el historial de commits:
   ```bash
   git log
   ```
   Usa las teclas de dirección para navegar y presiona `q` para salir.

2. Visualiza un historial más compacto:
   ```bash
   git log --oneline --graph
   ```

### Paso 6: Opcional - Elimina una rama

1. Elimina la rama `feature` después de fusionarla:
   ```bash
   git branch -d feature
   ```

## Tabla de comandos clave

| **Comando**               | **Descripción**                                                                                                                                   | **Ejemplo**                         |
|---------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| `git init`               | Inicializa un repositorio en la carpeta actual.                                                                                                 | `git init`                         |
| `git status`             | Muestra el estado actual del repositorio (archivos modificados o no rastreados).                                                                | `git status`                       |
| `git add [archivo]`      | Añade un archivo específico al área de preparación.                                                                                            | `git add archivo.txt`              |
| `git add .`              | Añade todos los archivos al área de preparación.                                                                                               | `git add .`                        |
| `git commit -m "mensaje"`| Confirma los cambios preparados con un mensaje descriptivo.                                                                                     | `git commit -m "Cambios iniciales"`|
| `git push`               | Sube los cambios confirmados al repositorio remoto.                                                                                            | `git push`                         |
| `git diff`               | Muestra las diferencias entre los archivos en el área de trabajo y los cambios confirmados.                                                    | `git diff`                         |
| `git branch [nombre]`    | Crea una nueva rama.                                                                                                                           | `git branch feature`               |
| `git checkout [nombre]`  | Cambia a una rama específica.                                                                                                                  | `git checkout main`                |
| `git merge [rama]`       | Combina los cambios de otra rama en la actual.                                                                                                 | `git merge feature`                |
| `git clone [ruta]`       | Clona un repositorio remoto.                                                                                                                   | `git clone https://url-repo.git`   |
