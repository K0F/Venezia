//////////////// DataParser class

class DataParser {
	String rawData [];
	String filename;

	ArrayList coords;
	//ArrayList nodes;

	float shiftX = 1316.359;
	float shiftY = 658.179;

	DataParser(String _filename) {
		filename = _filename;
		rawData = loadStrings(filename);
		//println("stage 1 "+blocks.size());
		parseVals(rawData);
		//println("stage 2 "+blocks.size());
		castNodes();
		//println("stage 3 "+blocks.size());
		loadVals();
		//println("stage 4 "+blocks.size());
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
		//nodes = new ArrayList(0);
		blocks = new ArrayList(0);

		if(debug)
			println("casting Nodes...");

		int blockCnt = 0;
		int nodeCnt = 0;
		for (float sX = 0;sX < 8*shiftX-2;sX+=shiftX) {
			// Y hack
			for (float sY = 0; sY < 6*shiftY-2 ;sY+=shiftY) {
				//templorary nodes
				ArrayList tempNodes = new ArrayList(0);

				for (int i = 0;i<coords.size();i++) {
					PVector current = (PVector)coords.get(i);
					//nodes.add(new Node(i, blockId, current.x+sX, current.y+sY, current.z));
					nodeCnt++;		
					//Node currentNode = (Node)nodes.get(i);
					tempNodes.add(new Node(i, blockCnt, current.x+sX, current.y+sY, current.z));
				}

				// fill blocks with Nodes here
				blocks.add(new Block(blockCnt));
				Block currentBlock = (Block)blocks.get(blockCnt);
				currentBlock.setNodes(tempNodes);

				blockCnt ++;
				//if(debug)
				//	println(blockcnt);
			}
		}
		blockCount = blockCnt;
		nodeCount = nodeCnt;
	}

	ArrayList getNodes() {
		ArrayList _nodes = new ArrayList(0);
		for(int i =0;i<blocks.size();i++){
			Block b = (Block)blocks.get(i);
			for(int ii = 0;ii<b.nodes.size();ii++){
				Node n = (Node)b.nodes.get(ii);
				_nodes.add(n);
			}
		}
		return _nodes;
	}
/*
	void loadCurrentVals(){

		ArrayList names = new ArrayList(0);

		File folder = new File(sketchPath+"/blocks");
		File[] listOfFiles = folder.listFiles();

		println("nacitam ze zalohy");
		for(int i = 0 ; i < listOfFiles.length; i++){
			if(listOfFiles[i].getName().indexOf("2dg")>-1){
				names.add(listOfFiles[i].getName());
				println(listOfFiles[i].getName());
			}
		}

		for(int i = 0 ; i < names.size() ; i++){
			String tmp = (String)names.get(i);
			int ID = parseInt(tmp.substring(1,4));
			println(ID);
			tmp = (String)names.get(i);
			String[] raw = loadStrings(sketchPath+"/blocks/"+tmp);

			for(int b = 0 ; b < blocks.size() ; b++){
				Block bl = (Block)blocks.get(b);
				for(int ii = 0 ; ii < bl.nodes.size(); ii++){
					Node tmpNode = (Node)bl.nodes.get(ii);
					if(ID==tmpNode.blockNo){
						for(int iii = 0;iii < raw.length;iii++){
							if(iii==tmpNode.id){
								String vals;
								try{
									vals = split(raw[iii]," ;")[1];
									tmpNode.sum = parseInt(vals);
								}catch(Exception e){
									tmpNode.sum = 0;
								}
							}
						}
					}
				}
			}
		}
	}
*/
	// restoring values to saved sums
	void loadVals(){
		for(int i = 0 ; i< blocks.size();i++){
			Block b = (Block)blocks.get(i);
			
			String[] data = loadStrings(sketchPath+"/blocks/b"+nf(i,3)+".2dg");
			
			int nodeNo = 0;
			for(int ln = 1;ln < data.length;ln += 2){
				String tmp[] = splitTokens(data[ln],"; ");
				Node n = (Node)b.nodes.get(nodeNo);
				n.sum = parseFloat(tmp[1]);
				nodeNo++;	
			}
		}

	}

}

