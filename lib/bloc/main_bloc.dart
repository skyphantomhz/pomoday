import 'package:bloc_provider/bloc_provider.dart';
import 'package:pomoday/model/report.dart';
import 'package:pomoday/model/task.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends Bloc {
  PublishSubject<String> _input = PublishSubject<String>();
  Observable<String> get input => _input.stream;

  BehaviorSubject<List<Task>> _tasks = BehaviorSubject<List<Task>>();
  Observable<List<Task>> get tasks => _tasks.stream;

  PublishSubject<Report> _report = PublishSubject<Report>();
  Observable<Report> get report => _report.stream;

  @override
  void dispose() {
    _input.close();
    _tasks.close();
    _report.close();
  }

  void parserCommand(String str) {
    if (regTask.hasMatch(str)) {
      _input.sink.add("");
      _addTask(parseTaskCommand(str));
      return;
    }

    if (regHelp.hasMatch(str)) {
      _input.sink.add("");
      print("parseHelpCommand");
      return;
    }

    if (!_tasks.hasValue) {
      return;
    }

    if (regCheck.hasMatch(str)) {
      _input.sink.add("");
      _updateTask(parseCheckCommand(str), TaskStatus.DONE);
      return;
    }

    if (regBegin.hasMatch(str)) {
      _input.sink.add("");
      _updateTask(parseBeginCommand(str), TaskStatus.PROCESS);
      return;
    }

    if (regDelete.hasMatch(str)) {
      _input.sink.add("");
      _deleteTask(parseDeleteCommand(str));
      return;
    }
  }

  void _addTask(RegExpMatch matchTask) {
    var tempTasks = List<Task>();
    if (_tasks.hasValue) {
      tempTasks = _tasks.value;
    }

    var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var task = Task(
        id: tempTasks.length,
        header: matchTask?.group(2) ?? "",
        name: matchTask?.group(3)?.trim() ?? "",
        createDate: currentMilliseconds,
        startDate: 0,
        endDate: 0);
    tempTasks.add(task);
    prepareData(tempTasks);
  }

  _updateTask(RegExpMatch matchTask, TaskStatus status) {
    var tempTasks = _tasks.value;
    tempTasks.forEach((task) {
      if (task.id.toString() == matchTask.group(2)) {
        task.status = status;
      }
    });
    prepareData(tempTasks);
  }

  _deleteTask(RegExpMatch matchTask) {
    var tempTasks = _tasks.value;
    for (Task task in tempTasks) {
      if (task.id.toString() == matchTask.group(2)) {
        tempTasks.remove(task);
      }
    }
    prepareData(tempTasks);
  }

  void prepareData(List<Task> newTasks) {
    newTasks.sort((a, b) => a.header.compareTo(b.header) * -1);
    var report = Report();
    newTasks.forEach((task) {
      switch (task.status) {
        case TaskStatus.PROCESS:
          report.processing++;
          break;
        case TaskStatus.DONE:
          report.finish++;
          break;
        default:
          report.waiting++;
      }
    });
    _report.sink.add(report);
    _tasks.sink.add(newTasks);
  }

  var regTask = new RegExp(
    r"^(c(?:reate)?)\s(@(?:\S*['-]?)(?:[0-9a-zA-Z'-]+))?(.*)",
    caseSensitive: false,
    multiLine: false,
  );

  var regCheck = new RegExp(
    r"^(f(?:inish)?)\s(\d+)",
    caseSensitive: false,
    multiLine: false,
  );

  var regBegin = new RegExp(
    r"^(p(?:rocess)?)\s(\d+)",
    caseSensitive: false,
    multiLine: false,
  );

  var regDelete = new RegExp(
    r"^(d(?:elete)?)\s(\d+)",
    caseSensitive: false,
    multiLine: false,
  );

  var regHelp = new RegExp(
    r"^(close-help|help)",
    caseSensitive: false,
    multiLine: false,
  );

  RegExpMatch parseTaskCommand(String str) => regTask.allMatches(str).first;
  RegExpMatch parseCheckCommand(String str) => regCheck.allMatches(str).first;
  RegExpMatch parseBeginCommand(String str) => regBegin.allMatches(str).first;
  RegExpMatch parseDeleteCommand(String str) => regDelete.allMatches(str).first;
  RegExpMatch parseHelpCommand(String str) => regHelp.allMatches(str).first;
}
