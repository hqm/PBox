Coord deltaX = new Coord(1, 0, 0);
Coord deltaY = new Coord(0, 1, 0);
Coord deltaZ = new Coord(0, 0, 1);

Coord ndeltaX = new Coord(-1, 0, 0);
Coord ndeltaY = new Coord(0, -1, 0);
Coord ndeltaZ = new Coord(0, 0, -1);

void computeNextStep() {
  int phase = clockPhase();
  swaps.clear();

  clearSwapState(realCells);
  clearSwapState(imagCells);

  switch(phase) {
  case 0:
    theRule(realCells, deltaX);
    theRule(realCells, ndeltaX);
    break;
  case 2:
    theRule(realCells, deltaY);
    theRule(realCells, ndeltaY);
    break;
  case 4:
    theRule(realCells, deltaZ);
    theRule(realCells, ndeltaZ);
    break;
  case 1:
    theRule(imagCells, deltaX);
    theRule(imagCells, ndeltaX);
    break;
  case 3:
    theRule(imagCells, deltaY);
    theRule(imagCells, ndeltaY);
    break;
  case 5:
    theRule(imagCells, deltaZ);
    theRule(imagCells, ndeltaZ);
    break;
  }

  doSwaps();
}

void theRule(ArrayList<Cell> cells, Coord delta) {

  for (Cell cell : cells) {
    Coord.add(cell.loc, delta, p1); // p1 := cell + delta
    if (debug) println("eval "+cell.loc+", read cell @+ deltaX => p1  "+p1);
    if (cell.state == 1) {
      Coord.add(p1, delta, p2); // p2 = rx+1
      p2.add(delta); // rx+2
      proposeSwap(p1, p2); // propose a swap to the right, i.e., repel
    }
  }
}
