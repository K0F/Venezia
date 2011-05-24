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
		String tmp = theOscMessage.typetag();

		if (debug)
			println("values received: " + tmp.length());




		float X = theOscMessage.get(0).floatValue() * width;
		float Y = theOscMessage.get(1).floatValue() * height;
		/*
		   if (plot) {
		   if (lastX == 0 && lastY == 0) {
		   lastX = X;
		   lastY = Y;
		   }


		   if (dist(X, Y, lastX, lastY)<plotter.plotDist);
		   plotter.buffer.beginDraw();
		   plotter.buffer.line(X, Y, lastX, lastY);
		   plotter.buffer.endDraw();


		   lastX = X;
		   lastY = Y;
		   }
		 */
		for (int i = 0 ;i<globNodes.size();i++) {
			Node activ = (Node)globNodes.get(i);
			float d = dist(X, Y, activ.position.x*world.scale, activ.position.y*world.scale);
			if (d<R) {
				activ.val += map(d, 0, R, 255, 0);
				activ.val = constrain(activ.val,0,255);
				activ.sum++;
			}
		}
	}
}
