
// rule for X,Y gliders with + and - state

class Rule2 extends Rule {
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

  //horiz/vertical moves XY plane

  Coord dx1 = new Coord(1, 0, 0);
  Coord dx2 = new Coord(3, 0, 0);

  // moves XZ plane

  Coord dz1 = new Coord(0, 0, 1);
  Coord dz2 = new Coord(0, 0, 3);

  // moves YZ plane
  Coord dy1 = new Coord(0, 1, 0);
  Coord dy2 = new Coord(0, 3, 0);


  void runRule() {
    int phase = clockPhase();

    ArrayList<Cell> cells;
    if (phase % 2 == 0) {
      cells = evenCells;
    } else {
      cells = oddCells;
    }

    switch(phase) {
    case 0:
      busybox(cells, dx1, dx2);
      break;
    case 1:
      busybox(cells, dy1, dy2);
      break;
    case 2:
      busybox(cells, dz1, dz2);
      break;
    case 3:
      busybox(cells, dx1, dx2);
      break;
    case 4:
      busybox(cells, dy1, dy2);
      break;
    case 5:
      busybox(cells, dz1, dz2);
      break;
    }
  }

  void busybox(ArrayList<Cell> cells, Coord d1, Coord d2) {

    for (Cell cell : cells) {
      Coord.add(cell.loc, d1, p1); // p1 := cell + delta1
      Coord.add(cell.loc, d2, p2); // p1 := cell + delta1
      if (cell.state == 1) {
        proposeSwap(p1, p2);
      }
      Coord.sub(cell.loc, d1, p1); // p1 := cell + delta1
      Coord.sub(cell.loc, d2, p2); // p1 := cell + delta1
      if (cell.state == 1) {
        proposeSwap(p1, p2);
      }
    }
  }
}
