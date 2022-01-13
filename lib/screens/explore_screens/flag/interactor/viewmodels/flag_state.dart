import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';

class FlagState extends Equatable {
  final PageCommand? pageCommand;

  const FlagState({this.pageCommand});

  @override
  List<Object?> get props => [pageCommand];

  FlagState copyWith({PageCommand? pageCommand}) {
    return FlagState(pageCommand: pageCommand);
  }

  factory FlagState.initial() => const FlagState();
}
