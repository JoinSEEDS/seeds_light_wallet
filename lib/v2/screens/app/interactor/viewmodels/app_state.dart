import 'package:equatable/equatable.dart';

/// STATE
class AppState extends Equatable {
  final int index;
  final bool hasNotification;

  const AppState({required this.index, required this.hasNotification});

  @override
  List<Object?> get props => [index, hasNotification];

  AppState copyWith({int? index, bool? hasNotification}) {
    return AppState(
      index: index ?? this.index,
      hasNotification: hasNotification ?? this.hasNotification,
    );
  }

  factory AppState.initial() {
    return const AppState(index: 0, hasNotification: false);
  }
}
