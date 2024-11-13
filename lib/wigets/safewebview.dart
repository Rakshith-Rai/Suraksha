import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Safewebview extends StatelessWidget {
  final String?url;
  Safewebview({this.url});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
            initialUrl: url,
            
      ),
    );
  }
}