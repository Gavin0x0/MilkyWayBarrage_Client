import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRcodeScanner extends StatefulWidget {
  const QRcodeScanner({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRcodeScannerState();
}

class _QRcodeScannerState extends State<QRcodeScanner> {
  var qrText = '';
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
    ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final responseJson = json.decode(scanData.code);
      Map<String, dynamic> content = responseJson;
      int roomid = 0;
      String token = '';
      try {
        roomid = content['roomid'];
        token = content['token'];
      } catch (e) {
        content = null;
      }
      if (content != null) {
        controller?.pauseCamera();
        Navigator.pop(context, content);
      }
      setState(() {
        qrText = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
