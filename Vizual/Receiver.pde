class Receiver {
  PApplet parent;
  OscP5 osc;
  int port;
 
   Receiver(PApplet _parent,int _port) {
    parent = _parent;
    port = _port;
    
    osc = new OscP5(parent,port);
     
   }
  
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
