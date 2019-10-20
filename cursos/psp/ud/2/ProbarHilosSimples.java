class HiloSimple extends Thread {
  public void run() {
    System.out.println("¡Hola!");
  }
}


public class ProbarHilosSimples {
  public static void main (String arg[]) {
    HiloSimple t1, t2;

    t1 = new HiloSimple();
    t2 = new HiloSimple();

    t1.start();
    t2.start();
  }
}
