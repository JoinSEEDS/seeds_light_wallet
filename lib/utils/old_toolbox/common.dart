import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:seeds/utils/old_toolbox/toolbox_config.dart';

NoItemsFoundBuilder noItemsFoundBuilder(
  BuildContext context, {
  @required NoItemsFoundBuilder noItemsFoundBuilder,
  @required Widget noItemsFoundWidget,
}) {
  final defaultNoItemsFoundBuilder = noItemsFoundWidget == null
      ? null
      : (BuildContext context) {
          final height = MediaQuery.of(context).size.height - kToolbarHeight;
          return SizedBox(
            height: height,
            child: Center(
              child: noItemsFoundWidget,
            ),
          );
        };

  final localNoItemFound = noItemsFoundBuilder ?? defaultNoItemsFoundBuilder;

  final config = ToolboxConfig.of(context);
  final globalNoItemFound = config.noItemsFoundBuilder ??
      _buildNoItemFoundBuilder(config.noItemsFoundWidget);

  return localNoItemFound ?? globalNoItemFound;
}

NoItemsFoundBuilder _buildNoItemFoundBuilder(Widget noItemsFoundWidget) {
  return (BuildContext context) {
    // remove the height of the appBar and some to make sure
    // the noItemsFoundWidget don't scroll
    final height = MediaQuery.of(context).size.height - kToolbarHeight * 3;
    return SizedBox(
      height: height,
      child: Center(
        child: noItemsFoundWidget,
      ),
    );
  };
}
