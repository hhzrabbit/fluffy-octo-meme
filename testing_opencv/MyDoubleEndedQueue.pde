import java.util.NoSuchElementException;

public class MyDoubleEndedQueue<T> {
  private Object[] data;
  private int[] priority;
  private int head;
  private int tail;
  private int size;



  public MyDoubleEndedQueue() {
    data = new Object[10];
    head = 5;
    tail = 4;
    size = 0;
    priority = new int[10];
  }

  public void getAndResize() {
    Object[] hi = new Object[data.length * 2];
    int[] lol = new int[data.length * 2];
    int i = tail + 1;
    if (i == data.length) {
      i = 0;
    }
    int j = 0;
    while ((i + 1) != head && !(head == 0 && i == 0)) {
      hi[j] = data[i];
      lol[j] = priority[i];
      j++;
      i++;
      if (i == data.length) {
        i = 0;
      }
    }
    if (head == 0) {
      hi[j] = data[data.length - 1];
      lol[j] = priority[data.length - 1];
    } else {
      hi[j] = data[head - 1];
      lol[j] = priority[head - 1];
    }
    tail = 0;
    head = data.length;
    data = hi;
    priority = lol;
    tail = data.length - 1;
  }

  public String toString() {
    String toReturn = "";
    toReturn += "[";
    for (Object i : data) {
      toReturn += i + ", ";
    }
    toReturn += "]";
    toReturn += "\n[";
    for (int i : priority) {
      toReturn += i + ", ";
    }
    toReturn += "]";
    return toReturn + "\nHead:" + head + "\nTail: " + tail;
  }

  public void addFirst(T value) {
    if (isFull()) {
      getAndResize();
    }
    data[tail--] = value;
    if (tail == -1) {
      tail = data.length - 1;
    }
    size++;
  }

  public void addFirst(T value, int p) {
    if (isFull()) {
      getAndResize();
    }
    data[tail] = value;
    priority[tail] = p;
    tail--;
    if (tail == -1) {
      tail = data.length - 1;
    }
    size++;
  }
  public void addLast(T value) {
    if (isFull()) {
      getAndResize();
    }
    data[head++] = value;
    if (head == data.length) {
      head = 0;
    }
    size++;
  }
  public void addLast(T value, int p) {
    if (isFull()) {
      getAndResize();
    }
    data[head] = value;
    priority[head] = p;
    head++;
    if (head == data.length) {
      head = 0;
    }
    size++;
  }
  public T removeSmallest() {
    int indexOfSmallest = 0;
    for (int i = 0; i < data.length; i++) {
      if ((priority[i] < priority[indexOfSmallest] && data[i] != null)||data[indexOfSmallest] == null) {
        indexOfSmallest = i;
      }
    }
    T toReturn = (T)data[indexOfSmallest];
    tail++;
    if (tail == data.length) {
      tail = 0;
    }
    int priorityOfHead = priority[tail];
    T dataInHead = (T)data[tail];
    data[indexOfSmallest] = dataInHead;
    priority[indexOfSmallest] = priorityOfHead;
    data[tail] = null;
    priority[tail] = 0;
    size--;
    return toReturn;
  }
  public T removeFirst() {
    T a;
    if (tail == data.length - 1) {
      tail = -1;
      a = (T)data[++tail];
      data[tail] = null;
    } else {
      a = (T)data[++tail];
      data[tail] = null;
    }
    size--;
    return a;
  }
  public T removeLast() {
    T a;
    if (head == 0) {
      head = data.length;
      a = (T)data[--head];
      data[head] = null;
    } else {
      a = (T)data[--head];
      data[head] = null;
    }
    size--;
    return a;
  }   
  public T getFirst() {
    if (size == 0) {
      throw new NoSuchElementException();
    }
    if (tail == data.length - 1) {
      return (T)data[0];
    } else {
      return (T)data[tail + 1];
    }
  }
  public T getLast() {
    if (size == 0) {
      throw new NoSuchElementException();
    }
    if (head == 0) {
      return (T)data[data.length - 1];
    } else {
      return (T)data[head - 1];
    }
  }
  public boolean isFull() {
    if (size == data.length) {
      return true;
    } else {
      return false;
    }
  }
  public int size() {
    return size;
  }
}