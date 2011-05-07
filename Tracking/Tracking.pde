import oscP5.*;
import netP5.*;

import codeanticode.gsvideo.*;

Transmitter transmitter;
GSPipeline pipe;

float tresh =  127;

int W = 320;//1280/2;
int H = 240;//1024/2;

PImage maska;

boolean newMask = true;

String pipeline = "v4l2src device=/dev/video2 ! "+
"ffmpegcolorspace ! "+
"queue2 ! "+
"video/x-raw-rgb, width="+W+", height="+H+", bpp=32, depth=24";

String ipcam = "rtspsrc location=rtsp://10.0.0.10:554/low latency=0 ! decodebin ! ffmpegcolorspace ! queue ! "+
"video/x-raw-rgb, width="+W+", height="+H+", bpp=32, depth=24";

String ipcam2 = "rtspsrc location=rtsp://10.0.0.10:554/low latency=5 ! decodebin ! ffmpegcolorspace "+
"video/x-raw-rgb, width="+W+", height="+H+", bpp=32, depth=24";


void setup()
{
  size(W,H);
  reset();
}

void reset() {

  frameRate(25);


  rectMode(CENTER);

  transmitter = new Transmitter(this,"127.0.0.1",5555);


  maska = createImage(W,H,RGB);
  pipe = new GSPipeline(this, ipcam);

  background(0);
}

void draw() {

  //if(frameCount%50==0)
  // newMask=true;

  try {

    if (pipe.available()) {
      pipe.read();
      pipe.loadPixels();

      maska.loadPixels();


      if(newMask) {
        //  maska = createImage(W,H,RGB);

        for(int i =0;i<pipe.pixels.length;i++) {
          maska.pixels[i] = pipe.pixels[i];
        }

        newMask = false;
      }


      for(int i =0;i<pipe.pixels.length;i++) {
        float change = abs(brightness(pipe.pixels[i])-brightness(maska.pixels[i]));
        if(change>tresh)
          pipe.pixels[i] = 0xffffffff;
        else
          pipe.pixels[i] = 0xff000000;
      }
      //tint(255,55);
      //image(pipe,0, 0);


      transmitter.transmitData(pipe);


      //set(0,0,pipe);
    }
  }
  catch(Exception e) {
    println(e);
  }
}

void keyPressed() {
  newMask = true;
}

void keyReleased() {
  newMask = false;
}

