
package mediaplayer;
/**
 *
 * @author 100219034
 */
public class Track implements Comparable <Track>  {
    
    
    private String track;
    private Duration duration; 
    
    //Track consturtor to supply a duration and track
    public  Track (Duration duration,String track)
    {
        this.track = track;
        this.duration = duration;
    }
    
    //Return the current value of the variable title 
    public String getTrack(){
        return this.track;
    }
    
    //Return the current value of the variable duration
    public Duration getDuration(){
        return this.duration;
    }
    
    public Track (String strg){
        String [] parts = strg.split(" - ");
        track = parts[1];
        duration = new Duration(parts[0]);
    }
    
    @Override
    public int compareTo(Track trk){
        return this.duration.compareTo(trk.duration);
    }
    //toString outputing the duration and title together
    @Override
    public String toString(){
        
        return duration + " - " + track;
    }
    
    public static void main(String[] args) {
        //Testing track constructor to accept a string containg a 
        // duration and track name as wel as the toString method
        Track trk = new Track("0:06:50 - Third Stone from the Sun");
        System.out.println(trk);
        //Testing track construtctor to accept a duratoin obj and track string
        Duration d = new Duration(0,1,30);
        Track trk2 = new Track(d,"Speak to Me");
        System.out.println("\n"+trk2);
        //Comparing to duration of a track and this case it is a 1 because
        // trk dur is 6 minutes and trk2 is 1 minute
        System.out.println("\nComparing two durations ("+trk.getDuration()
                + " and " + trk2.getDuration()+" ) between two tracks '"+trk.getTrack()+ 
                "' and '"+trk2.getTrack()+"' results are: "+trk.compareTo(trk2)
                + ". Showing that '" + trk.getTrack() + "' is larger.");
        //testing get methods of Track class
        System.out.println("\nTesting get Duration method: "+trk.getDuration());
        System.out.println("Testing get Title method: "+trk.getTrack());
               
        
    }

    
}

