part of 'swap_seeds_bloc.dart';

abstract class SwapSeedsEvent extends Equatable {
  const SwapSeedsEvent();

  @override
  List<Object> get props => [];
}

class OnMessageReceived extends SwapSeedsEvent {
  final JavaScriptMessage javascriptMessage;

  const OnMessageReceived(this.javascriptMessage);

  @override
  String toString() => 'OnMessageReceived';
}

class OnPageLoaded extends SwapSeedsEvent {
  const OnPageLoaded();

  @override
  String toString() => 'OnPageLoaded';
}
