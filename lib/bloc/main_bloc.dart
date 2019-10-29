import 'package:bloc_provider/bloc_provider.dart';
import 'package:pomoday/model/task.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends Bloc {
  PublishSubject<String> _input = PublishSubject<String>();
  Observable<String> get input => _input.stream;

  BehaviorSubject<List<Task>> _tasks = BehaviorSubject<List<Task>>();
  Observable<List<Task>> get tasks => _tasks.stream;

  @override
  void dispose() {
    _input.close();
    _tasks.close();
  }

  void parserCommand(String str) {
    if (regTask.hasMatch(str)) {
      _input.sink.add("");
      print("parserCommand");
      _addTask(parseTaskCommand(str));
      return;
    }

    if (regCheck.hasMatch(str)) {
      _input.sink.add("");
      print("parseCheckCommand");
      return;
    }

    if (regBegin.hasMatch(str)) {
      _input.sink.add("");
      print("parseBeginCommand");
      return;
    }

    if (regDelete.hasMatch(str)) {
      _input.sink.add("");
      print("parseDeleteCommand");
      return;
    }

    if (regHelp.hasMatch(str)) {
      _input.sink.add("");
      print("parseHelpCommand");
      return;
    }
  }

  void _addTask(Iterable<RegExpMatch> matchTask) {
    var tempTasks = List<Task>();
    if (_tasks.hasValue) {
      tempTasks = _tasks.value;
    }

    var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var matching = matchTask.elementAt(0);
    var task = Task(
        id: tempTasks.length,
        header: matching?.group(2)??"",
        name: matching?.group(3)?.trim()??"",
        createDate: currentMilliseconds,
        startDate: 0,
        endDate: 0);
    tempTasks.add(task);
    prepareData(tempTasks);
  }

  void prepareData(List<Task> newTasks) {
    newTasks.sort((a, b) => a.header.compareTo(b.header)*-1);
    _tasks.sink.add(newTasks);
  }

  var regTask = new RegExp(
    r"^(t(?:ask)?)\s(@(?:\S*['-]?)(?:[0-9a-zA-Z'-]+))?(.*)",
    caseSensitive: false,
    multiLine: false,
  );

  var regCheck = new RegExp(
    r"^(c(?:heck)?)\s(\d+)",
    caseSensitive: false,
    multiLine: false,
  );

  var regBegin = new RegExp(
    r"^(b(?:egin)?)\s(\d+)",
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

  Iterable<RegExpMatch> parseTaskCommand(String str) => regTask.allMatches(str);
  Iterable<RegExpMatch> parseCheckCommand(String str) => regCheck.allMatches(str);
  Iterable<RegExpMatch> parseBeginCommand(String str) => regBegin.allMatches(str);
  Iterable<RegExpMatch> parseDeleteCommand(String str) => regDelete.allMatches(str);
  Iterable<RegExpMatch> parseHelpCommand(String str) => regHelp.allMatches(str);
}
