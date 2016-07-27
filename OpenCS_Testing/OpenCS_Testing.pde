import gab.opencv.*;
import processing.video.*;

Capture cam;
OpenCV opencv;
PImage src, canny, scharr, sobel;

boolean webcam;
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


void draw() {
  if (webcam) {
    if (cam.available() == true) {
      cam.read();
    }
    image(cam, 0, 0);
  } else {
    draw_edges();
  }
}

void draw_edges() {
  pushMatrix();
  scale(0.5);
  image(src, 0, 0);
  image(canny, src.width, 0);
  image(scharr, 0, src.height);
  image(sobel, src.width, src.height);
  popMatrix();

  text("Source", 10, 25); 
  text("Canny", src.width/2 + 10, 25); 
  text("Scharr", 10, src.height/2 + 25); 
  text("Sobel", src.width/2 + 10, src.height/2 + 25);
}

void mouseClicked() {
  if (webcam) {
    webcam = false;
    src = cam;

    opencv = new OpenCV(this, src);
    opencv.findCannyEdges(20, 75);
    canny = opencv.getSnapshot();

    opencv.loadImage(src);
    opencv.findScharrEdges(OpenCV.HORIZONTAL);
    scharr = opencv.getSnapshot();

    opencv.loadImage(src);
    opencv.findSobelEdges(1, 0);
    sobel = opencv.getSnapshot();
  } else {
    webcam = true;
  }
}