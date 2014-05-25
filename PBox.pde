// 3d cellular automata //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 
//

import java.util.*; 
import java.util.Map.Entry; 
import java.io.*; 

import javax.swing.filechooser.FileFilter;
import javax.swing.filechooser.FileNameExtensionFilter;

import javax.swing.*;

import java.awt.Container;
import java.awt.GridLayout;
import java.awt.event.*;


int gridSize = 200;
int cellSize = 4;
int scienceCycles = 100;


// Set the Rule here
Rule rule = new Rule1();


// Beanshell interpreter for debugging
import bsh.*;


PeasyCam cam;
boolean singleStep = false;
boolean run = false;
boolean fast = true;
boolean debug = false;
boolean placingModule = false;
boolean useSphere = false;
boolean writeMovie = false;
boolean showgrid = true;
boolean science = false;

int clock = 0;
int fastclock = 0;
boolean wrap = true;
boolean forward = true;
// trails = 0:none, 1:every, 2:center-of-mass
int trails = 0;
// how many points in trail
int trailSize = 1024;
int trailPos = 0;

//public static PBox app;

// Hash table which holds position of all cells
public HashMap<Coord, Cell> grid = new HashMap<Coord, Cell>();

// Keep track of which cell a given cell is supposed to swap with. Used to find and prevent
// conflicting swaps.
// Using a cell location as a key, holds the target location that this cell is proposed to swap with
public HashMap<Coord, ArrayList<Coord>> swaps = new HashMap<Coord, ArrayList<Coord>>();

// List of the cells in even plane
public ArrayList<Cell> evenCells = new ArrayList<Cell>();
// List of cells in imaginary plane
public ArrayList<Cell> oddCells = new ArrayList<Cell>();

public ArrayList<Cell>  moduleCells = new ArrayList<Cell>();
// store state of all cells, so we can reset back to original config in RAM
public ArrayList<Cell>  stashCells = new ArrayList<Cell>();
int stashPhase = 0;

// for drawing center of mass trails
public PVector[] trail = new PVector[trailSize];


// clear the grid and regenerate it from cells
void resetGrid() {
  grid.clear();
  for (Cell cell : evenCells) {
    grid.put(cell.loc, cell);
  }
  for (Cell cell : oddCells) {
    grid.put(cell.loc, cell);
  }
}



// Keep a copy of the world state so we can easily reset it during experiments
void stashCells(int phase) {
  stashCells.clear();
  for (Cell cell : evenCells) {
    stashCells.add(cell.copy());
  }
  for (Cell cell : oddCells) {
    stashCells.add(cell.copy());
  }
  stashPhase = phase;
}

void restoreFromStash() {
  clearWorld();
  run = false;
  singleStep = true;
  for (Cell cell : stashCells) {
    addCell(cell.loc, cell.state);
  }
  resetGrid();
  clock = stashPhase;
}

void addCell(Coord c, int state) {
  addCell(c.x, c.y, c.z, state);
}



public Coord cursorPos = new Coord(0, 0, 0);
int cursorVal = 1;

Coord target = new Coord(0, 0, 0);
Coord delta = new Coord(0, 0, 0);

static final int CURSOR_ALPHA = 30;

int[] evenColors = {
  color(255, 0, 0), // state = 1  EVEN
  color(255, 200, 0) // state = -1 EVEN
};

int[] oddColors = {
  color(0, 0, 255), // state = 1  IMG
  color(0, 255, 20) // state = -1  IMG
};


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
  statusFrame.cursorLabel.setText("Cursor: "+ cursorPos);
  statusFrame.trailLabel.setText("Trails: "+ (trails == 0 ? "none" : (trails == 1 ? "every cell" : "average")));
  statusFrame.movieLabel.setText("Write Movie: "+ (writeMovie ? "ON" : "OFF"));
}

int clockPhase() {
  int phi = clock % 6;
  if (phi < 0) phi = phi+6;
  return phi;
}

void initTrails() {
  for (int i = 0; i < trail.length; i++) {
    trail[i] = null;
  }
}

void setup() {
  size(1000, 800, P3D);
  smooth(4);
  initTrails();
  System.setProperty("java.awt.headless", "false");
  System.setProperty("apple.laf.useScreenMenuBar", "true");
  System.setProperty("com.apple.mrj.application.apple.menu.about.name", "Test");
  //UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  statusFrame = new RootGUI(this);
  initJFrame(statusFrame);

  //app = this;


  if (frame != null) {
    frame.setResizable(true);
  }

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(10000);
  loadConfig(2);
  frameRate(10000);
}

