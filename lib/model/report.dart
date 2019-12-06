class Report{
  int waiting;
  int processing;
  int finish;

  Report({this.waiting = 0, this.processing = 0, this.finish = 0});

  Report.fromJson(Map<String, dynamic> json) {
    waiting = json['waiting'];
    processing = json['processing'];
    finish = json['finish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waiting'] = this.waiting;
    data['processing'] = this.processing;
    data['finish'] = this.finish;
    return data;
  }

}