import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  GradientButton({
    this.colors,
    this.width,
    this.height,
    this.onPressed,
    this.borderRadius,
    @required this.child,
  });

  // 渐变色数组,最后一位为主题颜色
  final List<Color> colors;

  // 按钮宽高
  final double width;
  final double height;

  final Widget child;
  final BorderRadius borderRadius;

  //点击回调
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    //确保colors数组不空
    List<Color> _colors = colors ??
        [theme.primaryColor, theme.primaryColorDark ?? theme.primaryColor];

    return Stack(alignment: Alignment.center, children: <Widget>[
      DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [_colors[0], _colors[1], _colors[2]]),
            borderRadius: borderRadius,
            //阴影的设置
            boxShadow: [
              BoxShadow(
                  color: Colors.white30,
                  offset: Offset(0, 0),
                  blurRadius: 10.0,
                  spreadRadius: 1.0),
            ]),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: borderRadius,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(height: height, width: width),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(
          color: _colors.last,
          borderRadius: borderRadius,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            focusColor: Colors.black,
            splashColor: Colors.white12,
            highlightColor: Colors.transparent,
            borderRadius: borderRadius,
            onTap: onPressed,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(height: height - 6, width: width - 6),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
