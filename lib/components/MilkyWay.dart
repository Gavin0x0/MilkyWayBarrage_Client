import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:milkyway/providers/OffsetHandler.dart';
import 'package:milkyway/providers/ParameterModifier.dart';
import 'package:provider/provider.dart';

class MilkyWay extends BaseGame {
  BuildContext context;
  TextConfig text;

  void resize(Size size) {
    context.read<ParameterModifier>().setScreenSize(size);
    print("resize");
    super.resize(size);
  }

  MilkyWay(BuildContext cxt) {
    context = cxt;
    initialize();
  }

  void initialize() async {
    Flame.util.initialDimensions().then((value) => {resize(value)});
  }

  // ignore: must_call_super
  void render(Canvas canvas) {
    var textPara = context.read<ParameterModifier>();
    //定义一个和屏幕同等大小的矩形
    Rect bgRect = Rect.fromLTWH(
        0, 0, textPara.screenSize.width, textPara.screenSize.height);
    //定义背景的Paint对象，并分配颜色（带透明度）
    Paint bgPaint = Paint();
    //从0x00到0xff表示从透明到不透明
    bgPaint.color = textPara.backgroundColor;
    //使用React和Paint绘制
    canvas.drawRect(bgRect, bgPaint);

    text = TextConfig(
      color: textPara.textColor,
      fontSize: textPara.textSize,
      fontFamily: 'Alibaba-Bold',
    );
    var safezone = text.toTextPainter(textPara.textToLaunch).width;
    textPara.setSafezone(safezone);
    var x = ((context.read<OffsetHandler>().getServerTimestampNow() -
                    textPara.startTimestamp) *
                textPara.speed *
                0.01) %
            (textPara.screenSize.width +
                safezone +
                textPara.leftWidth +
                textPara.rightWidth) -
        safezone -
        textPara.leftWidth;
    text.render(canvas, textPara.textToLaunch,
        Position(x, textPara.screenSize.height / 2),
        anchor: Anchor.centerLeft);
  }

  // ignore: must_call_super
  void update(double t) {}
}
