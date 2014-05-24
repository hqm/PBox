// 3d cellular automata //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 
//

import java.util.HashMap; 
import java.util.Map; 
import java.util.Map.Entry; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

import javax.swing.*;
import java.awt.Container;
import java.awt.GridLayout;
import java.awt.event.*;

// Beanshell interpreter for debugging
import bsh.*;


PeasyCam cam;
boolean singleStep = false;
boolean run = false;
boolean fast = true;
boolean debug = true;

int clock = 0;
int fastclock = 0;
boolean wrap = true;
boolean forward = true;

public static PBox app;

// Hash table which holds position of all cells
public HashMap<Coord, Cell> grid = new HashMap<Coord, Cell>();

// Keep track of which cell a given cell is supposed to swap with. Used to find and prevent
// conflicting swaps.
// Using a cell location as a key, holds the target location that this cell is proposed to swap with
public HashMap<Coord, ArrayList<Coord>> swaps = new HashMap<Coord, ArrayList<Coord>>();

// List of the cells in real plane
public ArrayList<Cell> realCells = new ArrayList<Cell>();
// List of cells in imaginary plane
public ArrayList<Cell> imagCells = new ArrayList<Cell>();


public Coord cursorPos = new Coord(0, 0, 0);
int cursorVal = 1;

// tmp working registers for coordinates
Coord p1 = new Coord(0, 0, 0);
Coord p2 = new Coord(0, 0, 0);
Coord p3 = new Coord(0, 0, 0);
Coord target = new Coord(0, 0, 0);
Coord delta = new Coord(0, 0, 0);

static final int CURSOR_ALPHA = 30;

int[] realColors = {
  color(255, 0, 0), // state = 1  REAL
  color(255, 200, 0) // state = -1 REAL
};

int[] imagColors = {
  color(0, 0, 255), // state = 1  IMG
  color(0, 255, 20) // state = -1  IMG
};

int gridSize = 32;
int cellSize = 10;

void initJFrame(JFrame f) {
  f.setSize(250, 600);
  f.setVisible(true);
}

RootGUI statusFrame = null;

void updateStatusFrame() {
  statusFrame.clockLabel.setText("Clock: "+clock/6+"#"+clockPhase());
  statusFrame.phaseLabel.setText("Phase: "+clockPhase());
  statusFrame.debugLabel.setText("Debug: "+debug);
  statusFrame.directionLabel.setText("Direction: "+ (forward ? "forward" : "backward"));
  statusFrame.speedLabel.setText("Speed: "+ (fast ? "fast" : "slow"));
  statusFrame.wrapLabel.setText("Wrap: "+ wrap);
}

int clockPhase() {
  int phi = clock % 6;
  if (phi < 0) phi = phi+6;
  return phi;
}

void setup() {
  size(1000, 800, P3D);
  smooth(4);

  System.setProperty("java.awt.headless", "false");
  System.setProperty("apple.laf.useScreenMenuBar", "true");
  System.setProperty("com.apple.mrj.application.apple.menu.about.name", "Test");
  //UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  statusFrame = new RootGUI(this);
  initJFrame(statusFrame);

  app = this;


  if (frame != null) {
    frame.setResizable(true);
  }

  cam = new PeasyCam(this, 300);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(1000);
  loadConfig(1);
  frameRate(60);
}

void addCell(int x, int y, int z, int state) {
  Cell cell = new Cell(x, y, z, state);  
  grid.put(cell.loc, cell);
  if ((x+y+z)%2 == 0) {
    // real
    realCells.add(cell);
  } else {
    imagCells.add(cell);
  }
}


void deleteCell(Cell c) {
  grid.remove(c.loc);
  if ((c.loc.x+c.loc.y+c.loc.z)%2 == 0) {
    // real
    realCells.remove(c);
  } else {
    imagCells.remove(c);
  }
}


// clear all cells
void clearWorld() {
  grid.clear(); 
  realCells.clear();
  imagCells.clear();
  clock = 0;
}

void loadConfig(int n) {
  clearWorld();
  switch(n) {
  case 1:
    initConfig1();
    break;
  case 2:
    initConfig2();
    break;
  }
}

void initConfig1() {
  addCell(0, 0, 0, 1);
  addCell(1, 0, 0, 1);
}

void initConfig2() {
  addCell(0, 0, 0, 1);
  addCell(1, 0, 0, 1);
  addCell(4, 0, 0, 1);
}

