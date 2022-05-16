import 'dart:core';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/screens/authentication/verification/components/circle.dart';
import 'package:seeds/screens/authentication/verification/components/keyboard.dart';
import 'package:seeds/utils/build_context_extension.dart';

class _ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * 2.5 * pi).abs(); //t from 0.0 to 1.0
}

const _passwordDigits = 4;

class PasscodeScreen extends StatefulWidget {
  final Widget title;
  final ValueSetter<String> onPasscodeCompleted;
  final Widget? bottomWidget;

  const PasscodeScreen({super.key, required this.title, required this.onPasscodeCompleted, this.bottomWidget});

  @override
  State<StatefulWidget> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  String enteredPasscode = '';

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    final Animation curve = CurvedAnimation(parent: controller, curve: _ShakeCurve());
    animation = Tween(begin: 0.0, end: 10.0).animate(curve as Animation<double>)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            enteredPasscode = '';
            controller.value = 0;
          });
        }
      })
      ..addListener(() {
        setState(() {
          // the animation object’s value is the changed state
        });
      });
  }

  @override
  void didUpdateWidget(PasscodeScreen old) {
    super.didUpdateWidget(old);
    // clean dots on re-enter
    if (widget.title != old.title) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _onKeyboardButtonPressed(String text) async {
    if (enteredPasscode.length < _passwordDigits) {
      setState(() => enteredPasscode += text);
      // ignore: invariant_booleans
      if (enteredPasscode.length == _passwordDigits) {
        await Future.delayed(const Duration(milliseconds: 300));
        widget.onPasscodeCompleted(enteredPasscode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.title,
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < _passwordDigits; i++)
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: Circle(filled: i < enteredPasscode.length, extraSize: animation.value),
                          ),
                      ],
                    ),
                  ),
                  Keyboard(onDigitTapped: _onKeyboardButtonPressed),
                  widget.bottomWidget ?? const SizedBox.shrink()
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: CupertinoButton(
                onPressed: () {
                  if (enteredPasscode.isNotEmpty) {
                    setState(() => enteredPasscode = enteredPasscode.substring(0, enteredPasscode.length - 1));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(24),
                  child: enteredPasscode.isEmpty
                      ? const SizedBox.shrink()
                      : Text(context.loc.verificationPasscodeScreenButtonTitle,
                          style: Theme.of(context).textTheme.subtitle2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
