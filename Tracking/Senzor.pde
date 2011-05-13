class Senzor {
  int x, y;
  int id;
  int val,lastVal;
  boolean change = false;


  Senzor(int _id, int _x, int _y) {
    x = _x;
    y = _y;
    id = _id;
    val = lastVal = 0;
    
    println("adding senzor no: "+id+" on X:"+x+"  Y: "+y);
  }

  void update(int [] pix) {
    val = (int)brightness(pix[y*width+x]);
    change = changed();
    mem();
  }

  void mem() {
    lastVal = val;
  }


  boolean changed() {
    if (abs(val-lastVal)>tresh) {
      return true;
    } 
    else {
      return false;
    }
  }

  void draw() {
    
    if(change)
    fill(#ff0000);
    else
    fill(#ffcc00);
    
    noStroke();
    rect(x, y, 2, 2);
    text(id+" ---> "+val,x+3,y+3);
  }
}

