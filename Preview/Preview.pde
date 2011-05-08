import oscP5.*;
import netP5.*;
import peasy.*;

boolean debug = false;

boolean showText = false;

String render = P3D;

PeasyCam cam;

float W,H;

World world;
DataParser parser;
ArrayList globNodes;

Receiver receiver;

void setup(){
    size(800,600,render);
    reset();


}

    void reset(){
        if(render == OPENGL) 
            hint(ENABLE_OPENGL_4X_SMOOTH);

        if(render == P3D)
            noSmooth();

        textFont(createFont("Verdana",7,false));

        if(render == P3D)
            textMode(SCREEN);




        //set initial width, height
        W = 0;
        H = 0;

        //load default positions grid
        parser = new DataParser("foundation.2dg");

        //get nodes from parser
        globNodes = parser.getNodes();



        //initialize world coordinates
        world = new World(0.25,0,0,0);

        // init OSC listener class
        receiver = new Receiver(this,12000);

        cam = new PeasyCam(this, 1500);
        cam.setMinimumDistance(1000);
        cam.setMaximumDistance(2000);

    }

void draw(){
    background(0);

    draw3D();

    draw2D();
}

void draw3D(){

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
