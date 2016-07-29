public class Frontier {
  private int toggle;
  private int endx, endy;
  MyDoubleEndedQueue<Pt> frontier;
  public Frontier(int mode, int endxa, int endya) {
    toggle = mode;
    endx = endxa;
    endy = endya;
    frontier = new MyDoubleEndedQueue<Pt>();
  }
  public String toString() {
    return frontier.toString();
  }
  public void add(Pt p) {
    if (toggle == 2) {
      frontier.addLast(p, ((int)Math.abs((p.getX() - endx)) + Math.abs(p.getY() - endy)));
    } else if (toggle == 3) {
      frontier.addLast(p, Math.abs(p.getX() - endx) + Math.abs(p.getY() - endy) + p.getSteps());
    } else {
      frontier.addLast(p);
    }
  }
  public Pt remove() {
    if (toggle == 0) {
      return frontier.removeLast();
    } else if (toggle == 1) {
      return frontier.removeFirst();
    } else if (toggle == 2) {
      return frontier.removeSmallest();
    } else if (toggle == 3) {
      return frontier.removeSmallest();
    }
    return null;
  }
  public boolean hasNext() {
    if (frontier.size() != 0) {
      return true;
    }
    return false;
  }
}