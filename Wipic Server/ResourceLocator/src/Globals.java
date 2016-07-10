import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.*;

public class Globals{
	
	public static final double FACTOR = .00025;				/* .00028 difference in two points is approximately 25 meters */
	public static final double MAX_DISTANCE = 25;				/* Number of meters a person can be from someone else */
	public static final double MIN_LATITUDE = -90.0;		/* minimum latitude value */
	public static final double MAX_LATITUDE = 90.0;			/* maximum latitude value */
	public static final double MIN_LONGITUDE = -180.0;		/* minimum longitude value */
	public static final double MAX_LONGITUDE = 180.0;		/* maximum longitude value */
	public static final int PORT_NUMBER = 8087;				/* port number for server to run on */
	
	/* key: String value representing the name of the bucket value: the Bucket object */
	public static Map<String, Map<String, Bucket>> bucketMap = new HashMap<String, Map<String, Bucket>>();
	
	/* Key: String value representing the username of the person value: array containing the latitude and longitude of the current residing bucket*/
	public static Map<String, double[]> personMap = new HashMap<String, double[]>();
	
	public static NumberFormat formatter = new DecimalFormat("#0.00000");
	
	/* Creates a new bucket in the map if it does not exist */
	public static Bucket createBuckets(String latitude, String longitude){
		Map<String, Bucket> lonMap = null; 
		/* Checks whether the latitude has been added before */
		if(!bucketMap.containsKey(latitude)){
			/* Creates the hash for the longitude and buckets */
			lonMap = new HashMap<String, Bucket>();
			bucketMap.put(latitude, lonMap);
		}
		else{
			/* the map already exists */
			lonMap = bucketMap.get(latitude);
		}
		
		/* longitude key and bucket do not exist */
		if(!lonMap.containsKey(longitude))
			lonMap.put(longitude, new Bucket(latitude, longitude));
		
		return lonMap.get(longitude);
	}
	
	/* Gets a bucket from the map */
	public static Bucket getBucket(String latitude, String longitude){
		Bucket b = null;
		
		if(bucketMap.containsKey(latitude))
			if(bucketMap.get(latitude).containsKey(longitude))
				b = bucketMap.get(latitude).get(longitude);
		
		return b;
	}
	
	/* Determines the new bucket for the user */
	public static void determinePersonsBucket(Person p){
		/* Checks if the person belongs to a bucket*/
		double formattedLat = Double.NaN, formattedLon = Double.NaN;
		double curBaseLat = Double.NaN, curBaseLon = Double.NaN;
		
		/* Person must be updated if exists, stores current coordinates */
		if(personMap.containsKey(p.getUsername())){
			
			double[] coord;
			coord = personMap.get(p.getUsername());
			curBaseLat = coord[0];
			curBaseLon = coord[1];
		}
		
		double[] formattedCoords = getFormattedCoordinates(p.getLatitude(), p.getLongitude());
		formattedLat = formattedCoords[0]; /* latitude formatted to 5 decimals*/
		formattedLon = formattedCoords[1]; /* longitude formatted to 5 decimals */
		
		if(!Double.isNaN(formattedLat) && !Double.isNaN(formattedLon)){
		
			double[] baseCoord = getBaseCoordinates(formattedLat, formattedLon); 
			
			double baseLat = baseCoord[0]; /* latitude used to find the nearest bucket */
			double baseLon = baseCoord[1]; /* longitude used to find the nearest bucket */
			System.out.println(baseLat);
			/*Gets the bucket associated with the base longitude and latitude */
			Bucket b = createBuckets(String.valueOf(baseLat), String.valueOf(baseLon));
			
			if(!Double.isNaN(curBaseLon) && !Double.isNaN(curBaseLat)){
				/* the person existed so check if the bucket has changed */
				if(curBaseLat == baseLat && curBaseLon == baseLon){
					/* The old base latitude and longitude match (same bucket) so just update new current coordinate */
					Person person = b.getPersonFromBucketByName(p.getUsername());
					/* Set their current coordinates */
					person.setLatitude(String.valueOf(formattedLat));
					person.setLongitude(String.valueOf(formattedLon));
				}
				else{
					/* Person has moved from one bucket to another */
					/* Remove the person from their current bucket */
					Bucket currentBucket = bucketMap.get(String.valueOf(curBaseLat)).get(String.valueOf(curBaseLon));
					/* Get the person object from the bucket before it is removed */
					Person person = b.getPersonFromBucketByName(p.getUsername());
					/* Remove the person from their current bucket */
					currentBucket.removePersonFromBucket(p.getUsername());
					/* Set their current coordinates */
					person.setLatitude(String.valueOf(formattedLat));
					person.setLongitude(String.valueOf(formattedLon));
					
					/* Add person to their new bucket */
					b.addPersonToBucket(person);
				}
			}
			else{
				/* the person does not exist yet */
				/* Set their current coordinates */
				p.setLatitude(String.valueOf(formattedLat));
				p.setLongitude(String.valueOf(formattedLon));
				
				/* Add person to their new bucket */
				b.addPersonToBucket(p);
			}
			
			/* Update the person map to the new bucket base coordinates */
			double[] coord = new double[2];
			coord[0] = baseLat;
			coord[1] = baseLon;
			
			if(personMap.containsKey(p.getUsername()))
				personMap.replace(p.getUsername(), coord);
			else
				personMap.put(p.getUsername(), coord);
		}
		else
		{
			//TODO: Report issue occured
		}
	}
	
