import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:pomoday/di/locator.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text("Hello world!"),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter anything here...',
                fillColor: Colors.black12,
                contentPadding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0)
              ),
              onSubmitted: (str) {
                  
              },
            )
          ],
        ),
      ),
    );
  }
}
