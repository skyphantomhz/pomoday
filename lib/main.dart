import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:pomoday/di/locator.dart';
import 'package:pomoday/model/report.dart';
import 'package:pomoday/model/task.dart';
import 'package:pomoday/widget/overlay.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MainBloc bloc;
  var inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<MainBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: EmptyAppBar(),
      endDrawer: Drawer(
        child: Container(
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(color: Colors.grey[100]),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Help:",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "c[reate] [@tag] [todo]",
                    style: TextStyle(color: Colors.grey),
                  )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "p[rocess] [id]",
                    style: TextStyle(color: Colors.grey),
                  )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "f[inish] [id]",
                    style: TextStyle(color: Colors.grey),
                  )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "d[elete] [id]",
                    style: TextStyle(color: Colors.grey),
                  )),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            InkWell(
              onTap: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
              child: Text(
                "Pomoday",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.grey,
                    fontFamily: 'Pacifico'),
              ),
            ),
            Expanded(
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
                        if (currentHeader == task.header) {
                          return Container(
                            margin: EdgeInsets.only(left: 40),
                            child: Row(
                              children: <Widget>[
                                Status(
                                  status: task.status,
                                ),
                                Text(
                                  "${task.id}. ${task.name}",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Status(
                                      status: task.status,
                                    ),
                                    Text(
                                      "${task.id}. ${task.name}",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Status(
                                  status: task.status,
                                ),
                                Text(
                                  "${task.id}. ${task.name}",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            StreamBuilder<Report>(
              stream: bloc.report,
              initialData: Report(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Report report = snapshot.data;
                return Text(
                  "Waiting: ${report.waiting} Processing: ${report.processing} done: ${report.finish}",
                  style: TextStyle(color: Colors.black54),
                );
              },
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

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(TutorialOverlay());
  }
}

class Status extends StatelessWidget {
  final TaskStatus status;
  const Status({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TaskStatus.PROCESS:
        return Icon(Icons.autorenew);
        break;
      case TaskStatus.DONE:
        return Icon(Icons.check, color: Colors.green);
        break;
      default:
        return Icon(Icons.check_box_outline_blank);
    }
  }
}

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
