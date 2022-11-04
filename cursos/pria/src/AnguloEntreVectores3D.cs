// ÁNGULO ENTRE DOS VECTORES 3D
//
// https://stackoverflow.com/a/32724066
//
// Devuelve el ángulo mínimo, sin signo, que hay de 'a' a 'b' en grados.

using System.Numerics;

float AngleBetween3DVectors(Vector3 a, Vector3 b)
{
    Vector3 cross = Vector3.Cross(a, b);
    float dot = Vector3.Dot(a, b);

    return MathF.Atan2(cross.Length(), dot) * (180 / MathF.PI);
}

Vector3 v = new Vector3(2, 3, -1);
Vector3 w = new Vector3(-4, -1, 2);

float angle = AngleBetween3DVectors(v, w);

Console.WriteLine(angle);
