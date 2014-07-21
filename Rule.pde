// the base class for defining rules
abstract class Rule { 
  
   // the default starting configuration
  void initConfig() {

    int N = 20;
    for (int x = -N; x < N; x+=2) {
      for (int y = -N; y < N; y+=2) {
        for (int z = -N; z < N; z+=2) {
          addCell(x, y, z, 1);
          addCell(x+2, y+1, z, 1);
        }
      }
    }
    addCell(0, 0, 0, 1);
    addCell(1, 2, 0, 1);
    addCell(3, 3, 0, 1);
    addCell(3, 5, 1, 1);
    addCell(3, 6, 3, 1);
  }

  

  void runRule() {
    
  }
}

