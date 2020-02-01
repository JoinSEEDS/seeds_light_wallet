import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/connection_notifier.dart';

class ConnectionStatus extends StatelessWidget {
  final Widget child;

  ConnectionStatus({this.child});

  Widget build(BuildContext context) {
    return Consumer<ConnectionNotifier>(
      child: Flexible(
        child: child,
      ),
      builder: (ctx, connection, child) => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            color: connection.status == true
                ? AppColors.green
                : AppColors.black50,
            child: Center(
              child: Text(
                  "${connection.status ? "ONLINE (connected to ${connection.currentEndpoint})" : 'OFFLINE (trying to reconnect)'}",
                  style: TextStyle(color: AppColors.lightGrey)),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
