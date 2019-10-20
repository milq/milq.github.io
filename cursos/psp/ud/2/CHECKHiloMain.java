/***************************************************************************
* Este programa identifica el hilo que ejecuta el método 'main'() de la típica
* aplicación de consola "¡Hola, mundo!".
* Se utilizan para ello los métodos: 'currentThread()' y 'getName()' de la
* clase Thread.
*/

public class HiloMain {
    public static void main(String[] args) {

    // Imprime "¡Hola mundo!" en la Salida.
    System.out.println("¡Hola, mundo!");

    // Obtiene el hilo donde se está ejecutando este método mediante la función
    // Thread.currentThread(), y lo almacena en la variable local miHilo.
    Thread miHilo = Thread.currentThread();

    // Imprime el nombre del hilo en la Salida (función ¡getName()')
    System.out.println("Por defecto, el hilo que ejecuta el método 'main()'" +
                       " de mi programa se llama '" + miHilo.getName() + "'.");
  }
}
