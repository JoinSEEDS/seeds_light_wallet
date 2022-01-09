part of 'p2p_bloc.dart';

abstract class P2PEvent extends Equatable {
  const P2PEvent();

  @override
  List<Object> get props => [];
}

class OnMessageReceived extends P2PEvent {
  final JavascriptMessage javascriptMessage;

  const OnMessageReceived(this.javascriptMessage);

  @override
  String toString() => 'OnMessageReceived';
}

class OnPageLoaded extends P2PEvent {
  const OnPageLoaded();

  @override
  String toString() => 'OnPageLoaded';
}
