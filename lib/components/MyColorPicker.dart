import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:milkyway/providers/ParameterModifier.dart';
import 'package:provider/provider.dart';

typedef PickerBuilder = Widget Function(
    BuildContext context, Color color, Function changeColor);

class MyColorPicker extends StatefulWidget {
  ///
  ///pickerType: 颜色选择器类型（文字颜色：textColor，背景颜色：BGColor）
  ///
  const MyColorPicker({
    @required this.pickerColor,
    @required this.onColorChanged,
    @required this.pickerType,
    this.pickerBuilder = defaultPickerBuilder,
  });
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final PickerBuilder pickerBuilder;
  final String pickerType;

  static Widget defaultPickerBuilder(
      BuildContext cxt, Color color, Function changeColor) {
    return Container(
      margin: EdgeInsets.all(0),
      child: CircleColorPicker(
        initialColor: color,
        onChanged: changeColor,
        //strokeWidth: 2,
        //thumbSize: 30,
      ),
    );
  }

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<MyColorPicker> {
  Color _currentColor = Colors.blue;
  void initState() {
    _currentColor = widget.pickerColor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.pickerBuilder(context, _currentColor, _onColorChanged);
  }

  void _onColorChanged(Color color) {
    setState(() => _currentColor = color);
    //调整颜色时调用这里
    widget.onColorChanged(color);
  }

  void deactivate() {
    switch (widget.pickerType) {
      case 'BGColor':
        context.read<ParameterModifier>().sendBGColor();
        break;
      case 'textColor':
        context.read<ParameterModifier>().sendTextColor();
        break;
      default:
    }
    super.deactivate();
  }
}
