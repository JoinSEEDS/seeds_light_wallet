import 'package:flutter_bloc/flutter_bloc.dart';

class BalanceState {
  BalanceState();

  factory BalanceState.initial() => BalanceState();
}

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit() : super(BalanceState.initial());
}
