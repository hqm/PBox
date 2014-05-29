
class Rule1 extends Rule {
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

  //knights moves XY plane

  Coord dxy1 = new Coord(2, 1, 0);
  Coord dxy2 = new Coord(1, 2, 0);

  Coord dxy5 = new Coord(2, -1, 0);
  Coord dxy6 = new Coord(1, -2, 0);

  //knights moves XZ plane
  Coord dxz1 = new Coord(2, 0, 1);
  Coord dxz2 = new Coord(1, 0, 2);

  Coord dxz5 = new Coord(2, 0, -1);
  Coord dxz6 = new Coord(1, 0, -2);

  //knights moves YZ plane
  Coord dyz1 = new Coord(0, 2, 1);
  Coord dyz2 = new Coord(0, 1, 2);

  Coord dyz5 = new Coord(0, 2, -1);
  Coord dyz6 = new Coord(0, 1, -2);


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
      busybox(cells, dxy1, dxy2);
      busybox(cells, dxy5, dxy6);
      break;
    case 1:
      busybox(cells, dyz1, dyz2);
      busybox(cells, dyz5, dyz6);
      break;
    case 2:
      busybox(cells, dxz1, dxz2);
      busybox(cells, dxz5, dxz6);
      break;
    case 3:
      busybox(cells, dxy1, dxy2);
      busybox(cells, dxy5, dxy6);
      break;
    case 4:
      busybox(cells, dyz1, dyz2);
      busybox(cells, dyz5, dyz6);
      break;
    case 5:
      busybox(cells, dxz1, dxz2);
      busybox(cells, dxz5, dxz6);
      break;
    }
  }

  void busybox(ArrayList<Cell> cells, Coord d1, Coord d2) {

    for (Cell cell : cells) {
      Coord.add(cell.loc, d1, p1); // p1 := cell + delta1
      Coord.add(cell.loc, d2, p2); // p1 := cell + delta1
      if (cell.state != 0) {
        proposeSwap(p1, p2);
      }
      Coord.sub(cell.loc, d1, p1); // p1 := cell + delta1
      Coord.sub(cell.loc, d2, p2); // p1 := cell + delta1
      if (cell.state != 0) {
        proposeSwap(p1, p2);
      }
    }
  }
}
