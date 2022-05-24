import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milkyway/providers/ParameterModifier.dart';
import 'package:provider/provider.dart';

class ItemSlider extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<ItemSlider> {
  double _fontSize = 100;
  double _speed = -10;

  final _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text;
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  @override
  void dispose() {
    super.dispose();
    //释放键盘监听
    _focusNode.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 20, 50, 20),
          child: TextFormField(
            controller: _controller,
            textAlign: TextAlign.center,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: '在这里输入要发射的文字🚀',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onChanged: (value) =>
                context.read<ParameterModifier>().changeText(value),
            onEditingComplete: () => _focusNode.unfocus(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 0, 30, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '大小',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54),
                ),
              ),
              Expanded(
                flex: 4,
                child: Slider(
                  value: _fontSize,
                  onChanged: (data) {
                    print('change:$data');
                    context.read<ParameterModifier>().onlySetTextSize(data);
                    //字体大小调整时调用
                    setState(() {
                      this._fontSize = data;
                    });
                  },
                  onChangeStart: (data) {
                    print('start:$data');
                  },
                  onChangeEnd: (data) {
                    context.read<ParameterModifier>().setTextSize(data);
                  },
                  min: 0,
                  max: 200,
                  divisions: 200,
                  label: '${_fontSize.floor()}',
                  activeColor: Color(0xFF282832),
                  inactiveColor: Colors.grey,
                  semanticFormatterCallback: (double newValue) {
                    return '${newValue.round()} dollars}';
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 0, 30, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '速度',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54),
                ),
              ),
              Expanded(
                flex: 4,
                child: Slider(
                  value: _speed,
                  onChanged: (data) {
                    //速度调整时调用
                    //print('change:$data');
                    setState(() {
                      this._speed = data;
                    });
                    context.read<ParameterModifier>().onlySetSpeed(data);
                  },
                  onChangeStart: (data) {
                    //print('start:$data');
                  },
                  onChangeEnd: (data) {
                    context.read<ParameterModifier>().setSpeed(data);
                  },
                  min: -50,
                  max: 50,
                  divisions: 100,
                  label: '${_speed.floor()}',
                  activeColor: Color(0xFF282832),
                  inactiveColor: Colors.grey,
                  semanticFormatterCallback: (double newValue) {
                    return '${newValue.round()} dollars}';
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
