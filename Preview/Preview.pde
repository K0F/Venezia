mport processing.opengl.*;
import oscP5.*;
import netP5.*;
import peasy.*;

boolean debug = false;

boolean showText = false;

int PORT = 10000;

String render = OPENGL;

PeasyCam cam;

float W,H;

String filename = "bloky.2dg";

World world;
DataParser parser;
ArrayList globNodes;
Brush brush;

Receiver receiver;


void setup(){
    size(1024,768,render);
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


        brush = new Brush("peak.png");

        //set initial width, height
        W = 0;
        H = 0;

        //load default positions grid
        parser = new DataParser(filename);

        //get nodes from parser
        globNodes = parser.getNodes();



        //initialize world coordinates
        world = new World(0.25,0,0,0);

        // init OSC listener class
        receiver = new Receiver(this,PORT);

        cam = new PeasyCam(this, 5000);
        //cam.setMinimumDistance(1000);
        //cam.setMaximumDistance(2000);

        int mid = (int)(globNodes.size()/2.0);
        Node midN = (Node)globNodes.get(mid);
        //cam.lookAt(midN.position.x,midN.position.y,midN.position.z+midN.val);


        //cam.setRotations(0,45,30);
    }

void draw(){
    background(0);


    lights();


    draw3D();

    // draw2D();
    save(hour()+"_"+minute()+"_"+second()+".png");
    exit();
}

void draw3D(){

    pushMatrix();
    translate(0,0);

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
