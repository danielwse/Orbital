class Task implements Comparable {
  final String name;
  final String index;
  final String time;
  final String description;
  bool notify;
  bool isComplete;
  bool isOverdue;
  double opacity;

  Task({this.index, this.name, this.time, this.description, this.notify = false, this.isComplete = false, this.isOverdue = false, this.opacity = 1});

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