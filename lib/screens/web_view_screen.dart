import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// class WebViewScreen extends StatefulWidget {
//   const WebViewScreen({super.key});
//
//   @override
//   WebViewScreenState createState() => WebViewScreenState();
// }
//
// class WebViewScreenState extends State<WebViewScreen> {
//   late WebViewController webViewController;
//   String text = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Flutter Task'),
//       ),
//       body: WebView(
//         initialUrl: 'https://uploads.gpseducation.com/test_125.html',
//         //allows JavaScript to run without any restrictions
//         // Use this mode if you need full JavaScript functionality within your WebView
//         javascriptMode: JavascriptMode.unrestricted,
//         //it is a callback that gets invoked when the WebView is created.
//         // This callback provides you with an instance of the WebViewController
//         // that allows you to control and interact with the WebView
//         onWebViewCreated: (WebViewController controller,) {
//           webViewController = controller;
//         },
//         //javascriptChannels: Enables communication between JavaScript in the WebView and the Flutter app.
//         // JavascriptChannel: Defines a named channel for sending messages from JavaScript to Flutter.
//         // onMessageReceived: Handles messages sent from JavaScript, allowing you to update the Flutter UI or perform other actions in response.
//         javascriptChannels: <JavascriptChannel>{
//           JavascriptChannel(
//             name: 'saveData',
//             onMessageReceived: (JavascriptMessage message) {
//               String received = message.message;
//               ScaffoldMessenger.of(context)
//                   .showSnackBar(
//                   SnackBar(content: Text(getTextAndReturn().toString())));
//             },
//           )
//         },
//
//       ),
//     );
//   }
//
//   Future<String> getTextAndReturn() async {
//     final value = await webViewController.runJavascriptReturningResult('saveData()');
//
//     print('value is $value');
//     return webViewController.runJavascriptReturningResult('window.saveData("$value")');
//   }
// }

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  // Completer is used to manage the WebViewController asynchronously
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Task'),
      ),
      body: WebView(
        // initialUrl: 'assets/html.html',
        // Allow unrestricted JavaScript execution in the WebViewPath to your HTML file
        javascriptMode: JavascriptMode.unrestricted,
        // Callback when the WebView is created
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          _loadHtmlFromAssets(); // Load the HTML file from assets
        },
        // Set up JavaScript channels to communicate between Flutter and JavaScript
        javascriptChannels: {
          JavascriptChannel(
              name: 'flutter_inject', // Matching the channel name in HTML file
              onMessageReceived: (JavascriptMessage message) {
                // Handle message received from JavaScript
                String value = message.message;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value),
                    backgroundColor: Colors.red,
                  ),
                );
              }),
        },
      ),
    );
  }

// Function to load HTML file from assets and inject it into the WebView
  _loadHtmlFromAssets() async {
    // Load HTML file content from assets
    String fileText =
        await DefaultAssetBundle.of(context).loadString('assets/index.html');
    // Use the WebViewController to load the HTML content
    _controller.future.then((webViewController) {
      webViewController.loadUrl(Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString());
    });
  }
}
