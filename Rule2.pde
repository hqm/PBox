
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

  //knights moves XY plane

  class Swap {
    Coord a;
    Coord b;
    public Swap(int x1, int y1, int z1, int x2, int y2, int z2) {
      a = new Coord(x1, y1, z1);
      b = new Coord(x2, y2, z2);
    }
  }


  Swap swaps[] = {
    new Swap(
    2, 1, 0, 
    1, 2, 0), 

    new Swap(
    2, -1, 0, 
    1, -2, 0), 
    //knights moves XZ plane
    new Swap(
    2, 0, 1, 
    1, 0, 2), 
    new Swap(
    2, 0, -1, 
    1, 0, -2), 

    //knights moves YZ plane
    new Swap(
    0, 2, 1, 
    0, 1, 2), 
    new Swap(
    0, 2, -1, 
    0, 1, -2)
    };

    void runRule() {
      int phase = clockPhase();

      ArrayList<Cell> cells;
      if (phase % 2 == 0) {
        cells = evenCells;
      } else {
        cells = oddCells;
      }

      rule(cells, swaps[(phase*2)%6], swaps[((phase*2)+1) %6]);
    }

  void rule(ArrayList<Cell> cells, Swap s1, Swap s2) {

    for (Cell cell : cells) {
      Coord.add(cell.loc, s1.a, p1); // p1 := cell + delta1
      Coord.add(cell.loc, s1.b, p2); // p1 := cell + delta1

      Coord.add(cell.loc, s2.a, p3); // p1 := cell + delta1
      Coord.add(cell.loc, s2.b, p4); // p1 := cell + delta1

      if (cell.state != 0) {
        proposeSwap(p1, p2);
        proposeSwap(p3, p4);
      }

      Coord.sub(cell.loc, s1.a, p1); // p1 := cell + delta1
      Coord.sub(cell.loc, s1.b, p2); // p1 := cell + delta1

      Coord.sub(cell.loc, s2.a, p3); // p1 := cell + delta1
      Coord.sub(cell.loc, s2.b, p4); // p1 := cell + delta1

      if (cell.state != 0) {
        proposeSwap(p1, p2);
        proposeSwap(p3, p4);
      }
    }
  }
}

