part of 'pick_image_bloc.dart';

class PickImageState extends Equatable {
  final String? errorMessage;
  final File? file;

  const PickImageState({this.errorMessage, this.file});

  @override
  List<Object?> get props => [errorMessage, file];

  PickImageState copyWith({String? errorMessage, File? file}) {
    return PickImageState(
      errorMessage: errorMessage,
      file: file ?? this.file,
    );
  }

  factory PickImageState.initial() => const PickImageState();
}
