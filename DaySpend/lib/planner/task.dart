
class Task implements Comparable {
  final int id;
  String name;
  String index;
  String time;
  String description;
  bool notify;
  bool isComplete;
  bool isOverdue;
  double opacity;
  DateTime dt;

  Task({this.id, this.index, this.name, this.time, this.dt, this.description, this.notify = false, this.isComplete = false, this.isOverdue = false, this.opacity = 1});

  void toggleNotify() {
    notify = !notify;
  }

  void toggleComplete() {
    isComplete = !isComplete;
  }

  void toggleOverdue() {
    isOverdue = true;
  }

  void toggleAnimate() {
    opacity = 0;
  }

  @override
  int compareTo(other) {
    return time.compareTo(other.time);
  }
}