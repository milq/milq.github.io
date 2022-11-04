// ÁNGULO ENTRE DOS VECTORES 2D
//
// https://wumbo.net/formulas/angle-between-two-vectors-2d/
//
// Devuelve el ángulo que hay del vector 'a' al vector 'b' en grados.

using System.Numerics;

float AngleBetween2DVectors(Vector2 a, Vector2 b)
{
    float sin = a.X * b.Y - b.X * a.Y;
    float cos = a.X * b.X + a.Y * b.Y;

    return MathF.Atan2(sin, cos) * (180 / MathF.PI);
}

Vector2 v = new Vector2(1, 0);
Vector2 w = new Vector2(0, 1);

float angle = AngleBetween2DVectors(v, w);

Console.WriteLine(angle);
