import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:milkyway/Screens/BarrageScreen.dart';
import 'package:http/http.dart' as http;
import 'package:milkyway/Screens/QRcodeScanner.dart';
import 'package:milkyway/components/DialogRouter.dart';
import 'package:milkyway/components/GradientButton.dart';
import 'package:flutter/services.dart'
    show SystemChannels, SystemNavigator, rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Room {
  final bool success;
  final String description;
  final int roomid;
  final String token;

  Room(this.success, this.description, this.roomid, this.token);

  Room.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        description = json['description'],
        roomid = json['roomid'],
        token = json['token'];
}

class MainScreen extends StatefulWidget {
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BuildContext cxt;
  bool loading = false;

  void createroom() async {
    try {
      Room t;
      http
          .get('http://mkdm-app.idealbroker.cn/api/createroom')
          .timeout(const Duration(seconds: 3))
          .catchError((e) {
        Navigator.pop(context, false);
        showDialog(
            context: cxt,
            builder: (context) => AlertDialog(
                  title: Text('网络连接超时，是否进入离线模式?'),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('取消'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    ElevatedButton(
                        child: Text('确定'),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(cxt,
                              MaterialPageRoute(builder: (context) {
                            return BarrageScreen(
                              roomid: 1,
                              token: 'offline',
                              context: cxt,
                            );
                          }));
                        }),
                  ],
                ));
      }).then((value) => {
                if (value == null)
                  {
                    Navigator.pop(context, false),
                    showDialog(
                        context: cxt,
                        builder: (context) => AlertDialog(
                              title: Text('网络连接错误，是否进入离线模式?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('取消'),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                ElevatedButton(
                                    child: Text('确定'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(cxt,
                                          MaterialPageRoute(builder: (context) {
                                        return BarrageScreen(
                                          roomid: 1,
                                          token: 'offline',
                                          context: cxt,
                                        );
                                      }));
                                    }),
                              ],
                            ))
                  }
                else
                  {
                    Navigator.pop(context, false),
                    print(value.body),
                    t = new Room.fromJson(jsonDecode(value.body)),
                    if (!t.success)
                      {Fluttertoast.showToast(msg: t.description)}
                    else
                      {
                        Navigator.push(cxt,
                            MaterialPageRoute(builder: (context) {
                          return BarrageScreen(
                            roomid: t.roomid,
                            token: t.token,
                            context: cxt,
                          );
                        }))
                      }
                  }
              });
    } catch (e) {
      Fluttertoast.showToast(msg: "连接超时");
    }
  }

  DateTime currentBackPressTime;

  Future<bool> _onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "再按一次退出");
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget build(BuildContext context) {
    cxt = context;
    showprivacynotice(cxt);
    List<Widget> gradientButtons = [
      GradientButton(
        child: Text(
          '开启弹幕',
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.w300, letterSpacing: 10),
        ),
        height: 70,
        width: 230,
        colors: [
          Color(0xFFc6ffdd),
          Color(0xFFfbd786),
          Color(0xFFf7797d),
          Color(0xFF2d3038),
        ],
        onPressed: () {
          Navigator.push(context, DialogRouter(LoadingDialog(true)));
          createroom();
        },
        borderRadius: BorderRadius.all(Radius.circular(90)),
      ),
      GradientButton(
        child: Text(
          '加入房间',
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.w300, letterSpacing: 10),
        ),
        height: 70,
        width: 230,
        colors: [
          Color(0xFFc6ffdd),
          Color(0xFFfbd786),
          Color(0xFFf7797d),
          Color(0xFF2d3038),
        ],
        onPressed: () {
          Navigator.push(cxt, MaterialPageRoute(builder: (context) {
            return QRcodeScanner();
          })).then((value) {
            int roomid = value['roomid'];
            String token = value['token'];
            Navigator.push(cxt, MaterialPageRoute(builder: (context) {
              return BarrageScreen(
                roomid: roomid,
                token: token,
                context: cxt,
              );
            }));
          });
        },
        borderRadius: BorderRadius.all(Radius.circular(90)),
      ),
    ];
    return WillPopScope(
      //onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          color: Colors.black,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Container(
              decoration: new BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFFc6ffdd),
                      Color(0xFFfbd786),
                      Color(0xFFf7797d)
                    ]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Container(
                      color: Color(0xFF282832),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Opacity(
                            opacity: 0.2,
                            child: Image.asset(
                              "assets/Milkyway3.png",
                              width: 600.0,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Image.asset(
                                  "assets/Milkyway1.png",
                                  width: 600.0,
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: MediaQuery.of(context).size.width <
                                          MediaQuery.of(context).size.height *
                                              1.2
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: gradientButtons,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: gradientButtons,
                                        )),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    'v1.0.1',
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 20,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: GestureDetector(
                                    child: Text(
                                      '隐私政策',
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          color: Colors.blueGrey),
                                    ),
                                    onTap: () {
                                      Navigator.push(cxt,
                                          MaterialPageRoute(builder: (context) {
                                        return new WebView(
                                          initialUrl:
                                              "https://mkdm-app.idealbroker.cn/privacy",
                                        );
                                      }));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'exit',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
        SystemNavigator.pop();
      }),
].toSet();
*/
Future<void> showprivacynotice(cxt) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool privacyok = prefs.getBool("privacyok");
  if (privacyok != null && privacyok) return;
  showDialog<Null>(
    context: cxt,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new AlertDialog(
        // title: new Text('标题'),
        contentPadding: EdgeInsets.zero,
        content: WebView(
          initialUrl: "https://mkdm-app.idealbroker.cn/privacy",
        ),

        actions: <Widget>[
          TextButton(
            child: Text('拒绝'),
            onPressed: () {
              prefs.setBool("privacyok", false);
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              exit(0);
            },
          ),
          TextButton(
            child: Text('同意'),
            onPressed: () {
              prefs.setBool("privacyok", true);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  ).then((val) {
    print(val);
  });
}
