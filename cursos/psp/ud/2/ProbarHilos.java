class Hilo extends Thread {

  public Hilo (String s) {
    super(s);
  }

  public void run() {
    System.out.println("¡Hola, soy el "+ getName());
  }
}


public class ProbarHilos {
  public static void main (String arg[]) {
    Hilo t1, t2, t3;

    t1 = new Hilo("Hilo 1");
    t2 = new Hilo("Hilo 2");
    t3 = new Hilo("Hilo 3");

    t1.start();
    t2.start();
    t3.start();
  }
}
