import 'package:flutter/material.dart';
import 'package:seeds/components/shimmer_circle.dart';
import 'package:seeds/components/shimmer_rectangle.dart';

class TransactionLoadingRow extends StatelessWidget {
  const TransactionLoadingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
      child: Row(
        children: [
          ShimmerCircle(60),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      ShimmerRectangle(size: Size(110, 21)),
                      Spacer(),
                      ShimmerRectangle(size: Size(64, 21)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ShimmerRectangle(size: Size(70, 16)),
                      Spacer(),
                      ShimmerRectangle(size: Size(44, 16)),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
