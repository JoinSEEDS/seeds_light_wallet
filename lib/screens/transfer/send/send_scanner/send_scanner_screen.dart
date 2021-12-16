import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/scanner/scanner_screen.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/transfer/transfer.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/transfer/send/send_scanner/interactor/viewmodels/send_scanner_bloc.dart';

/// SendScannerScreen SCREEN
class SendScannerScreen extends StatefulWidget {
  const SendScannerScreen({Key? key}) : super(key: key);

  @override
  _SendScannerScreenState createState() => _SendScannerScreenState();
}

class _SendScannerScreenState extends State<SendScannerScreen> {
  late ScannerScreen _scannerWidget;
  late SendScannerBloc _sendScannerBloc;

  @override
  void initState() {
    super.initState();
    _sendScannerBloc = SendScannerBloc();
    _scannerWidget = ScannerScreen(onCodeScanned: (scanResult) async {
      _sendScannerBloc.add(ExecuteScanResult(scanResult));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR Code".i18n)),
      body: BlocProvider(
        create: (_) => _sendScannerBloc,
        child: BlocListener<SendScannerBloc, SendScannerState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final pageCommand = state.pageCommand;
            BlocProvider.of<SendScannerBloc>(context).add(const ClearSendScannerPageCommand());
            if (pageCommand is NavigateToRouteWithArguments) {
              NavigationService.of(context).navigateTo(pageCommand.route, pageCommand.arguments);
            }
          },
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text("Scan QR Code to Send".i18n, style: Theme.of(context).textTheme.button),
              const SizedBox(height: 82),
              _scannerWidget,
              BlocBuilder<SendScannerBloc, SendScannerState>(
                builder: (context, state) {
                  switch (state.pageState) {
                    case PageState.initial:
                      _scannerWidget.scan();
                      return const SizedBox.shrink();
                    case PageState.loading:
                      _scannerWidget.showLoading();
                      return const SizedBox.shrink();
                    case PageState.failure:
                      return Padding(
                        padding: const EdgeInsets.all(32),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: AppColors.black, borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              state.errorMessage!,
                              style: Theme.of(context).textTheme.subtitle2!.copyWith(color: AppColors.orangeYellow),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
