
import java.util.*;
public class Bucket {
	
	String latitude, longitude;
	ArrayList<Person> personList;
	
	/* Creates a new bucket */
	public Bucket(String lat, String lon){
		this.latitude = lat;
		this.longitude = lon;
		personList = new ArrayList<Person>();
	}
	
	/* Returns the bucket latitude */
	public String getBucketLatitude(){ return latitude; }
	
	/* Returns the bucket longitude */
	public String getBucketLongitude(){ return longitude; }
	
	/* Returns the person from a bucket based off of username 
	 * Returns null if the person is not found in a bucket*/
	public Person getPersonFromBucketByName(String personName){
		
		Person p = null;
		for(int i = 0; i <personList.size(); ++i)
			if(personList.get(i).getUsername().equals(personName))
				p = personList.get(i);
		
		return p;
	}
	
	/* Returns the person from a bucket based off of id 
	 * Returns null if the person is not found in a bucket*/
	public Person getPersonFromBucketById(String personId){
		
		Person p = null;
		
		for(int i = 0; i <personList.size(); ++i)
			if(personList.get(i).getId().equals(personId))
				p = personList.get(i);
		
		return p;
	}
	
	/* Adds a person to a bucket */
	public void addPersonToBucket(Person person){
		personList.add(person);
	}
	
	/* Removes a person from a bucket*/
	public void removePersonFromBucket(String personName){
		
		Person p = null;
		
		for(int i = 0; i <personList.size(); ++i)
			if(personList.get(i).getUsername().equals(personName))
				p = personList.get(i);
		
		if(p != null)
			personList.remove(p);
	}
	
	public ArrayList<Person> getPersonList(){
		return personList;
	}
}
