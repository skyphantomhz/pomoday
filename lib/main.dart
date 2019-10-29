import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:pomoday/di/locator.dart';
import 'package:pomoday/model/task.dart';

import 'bloc/main_bloc.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<MainBloc>(
        creator: (_context, _bag) => MainBloc(),
        child: MyHomePage(title: "Pomoday"),
        autoDispose: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MainBloc bloc;
  var inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<MainBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              // child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(5),
                child: StreamBuilder<List<Task>>(
                  stream: bloc.tasks,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<Task> tasks = snapshot.data;
                    var currentHeader = "";
                    return ListView.builder(
                      itemCount: tasks?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        var task = tasks[index];
                        if(currentHeader == task.header){
                          return Container(
                            margin: EdgeInsets.only(left: 40),
                            child: Text(
                              "${task.id}. ${task.name}",
                              style: TextStyle(fontSize: 15.0),
                            ),
                          );
                        }
                        if (task.header.isNotEmpty) {
                          currentHeader = task.header;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                child: Text(
                                  task.header,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 40),
                                child: Text(
                                  "${task.id}. ${task.name}",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              "${task.id}. ${task.name}",
                              style: TextStyle(fontSize: 15.0),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            StreamBuilder<String>(
              stream: bloc.input,
              builder: (context, snapshot) {
                inputController.text = snapshot.data;
                return TextField(
                  controller: inputController,
                  decoration: InputDecoration(
                      hintText: 'Enter anything here...',
                      fillColor: Colors.black12,
                      contentPadding:
                          EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0)),
                  onSubmitted: (str) {
                    bloc.parserCommand(str);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
