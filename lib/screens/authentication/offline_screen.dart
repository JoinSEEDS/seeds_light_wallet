import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seeds/datasource/remote/internet_connection_checker.dart';
import 'package:seeds/design/app_colors.dart';

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  bool _isLoading = false;
  bool _isConnected = false;
  late StreamSubscription _listener;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      launchSnackBar('You are currently offline');

      _listener = InternetConnectionChecker().onStatusChange.listen((status) async {
        if (status == InternetConnectionStatus.connected) {
          setState(() => _isConnected = true);
          launchSnackBar('Your internet connection was restored');
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  void launchSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: AppColors.grey,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Expanded(child: Text(message, textAlign: TextAlign.center)),
          InkWell(
            onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: _isLoading || _isConnected
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You're offline now",
                      style: Theme.of(context).textTheme.headline6!.copyWith(color: AppColors.white)),
                  const SizedBox(height: 20.0),
                  Text('Opps! internet is disconnected.',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(color: AppColors.white)),
                  const SizedBox(height: 40.0),
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                    color: AppColors.green1,
                    disabledTextColor: AppColors.grey1,
                    disabledColor: AppColors.darkGreen2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      final bool isConnected = await InternetConnectionChecker().hasConnection;
                      if (isConnected) {
                        setState(() => _isConnected = true);
                        launchSnackBar('Your internet connection was restored');
                      } else {
                        setState(() => _isLoading = false);
                        launchSnackBar('You are currently offline');
                      }
                    },
                    child: Text('Try Again',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: AppColors.white)),
                  ),
                ],
              ),
      ),
    );
  }
}
