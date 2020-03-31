import 'package:flutter/material.dart';

class TransactionAvatar extends StatelessWidget {
  final String account;
  final double size;
  final BoxDecoration decoration;

  TransactionAvatar({this.account, this.size, this.decoration});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildTransactionAvatar(),
    );
  }

  Widget _buildTransactionAvatar() {
    String shortName = account.substring(0, 2).toUpperCase();

    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: Container(
        width: size,
        height: size,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            shortName,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        decoration: decoration,
      ),
    );
  }
}
