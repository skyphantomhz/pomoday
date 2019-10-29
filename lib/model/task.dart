class Task {
  int id;
  String header;
  String name;
  int createDate;
  int startDate;
  int endDate;

  Task(
      {this.id,
      this.header,
      this.name,
      this.createDate,
      this.startDate,
      this.endDate});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    name = json['name'];
    createDate = json['createDate'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['header'] = this.header;
    data['name'] = this.name;
    data['createDate'] = this.createDate;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}
