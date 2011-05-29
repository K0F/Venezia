/**
 *  Code by Krystof Pesek, licensed under Creative Commons Attribution-Share Alike 3.0 license.
 *  License: http://creativecommons.org/licenses/by-sa/3.0/
 *
 * visit more @ http://vimeo.com/kof
 * if you leave this header, bend, share, spread the code, it is a freedom!
 *
 *   ,dPYb,                  ,dPYb,
 *   IP'`Yb                  IP'`Yb
 *   I8  8I                  I8  8I
 *   I8  8bgg,               I8  8'
 *   I8 dP" "8    ,ggggg,    I8 dP
 *   I8d8bggP"   dP"  "Y8ggg I8dP
 *   I8P' "Yb,  i8'    ,8I   I8P
 *  ,d8    `Yb,,d8,   ,d8'  ,d8b,_
 *  88P      Y8P"Y8888P"    PI8"8888
 *                           I8 `8,
 *                           I8  `8,
 *                           I8   8I
 *                           I8   8I
 *                           I8, ,8'
 *                            "Y8P'
 *
 */

import processing.opengl.*;

import oscP5.*;
import netP5.*;

boolean debug = false;

String render = P2D;

int PORT = 10000;

float R = 10;

float mini = 1600;
float maxi = 0;

float lastX = 0;
float lastY = 0;

boolean retence = false;
boolean plot = false;

boolean fading = false;
boolean light = false;
boolean lightLast = false;
float illumS, illum;

World world;
DataParser parser;
DataDump dumper;
Plotter plotter;

ArrayList globNodes;

Receiver receiver;


void setup() {
	size(1680*2, 1050, render);
	frame.setLocation(0, 0);
	//frame.setAlwaysOnTop(true);

	reset();
}

void init() {


	frame.removeNotify();
	frame.setUndecorated(true);
	frame.addNotify();
	super.init();
}

// make setup things here
void reset() {
	if (render == OPENGL) 
		hint(DISABLE_OPENGL_2X_SMOOTH);

	if (render == P2D)
		noSmooth();

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

	R /= world.scale;
	illum = illumS = 255;
}

void draw() {

	if (fading) {
		background(illumS);
		illumS += (illum-illumS)/30.0;
	}
	else {
		background(255);
	}

	// world pre draw routine 
	world.preDraw();
	if (retence) {
		for (int i = 0 ;i< globNodes.size();i++) {
			Node tmp = (Node)globNodes.get(i);



			if (tmp.sum>maxi/10) {
				stroke(map(tmp.sum, mini, maxi, 255, 127)); 
				//line(tmp.position.x-R, tmp.position.y-R,tmp.position.x+R,tmp.position.y+R);
				//line(tmp.position.x+R, tmp.position.y-R,tmp.position.x-R,tmp.position.y+R);
				ellipse(tmp.position.x, tmp.position.y, R*2, R*2);
			}

			if (tmp.sum==maxi) {
				fill(0);
				text(tmp.id+" : "+tmp.blockNo, tmp.position.x, tmp.position.y);
			}
		}
	}

	lightLast = light;

	light = false;
	int cnt = 0;

	// draw nodes here
	for (int i = 0 ;i< globNodes.size();i++) {
		Node tmp = (Node)globNodes.get(i);
		tmp.draw2D();

		if (tmp.val>10)
			cnt ++;

		//if (retence) {
			mini += (min(tmp.sum, mini)-mini)/globNodes.size();
			maxi += (max(tmp.sum, maxi)-maxi)/globNodes.size();
		//}
	}

	if (fading) {
		if (cnt>200)
			light = true;
		else
			light = false;

		if (light && !lightLast) {
			illum = 255;
		}
		else if (!light && lightLast) {
			illum = 50;
		}
		else if (!light && !lightLast) {
			illum = 50;
		}
	}

	//ssh trigger, no key input
	if(frameCount%200==0){
		dumpAndExit();
	}


	// world post draw routine
	world.postDraw();
}

void dumpAndExit(){
	dumper.dumpBlocks();
	//exit();

}

