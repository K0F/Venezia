/**
* User interaction testing functions
*/


void mousePressed(){

    if(mouseButton == LEFT){

        for(int i = 0 ;i < globNodes.size();i++){
            Node n = (Node)globNodes.get(i);
            float distance = dist(mouseX,mouseY,n.position.x,n.position.y);

            if(distance < 90){
                n.setFreeze();
            }

        }
    }else if(mouseButton == RIGHT){
        releaseAllFreezes();
    }

}


void keyPressed(){
    if(key != CODED){
        if(key == 's' || key == 'S'){
            dumper.dumpVals();
            releaseAllFreezes();
        }

    }

}


void releaseAllFreezes(){
    for(int i = 0 ;i < globNodes.size();i++){
        Node n = (Node)globNodes.get(i);

        n.releaseFreeze();
        n.setVal(0);
    }
}
