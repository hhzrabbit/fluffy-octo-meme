class Frog extends Mover {

  int lives;

  Frog() {
    lives = 5;
    g = 255;
  }

  void changeIfPossible(float x, float y) {
    if ( (x - _width / 2  >= 0) && 
      (x + _width / 2 < width) && 
      (y - _height / 2 >= 0) && 
      (y + _height / 2 <= height)) {
      _position.set(x, y);
    }
  }

  void move(String dir) {
    if (dir.equals("UP"))
      changeIfPossible(_position.x, _position.y - _height);
    else if (dir.equals("DOWN"))
      changeIfPossible(_position.x, _position.y + _height);
    else if (dir.equals("LEFT"))
      changeIfPossible(_position.x - _width, _position.y);
    else if (dir.equals("RIGHT"))
      changeIfPossible(_position.x + _width, _position.y);
 }
 
 void loseLife(){
  lives--; 
 }
 
 void moveToStart(){
  _position.set(width / 2, height - _height); 
 }
 
}