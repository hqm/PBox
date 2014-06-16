
// rule for X,Y gliders with + and - state

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

  void rule3(ArrayList<Cell> cells, int phase) {

    for (Cell cell : cells) {
      switch(phase) {
      case 0:
      case 1:
        p1.set(cell.loc);
        p2.set(cell.loc);
        p1.x -= 1;
        p2.x -= 3;
        proposeSwap(p1, p2);


        p1.set(cell.loc);
        p2.set(cell.loc);
        p1.x += 1;
        p2.x += 3;
        proposeSwap(p1, p2);
        break;
      }
    }
  }



  void initConfig() {
    addCell(0, 0, 0, 1);
    addCell(1, 0, 0, 1);
  }
}

