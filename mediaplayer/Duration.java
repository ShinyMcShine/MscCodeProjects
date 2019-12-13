package mediaplayer;

/**
 *
 * @author 100219034
 */
import java.text.*;
//using implements Compareable so I can sort durations  
// to find the largest duration
public class Duration implements Comparable<Duration> {

    private int hours;
    private int minutes;
    private int seconds;
    public static DecimalFormat trackformat
            = new DecimalFormat("00");

    //Default Construtor to set hours, minutes, and seconds to 00   
    public Duration() {
        hours = 0;
        minutes = 0;
        seconds = 0;
    }

    /*
A second constructor to accept intergers for 
hours, minutes, and seconds and set the values to 
a current instance of hours, minutes, and seconds
     */
    public Duration(int hours, int minutes, int seconds) {
        this.hours = hours;
        this.minutes = minutes;
        this.seconds = seconds;
        OOR_Dur();

    }
    //method is based on Steve's demo of AlbumInfo program
    private void OOR_Dur() {
        
        int ttl_secs = toSeconds();
        hours = ttl_secs / 3600;
        minutes = (ttl_secs % 3600) / 60;
        seconds = ttl_secs % 60;
        
    }


    /*
This method will accept a string representing hours, 
minutes, and seconds and split them up into their 
respective interger variables
     */
    public Duration(String hhmmss) {
        String playtime[] = hhmmss.split(":");
        hours = Integer.parseInt(playtime[0]);
        minutes = Integer.parseInt(playtime[1]);
        seconds = Integer.parseInt(playtime[2]);
        OOR_Dur();
    }

    /*
    This compare function will take two durations and 
    return a integer based upon their match results
     */
    @Override
    public int compareTo(Duration dur) {
        /*
        converts the hours minutes and seconds into total seconds 
        for compare if the left is greater then that right a 1 
        is returned if they are equal a zero is returned
        if the left is less than the right a -1 is returned
        */
                
        return Integer.compare(this.toSeconds(), dur.toSeconds());
    }
//Get methods to retrive each section  of a duration

    public int getHours() {
        return this.hours;
    }

    public int getMinutes() {
        return this.minutes;
    }

    public int getSeconds() {
        return this.seconds;
    }
    
    private int toSeconds() {
        return hours * 3600 + minutes * 60 + seconds;
    }
//My toString for converting the hours minutes and 
// seconds in a decimal format of 00:00:00

    @Override
    public String toString() {

        return trackformat.format(hours) + ":"
                + trackformat.format(minutes) + ":"
                + trackformat.format(seconds);

    }

// my add method to take two durations and add them together
    public void add(Duration d) {
        hours = this.hours += d.hours;
        minutes = this.minutes += d.minutes;
        seconds = this.seconds += d.seconds;
        OOR_Dur();
        

    }

    public static void main(String[] args) {
        //Testing showing the add method to and split fucntion
        Duration d1 = new Duration("00:03:21");
        Duration d2 = new Duration("00:01:40");
        Duration d3 = new Duration("00:4:15");
        // d4 is used to test the default method
        Duration d4 = new Duration();
        //d5 is used to test the OOR range normalizing string data entry
        Duration d5 = new Duration("01:360:220");
        // d6 is testing OOR range normalizeing int data entry
        Duration d6 = new Duration(3,120,500);
        //Showing default duration when nothing is passed
        System.out.println("\n");
        System.out.println("Default Duration: " + d4);
        //Showing how the add method works between two durations
        System.out.println("\n");
        System.out.println(d1);
        System.out.println("Plus");
        System.out.println(d2);
        d1.add(d2);
        System.out.println("============");
        System.out.println(d1);
        System.out.println("Plus");
        System.out.println(d3);
        //Adding another duration showing that it can collect a sum
        d1.add(d3);
        System.out.println("============");
        System.out.println(d1);
        System.out.println("\n");
        System.out.println("Nomalizing data entry of a string to deal with OOR values: " + d5+"\n");
        System.out.println("Nomalizing data entry of int values to deal with OOR values: " + d6 );
        
        //This shows the compare between to tracks works correctly
        System.out.println("\nMy compare results is between d1 "
                + d1 + " and d2 " + d2 + " : " + d1.compareTo(d2));
    }




}
