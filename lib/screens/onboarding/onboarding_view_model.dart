import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';

class OnboardingViewModel extends PageViewModel {
  static const defaultBodyTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, fontFamily: "worksans");

  OnboardingViewModel._({bubble, mainImage, title, Widget body})
      : super(
          bubble: Icon(bubble),
          mainImage: Image.asset(
            mainImage,
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          ),
          body: body,
          title: Center(
            child: Text(
              title,
              textAlign: TextAlign.center
            ),
          ),
          pageColor: const Color(0xFF24b0d6),
          titleTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 38, fontFamily: "worksans"),
          bodyTextStyle: defaultBodyTextStyle,
        );

  OnboardingViewModel({bubble, mainImage, String body, title}) : this._(
    bubble: bubble,
    mainImage: mainImage,
    title: title,
    body: Text(body),
  );

  OnboardingViewModel.rich({bubble, mainImage, List<TextSpan> body, title}) : this._(
    bubble: bubble,
    mainImage: mainImage,
    title: title,
    body: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultBodyTextStyle,
        children: body
      )
    ),
  );
}
