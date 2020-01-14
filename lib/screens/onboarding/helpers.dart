import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:seeds/utils/config.dart';

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

Config secretConfig;

String applicationAccount = secretConfig.value('APPLICATION_ACCOUNT_NAME');
String applicationPrivateKey = secretConfig.value('APPLICATION_PRIVATE_KEY');
String debugAccount = secretConfig.value('DEBUG_ACCOUNT_NAME');
String debugPrivateKey = secretConfig.value('DEBUG_PRIVATE_KEY');
String debugInviteSecret = secretConfig.value('DEBUG_INVITE_SECRET');
String debugInviteLink = secretConfig.value('DEBUG_INVITE_LINK');

bool isDebugMode() => debugAccount != "" && debugPrivateKey != "";
