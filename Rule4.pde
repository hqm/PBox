// rule for X,Y gliders with + and - state
/*

 Strangely enough, I am now also interested in models that fill space
 with gliders that each move only in + or - X direction, or only + or
 – Y direction or only in + or – Z direction, until they have a
 collision.  The results of a collision could change the directions of
 both colliding Gliders, in a way that conserves momentum.
 
 In other words, these gliders would go straight down a coordinate
 axis, until 2 of them collide, the collision alters directions, but
 within the rules that momentum is conserved, and each of the
 resulting trajectories are each still in parallel to one of the
 Cartesian Coordinate axes.  */

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
  0, 1, 0);


  Swap dxy2 = new Swap(
  1, 0, 0, 
  0, -1, 0);

  // moves XZ plane

  Swap dxz1 =  new Swap(
  0, 0, 1, 
  1, 0, 0);

  Swap dxz2 = new Swap(
  0, 0, -1, 
  -1, 0, 0);

  // moves YZ plane
  Swap dyz1 = new Swap(
  0, 1, 0, 
  0, 0, 1);

  Swap dyz2 = new Swap(
  0, 1, 0, 
  0, 0, -1);



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
      rule4(cells, dxy1, dxy2);
      break;
    case 1:
      rule4(cells, dxz1, dxz2);
      break;
    case 2:
      rule4(cells, dyz1, dyz2 );
      break;
    case 3:
      rule4(cells, dxy1, dxy2);
      break;
    case 4:
      rule4(cells, dxz1, dxz2);
      break;
    case 5:
      rule4(cells, dyz1, dyz2 );
      break;
    }
  }

  void rule4(ArrayList<Cell> cells, Swap s1, Swap s2) {

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


  // the default starting configuration
  void initConfig() {

    int N = 5;
    for (int x = -N; x < N; x+=1) {
      for (int y = -N; y < N; y+=2) {
        for (int z = -N; z < N; z+=2) {
          addCell(x, y, z, round(random(-1, 1)));
        }
      }
    }
  }
}

