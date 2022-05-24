import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ParameterModifier with ChangeNotifier, DiagnosticableTreeMixin {
  int _roomid = 0;
  int get roomid => _roomid;
  String _token = 'offline';
  String get token => _token;
  int _deviceindex = 0;
  int get deviceindex => _deviceindex;
  String _text = 'Milky Way';
  String get textToLaunch => _text;
  double _textSize = 100;
  double get textSize => _textSize;
  Color _textColor = Colors.white;
  Color get textColor => _textColor;
  Color _backgroundColor = Colors.black;
  Color get backgroundColor => _backgroundColor;
  Size _screenSize = window.physicalSize;
  Size get screenSize => _screenSize;
  Size _oldScreenSize = window.physicalSize;
  Size get oldScreenSize => _oldScreenSize;
  double _safezone = 10;
  double get safezone => _safezone;
  double _speed = -10;
  double get speed => _speed;
  double _leftWidth = 0;
  double get leftWidth => _leftWidth;
  double _rightWidth = 0;
  double get rightWidth => _rightWidth;
  bool _online = false;
  bool get online => _online;
  int _startTimestamp = DateTime.now().millisecondsSinceEpoch;
  int get startTimestamp => _startTimestamp;
  WebSocketSink _ws;
  WebSocketSink get ws => _ws;

  void sendToServer(String a) {
    if (online) {
      _ws.add(a);
    }
  }

  void setwsconn(WebSocketSink a) {
    _ws = a;
    print('_ws changed');
  }

  Color hexToColor(String s) {
    // 如果传入的十六进制颜色值不符合要求，返回默认值
    if (s == null ||
        s.length != 7 ||
        int.tryParse(s.substring(1, 7), radix: 16) == null) {
      s = '#999999';
    }
    return new Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
  }

  String colorTohex(Color c) {
    return '#${c.value.toRadixString(16).substring(2)}';
  }

  void init(Map data) {
    _speed = data["speed"].toDouble();
    _text = data["text"];
    _textColor = hexToColor(data["textcolor"]);
    _backgroundColor = hexToColor(data["bgcolor"]);
    _startTimestamp = data["start_timestamp"];
    setBrightness(data["brightness"]);
  }

  void setBrightness(int a) {
    FlutterScreen.setBrightness(a / 100);
  }

  void setIndex(int a) {
    _deviceindex = a;
    print('deviceindex changed to $a');
  }

  void setRoomID(int a) {
    _roomid = a;
    print('roomid changed to $a');
  }

  void setToken(String a) {
    _token = a;
    print('token changed to $a');
  }

  void changeText(String a) {
    _text = a;
    sendToServer('{"action":"settext","data":"$a"}');
    // sendToServer(
    //     '{"action":"reportscreensize","screenheight":${screenSize.height.toStringAsFixed(3)},"screenwidth":${screenSize.width.toStringAsFixed(3)},"safezone":$safezone}');
    print('text changed to $a');
  }

  void onlyChangeText(String a) {
    _text = a;
  }

  void setSafezone(double a) {
    _safezone = a;
    //只接受改动，不发到服务器
  }

  void setTextSize(double a) {
    _textSize = a;
    sendToServer('{"action":"settextsize","data":${a.floor()}}');
  }

  void onlySetTextSize(double a) {
    _textSize = a;
  }

  void setScreenSize(Size a) {
    _screenSize = a;
    if (a != _oldScreenSize) {
      _oldScreenSize = a;
      reportscreensize();
    }
  }

  void reportscreensize() {
    sendToServer(
        '{"action":"reportscreensize","screenheight":${oldScreenSize.height.toStringAsFixed(3)},"screenwidth":${oldScreenSize.width.toStringAsFixed(3)},"safezone":${safezone.floor()}}');
  }

  void setSpeed(double a) {
    _speed = a;
    sendToServer('{"action":"setspeed","data":${a.floor()}}');
  }

  void onlySetSpeed(double a) {
    _speed = a;
    print("only set speed");
  }

  void setTextColor(Color a) {
    _textColor = a;
  }

  void onlySetTextColor(String a) {
    _textColor = hexToColor(a);
  }

  void setBGColor(Color a) {
    _backgroundColor = a;
  }

  void onlySetBGColor(String a) {
    _backgroundColor = hexToColor(a);
  }

  void sendTextColor() {
    sendToServer(
        '{"action":"settextcolor","data":"${colorTohex(_textColor)}"}');
  }

  void sendBGColor() {
    sendToServer(
        '{"action":"setbgcolor","data":"${colorTohex(_backgroundColor)}"}');
  }

  void resetColor() {
    _backgroundColor = Colors.black;
    _textColor = Colors.white;
    sendToServer('{"action":"settextcolor","data":"#ffffff"}');
    sendToServer('{"action":"setbgcolor","data":"#000000"}');
  }

  void setDeviceList(List a) {
    _leftWidth = 0;
    _rightWidth = 0;
    for (int i = 0; i < a.length; i++) {
      Map device = a[i];

      if (i + 1 < deviceindex) {
        _leftWidth += device["screenwidth"];
      } else if (i + 1 > deviceindex) {
        _rightWidth += device["screenwidth"];
      } else {
        print('the device ${i + 1} width is ${device["screenwidth"]}');
      }
      print(a[i]);
    }
    print('leftwidth: $_leftWidth');
    print('rightwidth: $_rightWidth');
  }

  void setConnectionState(bool a) {
    _online = a;
  }

  /// Makes `DelayCounter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('textToLaunch', textToLaunch));
    properties.add(IntProperty('roomid', roomid));
    properties.add(IntProperty('deviceindex', deviceindex));
    properties.add(IntProperty('startTimestamp', startTimestamp));
    properties.add(StringProperty('token', token));
    properties.add(DoubleProperty('textSize', textSize));
    properties.add(DoubleProperty('safezone', safezone));
    properties.add(DoubleProperty('speed', speed));
    properties.add(DoubleProperty('leftWidth', leftWidth));
    properties.add(DoubleProperty('rightWidth', rightWidth));
  }
}
