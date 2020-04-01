import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';

class OnboardingViewModel extends PageViewModel {
  OnboardingViewModel({bubble, mainImage, body, title})
      : super(
          bubble: Icon(bubble),
          mainImage: Image.asset(
            mainImage,
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          ),
          body: Text(body),
          title: Center(
            child: Text(
              title,
              textAlign: TextAlign.center
            ),
          ),
          pageColor: const Color(0xFF24b0d6),
          titleTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 38, fontFamily: "worksans"),
          bodyTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, fontFamily: "worksans"),
        );
}
