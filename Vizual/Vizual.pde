/**
 *  Venezia 2011 Vizual by Kof
 */

import processing.opengl.*;
import oscP5.*;
import netP5.*;

boolean debug = false;

String render = P2D;

int PORT = 10000;

float R = 50;

World world;
DataParser parser;
DataDump dumper;
ArrayList globNodes;

Receiver receiver;


void setup(){
    size(1920,1080,render);
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
    
    // init OSC listener class
    receiver = new Receiver(this,PORT);

    // init dump class
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

