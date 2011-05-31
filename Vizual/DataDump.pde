
//////////////// DataDump class 

class DataDump {
	String filename;

	DataDump(String _filename) {
		filename = _filename;
	}

	void dumpVals() {
		ArrayList data = new ArrayList(0);

		for(int q = 0 ; q < blocks.size() ; q++){
			Block tmp = (Block)blocks.get(q);
			for (int i = 0 ;i < tmp.nodes.size();i++) {
				Node n = (Node)tmp.nodes.get(i);
				String tmpCoord = n.position.x+":"+n.position.y+":"+n.position.z;
				String tmpVal = " "+n.val+";";
				data.add(tmpCoord);
				data.add(tmpVal);
			}
		}

		String dump[] = new String[data.size()];
		for (int i = 0 ;i< dump.length;i++) {
			dump[i] = (String)data.get(i)+"";
		}

		saveStrings(filename, dump);

		if (debug)
			println("data ulozena do souboru: "+filename);
	}

	void dumpBlocks(boolean time){


		String D = nf(day(),2)+"";
		String M = nf(month(),2)+"";
		String H = nf(hour(),2)+"";
		String MN = nf(minute(),2)+"";

		//ArrayList blocks = new ArrayList(0);

		//compute all nodes count
		int blockCnt = 0;
		for(int q = 0 ; q < blocks.size(); q++){
			Block tmpblock = (Block)blocks.get(q);
			for(int i = 0;i<tmpblock.nodes.size();i++){
				Node tmp = (Node)tmpblock.nodes.get(i);
				blockCnt = max(tmp.blockNo+1,blockCnt);
			}
		}

		println("timestamp: "+D+"/"+M+" "+H+":"+MN+" ukladam bloky... pocet: "+blockCnt);

		/*
		   ArrayList temp = new ArrayList(0);
		   for(int q = 0;q<blockCnt;q++){

		   ArrayList oneBlockNodes = new ArrayList(0);
		   boolean newBlock = false;

		   for(int bl = 0;bl < blocks.size();bl++){	
		   Block block = (Block)blocks.get(bl);
		   for(int i = 0; i< block.nodes.size();i++){
		   Node tmp = (Node)(block.nodes.get(i));
		//if(i==0)
		//println(q);

		if(q==tmp.blockNo){
		if(!newBlock){
		newBlock = true;
		temp.add(new Block(q));

		}
		oneBlockNodes.add(tmp);
		}

		}
		}

		//println("blok no.:"+q+" ma "+oneBlockNodes.size()+" nodu");
		Block b = (Block)blocks.get(q);
		b.fillNodes(oneBlockNodes);
		}*/


		for(int i = 0;i<blocks.size();i++){
			Block b = (Block)blocks.get(i);
			ArrayList raw = new ArrayList(0);
			for(int n =0;n<b.nodes.size();n++){
				Node tmpnode = (Node)b.nodes.get(n);

				//coordinte hack
				raw.add(tmpnode.position.x+":"+tmpnode.position.y+":"+tmpnode.position.z);

				raw.add(" "+map(tmpnode.sum,mini,maxi,0,1600)+";"+tmpnode.sum+";");
			}

			String [] arr = new String[raw.size()]; 
			for(int ln = 0;ln<arr.length;ln++){
				String line = (String)raw.get(ln);
				arr[ln] = line;
			}
			if(time){
				saveStrings("blocks/"+D+"_"+M+"-"+H+"_"+MN+"/b"+nf(i,3)+".2dg",arr);
				saveStrings("blocks/b"+nf(i,3)+".2dg",arr);
			}else{
				saveStrings("blocks/b"+nf(i,3)+".2dg",arr);
			}
		}
	}
}

