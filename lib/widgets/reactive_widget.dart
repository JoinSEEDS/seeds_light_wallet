import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// https://github.com/FilledStacks/flutter-tutorials/blob/master/014-provider-v3-updates/2-final/lib/ui/views/base_widget.dart
class ReactiveWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final T model;
  final Widget child;
  final Function(T) onModelReady;

  ReactiveWidget({
    Key key,
    this.builder,
    this.model,
    this.child,
    this.onModelReady
  }) : super(key: key);
  
  @override
  _ReactiveWidgetState<T> createState() => _ReactiveWidgetState<T>();
}

class _ReactiveWidgetState<T extends ChangeNotifier> extends State<ReactiveWidget<T>> {
  T model;

  @override
  void initState() {
    model = widget.model;

    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}