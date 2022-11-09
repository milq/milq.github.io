/// Interpola linealmente dos valores dado un valor normalizado.
/// Variable 'from': El valor inicial de la interpolación.
/// Variable 'to': El valor final de la interpolación.
/// Variable 'weight': un valor en el rango de 0.0 a 1.0 que representa la cantidad de interpolación.
/// Return: devuelve el valor resultante de la interpolación.
float lerp(float from, float to, float weight)
{
    return from + ((to - from) * weight);
}

float valorInicial = 0;
float valorFinal = 20;

float valorInterpolado1 = lerp(valorInicial, valorFinal, 0.5f);
float valorInterpolado2 = lerp(valorInicial, valorFinal, 0.25f);
float valorInterpolado3 = lerp(valorInicial, valorFinal, 0.75f);

Console.WriteLine(valorInterpolado1);
Console.WriteLine(valorInterpolado2);
Console.WriteLine(valorInterpolado3);