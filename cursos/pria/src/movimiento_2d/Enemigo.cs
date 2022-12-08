// Código del enemigo

void Update()
{
    // Obtenemos la posición del jugador.
    Vector2 targetPosition = player.transform.position;

    // Calculamos la diferencia entre la posición del jugador y la posición actual de la IA.
    Vector2 diff = targetPosition - (Vector2)(this.transform.position);

    // Calculamos el ángulo que se forma en radianes usando la función Atan2 (arcotangente de dos parámetros).
    float angleInRadians = Mathf.Atan2(diff.y, diff.x);

    // Convertimos el ángulo en grados y establecemos la nueva rotación del sprite de la IA.
    this.transform.rotation = Quaternion.Euler(0f, 0f, angleInRadians * Mathf.Rad2Deg);
}
