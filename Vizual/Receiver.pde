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

    if(theOscMessage.addrPattern().equals("/tracking")){
        String tmp = theOscMessage.typetag();

        if(debug)
            println("values received: " + tmp.length());

       

           
        Node activ = (Node)globNodes.get(theOscMessage.get(0).intValue());
         activ.val = 255;  
  
    }


}
