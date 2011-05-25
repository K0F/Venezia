//////////////// Node Class
class Node{
	PVector position;
	int id;
	float val;
	float radius = 47.5;
	float fading = 40.0;
	int sum = 0;
	int blockNo;
	boolean freeze = false;


	Node(int _id,int _blockNo,float _x,float _y,float _z){
		id = _id;
		position = new PVector(_x,_y,_z);
		val = 0;
		blockNo = _blockNo;

		if (debug)
			println("Creating node no "+id);
	}

	void draw2D(){

		if(!freeze)
			modVal();


		noStroke();//stroke(255,120);//stroke(0,val);
		fill(0,val/2);

		if(val>20)
			ellipse(position.x,position.y,val/2,val/2);

		int distance = 0;

	}

	void draw3D(){
		stroke(255,val);
		noFill();
		sphere(radius);
	}


	// modval every frame
	void modVal(){
		//val += (constrain(map(dist(mouseX,mouseY,position.x,position.y),0,90,255,0),0,255)-val)/fading;
		if(val>0)
			val += (-val)/fading;
	}

	// set frozen state to neode
	void setFreeze(){
		freeze = true;
	}

	// release frozen state
	void releaseFreeze(){
		freeze = false;
	}

	// set value of
	void setVal(int _val){
		val = _val;
	}
}






