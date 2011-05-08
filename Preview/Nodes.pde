//////////////// Node Class 

class Node{
    PVector position;
    int id;
    float val;
    float radius = 47.5;
    float fading = 30.0;
    boolean freeze = false;

    float modrange = 220;

    float basez;

    Node(int _id,float _x,float _y,float _z){
        id = _id;
        position = new PVector(_x,_y,_z);
        val = 0;
        
        W = max(W,position.x);
        H = max(H,position.y);
        
        basez = position.z;
        
        if (debug)
            println("Creating node no "+id);
    }

    void draw2D(){

        if(!freeze)
        modVal();

        stroke(lerpColor(#ffffff,#ffcc00,norm(val,0,255)),100);
        noFill();
        ellipse(position.x,position.y,radius,radius);
       
        int distance = 0;
        
        line(position.x,position.y,position.x+distance,position.y+distance);
         
         
         if(showText){
        fill(255);
        text(val,position.x+distance,position.y+distance);
         }  
  }

    void draw3D(){
      pushMatrix();
        stroke(lerpColor(#ffffff,#ffcc00,norm(val,0,255)),100);
        noFill();
        translate(position.x,position.y,position.z);
        box(radius);
        
        popMatrix();
    }

    void modVal(){
        float newVal = constrain(map(dist(mouseX/world.scale,mouseY/world.scale,position.x,position.y),0,modrange,255,0),0,255);

        if(newVal>val){
            val += (newVal-val)/fading;
            position.z = val + basez;
        }
    }

    void setFreeze(){
        freeze = true;
    }

    void releaseFreeze(){
        freeze = false;
    }

    void setVal(int _val){
        val = _val;
    }


}
