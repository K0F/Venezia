/**
 * User interaction testing functions
 */


void mousePressed() {

	if (mouseButton == LEFT) {

		for(int bl = 0 ; bl < blocks.size(); bl++){
			Block block = (Block)blocks.get(bl);
			for (int i = 0 ;i < block.nodes.size();i++) {
				Node n = (Node)block.nodes.get(i);
				float distance = dist(mouseX, mouseY, n.position.x, n.position.y);

				if (distance < 90) {
					n.setFreeze();
				}
			}
		}
	}
	else if (mouseButton == RIGHT) {
		releaseAllFreezes();
	}
}


void keyPressed() {
	if (key != CODED) {
		if (key == 's' || key == 'S') {
			//dumper.dumpVals();
			dumper.dumpBlocks(false);
			releaseAllFreezes();
		}
		else if (key == ' ') {

			save("/desk/vizualDev.png");
		}
	}
}


void releaseAllFreezes() {
	for(int bl = 0 ; bl < blocks.size(); bl++){
		Block block = (Block)blocks.get(bl);
		for (int i = 0 ;i < block.nodes.size();i++) {
			Node n = (Node)block.nodes.get(i);

			n.releaseFreeze();
			n.setVal(0);
		}
	}
}

