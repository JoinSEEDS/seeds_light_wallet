import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teloswallet/constants/app_colors.dart';
import 'package:teloswallet/providers/notifiers/connection_notifier.dart';

class ConnectionStatus extends StatefulWidget {
  final Widget child;

  ConnectionStatus({this.child});

  @override
  _ConnectionStatusState createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ConnectionNotifier>(context, listen: false).addListener(() {
        if (_visible == false) {
          setState(() {
            _visible = true;
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Consumer<ConnectionNotifier>(
      child: Flexible(
        child: widget.child,
      ),
      builder: (ctx, connection, child) => Column(
        children: [
          AnimatedOpacity(
            duration: Duration(seconds: 2),
            opacity: _visible ? 1.0 : 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              color: connection.status ? AppColors.blue : AppColors.red,
              child: Center(
                child: Text(
                    "[x] ${connection.status ? "ONLINE (connected to ${connection.currentEndpoint})" : 'OFFLINE (trying to reconnect)'}",
                    style: TextStyle(color: AppColors.lightGrey)),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
