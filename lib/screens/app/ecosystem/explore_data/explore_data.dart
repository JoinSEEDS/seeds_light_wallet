import 'package:flutter/material.dart';
import 'package:seeds/constants/config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExploreData extends StatefulWidget {
  @override
  _ExploreDataState createState() => _ExploreDataState();
}

class _ExploreDataState extends State<ExploreData> {
  final String removeHeaderElementsScript = """
    var header = document.getElementById('banner-row'); header.parentNode.removeChild(header);
    var header = document.getElementById('header-grid'); header.parentNode.removeChild(header);
    var header = document.getElementById('top-container'); header.parentNode.removeChild(header);
  """;

  final String replaceSigningButtonScript = """
    var old_element = document.getElementById("push-transaction-btn");
    var new_element = old_element.cloneNode(true);
    old_element.parentNode.replaceChild(new_element, old_element);

    document.addEventListener( 'click', function ( e ) {
        if (e.target.id === 'push-transaction-btn' ) {
            alert('test');
        }
    }, false );
  """;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl:
          '${Config.explorer}/account/token.seeds?tab=Tables&account=token.seeds&scope=token.seeds&limit=100&loadContract=true',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController controller) {
        controller.evaluateJavascript(removeHeaderElementsScript);
      },
    );
  }
}
