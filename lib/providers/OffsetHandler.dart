import 'package:flutter/foundation.dart';

class OffsetHandler with ChangeNotifier, DiagnosticableTreeMixin {
  int _offest = 0;
  int get offset => _offest;

  void increment(int a) {
    _offest += a;
    notifyListeners();
  }

  void sync(int t) {
    _offest = t - DateTime.now().millisecondsSinceEpoch;
  }

  int getServerTimestampNow() {
    return DateTime.now().millisecondsSinceEpoch + offset;
  }

  /// Makes `DelayCounter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('delay', offset));
  }
}
