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

  // track the swaps, to prevent conflicts
  public static final int CAN_SWAP  = 0;
  public static final int CONFLICT = 1;
  public static final int SWAPPED   = 2;

  public CellMode mode = CellMode.CAN_SWAP;

  public String toString() {
    return "<Cell:"+loc+" s="+state+" swapState="+mode+">";
  }
  public String getJson() {
    return("{\"x\": "+loc.x+", \"y\": "+loc.y+",\"z\": "+loc.z+","+
      "\"s\": "+ state+"}");
  }
}
