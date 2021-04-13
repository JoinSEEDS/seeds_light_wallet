// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import 'common.dart';

class PaginatedListView<T> extends StatefulWidget {
  final ItemBuilder<T> itemBuilder;
  final PageFuture<T> pageFuture;
  final int pageSize;
  final EdgeInsetsGeometry padding;
  final NoItemsFoundBuilder noItemsFoundBuilder;
  final Widget noItemsFoundWidget;
  final PagewiseLoadController<T> pageLoadController;

  /// default is false
  ///
  /// set to true if the future will change.
  final bool mutable;

  /// default is false
  ///
  /// set to true if the future will change.
  final bool showRefreshIndicator;

  final Axis scrollDirection;
  final bool shrinkWrap;

  const PaginatedListView({
    Key key,
    @required this.itemBuilder,
    @required this.pageFuture,
    this.pageSize = 10,
    this.padding,
    this.noItemsFoundBuilder,
    this.noItemsFoundWidget,
    this.pageLoadController,
    this.mutable = false,
    this.showRefreshIndicator = false,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  _PaginatedListViewState<T> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  bool _reload = false;

  @override
  Widget build(BuildContext context) {
    return widget.showRefreshIndicator
        ? RefreshIndicator(
            onRefresh: () async {
              await widget.pageFuture(1);
              setState(() => _reload = true);
            },
            child: buildListView(),
          )
        : buildListView();
  }

  Widget buildListView() {
    final mutable = widget.mutable ||
//        widget.showRefreshIndicator || removed as there it serve no purpose leave here just in case there is a side effect
        _reload ||
        widget.pageLoadController != null;

    _reload = false;

    final PageFuture<T> pageFuture =
        (int pageIndex) => widget.pageFuture(pageIndex + 1);

    final pageLoadController = widget.pageLoadController ??
        PagewiseLoadController(
          pageSize: widget.pageSize,
          pageFuture: pageFuture,
        );

    return PagewiseListView<T>(
      itemBuilder: widget.itemBuilder,
      padding: widget.padding,
      noItemsFoundBuilder: noItemsFoundBuilder(
        context,
        noItemsFoundBuilder: widget.noItemsFoundBuilder,
        noItemsFoundWidget: widget.noItemsFoundWidget,
      ),
      pageLoadController: mutable ? pageLoadController : null,
      pageSize: mutable ? null : widget.pageSize,
      pageFuture: mutable ? null : pageFuture,
      scrollDirection: widget.scrollDirection,
      shrinkWrap: widget.shrinkWrap,
    );
  }
}