	/*Returns a semicolon separated string of all the people closest to this person*/
	public static String returnClosestPeople(Person p){
		
		String people = "";
		double curBaseLat, curBaseLon;
		double[] northCoords;
		double[] southCoords;
		double[] eastCoords;
		double[] westCoords;
		double[] northEastCoords;
		double[] southEastCoords;
		double[] northWestCoords;
		double[] southWestCoords;
		
		/* Person must be updated if exists, stores current coordinates */
		if(personMap.containsKey(p.getUsername())){
			double[] coord;
			coord = personMap.get(p.getUsername());
			curBaseLat = coord[0];
			curBaseLon = coord[1];
			
			/*Must calculate each surrounding bucket coordinates */
			northCoords = returnCoords(1, coord);
			southCoords = returnCoords(2, coord);
			eastCoords = returnCoords(3, coord);
			westCoords = returnCoords(4, coord);
			northEastCoords = returnCoords(5, coord);
			southEastCoords = returnCoords(6, coord);
			northWestCoords = returnCoords(7, coord);
			southWestCoords = returnCoords(8, coord);
	
			double[] personLocation = getFormattedCoordinates(p.getLatitude(), p.getLongitude());
			
			Bucket b = getBucket(String.valueOf(curBaseLat), String.valueOf(curBaseLon));
			if(b != null){
				people += getPeopleFromBucket(personLocation[0], personLocation[1], b);
			}
			
			b = getBucket(String.valueOf(northCoords[0]), String.valueOf(northCoords[1]));
			if(b != null){
				people += getPeopleFromBucket(personLocation[0], personLocation[1], b);
			}
			
			b = getBucket(String.valueOf(southCoords[0]), String.valueOf(southCoords[1]));
			if(b != null){
				people += getPeopleFromBucket(personLocation[0], personLocation[1], b);
			}
			
			b = getBucket(String.valueOf(eastCoords[0]), String.valueOf(eastCoords[1]));
			if(b != null){
				people += getPeopleFromBucket(personLocation[0], personLocation[1], b);
			}
			
			b = getBucket(String.valueOf(westCoords[0]), String.valueOf(westCoords[1]));
			if(b != null){
				people += getPeopleFromBucket(personLocation[0], personLocation[1], b);
			}
			
			b = getBucket(String.valueOf(northEastCoords[0]), String.valueOf(northEastCoords[1]));
			if(b != null){
				people += getPeopleFromBucket(personLocation[0], personLocation[1], b);
			}
			
			b = getBucket(String.valueOf(southEastCoords[0]), String.valueOf(southEastCoords[1]));
			if(b != null){
				people += getPeopleFromBucket(personLocation[0], personLocation[1], b);
			}
			
			b = getBucket(String.valueOf(northWestCoords[0]), String.valueOf(northWestCoords[1]));
			if(b != null){
				people += getPeopleFromBucket(personLocation[0], personLocation[1], b);
			}
			
			b = getBucket(String.valueOf(southWestCoords[0]), String.valueOf(southWestCoords[1]));
			if(b != null){
				people += getPeopleFromBucket(personLocation[0], personLocation[1], b);
			}
			
		}
		else{
			//TODO: Report user has not updated location yet ***Not determined 
			return "Success = 0, Error = 1";
		}
		
		return "Success = 1, Error = 0, " + people;
	}
	
	/* Returns a string semicolon delimited with all the people 25 meters or less from the given coords*/
	public static String getPeopleFromBucket(double latitude, double longitude, Bucket b){
		
		String list = "";
		
		ArrayList<Person> personList = b.getPersonList();
		
		/* loop through the list of people*/
		for(int i = 0; i < personList.size(); ++i){
			Person p = personList.get(i);
			double lat = Double.parseDouble(p.getLatitude());
			double lon = Double.parseDouble(p.getLongitude());
			
			/* Get the distance between the two points*/
			double distance = calculateDistance(latitude, lat, longitude, lon);
			
			/* Store the name if the distance between the user and friend are less than the max distance */
			if(distance <= MAX_DISTANCE){
				list += p.getUsername() + ";";
			}
		}
		
		return list;
	}
	
