class Task implements Comparable {
  String name;
  String index;
  String time;
  String description;
  bool notify;
  bool isComplete;
  bool isOverdue;
  double opacity;
  DateTime dt;

  Task({this.index, this.name, this.time, this.description, this.notify = false, this.isComplete = false, this.isOverdue = false, this.opacity = 1, this.dt});

  void toggleNotify() {
    notify = !notify;
  }

  void toggleComplete() {
    isComplete = !isComplete;
  }

  void toggleOverdue() {
    isOverdue = !isOverdue;
  }

  void toggleAnimate() {
    opacity = 0;
  }

  @override
  int compareTo(other) {
    return time.compareTo(other.time);
  }
}