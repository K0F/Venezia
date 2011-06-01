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

import oscP5.*;
import netP5.*;

import codeanticode.gsvideo.*;

GSPipeline pipeline;
Transmitter transmitter;

int PORT = 10000;

// mode , 0 = static, 1 = interacrive
int MODE = 1;

boolean showImage = true;
boolean loadState = true;

PImage maska;

boolean newMask = true;

String render = P2D;

float tresh =  29;

int RES = 200;

Grid grid;
ArrayList senzory = new ArrayList(0);

int W = 1280; //1280/2;
int H = 720; //1024/2;

String ipcam = "rtspsrc location=rtsp://192.168.0.20:554/h264 latency=0 ! decodebin  ";

//"video/x-raw-rgb, width="+W+", height="+H+", bpp=32, depth=24";

void setup() {
	size(W, H,P2D);
	reset();
}

void reset(){
	textFont(createFont("Verdana",7,false));

	if(render == P2D)
		textMode(SCREEN);

	rectMode(CENTER);

	cursor(CROSS);

	transmitter = new Transmitter(this,"127.0.0.1",5555); 

	pipeline = new GSPipeline(this, ipcam);
	pipeline.play();

	grid = new Grid(RES,MODE);
	
        if(loadState){
          String [] raw = loadStrings("gridPos.txt");
          grid.sx = parseInt(raw[0]);
          grid.sy = parseInt(raw[1]);
          grid.ex = parseInt(raw[2]);
          grid.ey = parseInt(raw[3]);
          grid.generateBox();
        }
        senzory = grid.getSenzors();

	println("################################");
	println("###     TRACKING RUNNING     ###");
	println("################################");

}

void draw() {
	//background(0);

	boolean hasNew = false;

	if (pipeline.available()) {
		pipeline.read();
		pipeline.loadPixels();

		if(showImage)
			image(pipeline, 0, 0);
		hasNew = true;


		if(grid.selectArea){
			stroke(#ff0000);
			noFill();

			grid.ex = mouseX-grid.sx;
			grid.ey = mouseY-grid.sy;

			rectMode(CORNER);
			rect(grid.sx,grid.sy,grid.ex,grid.ey);

			rectMode(CENTER);

			//	pushStyle();
			for(int y = grid.sy; y < mouseY; y += grid.res){
				for(int x = grid.sx ; x < mouseX ; x+= grid.res){
					rect(x,y,3,3);

				}

			}
			//	popStyle();


		}



	}


	if(pipeline.pixels!=null)
		for(int i = 0 ;i<senzory.size();i++){
			Senzor tmp = (Senzor)senzory.get(i);
			tmp.update(pipeline.pixels);
			tmp.draw(); 
		}
}

void mousePressed(){
	if(MODE==1){
		grid.sx = mouseX;
		grid.sy = mouseY;
		grid.selectArea = true;
	}


	/*}else{

	  if(mouseButton==LEFT){
	  senzory.add(new Senzor(senzory.size(),mouseX,mouseY));
	  } 
	  }*/

}

void mouseReleased(){
	if(MODE==1){
		grid.selectArea = false;
		grid.generateBox();
		grid.ex = mouseX;
		grid.ey = mouseY;	
	}

}

void keyPressed(){
	if(keyCode == DELETE){
		senzory = new ArrayList(0); 
	}
}
