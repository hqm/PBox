class Rule4 extends Rule {
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
  Coord loc4 = new Coord();
  Coord locn4 = new Coord();
  Coord loc5 = new Coord();
  Coord locn5 = new Coord();
  Coord loc2 = new Coord();
  Coord locn2 = new Coord();
  Coord loc7 = new Coord();
  Coord locn7 = new Coord();

  void rule3(ArrayList<Cell> cells, int phase) {

    //  println("======================================" + clockPhase());

    Cell c1 ;
    Cell c3 ;
    Cell cn1;

    Cell cn2;
    Cell cn3;
    Cell c2 ;
    Cell cn7;
    Cell cn5;
    Cell c5;

    for (Cell cell : cells) {
      // X motion


      switch(phase) {
      case 0:
      case 3:

        loc1.set(cell.loc); 
        loc1.x += 1; 

        loc2.set(cell.loc); 
        loc2.x += 2;

        loc3.set(cell.loc); 
        loc3.x += 3; 

        loc4.set(cell.loc); 
        loc4.x += 4; 

        loc5.set(cell.loc); 
        loc5.x += 5; 

        loc7.set(cell.loc); 
        loc7.x += 7;

        locn1.set(cell.loc); 
        locn1.x -= 1; 

        locn2.set(cell.loc); 
        locn2.x -= 2;

        locn3.set(cell.loc); 
        locn3.x -= 3;

        locn4.set(cell.loc); 
        locn4.x -= 4; 

        locn5.set(cell.loc); 
        locn5.x -= 5; 

        locn7.set(cell.loc); 
        locn7.x -= 7;

        c1 = getCell(loc1);
        c2 = getCell(loc2);
        c3 = getCell(loc3);
        c5 = getCell(loc5);

        cn1 = getCell(locn1);
        cn2 = getCell(locn2);
        cn3 = getCell(locn3);
        cn5 = getCell(locn5);
        cn7 = getCell(locn7);




        // . . . . . . b J . . b . . . b . . . b . . . b
        // . . . . . . . J . . b . B . b . . . b . . . b
        // Let edge case: jumper to right of blue cell causes blue cell to jump to +7 to go into interstitial position
        if (cell.state == -1 && (cn1 != null) && (c3 != null)) {
          println("LEFT EDGE A");
          proposeSwap(locn1, loc5);
        } else if (cell.state == -1 && cn3 != null && cn1 != null ) { // right central case, jump cell over 
          // . . . . . . . . . . b . B J b . . . b . . . b
          // . . . . . . . . . . b . B J b . . . b . . . b
          proposeSwap(locn1, loc5);
        } else if (cn5 != null && cn5.state == -1) { // pull jumper cell to the right
          proposeSwap(locn5, locn1);
        } else if (cell.state == -1 && (cn1 != null && c3 == null)) { //  right edge case: jump back to left
          proposeSwap(locn1, locn5);
        }
        break;
      case 1:
      case 4:
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
   . . . R . . B . . R
   */



  void initConfig() {

    for (int y = -2; y < -1 ; y+=3) {
      addCell(-10, -2, 0, -1); //jump token starts on left

      for (int x = -11; x < 18; x+=4) {
        addCell(x, y, 0, 1);
      }
    }
  }
}