	public static double calculateDistance(double lat1, double lat2, double lon1, double lon2){
		double R = 7371000.0;
		double latRad1 = Math.toRadians(lat1);
		double latRad2 = Math.toRadians(lat2);
		double deltaLatRad = Math.toRadians(lat2-lat1);
		double deltaLonRad = Math.toRadians(lon2-lon1);
		double a = Math.sin(deltaLatRad/2) * Math.sin(deltaLatRad/2) +
				   Math.cos(latRad1) * Math.cos(latRad2) *
				   Math.sin(deltaLonRad/2) * Math.sin(deltaLonRad/2);
		double c = 2* Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
		double d = R*c;
		
		return d;
	}
	
	public static double[] returnCoords(int coordType, double baseCoords[]){
		double[] coords = new double[2];
		coords[0] = baseCoords[0];
		coords[1] = baseCoords[1];
		switch (coordType){
		case 1:
			/*North of base coordinates*/
			if(baseCoords[0] + FACTOR <= MAX_LATITUDE){
				coords[0] +=FACTOR;
				coords[1] = baseCoords[1];
			}
			else{
				coords[0] = MIN_LATITUDE;
				coords[1] = baseCoords[1];
			}
			break;
		case 2:
			/*South of base coordinates*/
			if(baseCoords[0] - FACTOR >= MIN_LATITUDE){
				coords[0] -=FACTOR;
				coords[1] = baseCoords[1];
			}
			else{
				coords[0] = MAX_LATITUDE;
				coords[1] = baseCoords[1];
			}
			break;
		
		case 3:
			/*East of base coordinates*/
			if(baseCoords[1] + FACTOR <= MAX_LONGITUDE){
				coords[0] = baseCoords[0];
				coords[1] += FACTOR;
			}
			else{
				coords[0] = baseCoords[0];
				coords[1] = MIN_LONGITUDE;
			}
			break;
		case 4:
			/*West of base coordinates*/
			if(baseCoords[1] - FACTOR >= MIN_LONGITUDE){
				coords[0] = baseCoords[0];
				coords[1] -= FACTOR;
			}
			else{
				coords[0] = baseCoords[0];
				coords[1] = MAX_LONGITUDE;
			}
			break;
		case 5:
			/*North East Coordinates*/
			coords = returnCoords(1, baseCoords);
			coords = returnCoords(3, coords);
			break;
		case 6:
			/*South East Coordinates*/
			coords = returnCoords(2, baseCoords);
			coords = returnCoords(3, coords);
			break;
		case 7:
			/*North West Coordinates*/
			coords = returnCoords(1, baseCoords);
			coords = returnCoords(4, coords);
			break;
		case 8:
			/*South West Coordinates*/
			coords = returnCoords(2, baseCoords);
			coords = returnCoords(4, coords);
			break;
		}	
		return coords;
	}
	
	public static double[] getBaseCoordinates(double formattedLat, double formattedLon){
		
		double[] coords = new double[2];

		double latDifference = formattedLat%Globals.FACTOR; /* The mod of the formatted latitude to get to the next whole number */
		double lonDifference = formattedLon%Globals.FACTOR; /* The mod of the formatted longitude to get to the next whole number */

		latDifference = Double.parseDouble(formatter.format(latDifference));
		lonDifference = Double.parseDouble(formatter.format(lonDifference));
		
		double baseLat = formattedLat - latDifference; /* latitude used to find the nearest bucket */
		double baseLon = formattedLon - lonDifference; /* longitude used to find the nearest bucket */
		
		coords[0] = Double.parseDouble(formatter.format(baseLat));
		coords[1] = Double.parseDouble(formatter.format(baseLon));

		return coords;
	}
	
	public static double[] getFormattedCoordinates(String latitude, String longitude){
		
		double lat = Double.NaN, lon = Double.NaN;
		double[] formattedCoords = new double[2];
		
		try{
			lat = Double.parseDouble(latitude);
		}catch(Exception e){
			
		}
		
		try{
			lon = Double.parseDouble(longitude);
		}catch(Exception e){
			
		}
		
		if(!Double.isNaN(lat) && !Double.isNaN(lon)){
			lat = Double.parseDouble(formatter.format(lat)); /* latitude formatted to 5 decimals */
			lon = Double.parseDouble(formatter.format(lon)); /* longitude formatted to 5 decimals */
			
		}
		
		formattedCoords[0] = lat;
		formattedCoords[1] = lon;
		
		return formattedCoords;
		
	}
	
}
