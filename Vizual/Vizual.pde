/**
 *  Venezia 2011 Vizual by Kof
 */

import processing.opengl.*;

import oscP5.*;
import netP5.*;

boolean debug = false;

String render = OPENGL;

int PORT = 10000;

float R = 20;

float mini = 50;
float maxi = 0;

float lastX = 0;
float lastY = 0;

boolean plot = false;

World world;
DataParser parser;
DataDump dumper;
Plotter plotter;

ArrayList globNodes;

Receiver receiver;


void setup() {
  size(1920, 1080, render);
  reset();
}

// make setup things here
void reset() {
  if (render == OPENGL) 
    hint(DISABLE_OPENGL_2X_SMOOTH);

  if (render == P2D)
    smooth();

  textFont(createFont("Verdana", 7, false));

  if (render == P2D)
    textMode(SCREEN);

  rectMode(CENTER);



  //initialize world coordinates
  world = new World();

  //load default positions grid
  parser = new DataParser("foundation.2dg");

  //get nodes from parser
  globNodes = parser.getNodes();

  // init OSC listener class
  receiver = new Receiver(this, PORT);

  // init dump class
  dumper = new DataDump(globNodes, "output/testDump.txt");

  if (plot)
    plotter = new Plotter();
}

void draw() {
  if (plot) {
    plotter.draw();
  }
  else {
    background(0);
  }
  
  // world pre draw routine 
  world.preDraw();

  // draw nodes here
  for (int i = 0 ;i< globNodes.size();i++) {
    Node tmp = (Node)globNodes.get(i);
    tmp.draw2D();
    mini += (min(tmp.sum, mini)-mini)/globNodes.size();
    maxi += (max(tmp.sum, maxi)-maxi)/globNodes.size();
  }

  noStroke();

  for (int i = 0 ;i< globNodes.size();i++) {
    Node tmp = (Node)globNodes.get(i);

    stroke(255, map(tmp.sum, mini, maxi, 0, 90));
    strokeWeight(10);

    if (tmp.sum>maxi/5)
      ellipse(tmp.position.x, tmp.position.y, R*2, R*2);
  }



  // world post draw routine
  world.postDraw();
}




