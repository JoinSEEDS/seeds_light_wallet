

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:seeds/generated/r.dart';

class NotionLoader extends StatefulWidget {
  final String? notion;

  NotionLoader({this.notion});

  @override
  _NotionLoaderState createState() => _NotionLoaderState();
}

class _NotionLoaderState extends State<NotionLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            var scale = math.sin(math.pi * animationController.value) + 0.7;
            return Align(
              alignment: Alignment.center,
              child: Transform.scale(
                scale: scale,
                child: RotationTransition(
                  child: Image.asset(
                    R.appIconTransparent,
                    width: 100,
                    height: 100,
                  ),
                  turns: Tween(begin: 0.0, end: 2.0).animate(
                    animationController,
                  ),
                ),
              ),
            );
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 17),
          child: Text(
            widget.notion!,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontFamily: 'worksans',
            ),
          ),
        ),
      ],
    );
  }
}
