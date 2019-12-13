/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mediaplayer;

/**
 *
 * @author 100219034
 * Code is from on http://introcs.cs.princeton.edu/java/faq/mp3/MP3.java.html
 */


import java.io.BufferedInputStream;
import java.io.FileInputStream;
import javax.swing.JOptionPane;

import javazoom.jl.player.Player;


public class MP3 {
    private String filename;
    private Player player;
    private volatile boolean stop = false;

    // constructor that takes the name of an MP3 file
    public MP3(String filename) {
        this.filename = filename;
        
    }
    
    // Close method will close the thread open from the play method
    public void Close() { if (player != null) player.close(); }
    
    //Stop method will stop a song from playing
    public void Stop(){
        stop = true;
        
    }
    // play the MP3 file to the sound card
    public void play() {
        try {
            FileInputStream fis     = new FileInputStream(filename);
            BufferedInputStream bis = new BufferedInputStream(fis);
            player = new Player(bis);
            
        }
        catch (Exception e) {
            JOptionPane.showMessageDialog(null, "No MP3 File Found!");
            //System.out.println("Problem playing file " + filename);
            //System.out.println(e);
        }

        // run in new thread to play in background
        new Thread() {
            @Override
            public void run() {
                
                try {
                    while(!stop){
                    player.play(); 
                    }
                }
                catch (Exception e) { System.out.println(e); }
            }
        }.start();

    }


    // test client to see if play method works as well as Close method
    public static void main(String[] args) {
        String filename = "F:\\KDD\\Application Programming\\Coursework 2\\Music Album and Playlist Playing System\\Music\\Lovira_-_01_-_All_things_considered.mp3";
        MP3 mp3 = new MP3(filename);
        mp3.play();

        // do whatever computation you like, while music plays
        int N = 4000;
        double sum = 0.0;
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                sum += Math.sin(i + j);
            }
        }
        System.out.println(sum);

        // when the computation is done, stop playing it
        mp3.Close();

        // play from the beginning
        mp3 = new MP3(filename);
        mp3.play();

    }

}
