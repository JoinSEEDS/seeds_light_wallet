import 'dart:io';
import 'package:udp/udp.dart';
import 'package:equatable/equatable.dart';

class UdpLogger extends Equatable {
  UdpLogger();

  Future<void> setSender({endpoint = null}) async {
    sender = await UDP.bind(endpoint ?? Endpoint.any(port: Port(65000)));
  }

  Future<void> setTarget(String targetAddress, int targetPort) async {
    targetEndpoint = Endpoint.unicast(
        InternetAddress(targetAddress), port: Port(targetPort));
  }

  Future<int> log(String string) async {
    if (sender == null || targetEndpoint == null) {
      return 0;
    }
    return await sender!.send(string.codeUnits, targetEndpoint!);
  }
  Endpoint? targetEndpoint;
  UDP? sender;

  @override
  List<Object?> get props => [targetEndpoint];
}

