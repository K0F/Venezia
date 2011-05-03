import codeanticode.gsvideo.*;

GSPipeline pipe;

float tresh =  100;

int W = 320;//1280/2;
int H = 240;//1024/2;

PImage maska;

boolean newMask = true;

String pipeline = "v4l2src device=/dev/video2 ! "+
"ffmpegcolorspace ! "+
"queue2 ! "+
"video/x-raw-rgb, width="+W+", height="+H+", bpp=32, depth=24";

String ipcam = "rtspsrc location=rtsp://10.0.0.102:554 latency=0 ! decodebin ! ffmpegcolorspace ! queue ! "+
"video/x-raw-rgb, width="+W+", height="+H+", bpp=32, depth=24";

String ipcam2 = "rtspsrc location=rtsp://10.0.0.102:554/low latency=5 ! decodebin ! ffmpegcolorspace "+
"video/x-raw-rgb, width="+W+", height="+H+", bpp=32, depth=24";


void setup()
{
  size(W,H,P2D);
  frameRate(50);

  rectMode(CENTER);

  maska = createImage(W,H,RGB);
  pipe = new GSPipeline(this, ipcam);
}

void draw() {

  //if(frameCount%50==0)
  // newMask=true;

  try {

    if (pipe.available() && frameCount%5==0) {
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
          pipe.pixels[i] = color(255);
        else
          pipe.pixels[i] = color(0);
      }
      tint(255,5);
      image(pipe, 0, 0);




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

