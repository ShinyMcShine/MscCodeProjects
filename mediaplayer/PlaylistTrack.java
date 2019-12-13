package mediaplayer;

/**
 *
 * @author 100219034
 */
public class PlaylistTrack extends Track {

    private Album AlbumofTrack;

    public PlaylistTrack(Duration duration, String track, Album album) {
        super(duration, track);
        this.AlbumofTrack = album;
    }

    //Returns the Album object    
    public Album getAlbumofTrack() {
        return this.AlbumofTrack;
    }
    //Based on Steve's demonstration
    @Override
    public String toString() {

        return getTrack() + " ("+ AlbumofTrack.getHeader() + ")";
    }

    public static void main(String[] args) {
        //Testing the class submitting parameters to the constructor and then 
        // calling the toString method    
        Album alb = new Album("Pink Floyd", "Dark Side of the Moon");
        Album alb2 = new Album("Pink Floyd", "Animals");
        Duration dur = new Duration();
        PlaylistTrack aot = new PlaylistTrack(dur, "The Great Gig in the Sky", alb);
        PlaylistTrack aot2 = new PlaylistTrack(dur,"Pigs (Three Different Ones)",alb2);
        System.out.println(aot);
        System.out.println(aot2.getAlbumofTrack());

    }
}
