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

String test = "videotestsrc";

String pipeline = "v4l2src device=/dev/video2 ! "+
"ffmpegcolorspace ! "+
"queue2 ! "+
"video/x-raw-rgb, width="+W+", height="+H+", bpp=32, depth=24";

String ipcam = "rtspsrc location=rtsp://192.168.0.20:554/h264 latency=10 ! decodebin ! ffmpegcolorspace ";
//"video/x-raw-rgb, width="+W+", height="+H+", bpp=32, depth=24";

String ipcam2 = "rtspsrc location=rtsp://10.0.0.10:554 latency=5 ! decodebin ! ffmpegcolorspace "+
"video/x-raw-rgb, width="+W+", height="+H+", bpp=32, depth=24";

String vfs = "gnomevfssrc location=http://192.168.1.10/axis-cgi/mjpg/video.cgi?resolution=640x480 ! jpegdec ! ffmpegcolorspace";

void setup()
{
  size(W, H);
  reset();
}

void reset() {

  frameRate(25);


  rectMode(CENTER);

  // transmitter = new Transmitter(this,"127.0.0.1",5555);


  maska = createImage(W, H, RGB);
  pipe = new GSPipeline(this, test);

  background(0);
}

void draw() {
  if (pipe.available()) {
    println("bang");
    pipe.read();
    image(pipe, 0, 0);
  }
}

void keyPressed() {
  newMask = true;
}

void keyReleased() {
  newMask = false;
}

