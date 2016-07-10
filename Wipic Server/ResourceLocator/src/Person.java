
public class Person {
	
	private String id, username,latitude, longitude;
	
	public Person(String id, String username, String latitude, String longitude){
		this.id = id;
		this.username = username;
		this.latitude = latitude;
		this.longitude = longitude;
	}
	
	public String getId(){ return id; }
	
	public String getUsername(){ return username; }
	
	public String getLatitude(){ return latitude; }
	
	public String getLongitude(){ return longitude; }
	
	public void setId(String id){ this.id = id; }
	
	public void setUsername(String username){ this.username = username; }
	
	public void setLatitude(String latitude){ this.latitude = latitude; }
	
	public void setLongitude(String longitude){ this.longitude = longitude; }
	
}
