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
    case 6:
      rule3(evenCells, phase);
      break;
    case 7:
      rule3(oddCells, phase);
      break;
    case 8:
      rule3(evenCells, phase);
      break;
    case 9:
      rule3(oddCells, phase);
      break;
    case 10:
      rule3(evenCells, phase);
      break;
    case 11:
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
    Cell c1 = null ;
    Cell c2  = null;
    Cell c3  = null;
    Cell c4  = null;
    Cell c5 = null;

    Cell cn1 = null;
    Cell cn2 = null;
    Cell cn3 = null;
    Cell cn4 = null;
    Cell cn5 = null;
    Cell cn7 = null;

    for (Cell cell : cells) {
      // X motion

      // 1   O E     E
      // 2   E O     O

      boolean evenY = cell.loc.y % 2 == 0;
      boolean oddY = !evenY;
      boolean evenX = cell.loc.x % 2 == 0;
      boolean oddX = !evenX;
      boolean evenZ = cell.loc.z % 2 == 0;
      boolean oddZ = !evenZ;

      boolean evenYZ = (cell.loc.z + cell.loc.y) % 2 == 0;
      boolean oddYZ = !evenYZ;

      boolean evenXZ = (cell.loc.z + cell.loc.x) % 2 == 0;
      boolean oddXZ = !evenXZ;

      boolean evenXY = (cell.loc.x + cell.loc.y) % 2 == 0;
      boolean oddXY = !evenXY;


      boolean even = cell.isEven();
      boolean odd = !even;
      switch(phase) {
      case 0:
      case 1:
      case 2:
      case 3:

        if ((phase == 0 && oddYZ) || 
          (phase == 1 && evenYZ) ||
          (phase == 2 && evenYZ) ||
          (phase == 3 && oddYZ) ) {


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
          c4 = getCell(loc4);
          c5 = getCell(loc5);

          cn1 = getCell(locn1);
          cn2 = getCell(locn2);
          cn3 = getCell(locn3);
          cn4 = getCell(locn4);
          cn5 = getCell(locn5);
          cn7 = getCell(locn7);
        }

        break;
      case 4:
      case 5:
      case 6:
      case 7:


        if ((phase == 4 && oddXZ)
          ||(phase == 5 && evenXZ) 
          || (phase == 6 && evenXZ) 
          || (phase == 7 && oddXZ)) {



          loc1.set(cell.loc); 
          loc1.y += 1; 

          loc2.set(cell.loc); 
          loc2.y += 2;

          loc3.set(cell.loc); 
          loc3.y += 3; 

          loc4.set(cell.loc); 
          loc4.y += 4; 

          loc5.set(cell.loc); 
          loc5.y += 5; 

          loc7.set(cell.loc); 
          loc7.y += 7;

          locn1.set(cell.loc); 
          locn1.y -= 1; 

          locn2.set(cell.loc); 
          locn2.y -= 2;

          locn3.set(cell.loc); 
          locn3.y -= 3;

          locn4.set(cell.loc); 
          locn4.y -= 4; 

          locn5.set(cell.loc); 
          locn5.y -= 5; 

          locn7.set(cell.loc); 
          locn7.y -= 7;

          c1 = getCell(loc1);
          c2 = getCell(loc2);
          c3 = getCell(loc3);
          c4 = getCell(loc4);
          c5 = getCell(loc5);

          cn1 = getCell(locn1);
          cn2 = getCell(locn2);
          cn3 = getCell(locn3);
          cn4 = getCell(locn4);
          cn5 = getCell(locn5);
          cn7 = getCell(locn7);
        }
        break;

      case 8:
      case 9:
      case 10:
      case 11:

        //if (true) continue;

        if ((phase == 8 && evenXY)
          ||(phase == 9 && oddXY)
          ||(phase == 10 && oddXY) 
          ||(phase == 11 && evenXY)) {



          loc1.set(cell.loc); 
          loc1.z += 1; 

          loc2.set(cell.loc); 
          loc2.z += 2;

          loc3.set(cell.loc); 
          loc3.z += 3; 

          loc4.set(cell.loc); 
          loc4.z += 4; 

          loc5.set(cell.loc); 
          loc5.z += 5; 

          loc7.set(cell.loc); 
          loc7.z += 7;

          locn1.set(cell.loc); 
          locn1.z -= 1; 

          locn2.set(cell.loc); 
          locn2.z -= 2;

          locn3.set(cell.loc); 
          locn3.z -= 3;

          locn4.set(cell.loc); 
          locn4.z -= 4; 

          locn5.set(cell.loc); 
          locn5.z -= 5; 

          locn7.set(cell.loc); 
          locn7.z -= 7;

          c1 = getCell(loc1);
          c2 = getCell(loc2);
          c3 = getCell(loc3);
          c4 = getCell(loc4);
          c5 = getCell(loc5);

          cn1 = getCell(locn1);
          cn2 = getCell(locn2);
          cn3 = getCell(locn3);
          cn4 = getCell(locn4);
          cn5 = getCell(locn5);
          cn7 = getCell(locn7);
        }

        break;
      }


      //NOTE TRY ALTERNATING RUNNING EVEN/ODD by row Y % 2 value. 
      //Run The even rows X phase 0, odd rows phase 3?


      // We treat any cell with abs value > 1 as a jumper cell

      // Let edge case: jumper to right of blue cell causes blue cell to jump to +7 to go into interstitial position
      if ((cn1 != null) && (c3 != null)) {
        //          println("LEFT EDGE A @ "+cell);
        proposeSwap(locn1, loc5);
      } else if ( (cn1 != null)  && (cn2 == null) && (cn4 != null) && (c2 == null))
      { //   jumper moves back to left in return shuttle phase
        //          println("SHUTTLE RETURN A @"+cell+",  cn1=="+cn1 +", cn2="+cn2+", cn4="+cn4);
        proposeSwap(locn1, locn5);
      } else if (cn5 != null 
        && (c2 != null || cn2 != null)) { // pull jumper cell to the right
        proposeSwap(locn5, locn1);
        //          println("PULL JUMPER RIGHT @"+cell);
      } else if (cn3 != null && cn1 != null ) { // right central case, jump cell over 
        // . . . . . . . . . . b . B J b . . . b . . . b
        // . . . . . . . . . . b . . J b . B . b . . . b
        //          println("RIGHT CENTRAL @"+cell);
        proposeSwap(locn1, loc5);
      } else if (cn1 != null 
        &&  c1 == null  && c2 == null) { // left side turnaround. Move jumper to other side
        // . . . . J b . . . b . . . b
        // . . . . . b J . . b . . . b
        //          println("LEFTSIDE TURNAROUND @"+cell);
        proposeSwap(locn1, loc1);
      }
    }
  }

  void brick2(int z, int NX, int NY, int STARTX, int STARTY) {


    // special line of vertical jump tokens, use special high order bit to signify we are all jump tokens
    addCell(STARTX-1, STARTY-1, z, 1 ); //jump token starts on left
    for (int x = STARTX, m = NX; m > 0; m--, x+=4) {
      addCell(x, STARTY-1, z, 1);
    }


    for (int y = STARTY, n = NY;  n > 0; n--,  y+=4) {
      addCell(STARTX-1, y, z, 1); //jump token starts on left

      for (int x = STARTX, m = NX; m > 0; m--, x+=4) {
        addCell(x, y, z, 1);
      }
    }
  }


  void initConfig() {
    brick1(8,16,20, -10, -10, 1);
    
  }
  
  void brick1(int NX, int NY,  int NZ, int STARTX, int STARTY, int STARTZ) {

    brick2(STARTZ-1, NX, NY, STARTX, STARTY);

    for (int z = STARTZ, n = NZ;  n > 0; n--,  z+=4) {
      brick2(z, NX, NY, STARTX, STARTY);
    }
  }
}

