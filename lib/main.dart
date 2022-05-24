import 'package:flutter/material.dart';
import 'package:milkyway/providers/OffsetHandler.dart';
import 'package:milkyway/providers/ParameterModifier.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'Screens/MainScreen.dart';

void main() async {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => OffsetHandler()),
          ChangeNotifierProvider(create: (_) => ParameterModifier()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainScreen(),
        )),
  );
  // if (Platform.isAndroid) {
  //   // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
  //   SystemUiOverlayStyle systemUiOverlayStyle =
  //       SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // }
}
