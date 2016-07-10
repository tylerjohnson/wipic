
public class ResourceApp {
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		/* Create a port listener object */
		ServerListener listener = new ServerListener(Globals.PORT_NUMBER);
		/* Create thread to run the listener */
		Thread listenerThread = new Thread(listener);
		
		
		/* Start the thread */
		try{
			listenerThread.start();
		}catch(Exception e){
			
		}
		
		/* Join the thread back into the main thread */
		try {
			listenerThread.join();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
