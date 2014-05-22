import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import shiffman.box2d.*; 

import java.util.HashMap; 
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

int clock = 0;

public static PBox app;


HashMap<PVector, Cell> grid = new HashMap<PVector, Cell>();
ArrayList<Cell> realCells = new ArrayList<Cell>();
ArrayList<Cell> imagCells = new ArrayList<Cell>();


PVector cursorPos = new PVector(0, 0, 0);

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
  f.setSize(150, 300);
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
  bsh.Console.main(new String[] {
    "util.bsh"
  }
  );

  if (frame != null) {
    frame.setResizable(true);
  }

  cam = new PeasyCam(this, 300);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
  initCells();
}

void addCell(int x, int y, int z, int state) {
  if ((x+y+z)%2 == 0) {
    // real
    realCells.add(new Cell(x, y, z, state));
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
  background(200, 200, 200);

  // draw status text
  textMode(SHAPE);
  fill(255);
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

void computeNextStep() {
  int phase = clock % 6;
  if (phase == 1) {


    // xy / real => imag
    /*
    if current cell is +1 , and neighbor to right is +1, move both cells apart horizontally by swaps
     
     if current cell is +1 , and neighbor to above is +1, move both cells apart vertically by swaps
     
     */
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
}
