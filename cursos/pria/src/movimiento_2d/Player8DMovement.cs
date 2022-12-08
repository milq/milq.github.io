using UnityEngine;

public class Player8DMovement : MonoBehaviour
{
    [SerializeField]
    private float speed; // Velocidad del jugador

    [SerializeField]
    private float rotationSpeed; // Velocidad de rotación del jugador

    void Update()
    {
        // Obtiene la entrada del jugador en los ejes horizontal y vertical
        float horizontalInput = Input.GetAxis("Horizontal");
        float verticalInput = Input.GetAxis("Vertical");

        // Establece la dirección del movimiento en 2D
        Vector2 movementDirection = new Vector2(horizontalInput, verticalInput);

        // Hace que este vector tenga una magnitud de 1
        movementDirection.Normalize();

        // Mueve el jugador en la dirección establecida
        transform.Translate(movementDirection * speed * Time.deltaTime, Space.World);

        // Si el jugador está moviéndose, rota en la dirección de movimiento
        if (movementDirection != Vector2.zero)
        {
            Quaternion toRotation = Quaternion.LookRotation(Vector3.forward, movementDirection);
            transform.rotation = Quaternion.RotateTowards(transform.rotation, toRotation, rotationSpeed * Time.deltaTime);
        }
    }
}
