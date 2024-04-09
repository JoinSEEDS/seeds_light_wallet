import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/transaction_results.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/swap_seeds/interactor/viewmodels/swap_seeds_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SwapSeedsScreen extends StatefulWidget {
  const SwapSeedsScreen({super.key});

  @override
  _SwapSeedsScreenState createState() => _SwapSeedsScreenState();
}

class _SwapSeedsScreenState extends State<SwapSeedsScreen> {
  final _webViewController = WebViewController()
       
    ..setBackgroundColor(AppColors.primary)
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (progress) => print('WebView is loading (progress : %$progress)'),
        onPageStarted: (url) => print('Page started loading: $url'),
        //onPageFinished: (_) => BlocProvider.of<SwapSeedsBloc>(context).add(const OnPageLoaded()),
        onWebResourceError: (error) => print(error),
        /*
        javaScriptChannels: {
          JavascriptChannel(
            name: 'onSignTransactions',
            onMessageReceived: (javascriptMessage) {
              BlocProvider.of<SwapSeedsBloc>(context).add(OnMessageReceived(javascriptMessage));
            },
          ),
          JavascriptChannel(
            name: 'onLogin',
            onMessageReceived: (_) {
              runJavascript("setAccountNameFromLw('${settingsStorage.accountName}')");
            },
          )
        },
        */
      )
    )
    ..loadRequest(Uri.parse(p2pAppUrl));



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SwapSeedsBloc(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<SwapSeedsBloc, SwapSeedsState>(
            listenWhen: (_, current) => current.pageCommand != null,
            listener: (context, state) async {
              final pageCommand = state.pageCommand;
              if (pageCommand is NavigateToSendConfirmation) {
                final TransactionResult? result =
                    await NavigationService.of(context).navigateTo(pageCommand.route, pageCommand.arguments) as TransactionResult?;
                if (result != null) {
                  await _webViewController.runJavaScript(
                      "setResponseCallbackLW({status: '${result.status.name}', message:'${result.message}'})");
                }
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  WebViewWidget(controller: _webViewController),
                  const Align(alignment: Alignment.topLeft, child: BackButton()),
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