void addCell(int x, int y, int z, int state) {
  Cell old = grid.get(new Coord(x, y, z));
  if (old != null) { 
    deleteCell(old);
  }

  Cell cell = new Cell(x, y, z, state);  
  grid.put(cell.loc, cell);
  if ((x+y+z)%2 == 0) {
    // even
    evenCells.add(cell);
  } else {
    oddCells.add(cell);
  }
}


void deleteCell(Cell c) {
  grid.remove(c.loc);
  if ((c.loc.x+c.loc.y+c.loc.z)%2 == 0) {
    // even
    evenCells.remove(c);
  } else {
    oddCells.remove(c);
  }
}


// clear all cells
void clearWorld() {
  grid.clear(); 
  evenCells.clear();
  oddCells.clear();
  clock = 0;
  singleStep = false;
  run = false;
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
  stashCells(0);
}

void initConfig1() {
  addCell(0, 0, 0, 1);
  addCell(2, 1, 0, 1);
}

void initConfig2() {
  int N = 20;
  for (int x = -N; x < N; x+=2) {
    for (int y = -N; y < N; y+=2) {
      for (int z = -N; z < N; z+=2) {
        addCell(x, y, z, 1);
        addCell(x+2, y+1, z, 1);
      }
    }
  }
  addCell(0, 0, 0, 1);
  addCell(1, 2, 0, 1);
  addCell(3, 3, 0, 1);
  addCell(3, 5, 1, 1);
  addCell(3, 6, 3, 1);
}

void drawGrid() {
  int offset = (gridSize / 2);
  int C = -cellSize/2;
  for (int i = 0; i < gridSize+2; i++) {
    line((i-offset)*cellSize+C, -gridSize*cellSize/2-C, C, 
    (i-offset)*cellSize+C, gridSize*cellSize/2-C, C);

    line(-gridSize*cellSize/2-C, (i-offset)*cellSize+C, C, 
    gridSize*cellSize/2-C, (i-offset)*cellSize+C, C);
    stroke(140);
  }
}

long startNs = 0;
long cycleTime = 0;
void doComputeStep() {
  computeNextStep();
  if (forward) {
    clock++;
  } else {
    clock--;
  }
}
void runScienceMode(int n) {
  for (int i = 0; i < n; i++) {
    long starttime = System.currentTimeMillis();
    doComputeStep();
  }
  println(clock);
}

void drawScene() {
  rotateX(0);
  rotateY(0);
  background(230);

  // draw status text
  textMode(SHAPE);
  fill(100, 100, 100);
  textSize(10);

  String timedir = (forward ? "forward" : "backward");

  if (run ) {
    text(timedir + " clock: "+clock/6+"#"+clockPhase() + "  "+cycleTime/1000, ((gridSize/2)-8)*cellSize, -(gridSize/2)*cellSize, -10);
  } else {
    text(timedir + " paused: "+clock/6+"#"+clockPhase()+ "  "+cycleTime/1000, ((gridSize/2)-8)*cellSize, -(gridSize/2)*cellSize, -10);
  }
  text("rule: "+ruleName, -((gridSize/2)-8)*cellSize, -(gridSize/2)*cellSize, -10);

  lights();

  noStroke();
  drawCells(evenCells);
  drawCells(oddCells);
  drawModuleCells();

  drawCursor();
  if (showgrid) drawGrid();

  if (debug) {
    drawFromGrid();
  }
  if (trails > 0) {
    drawTrail();
  }

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
}
void draw() {
  if (science) {
    drawScene();
    runScienceMode(scienceCycles);
    textMode(SHAPE);
    textSize(50);
    return;
  }
  //        if (singleStep == false && run == false) {
  startNs = System.nanoTime();

  drawScene();

  updateStatusFrame();
  if (fast || fastclock%5 == 0) {
    if (run || singleStep ) {
      doComputeStep();

      singleStep = false;
      if (trails > 0) {
        // add center of mass coord to trail
        addTrailCrumb();
      }
      cycleTime =  System.nanoTime() - startNs  ;
      if (writeMovie) {
        String path = String.format("/tmp/frames/pbframe.%05d.png", clock);
        println("saving image file "+path);
        save(path);
      }
    }
  }
  fastclock++;
}

// Adds either the position of all cells, or the center of mass the center of mass of all cells as a vector and add it to the trail
void addTrailCrumb() {
  if (trails == 2) {
    addCOMTrail();
  } else if (trails == 1) {
    addEveryCellTrail();
  }
}

void addEveryCellTrail() {
  int n = 0;
  for (Coord c : grid.keySet ()) {
    PVector pos = c.pvec();
    trail[trailPos++ % trail.length] = pos;
  }
}

