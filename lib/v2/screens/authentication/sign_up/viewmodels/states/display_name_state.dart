import 'package:equatable/equatable.dart';

class DisplayNameState extends Equatable {
  final String? displayName;

  const DisplayNameState({this.displayName});

  @override
  List<Object?> get props => [displayName];

  DisplayNameState copyWith({String? displayName}) {
    return DisplayNameState(
      displayName: displayName ?? this.displayName,
    );
  }

  factory DisplayNameState.initial() => const DisplayNameState();
}
