

// tmp working registers for coordinates
Coord p1 = new Coord(0, 0, 0);
Coord p2 = new Coord(0, 0, 0);
Coord p3 = new Coord(0, 0, 0);
Coord p4 = new Coord(0, 0, 0);




Coord deltaX1 = new Coord(1, 0, 0);
Coord deltaY1 = new Coord(0, 1, 0);
Coord deltaZ1 = new Coord(0, 0, 1);


Coord deltaX3 = new Coord(3, 0, 0);
Coord deltaY3 = new Coord(0, 3, 0);
Coord deltaZ3 = new Coord(0, 0, 3);


Coord ndeltaX1 = new Coord(-1, 0, 0);
Coord ndeltaY1 = new Coord(0, -1, 0);
Coord ndeltaZ1 = new Coord(0, 0, -1);


Coord ndeltaX3 = new Coord(-3, 0, 0);
Coord ndeltaY3 = new Coord(0, -3, 0);
Coord ndeltaZ3 = new Coord(0, 0, -3);

Coord deltaXY1 = new Coord(2, 1, 0);
Coord deltaXY2 = new Coord(1, 2, 0);
Coord deltaXY3 = new Coord(-1, 2, 0);
Coord deltaXY4 = new Coord(-2, -1, 0);

Coord deltaXZ1 = new Coord(1, 0, 2);
Coord deltaXZ2 = new Coord(2, 0, 1);
Coord deltaXZ3 = new Coord(2, 0, -1);
Coord deltaXZ4 = new Coord(-2,0, -1);

Coord deltaYZ1 = new Coord(0, 2, 1);
Coord deltaYZ2 = new Coord(0, 1, 2);
Coord deltaYZ3 = new Coord(-0, 1, 2);
Coord deltaYZ4 = new Coord(0, -2, 1);







void computeNextStep() {
  int phase = clockPhase();
  swaps.clear();

  clearSwapState(realCells);
  clearSwapState(imagCells);

  ArrayList<Cell> cells;
  if (phase % 2 == 0) {
      cells = realCells;
  } else {
      cells = imagCells;
  }

  switch(phase/2) {
  case 0:
    theRule(cells, deltaX1, deltaX3,deltaY1, deltaY3);
    theRule(cells, ndeltaX1, ndeltaX3,ndeltaY1, ndeltaY3 );

    theRule(cells, deltaXY1, deltaXY2 , deltaYZ1, deltaYZ2 );
    theRule(cells, deltaXY2, deltaXY3 , deltaYZ2, deltaYZ3 );
    theRule(cells, deltaXY3, deltaXY4, deltaYZ3, deltaYZ4 );
    theRule(cells, deltaXY4, deltaXY1 , deltaYZ4, deltaYZ1);

    break;
  case 1:
    theRule(cells, deltaY1, deltaY3, deltaZ1, deltaZ3);
    theRule(cells, ndeltaY1, ndeltaY3, ndeltaZ1, ndeltaZ3);

    theRule(cells, deltaYZ1, deltaYZ2,deltaXZ1, deltaXZ2  );
    theRule(cells, deltaYZ2, deltaYZ3,  deltaXZ2, deltaXZ3  );
    theRule(cells, deltaYZ3, deltaYZ4, deltaXZ3, deltaXZ4 );
    theRule(cells, deltaYZ4, deltaYZ1, deltaXZ4, deltaXZ1 );


    break;
  case 2:
    theRule(cells, deltaZ1, deltaZ3, deltaX1, deltaX3);
    theRule(cells, ndeltaZ1, ndeltaZ3, ndeltaX1, ndeltaX3);

    theRule(cells, deltaXZ1, deltaXZ2,deltaXY1, deltaXY2 );
    theRule(cells, deltaXZ2, deltaXZ3 ,deltaXY2, deltaXY3 );
    theRule(cells, deltaXZ3, deltaXZ4, deltaXY3 , deltaXY4);
    theRule(cells, deltaXZ4, deltaXZ1, deltaXY4, deltaXY1 );

    break;
  }

  doSwaps();
}

void theRule(ArrayList<Cell> cells, Coord d1, Coord d2, Coord d3, Coord d4) {

  for (Cell cell : cells) {
    Coord.add(cell.loc, d1, p1); // p1 := cell + delta1
    Coord.add(cell.loc, d2, p2); // p1 := cell + delta1
    Coord.add(cell.loc, d3, p3); // p1 := cell + delta1
    Coord.add(cell.loc, d4, p4); // p1 := cell + delta1
    if (cell.state == 1) {
      proposeSwap(p1, p2); 
    } else if (cell.state == -1) {
      proposeSwap(p3, p4); 
    }
  }
}
