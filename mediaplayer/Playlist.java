package mediaplayer;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.DefaultListModel;

/**
 *
 * @author 100219034
 */
public class Playlist {

    private ArrayList<PlaylistTrack> track_list = new ArrayList<>();
    //Creating a new albumcollection that will be loaded for comparison
    // during the split process of playlist.txt
    private AlbumCollection albumcl;

    private DefaultListModel listmodel_playlist;

    public Playlist(AlbumCollection ac) {
        //Creates a new ArrayList of track lists and new AlbumCollection
        // for each time this constructor is called.
        this.albumcl = ac;
        this.track_list = new ArrayList<>();
    }

    public DefaultListModel getListModelPlaylist() {
        listmodel_playlist = new DefaultListModel();
        for (PlaylistTrack trk : track_list) {
            listmodel_playlist.addElement(trk.getDuration() + "_" + trk);
        }
        return this.listmodel_playlist;
    }

    public void addPlaylistToListModel(PlaylistTrack playlist) {
        track_list.add(playlist);
    }

    public void removePlaylistTrack(int index) {
                   track_list.remove(index);
    }

    public void removePlaylistFromListModel(PlaylistTrack playlisttrack) {
        listmodel_playlist.removeElement(playlisttrack);
    }

    /* 
    Method to load a playlist file and split the file
    to load it into the track_list array with the durations
    Based upon Steve's demonstration
     */
    public void load_playlist(String file) {
        try {
            File read = new File(file);
            Scanner scanner = new Scanner(read);
            Album album = null;
            while (scanner.hasNextLine()) {
                //Here is the first split to extract the name of the track
                String line = scanner.nextLine().trim();
                //example Europe Endless ("Europa Endlos") (Kraftwerk : Trans Europe Express)
                if (line.contains(") (")) {
                    String[] subparts = line.split("\\) \\(");
                    String track = subparts[0] + ")";//the split removes the ) so it needs to be added again
                    Album alb2 = albumcl.getAlbByHeader(subparts[1].replace(")", ""));
                    Duration dur = alb2.getDurByAlbTrkTtl(track);
                   
                    PlaylistTrack playlisttrack = new PlaylistTrack(dur, track, alb2);
                    track_list.add(playlisttrack);
                }
                else{
                //example Hanging on the Telephone (Blondie : Parallel Lines)
                line = line.replace(")", "");
                String[] parts = line.split(" \\(");
                String trk = parts[0];
                Album alb = albumcl.getAlbByHeader(parts[1]);
                Duration dur = alb.getDurByAlbTrkTtl(trk);
                PlaylistTrack plylsttrk = new PlaylistTrack(dur, trk, alb);
                track_list.add(plylsttrk);                    
                }
            }
        } catch (FileNotFoundException ex) {
            Logger.getLogger(AlbumCollection.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    //Method based on Steve's demonstration
    public void add(PlaylistTrack playlisttrack) {
        track_list.add(playlisttrack);
    }

    public void clearPlaylistCollection() {
        track_list.clear();
    }

    private ArrayList<PlaylistTrack> getPlaylist() {
        return track_list;
    }

    public Duration getPlaylistDur() {
        Duration duradd = new Duration();
        for (Track durtrk : track_list) {
            duradd.add(durtrk.getDuration());
        }

        return duradd;
    }

    @Override
    public String toString() {
        String playlist = "";
        for (int i = 0; i < track_list.size(); i++) {
            playlist += track_list.get(i) + "\n";

        }
        return "Playlist:\n" + playlist + "\n";
    }

    public static void main(String[] args) throws IOException, Exception {
        //Testing to load the playlist file and output the list 
        // with duration
        AlbumCollection ac = new AlbumCollection();
        ac.load_albums("albums.txt");
        Playlist test = new Playlist(ac);
        //File file = new File("playlist.txt");
        //test.load_albumcollection();
        //test.load_playlist("playlist.txt");
        test.load_playlist("playlist_test_brackets.txt");
        System.out.println(test);
        //Test of the total Playlist duration 
        System.out.println("My total Playlist time: "
                + test.getPlaylistDur());
//        System.out.println(test.track_list);
//        test.clearPlaylistCollection();
//        System.out.println("Cleared "+test);
    }
}
