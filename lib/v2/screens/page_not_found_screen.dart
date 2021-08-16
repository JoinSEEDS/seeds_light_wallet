import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seeds/v2/i18n/page_no_found.i18n.dart';

class PageNotFoundScreen extends StatelessWidget {
  final String routeName;
  final Object? args;

  const PageNotFoundScreen({Key? key, required this.routeName, this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Not Found'.i18n)),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 80.0, color: Colors.black38),
              const SizedBox(height: 24.0),
              Text(
                'The page you are looking for is not available'.i18n,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 48.0),
              Text('Rote Name: $routeName'),
              const SizedBox(height: 8.0),
              Text('Arguments: $args'),
            ],
          ),
        ),
      ),
    );
  }
}
