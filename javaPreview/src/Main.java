import processing.core.*;
import java.util.ArrayList;
import oscP5.*;
import netP5.*;
import peasy.*;

public class Main extends PApplet{

    boolean debug = false;

    boolean showText = false;

    String render = P3D;

    PeasyCam cam;

    float W,H;

    World world;
    DataParser parser;
    ArrayList globNodes;
    Brush brush;

    Receiver receiver;

    public void setup(){
        size(800,600,render);
        reset();


    }

    public void reset(){
        if(render == OPENGL) 
            hint(ENABLE_OPENGL_4X_SMOOTH);

        if(render == P3D)
            noSmooth();

        textFont(createFont("Verdana",7,false));

        if(render == P3D)
            textMode(SCREEN);


        brush = new Brush("peak.png");

        //set initial width, height
        W = 0;
        H = 0;

        //load default positions grid
        parser = new DataParser("foundation.2dg");

        //get nodes from parser
        globNodes = parser.getNodes();



        //initialize world coordinates
        world = new World(0.25f,0,0,0);

        // init OSC listener class
        receiver = new Receiver(this,12000);

        cam = new PeasyCam(this, 1500);
        cam.setMinimumDistance(1000);
        cam.setMaximumDistance(2000);

    }

    public void draw(){
        background(0);

        draw3D();

        draw2D();
    }

    public void draw3D(){

        pushMatrix();
        translate(0,width/3);

        world.preDraw3D();

        for(int i = 0 ;i< globNodes.size();i++){
            Node tmp = (Node)globNodes.get(i);
            tmp.draw3D();
        }

        world.postDraw3D();

        popMatrix();

    }

    void draw2D(){

        cam.beginHUD();
        // world pre draw routine 
        world.preDraw2D();

        // draw nodes here

        for(int i = 0 ;i< globNodes.size();i++){
            Node tmp = (Node)globNodes.get(i);
            tmp.draw2D();
        }

        // world post draw routine
        world.postDraw2D();

        cam.endHUD();
    }


    class Brush{
        String filename;
        PImage peak;
        int profil[];

        Brush(String _filename){
            filename = _filename;
            peak = loadImage(filename);
            profil = new int[peak.width];

            analyze();
        }

        void analyze(){
            peak.loadPixels();

            for(int x = 0;x < profil.length ;x++){
                boolean gotWhite = false;

                for(int y = 0 ;y<peak.height;y++){
                    if(peak.pixels[y*peak.width+x] == 0xffffffff){
                        profil[x] = peak.height-y;
                        gotWhite = true;
                        break;
                    }
                }

                if(!gotWhite){
                    profil[x] = 0;
                }
            }


            println(profil);

        }

    }

    //////////////// DataParser class

    class DataParser{
        String rawData [];
        String filename;

        ArrayList coords;
        ArrayList nodes;

        DataParser(String _filename){
            filename = _filename;
            rawData = loadStrings(filename);

            parseVals(rawData);
            castNodes();

        }

        // parse a valuse from given data set
        void parseVals(String data[]){
            ArrayList tmp = new ArrayList();
            for(int i = 0;i<data.length;i+=2){
                tmp.add((String)data[i]);
            }


            coords = new ArrayList(0);

            for(int i = 0; i<tmp.size();i++){
                String cline = (String)tmp.get(i);
                String[] parsed = splitTokens(cline," :	");
                coords.add(new PVector(parseFloat(parsed[0]),parseFloat(parsed[1]),parseFloat(parsed[2])));
            }
        }

        void castNodes(){
            nodes = new ArrayList(0);
            for(int i = 0;i<coords.size();i++){
                PVector current = (PVector)coords.get(i);
                nodes.add(new Node(i,current.x,current.y,current.z));

            }

        }

        ArrayList getNodes(){
            return nodes;
        }
    }


    // r = reset

    public void keyPressed(){
        if(key != CODED){
            if(key=='r' || key == 'R'){
                resetVals(); 
            }
        } 

    }

    // reset all values to its original position
    void resetVals(){
        for(int i = 0;i<globNodes.size();i++){
            Node n = (Node)globNodes.get(i);
            n.val = 0;
            n.position.z = n.basez;  
        }   
    }
    //////////////// Node Class 

    class Node{
        PVector position;
        int id;
        float val;
        float radius = 47.5f;
        float fading = 30.0f;
        boolean freeze = false;

        float modrange = 500;

        float basez;

        Node(int _id,float _x,float _y,float _z){
            id = _id;
            position = new PVector(_x,_y,_z);
            val = 0;

            W = max(W,position.x);
            H = max(H,position.y);

            basez = position.z;

            if (debug)
                println("Creating node no "+id);
        }

        void draw2D(){

            if(!freeze)
                modVal();

           stroke(lerpColor(0xffffffff,0xffffcc00,norm(val,0,255)),100);
            noFill();
            ellipse(position.x,position.y,radius,radius);

            int distance = 0;

            line(position.x,position.y,position.x+distance,position.y+distance);


            if(showText){
                fill(255);
                text(val,position.x+distance,position.y+distance);
            }  
        }

        void draw3D(){
            pushMatrix();
            fill(lerpColor(0xff333333,0xffffcc00,norm(val,0,255)),220);
            stroke(0);
            translate(position.x,position.y,position.z);
            box(radius);

            popMatrix();
        }

        void modVal(){
            float newVal = brush.profil[(int)constrain(map(dist(mouseX/world.scale,mouseY/world.scale,position.x,position.y),0,modrange,brush.peak.width,0),0,brush.profil.length-1)];

            if(newVal>val){
                val += (newVal-val)/fading;
                position.z = val + basez;
            }
        }

        void setFreeze(){
            freeze = true;
        }

        void releaseFreeze(){
            freeze = false;
        }

        void setVal(int _val){
            val = _val;
        }


    }

    class Receiver {
        PApplet parent;
        OscP5 osc;
        int port;

        Receiver(PApplet _parent,int _port) {
            parent = _parent;
            port = _port;

            osc = new OscP5(parent,port);

        }

    }

    void oscEvent(OscMessage theOscMessage) {

        if(theOscMessage.addrPattern().equals("/tracking")){
            String tmp = theOscMessage.typetag();

            if(debug)
                println("values received: " + tmp.length());

            if(tmp.length()>0){

                int [] rawvals = new int[tmp.length()];
                for(int i = 0;i<tmp.length();i++){
                    rawvals[i] = theOscMessage.get(i).intValue();
                }

                for(int y = 0;y < 240;y++){
                    for(int x = 0;x < 320;x++){
                        for(int i = 0 ;i<rawvals.length;i++)
                            if(rawvals[i] == y*320+x){
                                rect(x,y,1,1);
                            }
                    }
                }


            }
        }else{
            if(debug)
                println("WARNING: receiving wrong tracking data!");
        }


    }

    //////////////// World class 
    class World{
        PVector position;
        float scale;

        World(float _scale,float _x,float _y,float _z){
            position = new PVector(_x,_y,_z);
            scale = _scale;

        }

        void preDraw2D(){
            pushMatrix();
            translate(position.x,position.y,position.z);
            scale(scale);
        }

        void postDraw2D(){
            popMatrix();

        }

        void preDraw3D(){
            pushMatrix();
            translate(-W/2,-H/2);
            //scale(scale);
        }

        void postDraw3D(){
            popMatrix();

        }

    }

    public static void main(String args[]){
        PApplet.main(new String[]{"--present","Main"});

    }
}
