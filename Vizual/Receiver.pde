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

        if(tmp.length()>0){

            int [] rawvals = new int[tmp.length()];
            for(int i = 0;i<tmp.length();i++){
                rawvals[i] = theOscMessage.get(i).intValue();
            }

            for(int y = 0;y < 240;y++){
                for(int x = 0;x < 320;x++){
                    for(int i = 0 ;i<rawvals.length;i++)
                        if(rawvals[i] == y*320+x){
                            rect(x,y,1,1);
                        }
                }
            }


        }
    }else{
        if(debug)
            println("WARNING: receiving wrong tracking data!");
    }


}
