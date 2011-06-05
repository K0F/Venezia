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

//////////////////////////////

boolean backups = true;
int frameCycle = 60000;

boolean debug = true;

String render = P2D;

int PORT = 10000;

float R = 10;

float mini = 1600;
float maxi = 0;

float lastX = 0;
float lastY = 0;

float maxY = 0;

boolean retence = false;
boolean plot = false;

boolean fading = false;
boolean light = false;
boolean lightLast = false;
float illumS, illum;

int nodeCount = 0;
int blockCount = 0;

//////////////////////////////

World world;
DataParser parser;
DataDump dumper;
Plotter plotter;

ArrayList globNodes;
ArrayList blocks;
Receiver receiver;

//////////////////////////////

void setup() {
	size(1400*2, 1050, render);
	frame.setLocation(0, 0);
	//frame.setAlwaysOnTop(true);

	reset();
}

//////////////////////////////

void init() {
	frame.removeNotify();
	frame.setUndecorated(true);
	frame.addNotify();
	super.init();
}


//////////////////////////////
// make setup things here
void reset() {
	if (render == OPENGL) 
		hint(DISABLE_OPENGL_2X_SMOOTH);

	if (render == P2D){
		noSmooth();
		noCursor();
	}

	textFont(createFont("Verdana", 20, false));

	//	if (render == P2D)
	//		textMode(SCREEN);

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
	dumper = new DataDump("output/testDump.txt");
	//dumper.dumpBlocks(false);
	
	if (plot)
		plotter = new Plotter();

	//parser.loadCurrentVals();

	R /= world.scale;
	illum = illumS = 255;

	frameRate(30);	

	println("################################");
	println("###      VIZUAL RUNNING      ###");
	println("################################");	
	
	Block test = (Block)blocks.get(32);
	for(int i = 0;i<test.nodes.size();i++){
		Node n = (Node)test.nodes.get(i);
		//println("test pattern @ block "+test.id);
		print(" "+n.sum);

	}
	println("-------------------------------------- ^^");
}

//////////////////////////////

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

		for(int bl = 0;bl < blocks.size();bl++){
			Block block = (Block)blocks.get(bl);
			for (int i = 0 ;i< block.nodes.size();i+=1) {
				Node tmp = (Node)block.nodes.get(i);
				
				if (tmp.sum>maxi/10) {
					//stroke(map(tmp.sum, mini, maxi/2, 255, 0)); 
					float q = map(tmp.sum, mini, maxi, 0, 255);
					//line(tmp.position.x-R, tmp.position.y-R,tmp.position.x+R,tmp.position.y+R);
					//line(tmp.position.x+R, tmp.position.y-R,tmp.position.x-R,tmp.position.y+R);
					rect(tmp.position.x, tmp.position.y, q, q);
				}

				if (tmp.sum==maxi) {
					fill(0);
					text(tmp.id+" : "+tmp.blockNo, tmp.position.x, tmp.position.y);
				}
			}
		}
	}

	lightLast = light;

	light = false;
	int cnt = 0;

	// draw nodes here
	for(int bl = 0;bl < blocks.size();bl++){
		Block block = (Block)blocks.get(bl);
		for (int i = 0 ;i< block.nodes.size();i++) {

			Node tmp = (Node)block.nodes.get(i);
			tmp.draw2D();

			if (tmp.val>10)
				cnt ++;

			//if (retence) {
			mini += (min(tmp.sum, mini)-mini)/(nodeCount+0.0);
			maxi += (max(tmp.sum, maxi)-maxi)/(nodeCount+0.0);
			//}
		}
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
	if(backups)
		if(frameCount%frameCycle==0){
			dumpAndExit();
		}

	// world post draw routine
	world.postDraw();
}

//////////////////////////////

void dumpAndExit(){

	dumper.dumpBlocks(true);
	//exit();
}

void exit(){
	dumper.dumpBlocks(false);
	super.exit();
}