void drawGrid() {
  int offset = (gridSize / 2);
  int C = -cellSize/2;
  for (int i = 0; i < gridSize+2; i++) {
    line((i-offset)*cellSize+C, -gridSize*cellSize/2-C, C, 
    (i-offset)*cellSize+C, gridSize*cellSize/2-C, C);

    line(-gridSize*cellSize/2-C, (i-offset)*cellSize+C, C, 
    gridSize*cellSize/2-C, (i-offset)*cellSize+C, C);
    stroke(125);
  }
}



void draw() {

  //        if (singleStep == false && run == false) {



  rotateX(0);
  rotateY(0);
  background(255);

  // draw status text
  textMode(SHAPE);
  fill(100, 100, 100);
  textSize(10);
  if (run ) {
    text("clock: "+clock/6+"#"+clockPhase(), ((gridSize/2)-8)*cellSize, -(gridSize/2)*cellSize, -10);
  } else {
    text("paused: "+clock/6+"#"+clockPhase(), ((gridSize/2)-8)*cellSize, -(gridSize/2)*cellSize, -10);
  }

  lights();

  noStroke();
  drawCells(realCells);
  drawCells(imagCells);

  drawCursor();
  drawGrid();

  // Draw axes 
  pushMatrix();
  translate(-(gridSize/2) * cellSize, -(gridSize/2) * cellSize, cellSize);
  stroke(255, 0, 0);
  line(0, 0, 0, 0, 0, 20);
  stroke(0, 255, 0);
  line(0, 0, 0, 20, 0, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 20, 0);
  noStroke();
  popMatrix();

  updateStatusFrame();
  if (fast || fastclock%5 == 0) {
    if (run || singleStep ) {
      computeNextStep();
      if (forward) {
        clock++;
      } else {
        clock--;
      }
      singleStep = false;
    }
  }
  fastclock++;
}

void drawCells(ArrayList<Cell> cells) {

  for (Cell cell : cells) {
    pushMatrix();
    translate(
    (cell.loc.x )*cellSize, 
    (cell.loc.y)*cellSize, 
    (cell.loc.z)*cellSize
      );

    if ((cell.loc.x+cell.loc.y+cell.loc.z)%2 == 0) { // real
      fill( (cell.state == 1) ? realColors[0] : realColors[1] );
    } else { // imaginary
      fill( (cell.state == 1) ? imagColors[0] : imagColors[1] );
    }

    box(cellSize);
    popMatrix();
  }
}

void drawCursor() {
  hint(DISABLE_DEPTH_TEST);

  pushMatrix();
  translate(
  (cursorPos.x )*cellSize, 
  (cursorPos.y)*cellSize, 
  (cursorPos.z)*cellSize
    );

  if ((cursorPos.x+cursorPos.y+cursorPos.z)%2 == 0) { // real
    fill( (cursorVal == 1) ? realColors[0] : realColors[1], CURSOR_ALPHA );
  } else { // imaginary
    fill( (cursorVal == 1) ? imagColors[0] : imagColors[1], CURSOR_ALPHA);
  }

  box(cellSize);
  popMatrix();
  hint(ENABLE_DEPTH_TEST);
}

// When proposing to swap cell A and B
// we push the target loc B onto the location A's swaps list.
// 
// We also push the location A onto target location B's swaps list.
void proposeSwap(Coord oa, Coord ob) {
  Coord a = oa.get();
  Coord b = ob.get();

  if (wrap) {
    a.wrap(gridSize);
    b.wrap(gridSize);
  }
  if (debug) println("proposeSwap("+a+"<=>"+b);

  ArrayList<Coord> swaps_a = swaps.get(a);
  if (swaps_a == null) {
    swaps_a = new ArrayList<Coord>();
    swaps.put(a, swaps_a);
  }
  if (!swaps_a.contains(b)) {
    swaps_a.add(b);
  }

  ArrayList<Coord> swaps_b = swaps.get(b);
  if (swaps_b == null) {
    swaps_b = new ArrayList<Coord>();
    swaps.put(b, swaps_b);
  }
  if (!swaps_b.contains(a)) {
    swaps_b.add(a);
  }
}

void clearSwapState(ArrayList<Cell> cells) {
  for (Cell cell : cells) {
    cell.mode = CellMode.CAN_SWAP;
  }
}

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

