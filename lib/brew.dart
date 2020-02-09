import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            color: Colors.brown[100],
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

  int _step = 1;

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

  var secs;

  String brewInstruct() {
    secs = stopwatch.elapsed.inSeconds;

    if (secs < 45) {
      return 'Bloom ${_bloom.toStringAsFixed(1)}ml';
    } else if (secs >= 45 && secs < 75) {
      if (secs == 45) {
        _step++;
      }
      return 'Pour to ${_firstPour.toStringAsFixed(1)}ml';
    } else if (secs >= 75 && secs < 105) {
      if (secs == 75) {
        _step++;
      }
      return 'Pour to ${_total.toStringAsFixed(1)}ml';
    } else if (secs >= 105) {
      return '';
    }

    return 'Error!';
  }

  String nextInstruct() {
    switch (_step) {
      case 1:
        return 'Pour to ${_firstPour.toStringAsFixed(1)}ml';
        break;

      case 2:
        return 'Pour to ${_total.toStringAsFixed(1)}ml';
        break;

      case 3:
        return ' ';
        break;

      default:
        return 'Out of scope: $_step';
        break;
    }
  }

  String timeLeft() {
    if (secs < 45) {
      return "${45 - secs} seconds";
    } else if (secs >= 45 && secs < 75) {
      return '${75 - secs} seconds';
    } else if (secs >= 75 && secs < 105) {
      return '${105 - secs} seconds';
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
    _step = 1;
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
          height: 130.0,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20.0)),
          margin: EdgeInsets.only(
            top: 17.0,
            bottom: 5.0,
            right: 0,
            left: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 5.0,
                  bottom: 0,
                  right: 45.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 69.0),
                      child: Text(
                        "Elapsed",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 80.0,
                      ),
                      child: Text(
                        //TIME Display
                        timeDisp,
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //Instructions
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          brewInstruct(),
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Text(timeLeft(),
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                    ]),
              ),
            ],
          ),
        ),
        Container(
          width: 500.0,
          height: 90.0,
          margin: EdgeInsets.symmetric(vertical: 7.0),
          padding: EdgeInsets.symmetric(vertical: 3.0),
          //constraints: BoxConstraints(minHeight: 50.0),
          //alignment: AlignmentGeometry.,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey[300],
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Next:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Container(
                        width: 150.0,
                        child: Text(
                          nextInstruct(),
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w400),
                        ),
                        margin: EdgeInsets.only(top: 5.0, right: 20.0)),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        child: Text('Ratio: $_mlRatio',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w300))),
                    Container(
                        child: Text('Dose: $_dose',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w300))),
                    Container(
                        child: Text('Water: $_total',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w300))),
                  ],
                )
              ]),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 20.0,
          ),
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
      ],
    );
  }
}
