
class Task implements Comparable {
  int id;
  String index;
  String name;
  String time;
  String description;
  bool notify;
  bool isComplete;
  bool isOverdue;
  bool isArchived;
  bool isExpired;
  double opacity;
  DateTime dt;
  int length;

  Task({this.id, this.index, this.name, this.time, this.dt, this.isArchived, this.description, this.notify = false, this.isComplete, this.isOverdue, this.isExpired, this.opacity = 1, this.length});

  void toggleAnimate() {
    opacity = 0;
  }

  @override
  int compareTo(other) {
    return dt.compareTo(other.dt);
  }

  factory Task.fromJson(Map<String, dynamic> data) => Task(
      id: data["id"],
      index: data["converted_index"],
      name: data["name"],
      time: data["time"],
      description: data["description"],
      notify: data["notify"] == 0 ? false : true,
      isComplete: data["isComplete"] == 0 ? false : true,
      isOverdue: data["isOverdue"] == 0 ? false : true,
      isArchived: data["isArchived"] == 0 ? false : true,
      isExpired: data["isExpired"] == 0 ? false : true,
      opacity: data["opacity"],
      dt: DateTime.parse(data["dt"]),
      length: data["length"]
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "converted_index": index,
      "name": name,
      "time": time,
      "description": description,
      "notify": notify == false ? 0 : 1,
      "isComplete": isComplete == false ? 0 : 1,
      "isOverdue": isOverdue == false ? 0 : 1,
      "isArchived": isArchived == false ? 0 : 1,
      "isExpired": isExpired == false ? 0 : 1,
      "opacity": opacity,
      "dt": dt.toIso8601String(),
      "length": length
    };
  }
}