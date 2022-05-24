import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markdown/markdown.dart' as md;

class AboutUs extends StatelessWidget {
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Color(0xFF282832),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF282832),
          title: const Text('关于我们'),
        ),
        body: Markdown(
          controller: controller,
          selectable: true,
          data: _markdownData,
          builders: {
            'h6': CenteredHeaderBuilder(),
            'sub': SubscriptBuilder(),
          },
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF282832),
            child: Icon(Icons.favorite),
            onPressed: () => Fluttertoast.showToast(msg: "❤", fontSize: 100)),
      ),
    );
  }
}

const String _markdownData = """
# MilkyWay-跨屏弹幕 v1.0.0
发射弹幕，一台设备怎么够？
- 按下绿色按钮启动连接
- 用其他扫码设备加入房间
- 按序号将设备排成一排
- 即刻体验我们的跨屏弹幕！
# 
# 
# 
# 
# 
# 
## 问题反馈
### QQ群：703667653




""";

class CenteredHeaderBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(md.Text text, TextStyle preferredStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(text.text, style: preferredStyle),
      ],
    );
  }
}

class SubscriptBuilder extends MarkdownElementBuilder {
  static const List<String> _subscripts = [
    '₀',
    '₁',
    '₂',
    '₃',
    '₄',
    '₅',
    '₆',
    '₇',
    '₈',
    '₉'
  ];

  @override
  Widget visitElementAfter(md.Element element, TextStyle preferredStyle) {
    // We don't currently have a way to control the vertical alignment of text spans.
    // See https://github.com/flutter/flutter/issues/10906#issuecomment-385723664
    String textContent = element.textContent;
    String text = '';
    for (int i = 0; i < textContent.length; i++) {
      text += _subscripts[int.parse(textContent[i])];
    }
    return SelectableText.rich(TextSpan(text: text));
  }
}

class SubscriptSyntax extends md.InlineSyntax {
  static final _pattern = r'_([0-9]+)';

  SubscriptSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Element.text('sub', match[1]));
    return true;
  }
}
