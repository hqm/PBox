import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 

class Cell {
  
  static final int CAN_SWAP  = 0;
  static final int CONFLICT = 1;
  static final int SWAPPED   = 2;
  
  PVector loc = new PVector(0, 0, 0);
  int swapState = CAN_SWAP;
  PVector swapTarget = null;

  void clearSwaps() {
    swapTarget = null;
    swapState = CAN_SWAP;
  }

  int state = 1;

  public Cell(int x, int y, int z, int state) {
    loc.x = x;
    loc.y = y;
    loc.z = z;
    this.state = state;
  }

  public Cell(int x, int y, int z) {
    loc.x = x;
    loc.y = y;
    loc.z = z;
  }
}
