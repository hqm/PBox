import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 
import java.util.HashMap; 
import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PBox extends PApplet {

PeasyCam cam;

HashMap<PVector, Cell> grid = new HashMap<PVector, Cell>();
ArrayList<Cell> cells = new ArrayList<Cell>();

int[] cellColors = {
  color(255, 0, 0), // state = 1  REAL
  color(100, 0, 100), // state = -1 REAL
  color(25, 100, 0), // state = 1  IMG
  color(100, 77, 228) // state = -1  IMG
};

int gridSize = 20;
int cellSize = 10;

public void setup() {
  size(1000, 800, P3D);
  cam = new PeasyCam(this, 300);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
  initCells();
}

public void initCells() {
  cells.add(new Cell(0, 0,0));
  cells.add(new Cell(2, 0,0,-1));
  cells.add(new Cell(1, 1,0));
  cells.add(new Cell(3, 1,0,-1));
  
   cells.add(new Cell(4, 4,0,-1));
  cells.add(new Cell(6, 4,0));
  cells.add(new Cell(5, 5,0,-1));
  cells.add(new Cell(7, 4,1));

}

public void drawGrid() {
  int offset = (gridSize / 2);
  int C = -cellSize/2;
  for (int i = 0; i <= gridSize; i++) {
    line((i-offset)*cellSize+C, -gridSize*cellSize, 0, 
    (i-offset)*cellSize+C, gridSize*cellSize, 0);

    line(-gridSize*cellSize, (i-offset)*cellSize+C, 0, 
    gridSize*cellSize, (i-offset)*cellSize+C, 0);
    stroke(80, 80, 80);
  }
}
public void draw() {
  rotateX(0);
  rotateY(0);
  background(200, 200, 200);
  lights();


  noStroke();
  for (Cell cell : cells) {
    pushMatrix();
    translate(
    (cell.loc.x )*cellSize, 
    (cell.loc.y)*cellSize, 
    (cell.loc.z)*cellSize
      );

    if ((cell.loc.x+cell.loc.y+cell.loc.z)%2 == 0) {
      if (cell.state == 1) 
        fill(cellColors[0]);
      else  
        fill(cellColors[1]);
    } 
    else {
       if (cell.state == 1) 
        fill(cellColors[2]);
      else  
        fill(cellColors[3]);
    }
    box(cellSize);
    popMatrix();
  }


  pushMatrix();
  translate(0, 0, 20);
  fill(0, 255, 0);
  box(5);
  popMatrix();


  drawGrid();
}



public class Cell {
  public PVector loc = new PVector(0,0,0);
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "PBox" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
