package mediaplayer;

import java.io.IOException;

/**
 *
 * @author 100219034
 */
public class AlbumInfoProgram  {
    public static void main(String[] args) throws IOException, Exception {
        AlbumCollection albumcol = new AlbumCollection();
        albumcol.load_albums("albums.txt");
        albumcol.SortAlbum();
        
        System.out.println("\nHere is my Album collection"+
                " in aplabetical order.\n"
                + albumcol);        
        System.out.println("\n"+"The total duration of alubms for the Artist "
                + "Pink Flyod == " + albumcol.ablum_duration("Pink Floyd"));
        System.out.println("\nHere is the ablum with the most tracks: \n"
                            +albumcol.getMostTracksAlbum());
        System.out.println("\nThe longest track is == "+ albumcol.getLongest()
                +"\n");
        //Loading and displaying the Playlist along with 
        // its total duration
        Playlist playlist = new Playlist(albumcol);
        playlist.load_playlist("playlist.txt");
        System.out.println("The Playlist total duration is-- " 
                + playlist.getPlaylistDur());
        
        
    } 
}
