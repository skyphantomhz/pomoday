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
    // _city.close();
  }

  void parserCommand(String str) {
    if(parseTaskCommand(str)){
      _input.sink.add("");
      return;
    }
  }

  var regTask = new RegExp(
    "/(t(?:ask)?)\s(@(?:\S*['-]?)(?:[0-9a-zA-Z'-]+))?(.*)/",
    caseSensitive: false,
    multiLine: false,
  );

  bool parseTaskCommand(String str) => regTask.hasMatch(str);
  // var parseCheckCommand = (String str) => str.match(/(c(?:heck)?)\s(\d+)/);
  // var parseBeginCommand = (String str) => str.match(/(b(?:egin)?)\s(\d+)/);
  // var parseDeleteCommand = (String str) => str.match(/(d(?:elete)?)\s(\d+)/);
  // var parseHelpCommand = (String str) => str.match(/(close-help|help)/);
}
