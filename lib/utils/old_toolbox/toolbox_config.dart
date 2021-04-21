

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';

class ToolboxConfig {
  ToolboxConfig({
    this.noItemsFoundBuilder,
    this.noItemsFoundWidget,
  });

  final NoItemsFoundBuilder? noItemsFoundBuilder;
  final Widget? noItemsFoundWidget;

  static ToolboxConfig of(BuildContext context) =>
      Provider.of<ToolboxConfig>(context);
}
