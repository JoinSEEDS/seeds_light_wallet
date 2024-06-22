import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  final ValueSetter<String> onDigitTapped;

  const Keyboard({super.key, required this.onDigitTapped});

  @override
  Widget build(BuildContext context) {
    final List<String> keyboardItems = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = screenSize.height > screenSize.width ? screenSize.height / 2 : screenSize.height - 80;
    final keyboardWidth = keyboardHeight * 3 / 4;
    return Container(
      width: keyboardWidth,
      height: keyboardHeight,
      margin: const EdgeInsets.only(top: 16),
      child: AlignedGrid(
        keyboardSize: Size(keyboardWidth, keyboardHeight),
        children: [
          for (final i in keyboardItems)
            Container(
              margin: const EdgeInsets.all(4),
              child: ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.4),
                    onTap: () => onDigitTapped(i),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white),
                      ),
                      child: DecoratedBox(
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
                        child: Center(
                          child: Text(i, style: const TextStyle(fontSize: 30, color: Colors.white), semanticsLabel: i),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class AlignedGrid extends StatelessWidget {
  final double runSpacing = 4;
  final int columns = 3;
  final List<Widget> children;
  final Size keyboardSize;

  const AlignedGrid({super.key, required this.children, required this.keyboardSize});

  @override
  Widget build(BuildContext context) {
    final primarySize = keyboardSize.width > keyboardSize.height ? keyboardSize.height : keyboardSize.width;
    final itemSize = (primarySize - runSpacing * (columns - 1)) / columns;
    return Wrap(
      runSpacing: runSpacing,
      spacing: 4,
      alignment: WrapAlignment.center,
      children: [for (final i in children) SizedBox(width: itemSize, height: itemSize, child: i)],
    );
  }
}
