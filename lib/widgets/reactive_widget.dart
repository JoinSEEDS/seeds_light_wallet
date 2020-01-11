import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  _ReactiveWidgetState createState() => _ReactiveWidgetState();
}

class _ReactiveWidgetState<T extends ChangeNotifier> extends State<ReactiveWidget> {
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