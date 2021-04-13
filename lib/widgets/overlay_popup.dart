// @dart=2.9

import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/i18n/widgets.i18n.dart';

class OverlayPopup extends StatefulWidget {
  final String title;
  final Widget body;
  final Function backCallback;

  OverlayPopup({this.title, this.body, this.backCallback});

  @override
  _OverlayPopupState createState() => _OverlayPopupState();
}

class _OverlayPopupState extends State<OverlayPopup>
    with SingleTickerProviderStateMixin {

  Widget buildHeader() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 150),
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: width,
        height: height * topSize(),
        padding: EdgeInsets.only(
            left: width * 0.23,
            right: width * 0.23,
            top: MediaQuery.of(context).padding.top,
            bottom: 30),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.32],
                colors: AppColors.gradient)),
        child: Image(
          image: AssetImage('assets/images/seeds_light_wallet_logo.png'),
        ),
      ),
    );
  }

  double topSize() {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return keyboardSpace > 33 ? 0.25 : 0.35;
  }

  Widget buildCard() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      margin: EdgeInsets.only(top: height * topSize() - 30),
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: widget.backCallback != null
          ? Column(
              children: <Widget>[
                Hero(
                  tag: 'header',
                  child: Container(
                    padding: EdgeInsets.only(left: 7, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () => widget.backCallback(),
                            child: Icon(Icons.arrow_back)),
                        InkWell(
                          onTap: () => widget.backCallback(),
                          child: Text(
                            'Back'.i18n,
                            style: TextStyle(
                                fontFamily: 'worksans',
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                widget.body,
              ],
            )
          : widget.body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            buildHeader(),
            buildCard(),
          ],
        ),
      ),
    );
  }
}
