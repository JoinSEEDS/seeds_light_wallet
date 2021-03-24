import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';
import 'package:seeds/v2/components/scanner/scanner_screen.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/send_scanner/interactor/send_scanner_bloc.dart';
import 'package:seeds/v2/screens/send_scanner/interactor/viewmodels/scanner_events.dart';
import 'package:seeds/v2/screens/send_scanner/interactor/viewmodels/send_scanner_state.dart';

/// SendScannerScreen SCREEN
class SendScannerScreen extends StatefulWidget {
  @override
  _SendScannerScreenState createState() => _SendScannerScreenState();
}

class _SendScannerScreenState extends State<SendScannerScreen> {
  ScannerScreen _scannerScreen;
  final _sendPageBloc = SendPageBloc();

  @override
  void initState() {
    super.initState();
    _scannerScreen = ScannerScreen(resultCallBack: onResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: BlocProvider(
        create: (context) => _sendPageBloc,
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text("Scan QR Code to Send", style: Theme.of(context).textTheme.button),
            const SizedBox(height: 82),
            _scannerScreen,
            BlocBuilder<SendPageBloc, SendPageState>(
              builder: (context, SendPageState state) {
                switch (state.pageState) {
                  case PageState.initial:
                    _scannerScreen.scan();
                    return const SizedBox.shrink();
                  case PageState.loading:
                    _scannerScreen.showLoading();
                    return const SizedBox.shrink();
                  case PageState.failure:
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              state.error,
                              style: Theme.of(context).textTheme.subtitle2.copyWith(color: AppColors.orangeYellow),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          decoration: const BoxDecoration(
                              color: AppColors.black, borderRadius: BorderRadius.all(Radius.circular(8)))),
                    );
                  case PageState.success:
                    _scannerScreen.stop();
                    NavigationService.of(context).navigateTo(
                        Routes.customTransaction,
                        CustomTransactionArguments(
                          account: state.pageCommand.resultData.accountName,
                          name: state.pageCommand.resultData.name,
                          data: state.pageCommand.resultData.data,
                        ),
                        true);
                    return const SizedBox.shrink();
                  default:
                    return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> onResult(String scanResult) async {
    _sendPageBloc.add(ExecuteScanResult(scanResult: scanResult));
  }
}
