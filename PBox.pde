// 3d cellular automata //<>//

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
boolean debug = true;

int clock = 0;

public static PBox app;

// Hash table which holds position of all cells
public HashMap<PVector, Cell> grid = new HashMap<PVector, Cell>();

// Keep track of which cell a given cell is supposed to swap with. Used to find and prevent
// conflicting swaps.
// Using a cell location as a key, holds the target location that this cell is proposed to swap with
public HashMap<PVector, ArrayList<PVector>> swaps = new HashMap<PVector, ArrayList<PVector>>();

// List of the cells in real plane
public ArrayList<Cell> realCells = new ArrayList<Cell>();
// List of cells in imaginary plane
public ArrayList<Cell> imagCells = new ArrayList<Cell>();


public PVector cursorPos = new PVector(0, 0, 0);

// tmp working registers for coordinates
PVector p1 = new PVector(0, 0, 0);
PVector p2 = new PVector(0, 0, 0);
PVector p3 = new PVector(0, 0, 0);
PVector target = new PVector(0, 0, 0);
PVector delta = new PVector(0, 0, 0);


int[] realColors = {
  color(255, 0, 0), // state = 1  REAL
  color(255, 200, 0) // state = -1 REAL
};

int[] imagColors = {
  color(0, 0, 255), // state = 1  IMG
  color(0, 255, 20) // state = -1  IMG
};

int gridSize = 20;
int cellSize = 10;

void initJFrame(JFrame f) {
  f.setSize(250, 600);
  f.setVisible(true);
}

RootGUI statusFrame = null;

void updateStatusFrame() {
  statusFrame.clockLabel.setText("Clock: "+clock/6+"#"+clock%6);
  statusFrame.phaseLabel.setText("Phase: "+clock%6);
}
void setup() {
  size(1000, 800, P3D);
  println("calling setup");
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
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
  initCells();
}

void addCell(int x, int y, int z, int state) {
  Cell cell = new Cell(x, y, z, state);  
  grid.put(cell.loc, cell);
  if ((x+y+z)%2 == 0) {
    // real
    realCells.add(cell);
  } 
  else {
    imagCells.add(new Cell(x, y, z, state));
  }
}

// clear all cells
void clearWorld() {
  grid.clear(); 
  realCells.clear();
  imagCells.clear();
}

void initCells() {
  clearWorld();
  initConfig1();
}

void initConfig1() {
  addCell(0, 0, 0, 1);
  addCell(1, 0, 0, 1);
}

void drawGrid() {
  int offset = (gridSize / 2);
  int C = -cellSize/2;
  for (int i = 0; i < gridSize+2; i++) {
    line((i-offset)*cellSize+C, -gridSize*cellSize/2-C, C, 
    (i-offset)*cellSize+C, gridSize*cellSize/2-C, C);

    line(-gridSize*cellSize/2-C, (i-offset)*cellSize+C, C, 
    gridSize*cellSize/2-C, (i-offset)*cellSize+C, C);
    stroke(80, 80, 80);
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
    text("clock: "+clock/6+"#"+clock%6, ((gridSize/2)-8)*cellSize, -(gridSize/2)*cellSize, -10);
  } 
  else {
    text("paused: "+clock/6+"#"+clock%6, ((gridSize/2)-8)*cellSize, -(gridSize/2)*cellSize, -10);
  }

  lights();
  drawGrid();

  noStroke();
  drawCells(realCells);
  drawCells(imagCells);


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
  if (run || singleStep ) {
    computeNextStep();
    clock++;
    singleStep = false;
  }
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
    } 
    else { // imaginary
      fill( (cell.state == 1) ? imagColors[0] : imagColors[1] );
    }

    box(cellSize);
    popMatrix();
  }
}


// When proposing to swap cell A and B
// we push the target loc B onto the location A's swaps list.
// 
// We also push the location A onto target location B's swaps list.
void proposeSwap(PVector a, PVector b) {
  if (debug) println("proposeSwap("+a+"<=>"+b);

  ArrayList<PVector> swaps_a = swaps.get(a);
  if (swaps_a == null) {
    swaps_a = new ArrayList<PVector>();
    swaps.put(a, swaps_a);
  }
  if (!swaps_a.contains(b)) {
    swaps_a.add(b);
  }

  ArrayList<PVector> swaps_b = swaps.get(b);
  if (swaps_b == null) {
    swaps_b = new ArrayList<PVector>();
    swaps.put(b, swaps_b);
  }
  if (!swaps_b.contains(a)) {
    swaps_b.add(a);
  }
}

void clearSwaps(ArrayList<Cell> cells) {
  for (Cell cell : cells) {
    cell.mode = CellMode.CAN_SWAP;
  }
  swaps.clear();
}

PVector deltaX = new PVector(1, 0, 0);
PVector deltaY = new PVector(0, 1, 0);
PVector deltaZ = new PVector(0, 0, 1);


void computeNextStep() {
  int phase = clock % 6;
  clearSwaps(realCells);
  clearSwaps(imagCells);

  if (phase == 0) {

    for (Cell cell: realCells) {
      if (debug) println("eval cell "+cell.loc);
      PVector.add(cell.loc, deltaX, p1); // p1 := cell + delta
      // position of cell to right
      Cell r = grid.get(p1);
      if (debug) println("found cell at "+p1+"="+r);
      if (r != null && r.state == 1 && cell.state == 1) {
        PVector.add(p1, deltaX, p2); // p2 = rx+1
        p2.add(deltaX); //

        proposeSwap(p1, p2); // propose a swap to the right, i.e., repel
      }
    }
  }

  doSwaps();
}

// Loop over all proposed swaps, and only swap two cells when they are the only designated swaps for each other
void doSwaps() {
  for (Map.Entry entry : swaps.entrySet()) {
    PVector locA = (PVector) entry.getKey();  
    ArrayList<PVector> swapsA = (ArrayList<PVector>) entry.getValue();
    if (swapsA.size() > 1) {
      if (debug) println("evalSwap  more than one proposed swap at "+locA+" = "+swapsA);
      continue; // we're designated to swap with more than one target, so do no swap
    }
    PVector locB = swapsA.get(0);
    ArrayList<PVector> swapsB = swaps.get(locB);
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
void moveCell(Cell a, PVector dest) {
  if (debug) println("moveCell "+a+" to "+dest);
  grid.put(a.loc, null); // remove cell from current grid pos
  a.loc.set(dest); // copy dest location value
  grid.put(dest, a);
  a.mode = CellMode.SWAPPED;
  if (debug) println(".... moved "+a);
}

PVector _prevA = new PVector();
PVector _prevB = new PVector();

void swapCells(PVector locA, PVector locB) {
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
  } 
  else if (a != null &&  a.mode == CellMode.CAN_SWAP) {
    if (debug) println("... swapping a "+a+" with empty loc "+locB);
    moveCell(a, locB);
  } 
  else if (b != null && b.mode == CellMode.CAN_SWAP) {
    if (debug) println("... swapping b"+b+" with empty loc "+locA);
    moveCell(b, locA);
  } 
  else {
    if (debug) println("... swapCells did nothing");
  }
}



public void keyPressed() {
  if (key == ' ') { // SPACE char means single step n clock steps ( one action time )
    run = false;
    singleStep = true;
  }
  else if (keyCode == ENTER) {
    run = true;
    singleStep = false;
  }
  else if (key == 'B') {
    bsh.Console.main(new String[] {
      "util.bsh"
    }
    );
  }
}