// Loop over all proposed swaps, and only swap two cells when they are the only designated swaps for each other
void doSwaps() {
  for (Map.Entry entry : swaps.entrySet ()) {
    Coord locA = (Coord) entry.getKey();  
    ArrayList<Coord> swapsA = (ArrayList<Coord>) entry.getValue();
    if (debug) println("locA = "+locA+" swapsA="+swapsA);
    if (swapsA.size() > 1) {
      if (debug) println("evalSwap  more than one proposed swap at "+locA+" = "+swapsA);
      continue; // we're designated to swap with more than one target, so do no swap
    }
    Coord locB = swapsA.get(0);
    ArrayList<Coord> swapsB = swaps.get(locB);
    if (swapsB.size() > 1) {
      if (debug) println("evalSwap  more than one proposed swap at "+locB+" (from "+locA+") = "+swapsB);
      continue;
    }
    if (swapsB.get(0).equals(locA)) {
      // other cell has just one swap, and it's a swap with us, so let's swap
      swapCells(locA, locB);
    }
  }
}

// moves a cell from it's location to dest. This will bash whatever is in dest, so only do this when moving to an empty location
void moveCell(Cell a, Coord dest) {
  if (debug) println("moveCell "+a+" to "+dest);
  grid.remove(a.loc); // remove cell from current grid pos
  a.loc.set(dest); // copy dest location value
  if (debug) println("a.loc = "+a.loc);
  grid.put(dest, a);
  a.mode = CellMode.SWAPPED;
  if (debug) println(".... moved "+a);
}

Coord _prevA = new Coord();
Coord _prevB = new Coord();

void swapCells(Coord locA, Coord locB) {
  Cell a = grid.get(locA);
  Cell b = grid.get(locB);
  if (debug) println("swapCells "+locA+" "+a+ ", "+locB+" "+b);
  if (a != null && b != null && a.mode == CellMode.CAN_SWAP && b.mode == CellMode.CAN_SWAP) {
    if (debug) println("... swapping non-null cells a="+a+", b="+b);
    _prevA.set(a.loc);
    _prevB.set(b.loc);
    grid.put(b.loc, a);
    grid.put(a.loc, b);
    a.loc.set(b.loc);
    b.loc.set(_prevA);
    a.mode = CellMode.SWAPPED;
    b.mode = CellMode.SWAPPED;
    if (debug) println("... swapped cells a="+a+", b="+b);
  } else if (a != null &&  a.mode == CellMode.CAN_SWAP) {
    if (debug) println("... swapping a "+a+" with empty loc "+locB);
    moveCell(a, locB);
  } else if (b != null && b.mode == CellMode.CAN_SWAP) {
    if (debug) println("... swapping b"+b+" with empty loc "+locA);
    moveCell(b, locA);
  } else {
    if (debug) println("... swapCells did nothing");
  }
}

// sets cell value at position
void toggleCellAtCursor() {
  Cell c = grid.get(cursorPos);
  if (c == null) {
    // create new cell with current cursor state
    addCell(cursorPos.x, cursorPos.y, cursorPos.z, cursorVal);
  } else {
    // existing cell, if it is 1, change to -1. If -1, delete it.
    if (c.state == 1) {
      c.state = -1;
    } else if (c.state == -1) {
      deleteCell(c);
    }
  }
}

public void keyPressed() {
  if (key == ' ') { // SPACE char means single step n clock steps ( one action time )
    run = false;
    singleStep = true;
  } else if (key == 'r') {
    run = true;
    singleStep = false;
  } else if (key == 'B') {
    bsh.Console.main(new String[] {
      "util.bsh"
    }
    );
  } else if (key == 'z') {
    if (forward) {
      clock--;
    } else {
      clock++;
    }
    forward = !forward;
  } else if (key == 'D') {
    debug = !debug;
  } else if (keyCode == UP) {
    cursorPos.y -= 1;
    if (wrap) cursorPos.wrap(gridSize);
  } else if (keyCode == DOWN) {
    cursorPos.y += 1;
    if (wrap) cursorPos.wrap(gridSize);
  } else if (keyCode == LEFT) {
    cursorPos.x -= 1;
    if (wrap) cursorPos.wrap(gridSize);
  } else if (keyCode == RIGHT) {
    cursorPos.x += 1;
    if (wrap) cursorPos.wrap(gridSize);
  } else if (key == 'u') { 
    cursorPos.z += 1;
    if (wrap) cursorPos.wrap(gridSize);
  } else if (key == 'd') { 
    cursorPos.z -= 1;
    if (wrap) cursorPos.wrap(gridSize);
  } else if (keyCode == ENTER) {
    toggleCellAtCursor();
  } else if (key == 's') {
    fast = !fast;
  } else if (key == 'w') {
    wrap = !wrap;
  }
}
