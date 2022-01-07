part of 'pick_image_bloc.dart';

abstract class PickImageEvent extends Equatable {
  const PickImageEvent();

  @override
  List<Object?> get props => [];
}

class GetImage extends PickImageEvent {
  final ImageSource source;

  const GetImage({required this.source});

  @override
  List<Object?> get props => [source];

  @override
  String toString() => 'GetImage { source: $source }';
}
