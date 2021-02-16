import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/screens/wallet/interactor/viewmodels/wallet_state.dart';
import 'package:seeds/v2/screens/wallet/interactor/wallet_bloc.dart';

/// Wallet HEADER
class WalletHeader extends StatelessWidget {
  const WalletHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      return Container(
        margin: EdgeInsets.all(20),
        width: 300,
        height: 200,
        color: Colors.blue,
      );
    });
  }
}
