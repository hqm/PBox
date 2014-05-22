import shiffman.box2d.*;

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
import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

import javax.swing.*;


    PeasyCam cam;
    boolean singleStep = false;
    boolean run = false;

    int clock = 0;

    HashMap<PVector, Cell> grid = new HashMap<PVector, Cell>();
    ArrayList<Cell> cells = new ArrayList<Cell>();

    PVector cursorPos = new PVector(0,0,0);

    int[] realColors = {
        color(255, 0, 0),  // state = 1  REAL
        color(255, 200, 0) // state = -1 REAL
    };

    int[] imagColors = {
        color(0, 0, 255),   // state = 1  IMG
        color(0, 255, 20) // state = -1  IMG
    };

    int gridSize = 20;
    int cellSize = 10;

    void initJFrame(JFrame frame) {
        setVisible(true);
        frame.setSize(300,300);
    }


    public void setup() {
        initJFrame(new RootGUI());

        size(1000, 800, P3D);
        if (frame != null) {
            frame.setResizable(true);
        }

        cam = new PeasyCam(this, 300);
        cam.setMinimumDistance(50);
        cam.setMaximumDistance(500);
        initCells();
    }

    public void initCells() {
        cells.add(new Cell(0,0,0,  1));
        cells.add(new Cell(2,0,0, -1));
        cells.add(new Cell(0,1,0,  1));
        cells.add(new Cell(2,1,0, -1));
  
        cells.add(new Cell(0,-3,2,  1));
        cells.add(new Cell(0,-4,3,  1));
    

    }

    public void drawGrid() {
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
    public void draw() {

        //        if (singleStep == false && run == false) {
        
            


        rotateX(0);
        rotateY(0);
        background(200, 200, 200);

        // draw status text
        textMode(SHAPE);
        fill(255);
        textSize(10);
        if (run || singleStep) {
            text("clock: "+clock, ((gridSize/2)-8)*cellSize , -(gridSize/2)*cellSize, -10);
        } else {
            text("paused: "+clock, ((gridSize/2)-8)*cellSize , -(gridSize/2)*cellSize, -10);            
        }

        lights();
        drawGrid();

        noStroke();
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


        pushMatrix();
        translate(0, 0, 20);
        fill(0, 255, 0);
        box(5);
        popMatrix();


        if (run || singleStep ) {
            computeNextStep();
            clock++;
            singleStep = false;
        }

    }

    void computeNextStep() {
        int phase = clock % 6;
        if (phase == 1) {
            // xy / real => imag
            

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




    static public void main(String[] passedArgs) {
        System.setProperty("java.awt.headless", "false");


        try {
            System.setProperty("apple.laf.useScreenMenuBar", "true");
            System.setProperty("com.apple.mrj.application.apple.menu.about.name", "Test");
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());


            //    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "PBox" };
            String[] appletArgs = new String[] { "--bgcolor=#666666", "--stop-color=#cccccc", "PBox" };
            if (passedArgs != null) {
                PApplet.main(concat(appletArgs, passedArgs));
            } else {
                PApplet.main(appletArgs);
            }

        }
        catch(ClassNotFoundException e) {
            System.out.println("ClassNotFoundException: " + e.getMessage());
        }
        catch(InstantiationException e) {
            System.out.println("InstantiationException: " + e.getMessage());
        }
        catch(IllegalAccessException e) {
            System.out.println("IllegalAccessException: " + e.getMessage());
        }
        catch(UnsupportedLookAndFeelException e) {
            System.out.println("UnsupportedLookAndFeelException: " + e.getMessage());
        }
  

    }








