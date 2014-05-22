import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 

class Cell {
  PVector loc = new PVector(0, 0, 0);
  boolean willSwap = true;
  Cell swapWith = null;
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
