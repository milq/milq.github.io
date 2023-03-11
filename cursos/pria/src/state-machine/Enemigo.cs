using UnityEngine;
using UnityEngine.AI;

public class Enemigo : MonoBehaviour
{
    // Enum para los diferentes estados de la máquina de estado finita
    public enum EnemyState
    {
        Patrol,
        Attack,
        Guard
    }

    // Estado actual de la máquina de estados
    public EnemyState currentState;

    // Array de puntos de patrulla
    public Transform[] patrolPoints;

    // Objetivo del enemigo (en este caso, el jugador)
    public Transform target;

    // Posición de guardia
    public Transform guard;

    // Distancia a la que el enemigo comenzará a atacar
    public float attackRadius = 1f;

    // Distancia a la que el enemigo comenzará a ir hacia el jugador para atacar
    public float attackRange = 4f;

    // Distancia a la que el enemigo comenzará a ir hacia la posición de guardia
    public float GuardRange = 5f;

    // Componente Nav Mesh Agent
    private NavMeshAgent agent;

    // Índice para el Array 'patrolPoints'
    private int patrolPointIndex = 0;

    void Start()
    {
        // Asignamos el componente Nav Mesh Agent
        agent = GetComponent<NavMeshAgent>();

        // Estado inicial
        currentState = EnemyState.Patrol;
    }

    void Update()
    {
        // Actualizamos al estado actual
        switch (currentState)
        {
            case EnemyState.Patrol:
                Patrol();
                break;
            case EnemyState.Attack:
                Attack();
                break;
            case EnemyState.Guard:
                Guard();
                break;
        }
    }

    // Comportamiento del enemigo en el estado Patrol
    void Patrol()
    {
        Debug.Log("Estado: Patrulla.");

        // Lógica del estado Patrulla:
        // Ir hacia el siguiente punto de patrulla
        if (!agent.pathPending && agent.remainingDistance < 0.5f)
            GoToNextPatrolPoint();

        // Lógica de la transición 1:
        // Si el enemigo ve al objetivo, cambiar al estado Attack
        if (CanSeeTarget())
        {
            currentState = EnemyState.Attack;
        }
    }

    // Comportamiento del enemigo en el estado Attack
    void Attack()
    {
        Debug.Log("Estado: Ataque.");

        // Lógica del estado Ataque:
        // Moverse hacia el objetivo, en este caso, al jugador, y si está cerca, atacar
        agent.destination = target.position;
        if (Vector3.Distance(transform.position, target.position) < attackRadius)
        {
            AttackAction();
        }

        // Lógica de la transición 1:
        // Si el enemigo está fuera del rango de ataque, cambiar al estado Guard
        if (Vector3.Distance(transform.position, target.position) > GuardRange)
        {
            currentState = EnemyState.Guard;
        }
    }

    // Comportamiento del enemigo en el estado Guard
    void Guard()
    {
        Debug.Log("Estado: Guardia.");

        // Lógica del estado Guardia:
        // Moverse hacia el punto de guardia
        agent.destination = guard.position;

        // Lógica de la transición 1:
        // Si el enemigo ve al objetivo, cambiar al estado Attack
        if (CanSeeTarget())
        {
            currentState = EnemyState.Attack;
        }
    }

    // Método para ir hacia el siguiente punto de patrulla
    void GoToNextPatrolPoint()
    {
        // Sale de la función si no se han asignado puntos de patrulla
        if (patrolPoints.Length == 0)
            return;

        // Mueve el agente al punto de patrulla
        agent.destination = patrolPoints[patrolPointIndex].position;

        // Elige el siguiente punto de patrulla y empieza por el primero si es necesario
        patrolPointIndex = (patrolPointIndex + 1) % patrolPoints.Length;
    }

    // Método para determinar si el enemigo puede ver al objetivo
    bool CanSeeTarget()
    {
        // Si el enemigo está lo suficientemente cerca del objetivo, puede verlo
        if (Vector3.Distance(transform.position, target.position) < attackRange)
        {
            return true;
        }
        return false;
    }

    // Método para atacar al objetivo
    void AttackAction()
    {
        Debug.Log("¡Disparo!");

        // Aquí iría el código para causar daño al objetivo, en este caso, el jugador.
    }
}
