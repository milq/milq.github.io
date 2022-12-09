using UnityEngine;

// Mueve al jugador hacia la posición del puntero del ratón.
// También aplica un 'steering behavior' de tipo 'seek' al movimiento
// También gira el jugador hacia la posición del puntero del ratón.
public class MousePointerMovement : MonoBehaviour
{
    // Velocidad máxima del jugador
    public float maxVelocity = 10f;

    // Velocidad actual del jugador
    private Vector2 velocity;

    void Update()
    {
        // Obtiene la posición del ratón en la pantalla
        Vector2 mousePosition = Input.mousePosition;

        // Convierte la posición del ratón en una posición en el mundo
        Vector2 worldMousePosition = Camera.main.ScreenToWorldPoint(mousePosition);

        // Calcula la velocidad deseada del jugador como la dirección hacia la posición del ratón normalizada y multiplicada por la velocidad máxima
        Vector2 desiredVelocity = (worldMousePosition - (Vector2)transform.position).normalized * maxVelocity;

        // Calcula la fuerza de 'steering' como la diferencia entre la velocidad deseada y la velocidad actual del jugador
        Vector2 steeringForce = desiredVelocity - velocity;

        // Añade la fuerza de 'steering' a la velocidad actual del jugador
        velocity += steeringForce;

        // Limita la velocidad a la velocidad máxima
        velocity = Vector2.ClampMagnitude(velocity, maxVelocity);

        // Actualiza la posición del jugador
        transform.position += (Vector3)velocity * Time.deltaTime;

        // Calcula la dirección hacia la posición del ratón
        Vector2 direction = worldMousePosition - (Vector2)transform.position;

        // Calcula el ángulo que hay en grados entre el eje X y la dirección hacia la posición del ratón.
        float angle = Mathf.Atan2(direction.y, direction.x) * Mathf.Rad2Deg;

        // Gira el jugador hacia la misma dirección del ratón
        transform.rotation = Quaternion.AngleAxis(angle, Vector3.forward);
    }
}
