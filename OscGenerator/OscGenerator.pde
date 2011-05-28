import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress broadcast;

float speed = 0.1;
float maxSpeed = 1.0;

int cycle = 2;

int num = 3;
ArrayList gen;


void setup(){
    size(640,240,P2D);
    oscP5 = new OscP5(this,5555);
    rectMode(CENTER);
    noFill();
    stroke(#FFFFFF);
   
    gen = new ArrayList(0); 
    for(int i = 0;i<num;i++){
        gen.add(new Generator(i));

    }
    broadcast = new NetAddress("192.168.0.255",10000);


}

void draw(){
    background(0);
    
    for(int i = 0; i< gen.size();i++){
        Generator tmp = (Generator)gen.get(i);
        tmp.update();
        tmp.draw();

        if(frameCount%cycle==0)
        tmp.send();
    }


}

class Generator{
       PVector vel;
       PVector pos;
       PVector acc;

       float blockId;
       int id;

       Generator(int _id){
            id =_id;
           
            pos = new PVector(random(width),random(height));
            acc = new PVector(random(-speed,speed),random(-speed,speed));
            vel = new PVector(0,0);
       }

       void update(){
            border();
            
            pos.add(vel);
            acc.add(new PVector(random(-speed,speed),random(-speed,speed)));
            vel.add(acc);
            vel.limit(maxSpeed);
       }

       void draw(){
            rect(pos.x,pos.y,3,3);
       }

       void send(){
           OscMessage msg = new OscMessage("/tracknig");
           msg.add(map(pos.x,0,width,0,1));
           msg.add(map(pos.y,0,height,0,1));

           oscP5.send(msg,broadcast);
       }

       void border(){
            if(pos.x>width) pos.x = 0;
            if(pos.x<0) pos.x = width;
            if(pos.y>height) pos.y = 0;
            if(pos.y<0) pos.y = height;

       }


}
