
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

  class Swap {
    Coord a;
    Coord b;
    public Swap(int x1, int y1, int z1, int x2, int y2, int z2) {
      a = new Coord(x1, y1, z1);
      b = new Coord(x2, y2, z2);
    }
  }


  Swap dxy1 = new Swap(2, 1, 0, 1, 2, 0);
  Swap dxy2 = new Swap(2, -1, 0, 1, -2, 0);

  //knights moves XZ plane
  Swap dxz1 = new Swap(2, 0, 1, 1, 0, 2);
  Swap dxz2 = new Swap(2, 0, -1, 1, 0, -2);

  //knights moves YZ plane
  Swap dyz1 = new Swap(0, 2, 1, 0, 1, 2);
  Swap dyz2 = new Swap(0, 2, -1, 0, 1, -2);

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
      break;
    case 1:
      busybox(cells, dyz1, dyz2);
      break;
    case 2:
      busybox(cells, dxz1, dxz2);
      break;
    case 3:
      busybox(cells, dxy1, dxy2);
      break;
    case 4:
      busybox(cells, dyz1, dyz2);
      break;
    case 5:
      busybox(cells, dxz1, dxz2);
      break;
    }
  }

  void busybox(ArrayList<Cell> cells, Swap s1, Swap s2) {

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


  void initConfig() {

    addCircular("X", 10,10, 10, 20);
  }

  void addCircular(String orientation, int x, int y, int z, int d) {
    int k = 0; 
    int j = 0;
    for (int i = 0; i < d; i++) {
      addCell(x-j, y-k, z, 1);  
      if (i % 2 == 0) {
        j+=2; 
        k+=1;
      } else {
        j+=1; 
        k+=2;
      }
    }
    addCell(x+1, y, z-2, 1);
  }
}

