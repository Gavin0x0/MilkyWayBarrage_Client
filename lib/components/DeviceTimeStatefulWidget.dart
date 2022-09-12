import 'dart:async';
import 'package:flutter/material.dart';
import 'package:milkyway/providers/OffsetHandler.dart';
import 'package:provider/provider.dart';

class DeviceTimeStatefulWidget extends StatefulWidget {
  @override
  const DeviceTimeStatefulWidget({
    Key key,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 40,
    ),
  }) : super(key: key);
  final TextStyle textStyle;
  _DeviceTimeStatefulWidgetState createState() {
    var state = new _DeviceTimeStatefulWidgetState();
    state.startTimer();
    return state;
  }
}

class _DeviceTimeStatefulWidgetState extends State<DeviceTimeStatefulWidget> {
  Timer _timer;
  int delay = 0;
  DateTime now = DateTime.now();
  void startTimer() {
    const oneSec = const Duration(milliseconds: 10); //间隔1秒
    _timer = new Timer.periodic(
      oneSec, //每秒调用一次
      (Timer timer) => setState(
        () {
          now = DateTime.now();
        },
      ),
    );
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  context.read<OffsetHandler>().increment(100);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '+0.1s',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<OffsetHandler>().increment(30000);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '+30s',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (now.millisecondsSinceEpoch % 1000000 +
                      context.watch<OffsetHandler>().offset)
                  .toString(),
              textAlign: TextAlign.center,
              style: widget.textStyle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  context.read<OffsetHandler>().increment(-100);
                },
                // shape: CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '-0.1s',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<OffsetHandler>().increment(-30000);
                },
                // shape: CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '-30s',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'DELAY : ${context.watch<OffsetHandler>().offset}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
