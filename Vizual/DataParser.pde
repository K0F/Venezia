
//////////////// DataParser class

class DataParser {
	String rawData [];
	String filename;

	ArrayList coords;
	ArrayList nodes;

	float shiftX = 1316.359;
	float shiftY = 658.179;

	DataParser(String _filename) {
		filename = _filename;
		rawData = loadStrings(filename);

		parseVals(rawData);
		castNodes();
	}

	// parse a valuse from given data set
	void parseVals(String data[]) {
		ArrayList tmp = new ArrayList();
		for (int i = 0;i<data.length;i+=2) {
			tmp.add((String)data[i]);
		}


		coords = new ArrayList(0);

		for (int i = 0; i<tmp.size();i++) {
			String cline = (String)tmp.get(i);
			String[] parsed = splitTokens(cline, " : ");
			coords.add(new PVector(parseFloat(parsed[0]), parseFloat(parsed[1]), parseFloat(parsed[2])));

			maxY = max(maxY,parseFloat(parsed[1]));	
		}
	}

	void castNodes() {
		nodes = new ArrayList(0);
		blocks = new ArrayList(0);

		if(debug)
			println("casting Nodes...");

		int blockId = 0;
		for (float sX = 0;sX < 8*shiftX;sX+=shiftX) {
			// Y hack
			for (float sY = 5*shiftY ;sY >= 0;sY-=shiftY) {

				//templorary nodes
				ArrayList tempNodes = new ArrayList(0);

				for (int i = 0;i<coords.size();i++) {
					PVector current = (PVector)coords.get(i);
					nodes.add(new Node(i, blockId, current.x+sX, current.y+sY, current.z));
						
					Node currentNode = (Node)nodes.get(i);
					tempNodes.add(currentNode);
				}
				
				// fill blocks with Nodes here
				blocks.add(new Block(blockId));
				Block currentBlock = (Block)blocks.get(blockId);
				currentBlock.setNodes(tempNodes);

				blockId ++;
				if(debug)
					println(blockId);
			}
		}
		blockCount = blockId;
		nodeCount = nodes.size();
	}

	ArrayList getNodes() {
		return nodes;
	}

	void loadCurrentVals(){

		ArrayList names = new ArrayList(0);

		File folder = new File(sketchPath+"/blocks");
		File[] listOfFiles = folder.listFiles();

		for(int i = 0 ; i < listOfFiles.length; i++){
			if(listOfFiles[i].getName().indexOf("2dg")>-1){
				names.add(listOfFiles[i].getName());
			}
		}

		for(int i = 0 ; i < names.size();i++){
			String tmp = (String)names.get(i);
			int ID = parseInt(split(tmp,"b0.2dg"))[0];
			String[] raw = loadStrings(sketchPath+"/blocks/"+tmp);

			for(int ii = 0 ; ii < nodes.size(); ii++){
				Node tmpNode = (Node)nodes.get(i);
				if(ID==tmpNode.blockNo){
					for(int iii = 0;iii < raw.length;iii++){
						if(iii==tmpNode.id){
							tmpNode.val = parseInt(split(raw[iii]," ;")[0]);
						}
					}

				}

			}
		}



	}
}

