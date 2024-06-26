import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'dart:async';

class BrewPage extends StatelessWidget {
  final int mlRatio;
  final double dose;
  final double finalWeight;

  const BrewPage({
    @required this.mlRatio,
    this.finalWeight,
    this.dose,
  })  : assert(mlRatio != null),
        assert(finalWeight != null || dose != null);
  //assert(finalWeight != null || mlRatio != null);

  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      title: 'Title',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Brew'),
            backgroundColor: Colors.brown[300],
          ),
          body: Container(
            child: BrewTimer(
              mlRatio: mlRatio,
              dose: dose,
              finalWeight: finalWeight,
            ),
          )),
    );
  }
}

class BrewTimer extends StatefulWidget {
  final int mlRatio;
  final double finalWeight;
  final double dose;

  const BrewTimer({
    @required this.mlRatio,
    this.dose,
    this.finalWeight,
  })  : assert(mlRatio != null),
        assert(dose != null || finalWeight != null);

  @override
  _BrewTimerState createState() => _BrewTimerState();
}

class _BrewTimerState extends State<BrewTimer> {
  bool stopStopwatch = false;
  bool startStopwatch = false;
  bool selectStart = true;
  String startPause = 'Start';

  double _dose;
  double _bloom;
  double _firstPour;
  double _total;
  int _mlRatio;

  @override
  void initState() {
    _total = widget.finalWeight;
    _dose = widget.dose;
    _mlRatio = widget.mlRatio;

    if (_dose == null) {
      _dose = _total * (widget.mlRatio / 1000);
      print("Unknown dose:\n" +
          "Ratio = ${widget.mlRatio}/1000\n" +
          "Water = $_total Dose = $_dose");
    } else if (_total == null) {
      _total = _dose / (widget.mlRatio / 1000);
      print("Unknown Total Water:\n" +
          "Ratio = ${widget.mlRatio}/1000\n" +
          "Water = $_total Dose = $_dose");
    }

    _total = double.parse(_total.toStringAsFixed(1));
    _dose = double.parse(_dose.toStringAsFixed(1));

    _firstPour = 0.6 * _total;
    _bloom = 2 * _dose;
    super.initState();
  }

  var stopwatch = new Stopwatch();
  String timeDisp = '00:00';

  String brewInstruct() {
    var secs = stopwatch.elapsed.inSeconds;

    if (secs < 45) {
      return 'Bloom ${_bloom.toStringAsFixed(1)}ml for ${45 - secs} seconds';
    } else if (secs >= 45 && secs < 75) {
      return 'Pour to ${_firstPour.toStringAsFixed(1)}ml for ${75 - secs} seconds';
    } else if (secs >= 75 && secs < 105) {
      return 'Pour to ${_total.toStringAsFixed(1)}ml for ${105 - secs} seconds';
    } else if (secs >= 105) {
      return 'Done!';
    }

    return 'Error!';
  }

  void keepWatch() {
    Timer(Duration(seconds: 1), swatchRun);
  }

  void textSP() {
    if (selectStart) {
      startPause = 'Start';
    } else if (!selectStart) {
      startPause = 'Pause';
      print(startPause);
    }
  }

  void startSWatch() {
    setState(() {});
    stopwatch.start();
    Screen.keepOn(true);
    keepWatch();
  }

  void stopSWatch() {
    setState(() {
      print("stopSWatch");
    });
    Screen.keepOn(false);
    stopwatch.reset();
    stopwatch.stop();
  }

  void swatchRun() {
    setState(() {
      timeDisp = stopwatch.elapsed.inMinutes.toString().padLeft(2, "0") +
          ':' +
          (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    });

    if (stopwatch.isRunning) {
      keepWatch();
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 150.0,
            bottom: 30.0,
          ),
          child: Text(
            timeDisp,
            style: TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 30.0),
          child: Text(
            brewInstruct(),
            style: TextStyle(
              fontSize: 30.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: Colors.redAccent,
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 20.0,
                ),
                onPressed: () {
                  stopSWatch();
                },
                child: Text("Reset",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )),
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 20.0,
                ),
                color: Colors.lightGreen[300],
                onPressed: () {
                  startSWatch();
                  //selectStart = false;
                  //textSP();
                },
                child: Text(
                  startPause,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.only(top: 40.0, bottom: 5),
            child: Text('Ratio: $_mlRatio', style: TextStyle(fontSize: 20.0))),
        Container(
            padding: EdgeInsets.all(2.5),
            child: Text('Dose: $_dose', style: TextStyle(fontSize: 20.0))),
        Container(
            padding: EdgeInsets.all(5),
            child: Text('Water: $_total', style: TextStyle(fontSize: 20.0))),
      ],
    );
  }
}
