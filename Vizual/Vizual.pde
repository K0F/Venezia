/**
*  Venezia 2011 Vizual by Kof
*/

import processing.opengl.*;

boolean debug = true;

DataParser parser;
ArrayList globNodes;


void setup(){
	size(1440,600,OPENGL);


	//init
	parser = new DataParser("stlp_B.txt");
	globNodes = parser.getNodes();

}



class DataParser{
	String rawData [];
	String filename;

	ArrayList coords;
	ArrayList nodes;

	DataParser(String _filename){
		filename = _filename;
		rawData = loadStrings(filename);
		
		parseVals(rawData);
		castNodes();
		
	}

	// parse a valuse from given data set
	void parseVals(String data[]){
		ArrayList tmp = new ArrayList();
		for(int i = 0;i<data.length;i+=2){
			tmp.add((String)data[i]);
		}

	
		coords = new ArrayList(0);

		for(int i = 0; i<tmp.size();i++){
			String cline = (String)tmp.get(i);
			String[] parsed = splitTokens(cline," :	");
			coords.add(new PVector(parseFloat(parsed[0]),parseFloat(parsed[1]),parseFloat(parsed[2])));
		}
	}

	void castNodes(){
		nodes = new ArrayList(0);
		for(int i = 0;i<coords.size();i++){
			PVector current = (PVector)coords.get(i);
			nodes.add(new Node(i,current.x,current.y,current.z));

		}

	}

	ArrayList getNodes(){
		return nodes;
	}


}

class Node{
	PVector position;
	int id;
	int val;


	Node(int _id,float _x,float _y,float _z){
		id = _id;
		position = new PVector(_x,_y,_z);
	}


}

class Grid{




}
