import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  String newsTitle;
  String newsUrl;
  WebViewWidget(this.newsTitle, this.newsUrl);
  @override
  WebViewWidgetState createState() => WebViewWidgetState();
}

class WebViewWidgetState extends State<WebViewWidget> {
  bool loader = true;
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid){
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.newsTitle),
        backgroundColor: Colors.cyan,
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: widget.newsUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                loader = false;
              });
            },
          ),
          loader ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
              strokeWidth: 3.0,
            ),
          ) : Stack()
        ],
      ),
    );
  }
}