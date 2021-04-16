import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seeds/i18n/widgets.i18n.dart';

class PageNotFound extends StatelessWidget {
  final String routeName;
  final Object? args;

  const PageNotFound({Key? key, required this.routeName, this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Page Not Found'.i18n),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.info_outline,
                size: 80.0,
                color: Colors.black38,
              ),
              const SizedBox(height: 24.0),
              Text(
                'The page you are looking for is not available'.i18n,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 48.0),
              Table(
                border: TableBorder.all(
                  color: Colors.grey,
                ),
                children: <TableRow>[
                  _routeName,
                  _arguments,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow get _routeName {
    return _buildRow('Rote Name', "'$routeName'");
  }

  TableRow get _arguments {
    return _buildRow('Arguments', args?.toString() ?? 'N/A');
  }

  TableRow _buildRow(String column1, String column2) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            column1,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(column2),
        ),
      ],
    );
  }
}
