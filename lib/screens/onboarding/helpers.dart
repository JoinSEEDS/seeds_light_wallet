import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:intro_views_flutter/Models/page_view_model.dart';

PageViewModel page({bubble, mainImage, body, title}) {
  return PageViewModel(
    bubble: Icon(bubble),
    mainImage: Image.asset(
      mainImage,
      height: 285.0,
      width: 285.0,
      alignment: Alignment.center,
    ),
    body: Text(body),
    title: Center(
      child: Text(title),
    ),
    pageColor: const Color(0xFF24b0d6),
    titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
    bodyTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
  );
}

String applicationAccount = DotEnv().env['APPLICATION_ACCOUNT_NAME'];
String applicationPrivateKey = DotEnv().env['APPLICATION_PRIVATE_KEY'];
String debugAccount = DotEnv().env['DEBUG_ACCOUNT_NAME'];
String debugPrivateKey = DotEnv().env['DEBUG_PRIVATE_KEY'];
String debugInviteSecret = DotEnv().env['DEBUG_INVITE_SECRET'];
String debugInviteLink = DotEnv().env['DEBUG_INVITE_LINK'];

bool isDebugMode() => debugAccount != "" && debugPrivateKey != "";