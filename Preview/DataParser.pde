
//////////////// DataParser class

class DataParser{
    String rawData [];
    String filename;

    ArrayList coords;
    ArrayList nodes;
    ArrayList vals;
    
    DataParser(String _filename){
        filename = _filename;
        rawData = loadStrings(filename);

        vals = new ArrayList();

        parseVals(rawData);
        castNodes();

    }

    // parse a valuse from given data set
    void parseVals(String data[]){
        ArrayList tmp = new ArrayList();
        
        for(int i = 0;i<data.length;i+=1){
            tmp.add((String)data[i]);
        }


        coords = new ArrayList(0);

        for(int i = 1; i<tmp.size();i+=2){
            String cline = (String)tmp.get(i-1);
            String[] parsed = splitTokens(cline," :	");
            coords.add(new PVector(parseFloat(parsed[0]),parseFloat(parsed[1]),parseFloat(parsed[2])));
            cline = (String)tmp.get(i);
            parsed = splitTokens(cline,"; ");
            vals.add((int)parseInt(parsed[0]));
        }
    }

    void castNodes(){
        nodes = new ArrayList(0);
        for(int i = 0;i<coords.size();i++){
            PVector current = (PVector)coords.get(i);
            int currVal = (Integer)vals.get(i);
            nodes.add(new Node(i,current.x,current.y,current.z,currVal));
            
        }

    }

    ArrayList getNodes(){
        return nodes;
    }
}


