//////////////// World class 
class World{
    PVector position;
    float scale;

    World(float _scale,float _x,float _y,float _z){
        position = new PVector(_x,_y,_z);
        scale = _scale;

    }

    void preDraw2D(){
        pushMatrix();
        translate(position.x,position.y,position.z);
        scale(scale);
    }

    void postDraw2D(){
        popMatrix();

    }
    
    void preDraw3D(){
        pushMatrix();
        translate(-W/2,-H/2);
        //scale(scale);
    }

    void postDraw3D(){
        popMatrix();

    }

}
