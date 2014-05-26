
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
    public Swap(int x1,int y1,int z1, int x2,int y2,int z2) {
      a = new Coord(x1,y1,z1);
      b = new Coord(x2,y2,z2);
    }
  }
  // moves XY plane

    Swap dxy1 = new Swap(1,0,0,
                        3,0,0);


    Swap dxy2 = new Swap(1, 0, 0,
                         0, 0, 1);

  // moves XZ plane

    Swap dxz1 =  new Swap(0, 0, 1,
                          0, 0, 3);

    Swap dxz2 = new Swap(0, 0, 1,
                         0, 1, 0);

    // moves YZ plane
    Swap dyz1 = new Swap(0, 1, 0,
                       0, 3, 0);

    Swap dyz2 = new Swap(1, 0, 0,
                         0, 1, 0);


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
      rule3(cells, dyz1, dyz2 );
      break;
    case 3:
      rule3(cells, dxy1, dxy2);
      break;
    case 4:
      rule3(cells, dxz1, dxz2);
      break;
    case 5:
      rule3(cells, dyz1, dyz2 );
      break;
    }
  }

  void rule3(ArrayList<Cell> cells, Swap s1, Swap s2) {

    for (Cell cell : cells) {
      if (cell.state == 1) {
          Coord.add(cell.loc, s1.a, p1); // p1 := cell + delta1
          Coord.add(cell.loc, s1.b, p2); // p1 := cell + delta1
          proposeSwap(p1, p2);

          Coord.sub(cell.loc, s1.a, p1); // p1 := cell + delta1
          Coord.sub(cell.loc, s1.b, p2); // p1 := cell + delta1
          proposeSwap(p1, p2);
      } else if (cell.state == -1) {
          Coord.add(cell.loc, s2.a, p1); // p1 := cell + delta1
          Coord.add(cell.loc, s2.b, p2); // p1 := cell + delta1
          proposeSwap(p1, p2);

          Coord.sub(cell.loc, s2.a, p1); // p1 := cell + delta1
          Coord.sub(cell.loc, s2.b, p2); // p1 := cell + delta1
          proposeSwap(p1, p2);
      }
    }
  }
}
