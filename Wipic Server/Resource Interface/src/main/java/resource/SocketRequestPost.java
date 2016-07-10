package resource;

import java.io.*;
import java.net.*;

public class SocketRequestPost implements Runnable{
    private final String MACHINE_NAME = "localhost";
    private final int PORT_NUMBER = 8087;

    private String id, username, longitude, latitude, serverResponse;

    public SocketRequestPost(String id, String username, String longitude, String latitude){
        this.id = id;
        this.username = username;
        this.longitude = longitude;
        this.latitude = latitude;
    }

    public String getId() {
        return id;
    }

    public String getServerResponse(){
        return serverResponse;
    }

    public String getUsername() {
        return username;
    }

    public String getLongitude(){
        return longitude;
    }

    public String getLatitude(){
        return latitude;
    }

    public void run(){
        Socket myClient = null;
        DataOutputStream os = null;
        DataInputStream is = null;

        try
        {
            myClient = new Socket(MACHINE_NAME, PORT_NUMBER);
            os = new DataOutputStream(myClient.getOutputStream());
            is = new DataInputStream(myClient.getInputStream());
        } catch (UnknownHostException e) {
            System.err.println("Don't know about host: hostname");
            serverResponse = "Success = 0, Error = 1";
        } catch (IOException e) {
            System.err.println("Couldn't get I/O for the connection to: " + MACHINE_NAME + " e: " + e);
            serverResponse = "Success = 0, Error = 1";
        }

        if (myClient != null && os != null && is != null) {
            try {
                System.out.println(username + "&"+id + "&"+latitude + "&" + longitude + "\n");
                os.writeBytes("update" + "&" + username + "&"+id + "&"+latitude + "&" + longitude + "\n");

                String responseLine;
                while ((responseLine = is.readLine()) != null) {
                    System.out.println("Server: " + responseLine);
                    serverResponse = responseLine;
                    break;
                }

                os.close();
                is.close();
                myClient.close();
            }catch (UnknownHostException e) {
                System.err.println("Trying to connect to unknown host: " + e);
                serverResponse = "Success = 0, Error = 1";
            } catch (IOException e) {
                System.err.println("IOException:  " + e);
                serverResponse = "Success = 0, Error = 1";
            }
        }
    }
}
