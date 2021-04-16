

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerTile() {
  return ListTile(
    leading: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    ),
    title: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: <Widget>[
          Container(
            width: 100.0,
            height: 12.0,
            color: Colors.white,
          ),
        ],
      ),
    ),
    subtitle: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 40.0,
        height: 12.0,
        color: Colors.white,
      ),
    ),
  );
}