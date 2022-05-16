import 'dart:math';
import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';

class DotsIndicator extends StatelessWidget {
  final int dotsCount;
  final double position;
  final DotsDecorator decorator;
  final Axis axis;
  final bool reversed;
  final ValueSetter<double>? onDotTaped;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;

  const DotsIndicator({
    super.key,
    required this.dotsCount,
    this.position = 0.0,
    this.decorator = const DotsDecorator(),
    this.axis = Axis.horizontal,
    this.reversed = false,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onDotTaped,
  })  : assert(dotsCount > 0),
        assert(position >= 0),
        assert(position < dotsCount, "Position must be inferior than dotsCount");

  Widget _buildDot(int index) {
    final state = min(1.0, (position - index).abs());
    final size = Size.lerp(decorator.activeSize, decorator.size, state)!;

    final dot = Container(
      width: size.width,
      height: size.height,
      margin: decorator.spacing,
      decoration: ShapeDecoration(
        color: Color.lerp(decorator.activeColor, decorator.color, state),
        shape: ShapeBorder.lerp(decorator.activeShape, decorator.shape, state)!,
      ),
    );
    return onDotTaped == null
        ? dot
        : InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onDotTaped!(index.toDouble()),
            child: dot,
          );
  }

  @override
  Widget build(BuildContext context) {
    final dotsList = List<Widget>.generate(dotsCount, _buildDot);
    final dots = reversed ? dotsList.reversed.toList() : dotsList;

    return axis == Axis.vertical
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: dots,
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: dots,
          );
  }
}

class DotsDecorator {
  final Color color;
  final Color activeColor;
  final Size size;
  final Size activeSize;
  final ShapeBorder shape;
  final ShapeBorder activeShape;
  final EdgeInsets spacing;

  const DotsDecorator({
    this.color = AppColors.darkGreen2,
    this.activeColor = AppColors.green1,
    this.size = const Size(10.0, 2.0),
    this.activeSize = const Size(18.0, 2.0),
    this.shape = const Border(),
    this.activeShape = const Border(),
    this.spacing = const EdgeInsets.all(2.0),
  });

  factory DotsDecorator.copyWith({
    Color? color,
    Color? activeColor,
    Size? size,
    Size? activeSize,
    ShapeBorder? shape,
    ShapeBorder? activeShape,
    EdgeInsets? spacing,
  }) {
    return DotsDecorator(
      color: color ?? AppColors.darkGreen2,
      activeColor: activeColor ?? AppColors.green1,
      size: size ?? const Size(10.0, 2.0),
      activeSize: activeSize ?? const Size(18.0, 2.0),
      shape: shape ?? const Border(),
      activeShape: activeShape ?? const Border(),
      spacing: spacing ?? const EdgeInsets.all(2.0),
    );
  }
}
