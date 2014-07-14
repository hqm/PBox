class Rule3 extends Rule {
  // tmp working registers for coordinates
  Coord p1 = new Coord(0, 0, 0);
  Coord p2 = new Coord(0, 0, 0);
  Coord p3 = new Coord(0, 0, 0);
  Coord p4 = new Coord(0, 0, 0);

  // busy box rule
  /*
 Phase 0: apply rule to even field in XY plane 
   Phase 1: apply rule to odd field in YZ plane 
   Phase 2: apply rule to even field in XZ plane 
   Phase 3: apply rule to odd field in XY plane 
   Phase 4: apply rule to even field in YZ plane 
   Phase 5: apply rule to odd field in XZ plane
   
   
   + -   N
   . . . . . . . . 
   - +         N
   +1  +3  +5
   
   
   */

  class Swap {
    Coord a;
    Coord b;
    public Swap(int x1, int y1, int z1, int x2, int y2, int z2) {
      a = new Coord(x1, y1, z1);
      b = new Coord(x2, y2, z2);
    }
  }


  void runRule() {
    int phase = clockPhase();

    switch(phase) {
    case 0:
      rule3(evenCells, phase);
      break;
    case 1:
      rule3(oddCells, phase);
      break;
    case 2:
      rule3(evenCells, phase);
      break;
    case 3:
      rule3(oddCells, phase);
      break;
    case 4:
      rule3(evenCells, phase);
      break;
    case 5:
      rule3(oddCells, phase);
      break;
    }
  }

  Coord loc1 = new Coord();
  Coord locn1 = new Coord();
  Coord loc3 = new Coord();
  Coord locn3 = new Coord();
  Coord loc5 = new Coord();
  Coord locn5 = new Coord();
  Coord loc2 = new Coord();
  Coord locn2 = new Coord();

  void rule3(ArrayList<Cell> cells, int phase) {

     println("======================================" + clockPhase());

    Cell c1 ;
    Cell c3 ;
    Cell cn1;

    Cell cn2;
    Cell cn3;
    Cell c2 ;

    for (Cell cell : cells) {



      switch(phase) {
      case 0:
      case 3:
        loc1.set(cell.loc);
        loc1.x += 1; 
        loc3.set(cell.loc);
        loc3.x += 3; 
        locn1.set(cell.loc);
        locn1.x -= 1; 
        locn3.set(cell.loc);
        locn3.x -= 3;
        loc5.set(cell.loc);
        loc5.x += 5; 

        locn2.set(cell.loc);
        locn2.x -= 2;
        loc2.set(cell.loc);
        loc2.x += 2;

        c1 = getCell(loc1);
        c3 = getCell(loc3);
        cn1 = getCell(locn1);
        cn2 = getCell(locn2);
        cn3 = getCell(locn3);
        c2 = getCell(loc2);

        if (c1 != null && c1.state >= 1 
          && c3 != null && c3.state >= 1
          ) {
          proposeSwap(loc3, loc5);
          println("C "+cell);
        } else if (cn1 != null && cn1.state >= 1  
          && cn3 != null  && cn3.state <= -1
          ) {
          proposeSwap(locn3, locn5);
          //  print("D");
        } else if (cell.state >= 0 ) {
          proposeSwap(loc1, loc3);
          println("A "+cell);
          if (
          cn2 == null 
            && !(cn1 != null && cn1.state <= -1) 
            && !(c1 != null && c1.state >= 1)
            ) {
            println("..B "+cell);
            proposeSwap(locn1, locn3);
          }
        }

        break;
      case 1:
      case 4:
      /*
        loc1.set(cell.loc);
        loc1.y += 1; 
        loc3.set(cell.loc);
        loc3.y += 3; 
        locn1.set(cell.loc);
        locn1.y -= 1; 
        locn3.set(cell.loc);
        locn3.y -= 3;
        loc5.set(cell.loc);
        loc5.y += 5; 

        loc2.set(cell.loc);
        loc2.y += 1;
        loc2.x += 1;
        locn2.set(cell.loc);
        locn2.y -= 2;

        c1 = getCell(loc1);
        c3 = getCell(loc3);
        cn1 = getCell(locn1);
        cn2 = getCell(locn2);
        cn3 = getCell(locn3);
        c2 = getCell(loc2);

        // if we have a pattern of 2.1,  swap with row below, and move both down by one grid cell in y direction
        if (cell.state > 1 || cell.state < -1) {
          proposeSwap(loc2, cell.loc);
        }

*/

        break;

      case 2:
      case 5:
        break;
      }
    }
  }

  /*
A        +-.. =>  +..-
   
   B        +..- => ..+-
   
   xoxoxoxo
   C        +-.+..  =>  -+...+
   
   D       -+..   =>   -..+
   E       -..+   =>   -+..
   
   proposeSwap(loc1, locn1); // SWAP CELLS phase shift
   
   */



  void initConfig() {

  //  addCell(0, 0, 0, 2);
  //  addCell(1, 0, 0, 2);
  //  addCell(7, 0, 0, 2);
  //  addCell(-7, 0, 0, -2);

    for (int y = 2; y <3 ; y+=2) {

      addCell(y%2, y, 0, 1);
      addCell(y%2+1, y, 0, 1);
      addCell(y%2+7, y, 0, 1);
      addCell(y%2-7, y, 0, -1);


   //   addCell(y%2, y+22, 0, 2);
    //  addCell(y%2+1, y+22, 0, 2);
  //    addCell(y%2+7, y+22, 0, 2);
   //   addCell(y%2-7, y+22, 0, -2);
    }
  }
}

