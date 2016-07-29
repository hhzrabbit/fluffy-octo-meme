import java.io.*;
import java.util.*;

class MazeSolver {

  private char[][] maze;
  private int h, w; //height, width of maze
  private int startR, startC;
  private boolean solved;

  //initialize constants
  final private char START =        'S';
  final private char PATH =         ' ';
  final private char WALL =         '#';
  final private char EXIT =         'E';
  final private char VISITED_PATH = '.';
  final private char ANSWER =       '+';


  public MazeSolver(char[][] m) {

    //init 2D array to represent maze 
    // ...same dimensions as default terminal window
    maze = m;
    h = maze.length;
    w = maze[0].length;
    startR = startC = -1;

    solved = false;
  }//end constructor
    
  public void setStart(int xcor, int ycor){
    startR = ycor;
    startC = xcor;
  }


  public String toString() {
    //send ANSI code "ESC[0;0H" to place cursor in upper left
    String retStr = "";// "[0;0H"; 
    //String retStr = "";
    int i, j;
    for ( i=0; i<h; i++ ) {
      for ( j=0; j<w; j++ )
        retStr = retStr + maze[i][j];
      retStr = retStr + "\n";
    }
    return retStr;
  }

  public boolean inBounds(int r, int c) {
    return (r >= 0 && c >= 0 && r < h && c < w);
  }

  public boolean visitable(int r, int c) {
    boolean thisIsVisitable =  inBounds(r, c) && maze[r][c] != WALL && maze[r][c] != VISITED_PATH;
    boolean thisIsNextToWall = nextToWall(r, c);
    return thisIsVisitable && thisIsNextToWall;
  }

  public boolean nextToWall(int r, int c) {
    int[][] adjacents = { {r - 1, c}, 
      {r + 1, c}, 
      {r, c - 1}, 
      {r, c +1}, 
      {r - 1, c - 1}, 
      {r + 1, c - 1}, 
      {r - 1, c + 1}, 
      {r + 1, c + 1} };

    for (int[] adj : adjacents) {
      int row = adj[0];
      int col = adj[1];
      if (inBounds(row, col) && maze[row][col] == WALL)
        return true;
    }
    return false;
  }

  public boolean isEnd(int r, int c) {
    return maze[r][c] == EXIT;
  }

  public void mark(int r, int c) {
    maze[r][c] = VISITED_PATH;
  }

  public void solve(Node n) {
    if (solved) return;
    int r = n.getRow();
    int c = n.getCol(); 
    Deque<Node> nodes = new ArrayDeque<Node>();
    int[][] adjacents = { {r + 1, c}, 
      {r - 1, c}, 
      {r, c + 1}, 
      {r, c - 1} };
    for (int[] adj : adjacents) {
      int row = adj[0];
      int col = adj[1];
      if (visitable(row, col)) {
        if (isEnd(row, col)) {  
          solved = true;
          finish(new Node(row, col, n));
          return;
        } else {       
          mark(row, col);
          nodes.add(new Node(row, col, n));
        }
      }
    }

    while (! nodes.isEmpty()) {
      solve(nodes.remove());
    }
    return;
  }

  public void solve() {
    println(startR + " " + startC);
    solve(new Node(startR, startC));
    if (!solved) println("NO SOLUTION HOMIE");
  }

  public void finish(Node n) {
    while (n != null) {
      maze[n.getRow()][n.getCol()] = ANSWER;
      n = n.getParent();
    }
   // System.out.println(this);
   println("Solved!");
  }
}