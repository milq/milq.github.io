using UnityEngine;

[RequireComponent(typeof(Rigidbody2D))]
public class PlayerSpaceshipMovement : MonoBehaviour
{
    // Crea una propiedad para obtener el componente Rigidbody2D del objeto
    public Rigidbody2D Rigidbody { get; private set; }

    // Establece la velocidad de empuje y si está o no empujando
    public float ThrustSpeed = 1f;
    public bool Thrusting { get; private set; }

    // Establece la dirección de giro y la velocidad de rotación
    public float TurnDirection { get; private set; } = 0f;
    public float RotationSpeed = 0.1f;

    // Obtiene el componente Rigidbody2D en el método Awake
    private void Awake()
    {
        Rigidbody = GetComponent<Rigidbody2D>();
    }

    // Actualiza el estado del empuje y la dirección de giro en el método Update
    private void Update()
    {
        // Establece si se está empujando según la entrada del teclado
        Thrusting = Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow);

        // Establece la dirección de giro según la entrada del teclado
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow))
        {
            TurnDirection = 1f;
        }
        else if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow))
        {
            TurnDirection = -1f;
        }
        else
        {
            TurnDirection = 0f;
        }
    }

    // Aplica el empuje y el giro al objeto en el método FixedUpdate
    private void FixedUpdate()
    {
        // Aplica una fuerza en la dirección actual si se está empujando
        if (Thrusting)
        {
            Rigidbody.AddForce(transform.up * ThrustSpeed);
        }

        // Aplica un torque en la dirección de giro si hay una dirección especificada
        if (TurnDirection != 0f)
        {
            Rigidbody.AddTorque(RotationSpeed * TurnDirection);
        }
    }
}
