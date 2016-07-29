class Node {
  private int row;
  private int col;
  private Node parent;

  public Node(int r, int c) {
    row = r;
    col = c;
    parent = null;
  }

  public Node(int r, int c, Node p) {
    this(r, c);
    parent = p;
  }

  public void setParent(Node n) {
    parent = n;
  }

  public int getRow() {
    return row;
  } 

  public int getCol() {
    return col;
  }

  public Node getParent() {
    return parent;
  }

  public String toString() {
    return row + " " + col ;//" " + parent;
  }
}