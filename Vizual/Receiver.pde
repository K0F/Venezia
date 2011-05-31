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

	if (theOscMessage.addrPattern().equals("/control")) {
		println("zprava od obsluhy ve tvaru: " + theOscMessage.typetag());

		if(theOscMessage.typetag().equals("ss")){
			println(""+theOscMessage.get(0).stringValue()+" "+theOscMessage.get(1).stringValue()); 

			if(theOscMessage.get(0).stringValue().equals("get")){
				int idx = parseInt(theOscMessage.get(1).stringValue());
				NetAddress addr = new NetAddress("127.0.0.1",5555);
				OscMessage msg = new OscMessage("/control");
				msg.add("arr");
				// /control arr(string) blokid(int) id(int[] array) hodnota(float[] array)
				msg.add(idx);

				Block tmp = (Block)blocks.get(idx);

				int[] ids = new int[tmp.nodes.size()];
				
				for(int i = 0 ; i < ids.length; i++){
					Node ntmp = (Node)tmp.nodes.get(i);
					ids[i] = ntmp.id;

				}

				msg.add(ids);
				float[] sums = new float[tmp.nodes.size()];
				for(int i = 0 ;i< sums.length;i++){
					Node ntmp = (Node)tmp.nodes.get(i);
					sums[i] = ntmp.sum;
				}
				msg.add(sums);
				
				
				
				receiver.osc.send(msg,addr);

			}

		}
	}

	if (theOscMessage.addrPattern().equals("/tracking")) {
		String tmp = theOscMessage.typetag();

//		if (debug)
//			println("values received: " + tmp.length());

		float X = theOscMessage.get(0).floatValue() * width;
		float Y = theOscMessage.get(1).floatValue() * height;

		for(int bl = 0 ; bl < blocks.size(); bl++){
			Block block = (Block)blocks.get(bl);
			for (int i = 0 ;i<block.nodes.size();i++) {
				Node activ = (Node)block.nodes.get(i);
				float d = dist(X, Y, activ.position.x*world.scale, activ.position.y*world.scale);
				if (d<R) {
					activ.val += map(d, 0, R, 255, 0);
					activ.val = constrain(activ.val, 0, 255);
					activ.sum+=0.1;
				}
			}
		}
	}
}

