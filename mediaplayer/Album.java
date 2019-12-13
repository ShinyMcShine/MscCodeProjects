package mediaplayer;
import java.util.*;
import javax.swing.DefaultListModel;


/**
 *
 * @author 100219034
 */
//using implements Compareable so I can sort albums in 
// alphabetical order
public class Album implements Comparable <Album> {
    
    private String artist;
    private String title;
    private ArrayList <Track> tracks;
    private DefaultListModel listmodel_albums;
    
//Construter for collecting album objects and creating
    // a new Arraylist of tracks
    public Album (String artist,  String title){
        this.artist = artist;
        this.title = title;
        this.tracks = new ArrayList<Track>();
    }
    
    //Get methods to retrive each section of a Album and the tracks array
    public String getArtist(){
        return this.artist;
    }  

    public String getTitle(){
        return this.title;
    }
    
    private ArrayList <Track> getTracks(){
        return this.tracks;
    }
        
    public int getCount() {
             
        return this.tracks.size();
    }
    //Based on Steve's demonstration
    public String getHeader(){
        return artist + " : " + title;
    }
    
        //used to return the album collection
    public DefaultListModel getListModelAlbum() {
        listmodel_albums = new DefaultListModel();
        for (Track track : tracks){
           //String element =  
           listmodel_albums.addElement(track.toString());
                
        }

        return this.listmodel_albums;
    }
    
    public DefaultListModel clearAlbumTrackList(){
        listmodel_albums.removeAllElements();
        return listmodel_albums;
    }
    // Method based on Steve's demonstration
    public Track getLongest (){
        Track longest = new Track(new Duration(),"");
        for (Track track : tracks){
            if (track.compareTo(longest) > 0){
                longest = track;
            }
        }
        return longest;
    }
    
    public void addTrack (Track trk)
    {   
        tracks.add(trk);
    }
    
    public Album (String strg){
        String [] parts = strg.split(" : ");
        this.artist = parts[0];
        this.title = parts [1];
        this.tracks = new ArrayList<>();
    }
    //method to calculate a total duration of a particular album
    public Duration totalAlbumDuration(){
       Duration duradd = new Duration(); 
       for (Track durtrk : tracks){           
           duradd.add(durtrk.getDuration());      
       }
       return duradd;
    }
    //Method based on Steve's demonstration
     public Duration getDurByAlbTrkTtl(String title) {
         for(Track trk : tracks){
             if (trk.getTrack().equals(title)){
                 return trk.getDuration();
             }
         }
        return null;
    }
    
    @Override
    public String toString(){
        StringBuilder sb = new StringBuilder();
        sb.append("\n"+getHeader());
        for (Track track : tracks){            
            sb.append("\n" + track);
        }
        return sb.toString();
    }
     /*
    Compare method used to compare two Artists and Albums
    for returning them in alphabetical order in 
    AlbumCollection class if they match
    */ 
    @Override
    //Head First Java pg 450
    //based on Steve's demonstation
    public int compareTo (Album alb){

        return (artist+title).compareTo(alb.artist+alb.title);
    }
    
    public static void main(String[] args) {
        //Testing album constructor passing two strings
        Album test = new Album("Pink Floyd","Dark Side of the Moon");
        System.out.println("Output of album constructor passing two strings: "
                +test);
        //Using track constructor to test addTrack method
        Track trk = new Track ("0:03:48 - Brain Damage");
        test.addTrack(trk);
        Track trk2 = new Track ("0:03:36 - On the Run");
        test.addTrack(trk2);
        //Testing album constructor passing a single string
        Album test2 = new Album("The Beatles : Rubber Soul");

        System.out.println("\nOutput of album constructor passing one string: "
                + test2);
        //Testing of get methods
        System.out.println("\nTesting Title get method: "+test.getTitle());
        System.out.println("Testing Artist get method: "+test.getArtist());
        System.out.println("Testing ArrayList get method:  "+test.getTracks());
        //Testing toString method
        System.out.println("\ntoString output test. \n"+test);
        System.out.println("\nCompare method Test between artist and albums: " 
                + test.compareTo(test2));
        System.out.println("Testing method to pull duration of a song based "
                + "on the title of a the track sent: " 
                + test.getDurByAlbTrkTtl("Brain Damage"));
        System.out.println("Test Album getHeader method " + test.getHeader());
       
    }




    
}

