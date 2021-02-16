import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/models/models.dart';

/// --- EVENTS
@immutable
abstract class WalletEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadWallet extends WalletEvent {
  final String userName;
  final List<TransactionModel> transactions;

  @override
  String toString() => 'LoadWallet: { userName: $userName }';

  LoadWallet({@required this.userName , this.transactions});
}
