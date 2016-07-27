import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Size;

import processing.video.*;

import org.opencv.core.Mat;
import org.opencv.core.CvType;


OpenCV opencv;
PImage src;
PImage card;
int cardWidth = 400;
int cardHeight = 400;

Contour contour;
boolean webcam;
Capture cam;

void setup() {
  size(640, 480);
  webcam = true;
  String[] cameras = Capture.list();

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
  if (webcam) {
    src = cam;
    opencv = new OpenCV(this, src);

    opencv.blur(1);
    opencv.threshold(170);

    contour = opencv.findContours(false, true).get(0).getPolygonApproximation();

    card = createImage(cardWidth, cardHeight, ARGB);  
    opencv.toPImage(warpPerspective(contour.getPoints(), cardWidth, cardHeight), card);
    webcam = false;
  } else {
    webcam = true;
  }
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
  for (int i = 0; i < points.size(); i++) {
    text(i, points.get(i).x, points.get(i).y);
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