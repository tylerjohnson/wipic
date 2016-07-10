import java.io.DataInputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.net.ServerSocket;
import java.net.Socket;

public class ServerListener implements Runnable {
	
	private int port; /* The port that the server will listen on */
	
	public ServerListener(int port){
		this.port = port;
	}
	
	public void run(){
		
		ServerSocket portListener = null;
		Socket clientSocket = null;
		String line;
		DataInputStream is;
		PrintStream os;
		
		/* Create a new socket on the port specified */
		try {
			portListener = new ServerSocket(port);
		}
		catch (IOException e) {
		   System.out.println(e);
		}   
		
	    try {
	    	/* Reset port objects for each client */
	    	
	    	while(true){
	    		/* Create connection to the port */
	    		String response = "";
	    		clientSocket = portListener.accept();
	    		is = new DataInputStream(clientSocket.getInputStream());
	            os = new PrintStream(clientSocket.getOutputStream());
	            System.out.println("here");
	            /* Listen for data from client */
	            while (true) {
	              line = is.readLine();
	              System.out.println(line);
	              /* 0 = type, 1 = username, 2 = id, 3 = latitude, 4 = longitude*/
	              String[] components = line.split("&");
	              
	              /* Must have the 5 components or the info is incorrect */
	              if(components.length == 5){
	            	  Person p = new Person(components[2], components[1], components[3], components[4]);
	            	  /* Update users location*/
	            	  if(components[0].equals("update")){
	            		  Globals.determinePersonsBucket(p);
	            		  response = "success";
		              }
	            	  /* Get the users location */
	            	  else if(components[0].equals("respond")){
	            		  response = Globals.returnClosestPeople(p);
	            	  }
	              }else{
	            	  response = "Success = 0, Error = 1";
	              }
	              
	              clientSocket.close();

	              os.println(response); 
	              break;
	            }
	        }
	    }
	              
	    catch (IOException e) {
	           System.out.println(e);
	    }
	    
	}
	
}
