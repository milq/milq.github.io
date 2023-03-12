using UnityEngine;
using UnityEngine.AI;

public class EnemigoFSM : MonoBehaviour
{
    // Enum para los estados del enemigo
    enum EnemyState
    {
        Patrol,
        Attack,
        Retreat,
        Rest,
        Guard
    }

    // Estado actual del enemigo
    EnemyState currentState;

    void Start()
    {
        // Estado inicial
        currentState = EnemyState.Patrol;
    }

    void Update()
    {
        // Lógica de la máquina de estados con 'switch-enum'
        switch (currentState)
        {
            case EnemyState.Patrol:
                Patrol();
                break;
            case EnemyState.Attack:
                Attack();
                break;
            case EnemyState.Retreat:
                Retreat();
                break;
            case EnemyState.Rest:
                Rest();
                break;
            case EnemyState.Guard:
                Guard();
                break;
        }
    }

    void Patrol()
    {
        // Lógica para el estado de patrulla:
        // Implementa la lógica para hacer que el enemigo patrulle por un área determinada

        // Lógica de las diferentes transiciones:
        // Implementa las transiciones que existan hacia otros estados
    }

    void Attack()
    {
        // Lógica para el estado de ataque:
        // Implementa la lógica para hacer que el enemigo ataque al jugador

        // Lógica de las diferentes transiciones:
        // Implementa las transiciones que existan hacia otros estados
    }

    void Retreat()
    {
        // Lógica para el estado de retirada:
        // Implementa la lógica para hacer que el enemigo se aleje del jugador

        // Lógica de las diferentes transiciones:
        // Implementa las transiciones que existan hacia otros estados
    }

    void Rest()
    {
        // Lógica para el estado de descanso:
        // Implementa la lógica para hacer que el enemigo descanse y recupere vida

        // Lógica de las diferentes transiciones:
        // Implementa las transiciones que existan hacia otros estados
    }

    void Guard()
    {
        // Lógica para el estado de guardia:
        // Implementa la lógica para hacer que el enemigo esté en guardia

        // Lógica de las diferentes transiciones:
        // Implementa las transiciones que existan hacia otros estados
    }
}
