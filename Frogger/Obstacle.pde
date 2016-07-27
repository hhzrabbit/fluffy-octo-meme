class Obstacle extends Mover {

  PVector _velocity;

  Obstacle(float x, float y, int width, int height, int dir) {
    _width = width;
    _height = height;
    _position = new PVector(x, y);
    _velocity = new PVector(dir, 0);
    b = 255;
  }

  void move() {
    move(_velocity);
  }

  boolean touchingFrog(Frog f) {
    return (f.leftSide() >= leftSide() && f.leftSide() <= rightSide() ||
      f.rightSide() >= leftSide() && f.rightSide() <= rightSide()) &&
      (f.topSide() >= topSide() && f.topSide() <= bottomSide() ||
      f.bottomSide() >= topSide() && f.bottomSide() <= bottomSide());
  }
}