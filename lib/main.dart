//import 'dart:html';

import 'package:flutter/material.dart';
import 'brewRoute.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext buildcontext) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[300],
          title: Center(
            child: Text(
              'App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
          ),
        ),
        body: Container(
          child: MethodRoute(),
          color: Colors.brown[50],
        ),
      ),
    );
  }
}

class Method extends StatelessWidget {
  final String methodName;
  final String imgLoc;

  const Method({
    Key key,
    @required this.methodName,
    @required this.imgLoc,
  })  : assert(methodName != null),
        assert(imgLoc != null),
        super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: InkWell(
          splashColor: Colors.brown[100],
          onTap: () {
            Navigator.push(
                buildContext,
                MaterialPageRoute(
                    builder: (BuildContext buildContext) => BrewSelectRoute(
                      method: methodName,
                    )));
            print("Pressed $methodName");
          },
          child: Row(
            children: <Widget>[
              Container(
                width: 100.0,
                child: Image(
                  image: AssetImage(imgLoc),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  methodName,
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
            ],
          ),
        ),
        height: 100.0,
      ),
    );
  }
}

class MethodRoute extends StatelessWidget {
  const MethodRoute();

  static const _methodNames = <String>[
    'V60',
    'Aeropress',
    'Chemex',
    'Wave 185',
    'French Press',
  ];

  static const _imgLocs = <String>[
    'assets/v60.png',
    'assets/aeropress.png',
    'assets/chemex.png',
    'assets/wave.png',
    'assets/press.png',
  ];

  Widget _buildMethodWidgets(List<Widget> methods) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => methods[index],
      itemCount: methods.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final methods = <Method>[];

    for (int i = 0; i < _methodNames.length; i++) {
      methods.add(Method(
        methodName: _methodNames[i],
        imgLoc: _imgLocs[i],
      ));
    }

    final listview = Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildMethodWidgets(methods),
    );

    return listview;
  }
}