void addCOMTrail() {
  PVector cm = null;
  int n = 0;
  for (Coord c : grid.keySet ()) {
    PVector pos = c.pvec();
    if (cm == null) {
      cm = pos;
    } else {
      cm.add(pos);
    }
    n++;
  }
  if (cm != null) {
    cm.div(n);
    // now we have center of mass point, add to trails
    trail[trailPos++ % trail.length] = cm;
  }
}


void drawTrail() {
  int n = trail.length;
  noStroke();
  for (int i = 0; i < n; i++) {

    PVector c = trail[i];
    if (c != null) {
      pushMatrix();
      translate(
      c.x *cellSize, 
      c.y*cellSize, 
      c.z*cellSize
        );

      if (trails == 1) {
        fill(0, 220, 220);
      } else {
        fill(0, 255, 0);
      }
      box(3);

      popMatrix();
    }
  }
}


void computeNextStep() {
  clearSwaps();
  rule.runRule();
  doSwaps();
}
void clearSwaps() {
  swaps.clear();
  clearSwapState(evenCells);
  clearSwapState(oddCells);
}

void drawCells(ArrayList<Cell> cells) {
  noStroke();
  for (Cell cell : cells) {
    pushMatrix();
    translate(
    (cell.loc.x )*cellSize, 
    (cell.loc.y)*cellSize, 
    (cell.loc.z)*cellSize
      );

    if ((cell.loc.x+cell.loc.y+cell.loc.z)%2 == 0) { // even
      fill( (cell.state == 1) ? evenColors[0] : evenColors[1] );
    } else { // imaginary
      fill( (cell.state == 1) ? oddColors[0] : oddColors[1] );
    }

    if (useSphere) {
      sphere(cellSize/2);
    } else {
      box(cellSize);
    }
    popMatrix();
  }
}

