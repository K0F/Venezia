// r = reset

void keyPressed(){
 if(key != CODED){
  if(key=='r' || key == 'R'){
   resetVals(); 
  }
 } 
  
}

// reset all values to its original position
void resetVals(){
 for(int i = 0;i<globNodes.size();i++){
  Node n = (Node)globNodes.get(i);
  n.val = 0;
  n.position.z = n.basez;  
 }   
}
