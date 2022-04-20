import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/datasource/local/util/seeds_esr.dart';

class ScanQrCodeResultData {
  final EOSTransaction transaction;
  final SeedsESR esr;

  ScanQrCodeResultData({required this.transaction, required this.esr});
}
