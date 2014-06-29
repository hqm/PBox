import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

public class Cell {

  public int state = 1;
  public Coord loc = new Coord(0, 0, 0);


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

  public Cell copy() {
    return new Cell(loc.x,loc.y,loc.z,state);
  }

  // track the swaps, to prevent conflicts
  public static final int CAN_SWAP  = 0;
  public static final int CONFLICT = 1;
  public static final int SWAPPED   = 2;

  public CellMode mode = CellMode.CAN_SWAP;


  public boolean isEven() {
      return ((loc.x + loc.y + loc.z) % 2) == 0;
  }

  public String toString() {
    return "<Cell:"+loc+" s="+state+" swapState="+mode+">";
  }

  public String getCSV() {
    return (loc.x+","+loc.y+","+loc.z+","+state);
  }
}
