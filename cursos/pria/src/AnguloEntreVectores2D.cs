// ÁNGULO ENTRE DOS VECTORES 2D
//
// https://wumbo.net/formulas/angle-between-two-vectors-2d/
//
// Devuelve el ángulo que hay del vector 'a' al vector 'b' en grados.

using System.Numerics;

double AngleBetween2DVectors(Vector2 a, Vector2 b)
{
    double sin = a.X * b.Y - b.X * a.Y;
    double cos = a.X * b.X + a.Y * b.Y;

    return Math.Atan2(sin, cos) * (180 / Math.PI);
}

Vector2 v = new Vector2(1, 0);
Vector2 w = new Vector2(0, 1);

double angle = AngleBetween2DVectors(v, w);

Console.WriteLine(angle);
