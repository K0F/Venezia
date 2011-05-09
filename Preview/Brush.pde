class Brush{
    String filename;
    PImage peak;
    int profil[];

    Brush(String _filename){
        filename = _filename;
        peak = loadImage(filename);
        profil = new int[peak.width];
    
        analyze();
    }

    void analyze(){
        peak.loadPixels();

        for(int x = 0;x < profil.length ;x++){
            boolean gotWhite = false;
            
            for(int y = 0 ;y<peak.height;y++){
                if(peak.pixels[y*peak.width+x] == 0xffffffff){
                    profil[x] = peak.height-y;
                    gotWhite = true;
                    break;
                }
            }

            if(!gotWhite){
                profil[x] = 0;
            }
        }

        
        println(profil);

    }

}
