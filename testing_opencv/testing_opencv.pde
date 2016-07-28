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


OpenCV opencv;
PImage src;
PImage card;
int cardWidth = 400;
int cardHeight = 400;

int min_x, min_y, max_x, max_y;

Contour contour;
boolean webcam;
Capture cam;

void setup() {
  size(640, 480);
  webcam = true;
  String[] cameras = Capture.list();

  max_x = 0;
  max_y = 0;
  min_x = 1000;
  min_y = 1000;

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + " " + cameras[i]);
    }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[25]);
    cam.start();
  }
}

void mouseClicked() {
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
  String[][] maze = new String[max_x - min_x][max_y - min_y];
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
      if (avg > 127) {
        maze[get_x(i) - min_x][get_y(i) - min_y] = " ";
      }
      else {
        maze[get_x(i) - min_x][get_y(i) - min_y] = "#";
      }
    }
  }
  
  try {
  PrintWriter out = new PrintWriter("output.txt");
  for (int i = 0; i < maze.length; i++) {
    for (int j = 0; j < maze[i].length; j++) {
      out.print(maze[i][j] + ",");  
    }
    out.println();
  }
  out.close();
  }
  catch (Exception e) {
    e.printStackTrace();
  }



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


void draw() {
  if (webcam) {
    if (cam.available() == true) {
      cam.read();
    }
    image(cam, 0, 0);
  } else {
    draw_special();
  }
}