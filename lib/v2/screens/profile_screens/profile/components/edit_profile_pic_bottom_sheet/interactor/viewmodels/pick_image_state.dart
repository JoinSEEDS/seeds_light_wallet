import 'dart:io';

import 'package:equatable/equatable.dart';

class PickImageState extends Equatable {
  final File? file;
  final String? errorMessage;

  const PickImageState({this.file, this.errorMessage});

  @override
  List<Object?> get props => [file, errorMessage];

  PickImageState copyWith({File? file, String? errorMessage}) {
    return PickImageState(
      file: file ?? this.file,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory PickImageState.initial() {
    return const PickImageState(file: null, errorMessage: null);
  }
}
