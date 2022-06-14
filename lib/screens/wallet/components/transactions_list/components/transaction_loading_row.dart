import 'package:flutter/material.dart';
import 'package:seeds/components/shimmer_circle.dart';
import 'package:seeds/components/shimmer_rectangle.dart';

class TransactionLoadingRow extends StatelessWidget {
  const TransactionLoadingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
      child: Row(
        children: [
          const ShimmerCircle(60),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      const ShimmerRectangle(size: Size(110, 21)),
                      const Spacer(),
                      const ShimmerRectangle(size: Size(64, 21)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const ShimmerRectangle(size: Size(70, 16)),
                      const Spacer(),
                      const ShimmerRectangle(size: Size(44, 16)),
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
