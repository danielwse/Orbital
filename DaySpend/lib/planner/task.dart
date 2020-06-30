class Task implements Comparable {
  final String name;
  final String index;
  final String time;
  final String status;
  final String description;

  Task(this.index, this.name, this.time, this.status, this.description);

  @override
  int compareTo(other) {
    return time.compareTo(other.time);
  }
}