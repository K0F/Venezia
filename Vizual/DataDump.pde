
//////////////// DataDump class 

class DataDump{
    ArrayList nodes;
    String filename;

    DataDump(ArrayList _nodes,String _filename){
        nodes = _nodes;
        filename = _filename;
    }

    void dumpVals(){
        ArrayList data = new ArrayList(0);

        for(int i = 0 ;i < nodes.size();i++){
            Node n = (Node)nodes.get(i);
            String tmpCoord = ""+n.position.x+":"+n.position.y+":"+n.position.z;
            String tmpVal = " "+n.val+";";
            data.add(tmpCoord);
            data.add(tmpVal);
        }

        String dump[] = new String[data.size()];
        for(int i = 0 ;i< dump.length;i++){
            dump[i] = (String)data.get(i)+"";
        }

        saveStrings(filename,dump);
        
        if(debug)
            println("data ulozena do souboru: "+filename);
    }

}

