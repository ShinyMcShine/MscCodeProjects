package mediaplayer;


import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.DefaultListModel;
import javax.swing.JOptionPane;

/**
 *
 * @author 100219034
 */
public class AlbumCollection {

    private ArrayList<Album> album_col;
    private DefaultListModel listmodel_albcol;
    
    //AlbumCollection constructer
    public AlbumCollection() {
        //Creates a new ArrayList
        this.album_col = new ArrayList<>();

    }

    //used to return the album collection to be added to the Jlist in MAPPSGUI
    public DefaultListModel getListModelAlbumcol() {
        listmodel_albcol = new DefaultListModel();
        for (Album alb : album_col){
           listmodel_albcol.addElement(alb.getHeader());
           
        }

        return this.listmodel_albcol;
    }
    
    public void clearAlbumCollection(){
        album_col.clear();
    }
    // Method based on Steve's demonstration
    // Method used to return the album, artist, and tracks with the largest number of tracks
    public Album getMostTracksAlbum (){
        Album mostTracks = new Album ("","");
        for (Album album : album_col){
            if(album.getCount() > mostTracks.getCount()){
                mostTracks = album;
            }
        }
        return mostTracks;
    }
    // Method based on Steve's demonstration
    // Method to searchs to return the longest track in album_col
    public Track getLongest (){
        Track longest = new Track(new Duration(),"");
        for (Album alb : album_col){
            Track track = alb.getLongest();
            if (track.compareTo(longest) > 0){
                longest = track;
            }
        }
        return longest;
    }
    
    //This method will look for any artists albums
    // add their duration together
    
    public Duration ablum_duration (String artist) {
        Duration pnkdur = new Duration();
        for (Album pnkalb : album_col) {

            if (pnkalb.getArtist().equals(artist)) {
                pnkdur.add(pnkalb.totalAlbumDuration());
            }
        }
        return pnkdur;
    }
    //Method based on Steve's code demonstration
    // Added a return for the MAPPSGUI to be used for loading album collection
    public void load_albums(String file) throws Exception{
        
        try {
            File read = new File(file);
            Scanner scanner =  new Scanner(read);
            Album album = null;
            int i = 0;
            while (scanner.hasNextLine()){
                String line = scanner.nextLine();
                if ((i == 0 && !line.contains(" : ")) ||(i == 1 && !line.contains(" - ")) ){
                    throw new Exception("Invalid Album File!");
                }
                i++;
                
                if (!line.contains(" - ")){
                    album = new Album(line);
                    if (!albumExists(line)){
                        album_col.add(album);
                    }
                }
                else {
                    Track track = new Track(line);
                    album.addTrack(track);
                }
            }
            
        } catch (Exception ex) {
            Logger.getLogger(AlbumCollection.class.getName()).log(Level.SEVERE, null, ex);
            JOptionPane.showMessageDialog(null, "Try Again and only select Album Collection files.");
        }
        
    }
    //Method based on Steve's demonstration
    public Album getAlbByHeader(String header){
        for (Album album : album_col){
            if (album.getHeader().equals(header)){
                return album;
            }
        }
        return null;
    }
    
    public boolean albumExists (String header){
        
        for (Album album : album_col){
            
            if (album.getHeader().equals(header)){
                return true;
            }
        }
        return false;
    }
  
    public void SortAlbum (){
        Collections.sort(album_col);
    }
    
    @Override
    public String toString() {

        String alboutput = "";

        for (Album albums : album_col) {

            alboutput += albums.toString();
        }
        //return is based on Steve's demonstration
        return alboutput.trim();

    }   

    public static void main(String[] args) throws Exception {
        /*
       Testing the list of albums aplhabetically and calling 
       the load_albums method to ensure it works
        */
        AlbumCollection test = new AlbumCollection();
        test.load_albums("albums.txt");
        test.SortAlbum();
        //System.out.println(test);
        
        System.out.println("\n"+"The total duration of alubms for the Artist "
                + "Pink Flyod == " +test.ablum_duration("Pink Floyd"));
        System.out.println("\nHere is the ablum with the most tracks: \n"
                +test.getMostTracksAlbum());
        System.out.println("\nThe longest track is == "+ test.getLongest());
        //System.out.println("Testing ablum_duration method "+ test.ablum_duration("Pink Floyd"));
        System.out.println("getAlbByHeader method test "+test.getAlbByHeader("Pink Floyd : Animals"));        
        System.out.println("Dup test to find if a album alredy exists in a collection "
                +test.albumExists("Pink Floyd : Animals"));
}

}
