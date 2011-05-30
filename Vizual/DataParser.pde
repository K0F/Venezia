
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
	
	if(debug)
    println("casting Nodes...");

    int blockId = 0;
    for (float sX = 0;sX < 8*shiftX-1;sX+=shiftX) {
	// Y hack
	for (float sY = 5*shiftY ;sY >= 0;sY-=shiftY) {
        for (int i = 0;i<coords.size();i++) {
          PVector current = (PVector)coords.get(i);
          nodes.add(new Node(i, blockId, current.x+sX, current.y+sY, current.z));
        }
        blockId ++;
	if(debug)
	println(blockId);
      }
    }
  }

  ArrayList getNodes() {
    return nodes;
  }
}

