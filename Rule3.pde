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
      //rule3(oddCells, phase);
      break;
    case 2:
      //  rule3(evenCells, phase);
      break;
    case 3:
      rule3(oddCells, phase);
      break;
    case 4:
      //  rule3(evenCells, phase);
      break;
    case 5:
      //  rule3(oddCells, phase);
      break;
    }
  }

  Coord loc1 = new Coord();
  Coord locn1 = new Coord();
  Coord loc3 = new Coord();
  Coord locn3 = new Coord();
  Coord loc5 = new Coord();
  Coord locn5 = new Coord();

  void rule3(ArrayList<Cell> cells, int phase) {

    for (Cell cell : cells) {
      switch(phase) {
      case 0:
      case 3:

        loc1.set(cell.loc);
        loc1.x += 1; 
        //Cell c1 = getCell(loc1);

        loc3.set(cell.loc);
        loc3.x += 3; 
        //Cell c3 = getCell(loc3);

        proposeSwap(loc1, loc3);

        //loc5.set(cell.loc);
        //loc5.x += 5; 
        //Cell c5 = getCell(loc5);


        locn1.set(cell.loc);
        locn1.x -= 1; 
        //Cell cn1 = getCell(locn1);

        locn3.set(cell.loc);
        locn3.x -= 3; 
        //Cell cn3 = getCell(locn3);

        proposeSwap(locn1, locn3);

        /*locn5.set(cell.loc);
         locn5.x -= 5; 
         //Cell cn5 = getCell(locn5);
         println(c1, c3, c5);
         if  (c5 == null) {
         proposeSwap(loc1, loc3);
         } 
         
         if (  (c3 != null) && (c3.state == -1) || (c5 != null && c5.state == -1)) {
         proposeSwap(loc1, locn1); //change direction
         proposeSwap(loc3, loc5);  // bring rightmost cell one step right
         }
         */
      }
    }
  }






  void initConfig() {
    addCell(0, 0, 0, 1);
    addCell(-1, 0, 0, 1);

    addCell(-3, 0, 0, -1);



  }
}

