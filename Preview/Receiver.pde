class Receiver {
  PApplet parent;
  OscP5 osc;
  int port;

  Receiver(PApplet _parent, int _port) {
    parent = _parent;
    port = _port;

    osc = new OscP5(parent, port);
  }
}

void oscEvent(OscMessage theOscMessage) {

  if (theOscMessage.addrPattern().equals("/tracking")) {
    //println("bang");

    String tmp = theOscMessage.typetag();

    if (debug)
      println("values received: " + tmp.length());

    if (tmp.equals("ff")) {

      
        for (int i = 0;i<globNodes.size();i++) {
          Node n = (Node)globNodes.get(i);

          float tx = theOscMessage.get(0).floatValue() * width / world.scale;
          float ty = theOscMessage.get(1).floatValue() * height / world.scale;

          float distance = dist(tx, ty, n.position.x, n.position.y);
          
          if(distance<n.modrange)
          n.modVal3(distance);
        }
    }
  }
}

