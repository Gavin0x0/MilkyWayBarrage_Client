import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:milkyway/components/AboutUs.dart';
import 'package:milkyway/providers/ParameterModifier.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:qr/qr.dart';

class LinkButtons extends StatefulWidget {
  const LinkButtons({@required this.cxt});

  final BuildContext cxt;
  @override
  _LinkButtonsState createState() => _LinkButtonsState();
}

class _LinkButtonsState extends State<LinkButtons> {
  String _qrDate;
  @override
  void initState() {
    setState(() {
      _qrDate =
          '{"roomid":${context.read<ParameterModifier>().roomid},"token":"${context.read<ParameterModifier>().token}"}';
    });

    super.initState();
  }

  void _generateQR() {
    setState(() {
      _qrDate =
          '{"roomid":${context.read<ParameterModifier>().roomid},"token":"${context.read<ParameterModifier>().token}"}';
    });
  }

  void callBack() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('确定退出房间吗?'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('取消'),
                  onPressed: () => Navigator.pop(widget.cxt, false),
                ),
                ElevatedButton(
                    child: Text('确定'),
                    onPressed: () {
                      Navigator.pop(widget.cxt);
                      Navigator.pop(widget.cxt);
                      print('tap the quit');
                    }),
              ],
            ));
  }

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              FloatingActionButton(
                elevation: 0.0,
                heroTag: 'Link',
                child: Icon(
                  Icons.link,
                  color: Colors.white,
                  size: 40,
                ),
                tooltip: "Link",
                foregroundColor: Colors.white,
                backgroundColor: Colors.green[300],
                onPressed: () {
                  _generateQR();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (context.watch<ParameterModifier>().online) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(50),
                          shape: CircleBorder(),
                          content: Container(
                            child: Center(
                              child: PrettyQr(
                                image: AssetImage('assets/Milkyway3.png'),
                                typeNumber: 4,
                                size: 200,
                                data: _qrDate,
                                errorCorrectLevel: QrErrorCorrectLevel.M,
                                roundEdges: true,
                              ),
                            ),
                            width: 320,
                            height: 320,
                          ),
                        );
                      } else {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(50),
                          shape: CircleBorder(),
                          content: Icon(
                            Icons.link_off,
                            color: Colors.black,
                            size: 80,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '开启连接',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              FloatingActionButton(
                elevation: 0.0,
                heroTag: 'quit',
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                  size: 40,
                ),
                tooltip: "quit",
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFf7797d),
                onPressed: () {
                  callBack();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '退出房间',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              FloatingActionButton(
                elevation: 0.0,
                heroTag: 'About',
                child: Icon(
                  Icons.alternate_email,
                  color: Colors.white,
                  size: 40,
                ),
                tooltip: "About",
                foregroundColor: Colors.white,
                backgroundColor: Colors.amber[200],
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.all(0),
                        insetPadding: EdgeInsets.fromLTRB(20, 150, 20, 150),
                        content: AboutUs(),
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '关于我们',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
