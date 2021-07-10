import 'package:flutter/material.dart';

class FullPageLoadingIndicator extends StatelessWidget {
  const FullPageLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: const Center(child: CircularProgressIndicator()));
  }
}
