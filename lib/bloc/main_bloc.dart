import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends Bloc {
  PublishSubject<String> _input = PublishSubject<String>();
  Observable<String> get input => _input.stream;

  void fetchData() async {
    // final response = await service.fetchData();
    // _city.sink.add(response);
  }

  @override
  void dispose() {
    _input.close();
  }

  void parserCommand(String str) {
    if(parseTaskCommand(str)){
      print("```````````````````````````Marching parseTaskCommand");
      _input.sink.add("");
      return;
    }

    if(parseCheckCommand(str)){
      print("```````````````````````````Marching parseCheckCommand");
      _input.sink.add("");
      return;
    }

    if(parseBeginCommand(str)){
      print("```````````````````````````Marching parseBeginCommand");
      _input.sink.add("");
      return;
    }

    if(parseDeleteCommand(str)){
      print("```````````````````````````Marching parseDeleteCommand");
      _input.sink.add("");
      return;
    }

    if(parseHelpCommand(str)){
      print("```````````````````````````Marching parseHelpCommand");
      _input.sink.add("");
      return;
    }
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

  bool parseTaskCommand(String str) => regTask.hasMatch(str);
  bool parseCheckCommand(String str) => regCheck.hasMatch(str);
  bool parseBeginCommand(String str) => regBegin.hasMatch(str);
  bool parseDeleteCommand(String str) => regDelete.hasMatch(str);
  bool parseHelpCommand(String str) => regHelp.hasMatch(str);
}
