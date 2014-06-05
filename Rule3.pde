
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
  3, 0, 0);


  Swap dxy2 = new Swap(
  1, 0, 0, 
  0, 1, 0);

  Coord testxy = new Coord(4, 0, 0);

  // moves XZ plane

  Swap dxz1 =  new Swap(
  0, 0, 1, 
  0, 0, 3);

  Swap dxz2 = new Swap(
  0, 1, 0, 
  0, 0, 1);

  Coord testxz = new Coord(0, 0, 4);

  // moves YZ plane
  Swap dyz1 = new Swap(
  0, 1, 0, 
  0, 3, 0);

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
      rule3(cells, dxy1, dxy2, testxy);
      break;
    case 1:
      rule3(cells, dxz1, dxz2, testxz);
      break;
    case 2:
      rule3(cells, dyz1, dyz2, testyz);
      break;
    case 3:
      rule3(cells, dxy1, dxy2, testxy);
      break;
    case 4:
      rule3(cells, dxz1, dxz2, testxz);
      break;
    case 5:
      rule3(cells, dyz1, dyz2, testyz);
      break;
    }
  }

  Coord ptest = new Coord(0, 0, 0);

  void rule3(ArrayList<Cell> cells, Swap s1, Swap s2, Coord ctest) {

    for (Cell cell : cells) {
      Coord.add(cell.loc, ctest, ptest);
      Cell cell2 = grid.get(ptest);

      if (cell2 == null || cell.state != cell2.state ) {
        Coord.add(cell.loc, s1.a, p1); // p1 := cell + delta1
        Coord.add(cell.loc, s1.b, p2); // p1 := cell + delta1
        proposeSwap(p1, p2);


        Coord.sub(cell.loc, s1.a, p1); // p1 := cell + delta1
        Coord.sub(cell.loc, s1.b, p2); // p1 := cell + delta1
        proposeSwap(p1, p2);
      } else {

        Coord.add(cell.loc, s2.a, p1); // p1 := cell + delta1
        Coord.add(cell.loc, s2.b, p2); // p1 := cell + delta1
        proposeSwap(p1, p2);

        Coord.sub(cell.loc, s2.a, p1); // p1 := cell + delta1
        Coord.sub(cell.loc, s2.b, p2); // p1 := cell + delta1
        proposeSwap(p1, p2);
      }
    }
  }


  // the default starting configuration
  void initConfig() {
    int n = 2000;
    while (n-- > 0) {
      int x = round(random(-32, 32));
      int y = round(random(-32, 32));
      int z = round(random(-32, 32));
      int s = (random(0, 1) < 0.5 ) ? 1 : -1;

      int dx = 0, dy=0, dz=0;
      int r = round(random(0, 3));
      if (r < 1)        dx = (random(0, 1) < 0.5 ) ? 1 : -1;
      else if (r >= 1 && r < 2)        dy = (random(0, 1) < 0.5 ) ? 1 : -1;
      else
        dz = (random(0, 1) < 0.5 ) ? 1 : -1;

      addCell(x, y, z, s);

      addCell(x+dx, y+dy, z+dz, s);
    }
  }
}

