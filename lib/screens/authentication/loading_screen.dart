import 'package:flutter/material.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: FullPageLoadingIndicator());
  }
}
