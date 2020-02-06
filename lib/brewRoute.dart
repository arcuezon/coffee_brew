import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'brew.dart';

class BrewSelectRoute extends StatelessWidget {
  final String method;

  const BrewSelectRoute({
    @required this.method,
  }) : assert(method != null);

  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      title: 'brewRoute',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[300],
          title: Text(method,
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        body: BrewSelectBody(),
      ),
    );
  }
}

class BrewSelectBody extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    double water;
    double dose;
    int mlRatio;

    final ratioIn = TextEditingController();
    final doseIn = TextEditingController();
    final waterIn = TextEditingController();

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: 20.0, right: 20.0, bottom: 30.0, top: 35.0),
            child: TextField(
              controller: ratioIn,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Ratio (g/L)', border: OutlineInputBorder()),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TextField(
              controller: doseIn,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Dose (g)', border: OutlineInputBorder()),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: TextField(
              controller: waterIn,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Total Water (mL)', border: OutlineInputBorder()),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 40.0),
            child: RaisedButton(
              child: Text(
                'Confirm',
                style: TextStyle(fontSize: 20.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 70.0),
              onPressed: () {
                if (ratioIn.text.isNotEmpty) {
                  mlRatio = int.parse(ratioIn.text);
                }

                if (doseIn.text.isNotEmpty) {
                  dose = double.parse(doseIn.text);
                }
                if (waterIn.text.isNotEmpty) {
                  water = double.parse(waterIn.text);
                }

                if ((doseIn.text.isEmpty && waterIn.text.isEmpty) ||
                    ratioIn.text.isEmpty) {
                  print('Fields empty!!!');
                } else {
                  print('BrewSelect confirm pressed.');
                  print('Ratio: $mlRatio \n' +
                      'Dose: ${dose}g\n' +
                      'Water: ${water}ml');

                  Navigator.push(
                      buildContext,
                      MaterialPageRoute(
                          builder: (BuildContext buildContext) => BrewPage(
                                mlRatio: mlRatio,
                                dose: dose,
                                finalWeight: water,
                              )));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
