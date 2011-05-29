
//////////////// DataParser class

class DataParser{
    String rawData [];
    String filename;

    ArrayList coords;
    ArrayList nodes;
    ArrayList vals;

    float fx,fy,fz;
    
    DataParser(String _filename){
        filename = _filename;
        rawData = loadStrings(sketchPath+"/blocks/"+filename);

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
            if(i==1){
                fx = parseFloat(parsed[0]);
                fy = parseFloat(parsed[1]);
                fz = parseFloat(parsed[2]);
            }
            coords.add(new PVector(parseFloat(parsed[0])-fx,parseFloat(parsed[1])-fy,parseFloat(parsed[2])-fz));
            cline = (String)tmp.get(i);
            parsed = splitTokens(cline,"; ");
            vals.add((float)parseFloat(parsed[0]));
        }
    }

    void castNodes(){
        nodes = new ArrayList(0);
        for(int i = 0;i<coords.size();i++){
            PVector current = (PVector)coords.get(i);
            float currVal = (Float)vals.get(i);
            nodes.add(new Node(i,current.x,current.y,current.z,currVal));
            
        }

    }

    ArrayList getNodes(){
        return nodes;
    }
}


