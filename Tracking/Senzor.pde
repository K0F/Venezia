class Grid {

  ArrayList s = new ArrayList(0);
  String filename;
  int res;
  boolean selectArea = false;
  int sx, sy;
  int ex, ey;
  int mode = 0;


  Grid(int _res, int _mode) {
    mode = _mode;

    switch(mode) {
    case 0:
      generateStatic(_res);
      break;

    case 1:
      runInteractive(_res);
      break;
    }
  }

  void generateStatic(int _res) {
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

  void generateBox() {

    int cnt = 0;

    for (int y = grid.sy; y < mouseY; y += grid.res) {
      for (int x = grid.sx ; x < mouseX ; x+= grid.res) {
        s.add(new Senzor(cnt, x, y));
        cnt ++;
      }
    }
  }



  void runInteractive(int _res) {
    res = (int)(W/_res);
    //	selectArea = true;
  }

  ArrayList getSenzors() {
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
      try {
        val = (int)brightness(pix[y*W+x]);
      }
      catch(Exception e) {
      }

      mem();
    }
    else {

      try {
        val = (int)brightness(pix[y*W+x]);
      }
      catch(Exception e) {
      }

      change = changed();
      mem();

      if (change) {
        transmitter.sendSenzor(this);
        timer = sustain;
      }
    }

    //change = false
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

