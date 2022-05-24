import 'dart:math';
import 'package:flutter/material.dart';
import 'package:milkyway/components/MyColorPicker.dart';
import 'package:milkyway/providers/ParameterModifier.dart';
import 'package:provider/provider.dart';

class ColorPickerButtons extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ColorPickerButtonsState();
}

class _ColorPickerButtonsState extends State<ColorPickerButtons> {
  bool lightTheme = true;
  Color currentFontColor = Colors.white;
  Color currentBGColor = Colors.black;

  bool useWhiteForeground(Color color, {double bias: 1.0}) {
    // Old:
    // return 1.05 / (color.computeLuminance() + 0.05) > 4.5;

    // New:
    bias ??= 1.0;
    int v = sqrt(pow(color.red, 2) * 0.299 +
            pow(color.green, 2) * 0.587 +
            pow(color.blue, 2) * 0.114)
        .round();
    return v < 130 * bias ? true : false;
  }

  void changeFontColor(Color color) {
    setState(() => currentFontColor = color);
    context.read<ParameterModifier>().setTextColor(color);
  }

  void changeBGColor(Color color) {
    setState(() => currentBGColor = color);
    context.read<ParameterModifier>().setBGColor(color);
  }

  @override
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
                heroTag: 'Font',
                child: Icon(
                  Icons.font_download,
                  color: useWhiteForeground(currentFontColor)
                      ? const Color(0xffffffff)
                      : const Color(0xff000000),
                  size: 40,
                ),
                tooltip: "Font Color",
                foregroundColor: Colors.white,
                backgroundColor: currentFontColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.all(0),
                        shape: CircleBorder(),
                        content: MyColorPicker(
                          pickerType: 'textColor',
                          pickerColor: currentFontColor,
                          onColorChanged: changeFontColor,
                        ),
                      );
                    },
                  );
                  //click callback
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '文字颜色',
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
                heroTag: 'Reset',
                child: Icon(
                  Icons.sync,
                  color: Colors.black,
                  size: 40,
                ),
                tooltip: "Reset Color",
                foregroundColor: Colors.white,
                backgroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    currentFontColor = Colors.white;
                    currentBGColor = Colors.black;
                  });
                  //click callback
                  context.read<ParameterModifier>().resetColor();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '重置样式',
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
                heroTag: 'Background',
                child: Icon(
                  Icons.format_paint,
                  color: useWhiteForeground(currentBGColor)
                      ? const Color(0xffffffff)
                      : const Color(0xff000000),
                  size: 40,
                ),
                tooltip: "Background Color",
                foregroundColor: Colors.white,
                backgroundColor: currentBGColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.all(0),
                        shape: CircleBorder(),
                        content: MyColorPicker(
                          pickerType: 'BGColor',
                          pickerColor: currentBGColor,
                          onColorChanged: changeBGColor,
                        ),
                      );
                    },
                  );
                  //click callback
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '背景颜色',
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
