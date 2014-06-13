
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
  // moves XY plane

  Swap dxy1 = new Swap(
  1, 0, 0, 
  1, 0, 0);


  Swap dxy2 = new Swap(
  1, 0, 0, 
  0, 1, 0);

  Coord testxy = new Coord(4, 0, 0);

  // moves XZ plane

  Swap dxz1 =  new Swap(
  0, 0, 1, 
  1, 0, 2);

  Swap dxz2 = new Swap(
  0, 1, 0, 
  0, 0, 1);

  Coord testxz = new Coord(0, 0, 4);

  // moves YZ plane
  Swap dyz1 = new Swap(
  0, 1, 0, 
  0, 2, 1);

  Swap dyz2 = new Swap(
  0, 0, 1, 
  1, 0, 0);

  Coord testyz = new Coord(0, 4, 0);


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
      rule3(cells, dxy1, dxy2);
      break;
    case 1:
      rule3(cells, dxz1, dxz2);
      break;
    case 2:
      rule3(cells, dyz1, dyz2);
      break;
    case 3:
      rule3(cells, dxy1, dxy2);
      break;
    case 4:
      rule3(cells, dxz1, dxz2);
      break;
    case 5:
      rule3(cells, dyz1, dyz2);
      break;
    }
  }

  Coord ptest1 = new Coord(0, 0, 0);
  Coord ptest2 = new Coord(0, 0, 0);

  void rule3(ArrayList<Cell> cells, Swap s1, Swap s2) {

    for (Cell cell : cells) {
      addCoords(cell.loc, s1.a, p1); // p1 := cell + delta1
      addCoords(cell.loc, s1.b, p2); // p1 := cell + delta1
      Cell cell1 = grid.get(p1);
      Cell cell2 = grid.get(p2);

      if ((cell2 != null && cell.state != cell2.state ) || (cell1 != null && cell.state != cell1.state )) {
        addCoords(cell.loc, s1.a, p1); // p1 := cell + delta1
        addCoords(cell.loc, s1.b, p2); // p1 := cell + delta1
        proposeSwap(p1, p2);


        subCoords(cell.loc, s1.a, p1); // p1 := cell + delta1
        subCoords(cell.loc, s1.b, p2); // p1 := cell + delta1
        proposeSwap(p1, p2);
      } else {

        addCoords(cell.loc, s2.a, p1); // p1 := cell + delta1
        addCoords(cell.loc, s2.b, p2); // p1 := cell + delta1
        proposeSwap(p1, p2);

        subCoords(cell.loc, s2.a, p1); // p1 := cell + delta1
        subCoords(cell.loc, s2.b, p2); // p1 := cell + delta1
        proposeSwap(p1, p2);
      }
    }
  }

  // the default starting configuration
  void initConfig() {
    int n = 14;
    int x=0;
    int y=0;
    int z=0;
    while (n-- > 0) {

      addCell(x, y, z, 1);
      y++;
    }
  }
}

