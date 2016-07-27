Frog player;
Obstacle[] obs;

void setup() {
  size(600, 600);
  background(50, 200, 200);
  player = new Frog();
  obs = new Obstacle[10];
  for (int i = 0; i < obs.length; i++) {
    obs[i] = new Obstacle(100, 30 + i * 30, 30, 30, 1);
  }
}

void draw() {
  background(50, 200, 200);
  player.display();
  for (Obstacle o : obs) {
    o.move();
    o.display();
    if (o.touchingFrog(player)) noLoop();
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