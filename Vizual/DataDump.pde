
//////////////// DataDump class 

class DataDump {
	ArrayList nodes;
	String filename;

	DataDump(ArrayList _nodes, String _filename) {
		nodes = _nodes;
		filename = _filename;
	}

	void dumpVals() {
		ArrayList data = new ArrayList(0);

		for (int i = 0 ;i < nodes.size();i++) {
			Node n = (Node)nodes.get(i);
			String tmpCoord = ""+n.position.x+":"+n.position.y+":"+n.position.z;
			String tmpVal = " "+n.val+";";
			data.add(tmpCoord);
			data.add(tmpVal);
		}

		String dump[] = new String[data.size()];
		for (int i = 0 ;i< dump.length;i++) {
			dump[i] = (String)data.get(i)+"";
		}

		saveStrings(filename, dump);

		if (debug)
			println("data ulozena do souboru: "+filename);
	}

	void dumpBlocks(){


		ArrayList blocks = new ArrayList(0);

		int blockCnt = 0;
		for(int i = 0;i<nodes.size();i++){
			Node tmp = (Node)nodes.get(i);
			blockCnt = max(tmp.blockNo,blockCnt);
		}

		println("ukladam bloky... pocet: "+blockCnt);


		for(int q = 0;q<blockCnt;q++){

			ArrayList oneBlockNodes = new ArrayList(0);
			boolean newBlock = false;

			for(int i = 0; i< globNodes.size();i++){
				Node tmp = (Node)(globNodes.get(i));
				//if(i==0)
					//println(q);

				if(q==tmp.blockNo){
					if(!newBlock){
						newBlock = true;
						blocks.add(new Block(q));

					}
					oneBlockNodes.add(tmp);
				}

			}

			//println("blok no.:"+q+" ma "+oneBlockNodes.size()+" nodu");
			Block b = (Block)blocks.get(q);
			b.fillNodes(oneBlockNodes);
		}


		for(int i = 0;i<blocks.size();i++){
			Block b = (Block)blocks.get(i);
			ArrayList raw = new ArrayList(0);
			for(int n =0;n<b.nodes.size();n++){
				Node tmpnode = (Node)b.nodes.get(n);
				raw.add(tmpnode.position.x+":"+tmpnode.position.y+":"+tmpnode.position.z);
				raw.add(" "+map(tmpnode.sum,mini,maxi,0,1600)+";");
			}

			String [] arr = new String[raw.size()]; 
			for(int ln = 0;ln<arr.length;ln++){
				String line = (String)raw.get(ln);
				arr[ln] = line;
			}
			saveStrings("blocks/b"+nf(i,3)+".2dg",arr);
		}


	}
}

class Block{
	ArrayList nodes;
	int id;

	Block(int _id){
		id = _id;

	}

	void fillNodes(ArrayList a){
		nodes = a;
	}

}

