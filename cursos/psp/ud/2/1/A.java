public class HiloNumeroLetras implements Runnable {
 //Atributos
 private int tipo;

 //Constructor
 public HiloNumeroLetras(int tipo) {
  this.tipo = tipo;
 }

 @Override
 public void run() {
  
  while (true) {                   // Bucle infinito.
   switch (tipo) {                 // Según el tipo hace una u otra cosa.
    case 1:                        // Números.
     for (int i = 1; i < 30; i++) {
      System.out.println(i);
     }
     break;
    case 2:                        // Letras
     for (char c = 'a'; c < 'z'; c++) {
      System.out.println(c);
     }
     break;
   }
  }
 }
}

package ejercicio_thread_ddr_1;
 
public class Ejercicio_thread_DDR_1 {
 
    public static void main(String[] args) {
         
        HiloNumeroLetras h1 = new HiloNumeroLetras(1);
        HiloNumeroLetras h2 = new HiloNumeroLetras(2);
         
        Thread t1 = new Thread(h1);
        Thread t2 = new Thread(h2);
         
        t1.start();
        t2.start();
         
    }
 
}
