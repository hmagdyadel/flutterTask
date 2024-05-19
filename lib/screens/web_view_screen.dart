import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
   WebViewController? webViewController;
  String textFromWebPage = '';

  @override
  void initState() {
    super.initState();
    // Enabling virtual display for WebView on Android
    if (WebView.platform is AndroidWebView) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task'),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebView(
              initialUrl: 'https://uploads.gpseducation.com/test_125.html',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                webViewController = webViewController;
              },
              javascriptChannels: <JavascriptChannel>{
                JavascriptChannel(
                  name: 'saveData',
                  onMessageReceived: (JavascriptMessage message) {
                    setState(() {
                      textFromWebPage = message.message;
                    });
                  },
                ),
              },
              onPageFinished: (String url) {
                injectJavaScript();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Received Value: $textFromWebPage'),
          ),
        ],
      ),
    );
  }


  void injectJavaScript() {
    webViewController?.runJavascript('''
      window.saveData = function(value) {
        if (window.saveData.postMessage) {
          window.saveData.postMessage(value);
        } else {
          console.log("saveData.postMessage is not available");
        }
      }
    ''').then((result) {
      print("JavaScript injected successfully");
    }).catchError((error) {
      print("Error injecting JavaScript: $error");
    });
  }
}
