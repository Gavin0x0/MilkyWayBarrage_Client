import 'dart:async';
import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screen/flutter_screen.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:milkyway/Screens/MainScreen.dart';
import 'package:milkyway/components/MilkyWay.dart';
import 'package:milkyway/components/ColorPickerButtons.dart';
import 'package:milkyway/providers/OffsetHandler.dart';
import 'package:milkyway/providers/ParameterModifier.dart';
import 'package:provider/provider.dart';
import 'package:milkyway/components/LinkButtons.dart';
import 'package:milkyway/components/itemSlider.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:package_info/package_info.dart';

class BarrageScreen extends StatefulWidget {
  final int roomid;
  final String token;
  final BuildContext context;
  BarrageScreen(
      {Key key,
      @required this.roomid,
      @required this.token,
      @required this.context})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    var state = new _BarrageScreenState();
    if (token != 'offline') {
      print('启动心跳包');
      state.heartbeat();
    }
    return state;
  }
}

class _BarrageScreenState extends State<BarrageScreen> {
  IOWebSocketChannel channel;
  Timer _timer;
  bool screenLock = false;
  DateTime currentBackPressTime;
  Future<bool> _onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "再按一次退出房间");
      return Future.value(false);
    }
    return Future.value(true);
  }

  PanelController panel = new PanelController();

  void heartbeat() {
    const interval = const Duration(milliseconds: 15000); //间隔15秒
    _timer = new Timer.periodic(
        interval, //每15秒调用一次
        (Timer timer) => channel.sink.add('{"action":"ping"}'));
  }

  var battery = Battery();
  var statusreportstr;
  FToast fToast;
  String version;
  void initState() {
    super.initState();
    getVersion();
    fToast = FToast();
    battery.onBatteryStateChanged.listen((BatteryState state) async {
      var t =
          '{"action":"statusreport","batterylevel":${await battery.batteryLevel},"batterystatus":${state.index}}';
      if (t != statusreportstr) {
        channel.sink.add(t);
        statusreportstr = t;
      }
    });
    if (widget.token != 'offline') {
      establishConnection();
    } else {
      setState(() {
        channel = IOWebSocketChannel.connect("ws://000.000.000.000");
      });
    }
  }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    //SystemChrome.setEnabledSystemUIOverlays([]);

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: GestureDetector(
          onTap: () {
            //隐藏键盘
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
            body: SlidingUpPanel(
              controller: panel,
              header: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'ROOM : ${context.watch<ParameterModifier>().roomid}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text(
                          'INDEX : ${context.watch<ParameterModifier>().deviceindex}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
              ),
              panel: Center(
                child: MediaQuery.of(context).size.height * 1.6 <
                        MediaQuery.of(context).size.width
                    ? Text('请在竖屏模式调节参数')
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ItemSlider(),
                          ColorPickerButtons(),
                          LinkButtons(
                            cxt: context,
                          ),
                        ],
                      ),
              ),
              collapsed: Container(
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: radius),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.lock_open),
                          color: Colors.transparent,
                          iconSize: 30.0,
                          onPressed: () {
                            print('nothing');
                          }),
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.black,
                        semanticLabel: "open",
                        size: 40.0,
                        textDirection: TextDirection.rtl,
                      ),
                      IconButton(
                          icon: Icon(Icons.lock_open),
                          color: Colors.black,
                          iconSize: 30.0,
                          onPressed: () {
                            print('lock');
                            setState(() {
                              screenLock = true;
                              // FlutterScreen.keepOn(true);
                            });
                          }),
                    ],
                  ),
                ),
              ),
              body: GestureDetector(
                onTap: () {
                  panel.close();
                },
                child: Center(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      MilkyWay(context).widget,
                      IconButton(
                          padding: EdgeInsets.all(15),
                          iconSize: 30,
                          color: MediaQuery.of(context).size.height * 1.6 <
                                  MediaQuery.of(context).size.width
                              ? Colors.transparent
                              : Colors.white,
                          icon: Icon(Icons.lock_outline),
                          onPressed: () {
                            print('lock open');
                            setState(() {
                              screenLock = false;
                              // FlutterScreen.keepOn(false);
                            });
                          })
                    ],
                  ),
                ),
              ),
              borderRadius: radius,
              //滚动视差
              parallaxEnabled: true,
              parallaxOffset: 0.5,
              //打开和折叠时的高度
              minHeight: MediaQuery.of(context).size.height * 1.6 <
                      MediaQuery.of(context).size.width
                  ? 0
                  : screenLock
                      ? 0
                      : 60,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              backdropTapClosesPanel: false,
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _timer.cancel();
    channel.sink.close();
    // FlutterScreen.resetBrightness();
    resetBrightness();
    super.dispose();
  }

  void resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to reset brightness';
    }
  }

  bool connected = false;
  void establishConnection() {
    setState(() {
      channel = IOWebSocketChannel.connect(
          "ws://mkdm-app.idealbroker.cn/ws/${version}/${widget.roomid.toString()}/${widget.token}");
      connected = true;
    });
    var textPara = context.read<ParameterModifier>();
    // 监听消息
    textPara.setwsconn(channel.sink);
    textPara.setRoomID(widget.roomid);
    textPara.setToken(widget.token);
    textPara.setConnectionState(true);
    channel.stream.listen((message) async {
      print(message);
      Map<String, dynamic> room;
      Map<String, dynamic> msg = jsonDecode(message);
      switch (msg["action"]) {
        case "init":
          room = msg["data"];
          textPara.init(room);
          channel.sink.add('{"action":"timestamp"}');
          var model, brand;
          if (Platform.isAndroid) {
            var deviceInfo = await DeviceInfoPlugin().androidInfo;
            brand = deviceInfo.manufacturer;
            model = deviceInfo.model;
          } else if (Platform.isIOS) {
            var deviceInfo = await DeviceInfoPlugin().iosInfo;
            brand = "apple";
            model = deviceInfo.model;
          }
          var connectivityResult = await (Connectivity().checkConnectivity());
          channel.sink.add(
              '{"action":"init","nettype":${connectivityResult.index},"brand":"${brand}","model":"${model}","platform":"${Platform.operatingSystem}"}');
          textPara.reportscreensize();
          break;
        case "setindex":
          textPara.setIndex(msg["index"]);
          break;
        case "setspeed":
          textPara.onlySetSpeed(msg["data"].toDouble());
          break;
        case "settext":
          textPara.onlyChangeText(msg["data"]);
          break;
        case "settextsize":
          textPara.onlySetTextSize(msg["data"].toDouble());
          break;
        case "settextcolor":
          textPara.onlySetTextColor(msg["data"]);
          break;
        case "setbackgroundcolor":
          textPara.onlySetBGColor(msg["data"]);
          break;
        case "setdevicelist":
          textPara.setDeviceList(msg["data"]);
          break;
        case "timestamp":
          context.read<OffsetHandler>().sync(msg["data"]);
          break;
        case "msg":
          Widget toast = Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.amberAccent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.message),
                SizedBox(
                  width: 12.0,
                ),
                Text(msg["msg"]),
              ],
            ),
          );
          fToast.removeCustomToast();
          fToast.showToast(
            child: toast,
            gravity: ToastGravity.TOP,
            toastDuration: Duration(seconds: 2),
          );
          break;
        case "showexitdialog":
          reconnectlock = true;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => WillPopScope(
                  onWillPop: () {},
                  child: AlertDialog(
                    title: Text("服务器拒绝连接"),
                    content: Text(msg["data"]),
                    actions: <Widget>[
                      new ElevatedButton(
                        child: new Text('确定'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new MainScreen()),
                            (route) => route == null,
                          );
                        },
                      ),
                    ],
                  )));
          break;
      }
    }, onError: (error) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("网络连接错误"),
                content: Text(error.toString()),
              ));
    }, onDone: () async {
      //Fluttertoast.showToast(msg: "连接断开");
      connected = false;
      reconnect();
    });
  }

  bool reconnectlock = false;
  void reconnect() async {
    if (reconnectlock) return;
    BuildContext dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return WillPopScope(
            onWillPop: () {},
            child: AlertDialog(
              title: Text("连接断开，正在重连..."),
              actions: <Widget>[
                new ElevatedButton(
                  child: new Text('退出'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new MainScreen()),
                      (route) => route == null,
                    );
                  },
                ),
              ],
            ));
      },
    );
    while (!connected) {
      await Future.delayed(Duration(seconds: 3));
      establishConnection();
    }
    Navigator.pop(dialogContext);
  }
}
