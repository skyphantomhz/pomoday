class Task {
  int id;
  String header;
  String name;
  TaskStatus status;
  int createDate;
  int startDate;
  int endDate;

  Task(
      {this.id,
      this.header,
      this.name,
      this.status = TaskStatus.WAITING,
      this.createDate,
      this.startDate,
      this.endDate});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    name = json['name'];
    status = json['status'];
    createDate = json['createDate'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['header'] = this.header;
    data['name'] = this.name;
    data['status'] = this.status;
    data['createDate'] = this.createDate;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}

enum TaskStatus{WAITING, PROCESS, DONE}
