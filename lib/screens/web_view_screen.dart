import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  late WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter Task'),
      ),
      body: WebView(
        initialUrl: 'https://uploads.gpseducation.com/test_125.html',
        //allows JavaScript to run without any restrictions
        // Use this mode if you need full JavaScript functionality within your WebView
        javascriptMode: JavascriptMode.unrestricted,
        //it is a callback that gets invoked when the WebView is created.
        // This callback provides you with an instance of the WebViewController
        // that allows you to control and interact with the WebView
        onWebViewCreated: (WebViewController webViewController) {
          webViewController = webViewController;
        },
        //javascriptChannels: Enables communication between JavaScript in the WebView and the Flutter app.
        // JavascriptChannel: Defines a named channel for sending messages from JavaScript to Flutter.
        // onMessageReceived: Handles messages sent from JavaScript, allowing you to update the Flutter UI or perform other actions in response.
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
            name: 'saveData',
            onMessageReceived: (JavascriptMessage message) {
              String received = message.message;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(received)));
            },
          ),
        },
      ),
    );
  }
}
