/**
 *  Venezia 2011 Vizual by Kof
 */

import processing.opengl.*;

boolean debug = true;

String render = P2D;

World world;
DataParser parser;
DataDump dumper;
ArrayList globNodes;


void setup(){
    size(800,600,render);
    reset();

}

// make setup things here
void reset(){
    if(render == OPENGL) 
    hint(ENABLE_OPENGL_4X_SMOOTH);

    if(render == P2D)
    smooth();

    textFont(createFont("Verdana",7,false));
    
    if(render == P2D)
    textMode(SCREEN);

    //initialize world coordinates
    world = new World();

    //load default positions grid
    parser = new DataParser("foundation.2dg");
    
    //get nodes from parser
    globNodes = parser.getNodes();

    dumper = new DataDump(globNodes,"output/testDump.txt");
}

void draw(){
    background(0);


    // world pre draw routine 
    world.preDraw();


    // draw nodes here

    for(int i = 0 ;i< globNodes.size();i++){
        Node tmp = (Node)globNodes.get(i);
        tmp.draw2D();
    }


    // world post draw routine
    world.postDraw();

}

//////////////// World class 

class World{
    PVector position;
    float scale;

    World(){
        position = new PVector(0,0,0);
        scale = 1;

    }

    void preDraw(){
        pushMatrix();
        translate(position.x,position.y);
        scale(scale);
    }

    void postDraw(){
        popMatrix();

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

//////////////// DataDump class 

class DataDump{
    ArrayList nodes;
    String filename;

    DataDump(ArrayList _nodes,String _filename){
        nodes = _nodes;
        filename = _filename;
    }

    void dumpVals(){
        ArrayList data = new ArrayList(0);

        for(int i = 0 ;i < nodes.size();i++){
            Node n = (Node)nodes.get(i);
            String tmpCoord = ""+n.position.x+":"+n.position.y+":"+n.position.z;
            String tmpVal = " "+n.val+";";
            data.add(tmpCoord);
            data.add(tmpVal);
        }

        String dump[] = new String[data.size()];
        for(int i = 0 ;i< dump.length;i++){
            dump[i] = (String)data.get(i)+"";
        }

        saveStrings(filename,dump);
        
        if(debug)
            println("data ulozena do souboru: "+filename);
    }

}

//////////////// Node Class 

class Node{
    PVector position;
    int id;
    float val;
    float radius = 47.5;
    float fading = 30.0;
    boolean freeze = false;


    Node(int _id,float _x,float _y,float _z){
        id = _id;
        position = new PVector(_x,_y,_z);
        val = 0;

        if (debug)
            println("Creating node no "+id);
    }

    void draw2D(){

        if(!freeze)
        modVal();

        stroke(val);
        noFill();
        ellipse(position.x,position.y,radius,radius);
       
        int distance = 0;
        
        line(position.x,position.y,position.x+distance,position.y+distance);
         
        fill(255);
        text(val,position.x+distance,position.y+distance);
    }

    void draw3D(){
        stroke(255,val);
        noFill();
        sphere(radius);
    }

    void modVal(){
        val += (constrain(map(dist(mouseX,mouseY,position.x,position.y),0,90,255,0),0,255)-val)/fading;

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

class Grid{

}