// debugging routine to draw the cells based on the grid hashtable contents, to 
// see if it's consistent
void drawFromGrid() {
  for (Cell cell : grid.values ()) {

    pushMatrix();
    translate(
    (cell.loc.x )*cellSize, 
    (cell.loc.y)*cellSize, 
    (cell.loc.z)*cellSize
      );

    if ((cell.loc.x+cell.loc.y+cell.loc.z)%2 == 0) { // even
      fill( (cell.state == 1) ? evenColors[0] : evenColors[1] );
    } else { // imaginary
      fill( (cell.state == 1) ? oddColors[0] : oddColors[1] );
    }

    if (useSphere) {
      sphere(cellSize/2);
    } else {
      box(cellSize);
    }
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

  if ((cursorPos.x+cursorPos.y+cursorPos.z)%2 == 0) { // even
    fill( (cursorVal == 1) ? evenColors[0] : evenColors[1], CURSOR_ALPHA );
  } else { // imaginary
    fill( (cursorVal == 1) ? oddColors[0] : oddColors[1], CURSOR_ALPHA);
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
void toggleRun() {
  if (run) {
    run = false;
    singleStep = true;
  } else {
    run = true;
    singleStep = false;
  }
}

void toggleTrails() {
  trails = (trails+1) % 3;
  initTrails();

  if (debug) println("trails = "+trails);
}

void toggleTime() {
  if (forward) {
    clock--;
  } else {
    clock++;
  }
  forward = !forward;
}

public void keyPressed() {
  if (key == ' ') { // SPACE char means single step n clock steps ( one action time )
    run = false;
    singleStep = true;
  } else if (key == 'r') {
    toggleRun();
  } else if (key == 'B') {
    bsh.Console.main(new String[] {
      "util.bsh"
    }
    );
  } else if (key == 'z') {
    toggleTime();
  } else if (key == 'g') {
    showgrid = !showgrid;
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
    if (placingModule) {
      placingModule = false;
      moduleCells.clear();
    } else {
      toggleCellAtCursor();
    }
  } else if (key == 's') {
    fast = !fast;
  } else if (key == 'w') {
    wrap = !wrap;
  } else if (key == 'p') {
    placingModule = true;
    placeModule();
  } else if (key == 'q') {
    useSphere = !useSphere;
  } else if (key == 'h') {
    cursorPos.set(0, 0, 0);
  } else if (key == 't') {
    toggleTrails();
  } else if (key == 'm') {
    writeMovie = !writeMovie;
  } else if (key == 'S') {
    println("science = "+science);
    science = !science;
  }
}


void placeModule() {
  // copy module cells to workspace grid
  // we are going to overwrite any cells we land on

  for (Cell cell : moduleCells) {

    Cell ncell = cell.copy();
    ncell.loc.add(cursorPos);
    int x = ncell.loc.x;
    int y = ncell.loc.y ;
    int z = ncell.loc.z ;

    Cell target = grid.get(ncell.loc);
    if (target != null) { //collision, nuke the target cell
      deleteCell(target);
    }


    grid.put(ncell.loc, ncell);
    if ((x+y+z)%2 == 0) {
      // even
      evenCells.add(ncell);
    } else {
      oddCells.add(ncell);
    }
  }
}
// get json from current config
String getConfigCSV() {
  StringBuffer buf = new StringBuffer();
  // write out the clock phase as first line
  buf.append(clockPhase()+"\n");

  for (Cell cell : grid.values ()) {
    buf.append(cell.getCSV() + "\n");
  }
  return buf.toString();
}

JFileChooser chooser = new JFileChooser();

void saveConfigToFile() {
  chooser.setFileFilter(chooser.getAcceptAllFileFilter());
  int returnVal = chooser.showSaveDialog(null);
  if (returnVal == JFileChooser.APPROVE_OPTION) 
  {
    String path=chooser.getSelectedFile().getAbsolutePath();
    String filename=chooser.getSelectedFile().getName();
    if (!(filename.indexOf(".")>0) && !path.endsWith(".pbox")) {
      path = path +".pbox";
    }
    try {
      FileWriter fout = new FileWriter(path);
      fout.write(getConfigCSV());
      fout.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}

void loadConfigFromFile() {
  clearWorld();

  FileFilter pboxFilter = new FileNameExtensionFilter("PBox files", "pbox");

  //Attaching Filter to JFileChooser object
  chooser.addChoosableFileFilter(pboxFilter);
  int returnVal = chooser.showOpenDialog(null);
  int phase = 0;
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    try {
      String path=chooser.getSelectedFile().getAbsolutePath();
      BufferedReader in = new BufferedReader(new FileReader(path));
      String line = null;
      // get phase
      line = in.readLine();
      phase = Integer.parseInt(line.trim());

      while (true) {
        line = in.readLine();
        if (line == null) break;
        String vals[] = line.trim().split(",");
        int x = Integer.parseInt(vals[0]);
        int y = Integer.parseInt(vals[1]);
        int z = Integer.parseInt(vals[2]);
        int s = Integer.parseInt(vals[3]);
        addCell(x, y, z, s);
      }

      in.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
  stashCells(phase);
  clock = phase;
}

void loadModuleFromFile() {
  FileFilter pboxFilter = new FileNameExtensionFilter("PBox files", "pbox");

  //Attaching Filter to JFileChooser object
  chooser.addChoosableFileFilter(pboxFilter);
  int returnVal = chooser.showOpenDialog(null);
  if (returnVal == JFileChooser.APPROVE_OPTION) {
    try {
      String path=chooser.getSelectedFile().getAbsolutePath();
      BufferedReader in = new BufferedReader(new FileReader(path));
      String line = null;
      // get phase
      line = in.readLine();
      int phase = Integer.parseInt(line.trim());
      // we're not using phase in this right now, module just gets plunked down at current phase

      while (true) {
        line = in.readLine();
        if (line == null) break;
        String vals[] = line.trim().split(",");
        int x = Integer.parseInt(vals[0]);
        int y = Integer.parseInt(vals[1]);
        int z = Integer.parseInt(vals[2]);
        int s = Integer.parseInt(vals[3]);
        addModuleCell(x, y, z, s);
      }

      in.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}

void addModuleCell(int x, int y, int z, int state) {
  Cell cell = new Cell(x, y, z, state);  
  moduleCells.add(cell);
}


// Draw the module cells in some other tint to distinguish them
void drawModuleCells() {

  for (Cell cell : moduleCells) {
    pushMatrix();
    translate(
    (cell.loc.x + cursorPos.x )*cellSize, 
    (cell.loc.y + cursorPos.y)*cellSize, 
    (cell.loc.z+ cursorPos.z)*cellSize
      );

    if ((cell.loc.x+cell.loc.y+cell.loc.z)%2 == 0) { // even
      fill( (cell.state == 1) ? evenColors[0] : evenColors[1], 100);
    } else { // imaginary
      fill( (cell.state == 1) ? oddColors[0] : oddColors[1], 100);
    }

    if (useSphere) {
      sphere(cellSize/2);
    } else {
      box(cellSize);
    }
    popMatrix();
  }
}

String ruleName = "BusyBox Rule";

void setRule(String r) {
  ruleName = r;
  println("rule = "+ruleName);

  if (ruleName.equals("BusyBox")) {
    rule = new Rule1();
  } else if (ruleName.equals("Rule2")) {
    rule = new Rule2();
  } else if (ruleName.equals("Rule3")) {
    rule = new Rule3();
  } else if (ruleName.equals("Rule4")) {
    rule = new Rule4();
  } else if (ruleName.equals("Rule5")) {
    rule = new Rule5();
  }
}
