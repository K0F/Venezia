class Transmitter {
  PApplet parent;
  OscP5 osc;
  NetAddress remote;
  String address;
  int port;

  Transmitter(PApplet _parent,String _address,int _port) {
    parent = _parent;
    address = _address;
    port = _port;

    osc = new OscP5(parent,port);
    remote = new NetAddress(address,PORT);
  }
  
  void sendSenzor(Senzor s){
    OscMessage message = new OscMessage("/tracking");
    message.add(map(s.x,0,W,0,1));
    message.add(map(s.y,0,H,0,1));
    osc.send(message,remote);
    
  }

  void transmitData(PImage tmp) {
    tmp.loadPixels();
    ArrayList cout = new ArrayList(0);
    int c = 0;
    for(int i = 0 ; i < tmp.pixels.length;i+=1){
       if(tmp.pixels[i]==0xffffffff){
        c++;
        
        if(c<256)
        cout.add(i);
       } 
    }
    
    println(cout.size());
    
    int[] raw = new int[cout.size()];
    for(int i = 0 ; i < cout.size();i++){
      raw[i] = (Integer)cout.get(i);
    }
    
    OscMessage message = new OscMessage("/tracking");
    message.add(raw);
    
    osc.send(message,remote);
    
    
  }
}

