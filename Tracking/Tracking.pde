import oscP5.*;
import netP5.*;

import codeanticode.gsvideo.*;

GSPipeline pipeline;
Transmitter transmitter;



PImage maska;

boolean newMask = true;

String render = P2D;

float tresh =  8;

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
}

void draw() {
  //background(0);
  
  boolean hasNew = false;
  
  if (pipeline.available()) {
    pipeline.read();
    pipeline.loadPixels();
    image(pipeline, 0, 0);
    hasNew = true;
  }
  
  
  if(pipeline.pixels!=null)
  for(int i =0 ;i<senzory.size();i++){
   Senzor tmp = (Senzor)senzory.get(i);
   tmp.update(pipeline.pixels);
   tmp.draw(); 
  }
}

void mousePressed(){
 if(mouseButton==LEFT){
  senzory.add(new Senzor(senzory.size(),mouseX,mouseY));
 } 
  
}

void keyPressed(){
  if(keyCode == DELETE){
   senzory = new ArrayList(0); 
  }
}
