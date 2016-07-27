class Mover {

  PVector _position;
  int _width, _height;
  int r, g, b;
  int[] _sides;

  Mover() {
    _width = 30;
    _height = 30;
    _position = new PVector(width / 2, height - _height);
    _sides = new int[4];
    _sides[0] = leftSide();
    _sides[1] = rightSide();
    _sides[2] = topSide();
    _sides[3] = bottomSide();
    r = 0;
    g = 0;
    b = 0;
  }

  void move(PVector velocity) {
    _position.add(velocity);
  }

  void display() {
    rectMode(CENTER);
    fill(r, g, b);
    rect(_position.x, _position.y, _width, _height);
  }

  int leftSide() {
    return (int) _position.x - _width / 2;
  }

  int rightSide() {
    return (int) _position.x + _width / 2;
  }

  int topSide() {
    return (int) _position.y - _height / 2;
  }

  int bottomSide() {
    return (int) _position.y + _height / 2;
  }
}    