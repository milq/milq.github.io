using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransformQuaternion : MonoBehaviour
{
    void Start()
    {

    }

    void Update()
    {
        /*

        Ejercicio 1. Crea en Unity un proyecto 2D, crea este sprite, asígnale este script y explica la clase Transform.

        [...]

        Ejercicio 2. Explica qué es traslación, rotación y escalado y por qué es tan importante en los videojuegos.

        [...]

        Ejercicio 3. Describe ángulos de Euler y el problema del bloqueo del cardán cuando se usan ángulos de Euler.

        [...]

        Ejercicio 4. Define cuaternión y di todas las ventajas de usar cuaterniones para rotar en vez de ángulos de Euler.

        [...]

        Ejercicio 5. Di las diferencias entre Transform.position y Transform.Translate y translada de ambas maneras.

        [...]

        Ejercicio 6. Di las diferencias entre Transform.rotation y Transform.Rotate y rota de ambas maneras.

        [...]

        */

        Ejercicio5();
        Ejercicio6();
    }

    void Ejercicio5()
    {
        // Mueve el objeto 1 unidad/segundo hacia arriba (eje y).
        transform.Translate(Vector3.up * Time.deltaTime);

        // Mueve el objeto 1 unidad/segundo hacia abajo (eje y).
        // transform.Translate(Vector3.down * Time.deltaTime);

        // Mueve el objeto 1 unidad/segundo hacia la izquierda (eje x).
        // transform.Translate(Vector3.left * Time.deltaTime);

        // Mueve el objeto 1 unidad/segundo hacia la derecha (eje x).
        // transform.Translate(Vector3.right * Time.deltaTime);

        // Mueve el objeto 1 unidad/segundo hacia arriba (eje y).
        // transform.position = transform.position + new Vector3(0, Time.deltaTime, 0);

        // Mueve el objeto 1 unidad/segundo hacia abajo (eje y).
        // transform.position = transform.position + new Vector3(0, -Time.deltaTime, 0);

        // Mueve el objeto 1 unidad/segundo hacia la izquierda (eje x).
        // transform.position = transform.position + new Vector3(-Time.deltaTime, 0, 0);

        // Mueve el objeto 1 unidad/segundo hacia la derecha (eje x).
        transform.position = transform.position + new Vector3(Time.deltaTime, 0, 0);
    }

    void Ejercicio6()
    {
        // transform.Rotate(0.0f, 0.0f, 1.0f);

        // transform.rotation = [...]
    }

}
