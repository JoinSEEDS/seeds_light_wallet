import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/p2p/viewmodels/p2p_bloc.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:webview_flutter/webview_flutter.dart';

class P2PScreen extends StatefulWidget {
  const P2PScreen({Key? key}) : super(key: key);

  @override
  _P2PScreenState createState() => _P2PScreenState();
}

class _P2PScreenState extends State<P2PScreen> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => P2PBloc(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<P2PBloc, P2PState>(
            listenWhen: (_, current) => current.pageCommand != null,
            listener: (context, state) async {
              final pageCommand = state.pageCommand;
              if (pageCommand is NavigateToRouteWithArguments) {
                final wasSuccess = await NavigationService.of(context)
                    .navigateTo(pageCommand.route, SendConfirmationArguments(transaction: pageCommand.arguments));
                if (wasSuccess != null) {
                  final msg = 'Success';
                  await _webViewController.runJavascript("lightWalletResponseCallback('$msg')");
                }
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  WebView(
                    initialUrl: p2pAppUrl,
                    backgroundColor: AppColors.primary,
                    debuggingEnabled: true,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (webViewController) => _webViewController = webViewController,
                    onPageStarted: (url) => print('Page started loading: $url'),
                    onProgress: (progress) => print('WebView is loading (progress : %$progress)'),
                    onPageFinished: (url) async {
                      BlocProvider.of<P2PBloc>(context).add(const OnPageLoaded());
                      await _webViewController.runJavascript("setAccounNameFromLw('${settingsStorage.accountName}')");
                    },
                    onWebResourceError: (error) => print(error),
                    javascriptChannels: {
                      JavascriptChannel(
                        name: 'lw',
                        onMessageReceived: (javascriptMessage) {
                          BlocProvider.of<P2PBloc>(context).add(OnMessageReceived(javascriptMessage));
                        },
                      )
                    },
                  ),
                  if (state.pageState == PageState.loading) const FullPageLoadingIndicator()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
