import java.util.*;
import java.lang.NullPointerException;
import java.io.*;
public class MazeSolver {

  private char[][]maze;
  private int maxx, maxy;
  private int startx, starty;
  private int endx, endy;
  private ArrayList<Pt> solution;
  private Frontier rest;

  public boolean solveDFS() {
    return solve(0, false);
  }

  public boolean solveBFS() {
    return solve(1, false);
  }

  public boolean solveBest() {
    return solve(2, false);
  }

  public boolean solveAStar() {
    return solve(3, false);
  }

  public boolean solveDFS(boolean animate) {
    return solve(0, animate);
  }

  public boolean solveBFS(boolean animate) {
    return solve(1, animate);
  }

  public boolean solveBest(boolean animate) {
    return solve(2, animate);
  }

  public boolean solveAStar(boolean animate) {
    return solve(3, animate);
  }

  public String name() {
    return "john,rodda";
  }

  public MazeSolver(char[][] m) {
    maze = m;
    startx = starty = endx = endy = -1;
  }
  
  public void setStart(int x, int y){
   startx = x;
   starty = y;
  }
  
  public void setEnd(int x, int y){
   endx = x;
   endy = y;
  }

  public void wait(int millis) {
    try {
      Thread.sleep(millis);
    }
    catch (InterruptedException e) {
    }
  }

  public String toString() {
    String ans = "";
    for (int i = 0; i < maze.length; i++) {
      for (int j = 0; j < maze[i].length; j++) {
        ans = ans + maze[i][j];
      }
      ans = ans + "\n";
    }
    for (int i = 0; i < solution.size(); i++) {
      ans += solution.get(i).toString();
    }
    return ans;
  }

  public boolean solve(int mode, boolean animate) {
    rest = new Frontier(mode, endx, endy);
    Pt start = new Pt(startx, starty);

    rest.add(start);

    boolean solved = false;
    try {
      while (!solved && rest.hasNext()) {
        Pt next = rest.remove();
        if (!(next.getX() < 0 || next.getX() > maze.length || next.getY() < 0 || next.getY() > maze[0].length)) {
          if (endx == next.getX() && endy == next.getY()) {
            addCoordinatesToSolutionArray(next);
            solved = true;
          } else if (maze[next.getX()][next.getY()] == '?' || maze[next.getX()][next.getY()] == 'E' || maze[next.getX()][next.getY()] == 'S') {
            maze[next.getX()][next.getY()]='x';
            for (Pt p : getNeighbors(next)) {
              if (p != null) {
                rest.add(p);
                if (!(p.getX() == endx && p.getY() == endy)) {   
                  maze[p.getX()][p.getY()] = '?';
                }
              }
            }
          }
        }
      }
    }
    catch (NullPointerException e) {
      return false;
    }
    return true;
  }

  public Pt[] getNeighbors(Pt p) {
    Pt[] neighbors = new Pt[4];
    if (maze[p.getX() - 1][p.getY()] != '#' && maze[p.getX() - 1][p.getY()] != '?' && maze[p.getX() - 1][p.getY()] != 'x') {
      neighbors[0] = new Pt(p.getX() - 1, p.getY(), p, p.getSteps());
    }
    if (maze[p.getX() + 1][p.getY()] != '#' && maze[p.getX() + 1][p.getY()] != '?' && maze[p.getX() + 1][p.getY()] != 'x') {
      neighbors[1] = new Pt(p.getX() + 1, p.getY(), p, p.getSteps());
    }
    if (maze[p.getX()][p.getY() + 1] != '#' && maze[p.getX()][p.getY() + 1] != '?' && maze[p.getX()][p.getY() + 1] != 'x') {
      neighbors[2] = new Pt(p.getX(), p.getY() + 1, p, p.getSteps());
    }
    if (maze[p.getX()][p.getY() - 1] != '#' && maze[p.getX()][p.getY() - 1] != '?' && maze[p.getX()][p.getY() - 1] != 'x') {
      neighbors[3] = new Pt(p.getX(), p.getY() - 1, p, p.getSteps());
    }
    return neighbors;
  }

  public void addCoordinatesToSolutionArray(Pt p) {
    solution = new ArrayList<Pt>();
    solution.add(p);
    while (p.hasNext()) {
      solution.add(p.previousPoint());
      maze[p.getX()][p.getY()] = 'P';
      p = p.previousPoint();
    }
    maze[p.getX()][p.getY()] = 'P';
    Collections.reverse(solution);
  }
}