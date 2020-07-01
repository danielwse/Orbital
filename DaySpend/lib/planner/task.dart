class Task implements Comparable {
  final String name;
  final String index;
  final String time;
  final String description;
  bool notify;
  bool isComplete;
  bool isOverdue;

  Task({this.index, this.name, this.time, this.description, this.notify, this.isComplete, this.isOverdue});

  @override
  int compareTo(other) {
    return time.compareTo(other.time);
  }

  void toggleNotify() {
    notify = !notify;
  }
}