
// rule for X,Y gliders with + and - state

class Rule2 extends Rule {
  // tmp working registers for coordinates
  Coord p1 = new Coord(0, 0, 0);
  Coord p2 = new Coord(0, 0, 0);
  Coord p3 = new Coord(0, 0, 0);
  Coord p4 = new Coord(0, 0, 0);
  Coord p5 = new Coord(0, 0, 0);
  Coord p6 = new Coord(0, 0, 0);

  Coord ptest = new Coord(0, 0, 0);

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
  //horiz/vertical moves XY plane

  Swap dxy1 = new Swap(
  1, 0, 0, 
  3, 0, 0
    );

  Swap dxy2 = new Swap(
  1, 0, 0, 
  0, 1, 0
    );

  Coord dtestxy = new Coord(3, 0, 0);  // check the value of this cell to decide which swap to do (linear or diagonal)

  // moves XZ plane

  Swap dxz1 = new Swap(
  1, 0, 0, 
  3, 0, 0);

  Swap dxz2 = new Swap(
  1, 0, 0, 
  0, 0, 1);

  Coord dtestxz = new Coord(3, 0, 0);  // check the value of this cell to decide which swap to do (linear or diagonal)


  // moves YZ plane
  Swap dyz1 = new Swap(
  0, 1, 0, 
  0, 3, 0);

  Swap dyz2 = new Swap(
  0, 1, 0, 
  0, 0, 1);

  Coord dtestyz = new Coord(0, 3, 0);  // check the value of this cell to decide which swap to do (linear or diagonal)


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
      busybox(cells, dxy1, dxy2, dtestxy);
      break;
    case 1:
      busybox(cells, dyz1, dyz2, dtestyz);
      break;
    case 2:
      busybox(cells, dxz1, dxz2, dtestxz);
      break;
    case 3:
      busybox(cells, dxy1, dxy2, dtestxy);
      break;
    case 4:
      busybox(cells, dyz1, dyz2, dtestyz);
      break;
    case 5:
      busybox(cells, dxz1, dxz2, dtestxz);
      break;
    }
  }

  void busybox(ArrayList<Cell> cells, Swap s1, Swap s2, Coord dtest) {
    Cell cell2; // temp var to examine value of other cell
    for (Cell cell : cells) {
      Coord.add(cell.loc, s1.a, p1); // p1 := cell + delta1
      Coord.add(cell.loc, s1.b, p2); // p1 := cell + delta2
      Coord.add(cell.loc, s2.a, p3);
      Coord.add(cell.loc, s2.b, p4);

      Coord.add(cell.loc, dtest, ptest);
      cell2 = grid.get(ptest);

      if (cell.state != 0  &&  cell2 != null && cell2.state == -cell.state) { // is outlying cell opposite sign?
        proposeSwap(p1, p2);
      } else {
        proposeSwap(p3, p4);
      }

      Coord.sub(cell.loc, s1.a, p1); // p1 := cell + delta1
      Coord.sub(cell.loc, s1.b, p2); // p1 := cell + delta2
      Coord.sub(cell.loc, s2.a, p3);
      Coord.sub(cell.loc, s2.b, p4);

      Coord.sub(cell.loc, dtest, ptest);
      cell2 = grid.get(ptest);

      if (cell.state != 0 &&  cell2 != null && cell2.state == -cell.state) { // is outlying cell opposite sign?
        proposeSwap(p1, p2);
      } else {
        proposeSwap(p3, p4);
      }
    }
  }
}

