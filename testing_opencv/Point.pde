public class Pt {
  private int x;
  private int y;
  private Pt previous;
  private int step;
  public Pt(int xa, int xy, Pt p, int s) {
    x = xa;
    y = xy;
    previous = p;
    step = s + 1;
  }
  public Pt(int xa, int xy) {
    x = xa;
    y = xy;
    step = 0;
  }
  public int getX() {
    return x;
  }
  public int getY() {
    return y;
  }
  public Pt previousPoint() {
    return previous;
  }
  public int getSteps() {
    return step;
  }
  public String toString() {
    return "(" + x + ", " + y + ")";
  }
  public boolean hasNext() {
    if (previous != null) {
      return true;
    }
    return false;
  }
}