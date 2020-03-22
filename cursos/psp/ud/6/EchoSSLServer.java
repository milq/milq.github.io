import javax.net.ssl.SSLServerSocket;
import javax.net.ssl.SSLServerSocketFactory;
import javax.net.ssl.SSLSocket;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

public class EchoSSLServer {
  public static void main(String[] args) {
    try {
      SSLServerSocketFactory sslserversocketfactory = (SSLServerSocketFactory) SSLServerSocketFactory.getDefault();
      SSLServerSocket sslserversocket = (SSLServerSocket) sslserversocketfactory.createServerSocket(5001);
      SSLSocket sslsocket = (SSLSocket) sslserversocket.accept();

      InputStream inputstream = sslsocket.getInputStream();
      InputStreamReader inputstreamreader = new InputStreamReader(inputstream);
      BufferedReader bufferedreader = new BufferedReader(inputstreamreader);

      String string = null;
      while ((string = bufferedreader.readLine()) != null) {
        System.out.println("EchoServer heard "+string);
        System.out.flush();
      }
    } catch (Exception exception) {
      exception.printStackTrace();
    }
  }
}
