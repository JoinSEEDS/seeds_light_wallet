import 'package:flutter/material.dart';

class NotionLoader extends StatefulWidget {
  final String notion;

  NotionLoader({this.notion});

  @override
  _NotionLoaderState createState() => _NotionLoaderState();
}

class _NotionLoaderState extends State<NotionLoader>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animationController.addListener(() {
      if (animationController.status == AnimationStatus.completed) {
        animationController.reset();
      } else if (animationController.status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });

    animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RotationTransition(
          child: Image.asset('assets/images/loading.png'),
          turns: Tween(begin: 0.0, end: 1.0).animate(
            animationController,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 17),
          child: Text(
            widget.notion,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              fontFamily: "worksans",
            ),
          ),
        ),
      ],
    );
  }
}
