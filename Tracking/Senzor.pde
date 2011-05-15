class Grid {
  ArrayList s = new ArrayList(0);
  String filename;
  int res;

  Grid(int _res) {
    res = (int)(W/_res);
    int cnt = 0;
    for (int y = 0;y<H;y+=res) {
      for (int x = 0;x<W;x+=res) {
        s.add(new Senzor(cnt, x, y));
        cnt ++;
      }
    }
    println("Grid created count: "+cnt);
  }
  
  ArrayList getSenzors(){
   return s; 
  }
}

class Senzor {
  int x, y;
  int id;
  int val, lastVal;
  boolean change = false;
  int sustain = 50;
  int timer = 0;


  Senzor(int _id, int _x, int _y) {
    x = _x;
    y = _y;
    id = _id;
    val = lastVal = 0;

    println("adding senzor no: "+id+" on X:"+x+"  Y: "+y);
  }

  void update(int [] pix) {
    if (timer>0) {
      timer --;
    }
    else {

       try{
      val = (int)brightness(pix[y*W+x]);
       }catch(Exception e){
         
       }
      
      change = changed();
      mem();

      if (change) {
        transmitter.sendSenzor(this);
        timer = sustain;
      }
    }

    //change = false;
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

    if (change)
      fill(#ff0000);
    else
      fill(#ffcc00);

    noStroke();
    rect(x, y, 2, 2);
    //text(id+" : "+val, x+3, y+2);
  }
}

