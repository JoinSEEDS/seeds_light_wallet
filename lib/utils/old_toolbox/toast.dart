import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

const int LONG_DELAY = 3500;
const LONG_DURATION = const Duration(milliseconds: LONG_DELAY);

errorToast(String msg) {
  showToast(
    msg,
    duration: LONG_DURATION,
    backgroundColor: Colors.red,
    textStyle: TextStyle(color: Colors.white),
  );
}

successToast(String msg) {
  showToast(
    msg,
    duration: LONG_DURATION,
    backgroundColor: Colors.green,
    textStyle: TextStyle(color: Colors.white),
  );
}

toast(String msg) {
  showToast(
    msg,
    duration: LONG_DURATION,
  );
}
