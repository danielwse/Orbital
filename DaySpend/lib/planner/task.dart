
class Task implements Comparable {
  int id;
  String index;
  String name;
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

  factory Task.fromJson(Map<String, dynamic> data) => Task(
      id: data['id'],
      index: data['index'],
      name: data['name'],
      time: data['time'],
      description: data['description'],
      notify: data['notify'] == 0 ? false : true,
      isComplete: data['isComplete'] == 0 ? false : true,
      isOverdue: data['isOverdue'] == 0 ? false : true,
      opacity: data['isOverdue'],
      dt: DateTime.parse(data['dt'])
  );

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "index": this.index,
      "name": this.name,
      "time": this.time,
      "description": this.description,
      "notify": this.notify == false ? 0 : 1,
      "isComplete": this.isComplete == false ? 0 : 1,
      "isOverdue": this.isOverdue == false ? 0 : 1,
      "opacity": this.opacity,
      "dt": this.dt.toString().substring(0,19)
    };
  }
}