//======================= IMPORTING PACKAGES ==========================

import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Size;

import processing.video.*;

import org.opencv.core.Mat;
import org.opencv.core.CvType;

import java.awt.Polygon;
import java.io.*;
//====================================================================



//=================== DECLARING VARIABLES ============================
//image
Contour contour;
Capture cam;
boolean webcam;
OpenCV opencv;
PImage src;
PImage card;
int cardWidth = 400;
int cardHeight = 400;
int min_x, min_y, max_x, max_y;

//maze (to be exported as text file to feed into maze solver)
String[][] maze;

//progress variables (used to determine what step of the process we are at)
boolean detected;
int mode;
boolean endSelected;
//============================================================================




//============================ SETUP AND DRAW ================================
void setup() {
  size(640, 480);
  
  max_x = max_y = Integer.MIN_VALUE;
  min_x = min_y = Integer.MAX_VALUE;

  detected = false;
  endSelected = false;
  
  webcam = true;
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    cam = new Capture(this, cameras[25]);
    cam.start();
  }
}

//controls each step in maze-detecting-solving process
void draw() {
  background(255, 255, 255);
  if (webcam) {
    if (cam.available() == true) {
      cam.read();
    }
    image(cam, 0, 0);
  } else {
    draw_special();
  }

  if (detected) {
    fill(0);
    if (mode == 1) 
      text("click to place Start", mouseX, mouseY);
    else if (mode == 2)
      text("click to place End", mouseX, mouseY);
  }

  if (endSelected)
    exportToFile();
}
//===========================================================================



//=================================== STEP 1 ================================
//get image from webcam, use OpenCV to detect edges, translate into Stirng matrix
void keyPressed() {
  max_x = 0;
  max_y = 0;
  min_x = 1000;
  min_y = 1000;
  if (webcam) {
    
    src = cam;
    opencv = new OpenCV(this, src);
    opencv.blur(1);
    opencv.threshold(100);

    contour = opencv.findContours(false, true).get(0).getPolygonApproximation();

    card = createImage(cardWidth, cardHeight, ARGB);  
    opencv.toPImage(warpPerspective(contour.getPoints(), cardWidth, cardHeight), card);

    if (cam.available() == true) {
      cam.read();
    }
    cam.loadPixels();

    ArrayList<PVector> points = contour.getPoints();  

    int[] xpoints = new int[points.size()];
    int[] ypoints = new int[points.size()];
    for (int i = 0; i < points.size(); i++) {
      if (points.get(i).x > max_x) {
        max_x = (int) points.get(i).x;
      }
      if (points.get(i).x < min_x) {
        min_x = (int) points.get(i).x;
      }
      if (points.get(i).y > max_y) {
        max_y = (int) points.get(i).y;
      }
      if (points.get(i).y < min_y) {
        min_y = (int) points.get(i).y;
      }
      xpoints[i] = (int) points.get(i).x;
      ypoints[i] = (int) points.get(i).y;
    }



    Polygon p = new Polygon(xpoints, ypoints, xpoints.length);
    maze = new String[max_x - min_x][max_y - min_y];
    for (int i = 0; i < cam.pixels.length; i++) {
      if (get_x(i) > min_x && get_x(i) < max_x && get_y(i) < max_y && get_y(i) > min_y) {
        maze[get_x(i) - min_x][get_y(i) - min_y] = "#";
      }
      if (p.contains(get_x(i), get_y(i))) {
        color c = color(cam.pixels[i]);
        float r = red(c);
        float g = green(c);
        float b = blue(c);
        float avg = (r + g + b) / 3;
        if (avg > 100) {
          maze[get_x(i) - min_x][get_y(i) - min_y] = " ";
        } else {
          maze[get_x(i) - min_x][get_y(i) - min_y] = "#";
        }
      }
    }
    
    detected = true; //signal that the image detection is done
    mode = 1; //get ready to ask user for Start point
    
    webcam = false;
  } else {
    webcam = true;
  }
}

int get_x(int oneD) {
  int imageWidth = cam.width; 
  int imageHeight = cam.height; 

  return oneD % imageWidth;
}
int get_y(int oneD) {
  int imageWidth = cam.width; 
  int imageHeight = cam.height; 

  return oneD / imageWidth;
}

Mat getPerspectiveTransformation(ArrayList<PVector> inputPoints, int w, int h) {
  Point[] canonicalPoints = new Point[4]; 
  canonicalPoints[0] = new Point(w, 0); 
  canonicalPoints[1] = new Point(0, 0); 
  canonicalPoints[2] = new Point(0, h); 
  canonicalPoints[3] = new Point(w, h); 

  MatOfPoint2f canonicalMarker = new MatOfPoint2f(); 
  canonicalMarker.fromArray(canonicalPoints); 

  Point[] points = new Point[4]; 
  for (int i = 0; i < 4; i++) {
    points[i] = new Point(inputPoints.get(i).x, inputPoints.get(i).y);
  }
  MatOfPoint2f marker = new MatOfPoint2f(points); 
  return Imgproc.getPerspectiveTransform(marker, canonicalMarker);
}

Mat warpPerspective(ArrayList<PVector> inputPoints, int w, int h) {
  Mat transform = getPerspectiveTransformation(inputPoints, w, h); 
  Mat unWarpedMarker = new Mat(w, h, CvType.CV_8UC1); 
  Imgproc.warpPerspective(opencv.getColor(), unWarpedMarker, transform, new Size(w, h)); 
  return unWarpedMarker;
}
//============================================================================================




//=========================== STEP 2 ==================================
//ask user to click to decide start and end of maze
void mouseClicked() {
  if (mode != 0) {
    int xcor = (int) mouseX;
    int ycor = (int) mouseY;
    if (xcor >= min_x && xcor <= max_x && ycor >= min_y && ycor <= max_y) {
      if (mode == 1) {
        maze[xcor - min_x][ycor - min_y] = "S";
      } else if (mode == 2) {
        maze[xcor - min_x][ycor - min_y] = "E";
        endSelected = true;
      }
      mode = ++mode % 3;
    }
  }
}
//=======================================================================




//=========================== STEP 3 ====================================
//export String matrix to text file 
void exportToFile() {
  println("ogirwjoerjbreb");
  try {
    PrintWriter out = createWriter("data/output.txt");
    for (int i = 0; i < maze.length; i++) {
      for (int j = 0; j < maze[i].length; j++) {
        out.print(maze[i][j]);
      }
      out.println();
    }
    out.close();
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}
//=========================================================================




//================================ WHAT TO SHOW THE USER =======================
void draw_special() {
  webcam = false; 
  image(src, 0, 0); 
  noFill(); 
  stroke(0, 255, 0); 
  strokeWeight(4); 
  contour.draw(); 
  fill(255, 0); 
  ArrayList<PVector> points = contour.getPoints(); 
  //println("--------------------------------");
  for (int i = 0; i < points.size(); i++) {
    //println(points.get(i).x, points.get(i).y);
    text(i, points.get(i).x, points.get(i).y);
    rect(min_x, min_y, max_x - min_x, max_y - min_y);
  }

  pushMatrix(); 
  translate(src.width, 0); 
  image(card, 0, 0); 
  popMatrix();
}
//==========================================================================