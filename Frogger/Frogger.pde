Frog player;
ArrayList<Obstacle> obs;

void setup() {
  size(570, 600);
  background(50, 200, 200);
  drawGrid();
  player = new Frog();
  obs = new ArrayList<Obstacle>();
  
}

void draw() {
  background(50, 200, 200);
  drawGrid();
  for (Obstacle o : obs) {
    o.move();
    o.display();
  }
  player.display();
  for (Obstacle o : obs) {
    if (o.touchingFrog(player)) {
      died();
      break;
    }
  }
}

void drawGrid(){
   for (int i = 0; i < max(width, height); i+=30){
     line(i, 0, i, height); 
     line(0, i, width, i);
  } 
}

void keyPressed() {
  if (keyCode == UP)
    player.move("UP");
  else if (keyCode == DOWN)
    player.move("DOWN");
  else if (keyCode == LEFT)
    player.move("LEFT");
  else if (keyCode == RIGHT)
    player.move("RIGHT");
}

void died() {
  noLoop();
  player.loseLife();
  if (player.lives <= 0)
    noLoop();
  else {
    int waitTime = 0;
    while (waitTime < Integer.MAX_VALUE) {
      waitTime += 1;
    }
    loop();
    player.moveToStart();
  }
}