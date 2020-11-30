import 'package:seeds/providers/services/links_service.dart';

enum ScanStatus {
  successful,
  cancelled,
  failed,
}

enum ScanContentType {
  inviteUrl,
  inviteCode,
  esr, // EOSIO signing request; https://github.com/eosio-eps/EEPs/blob/master/EEPS/eep-7.md
  guardian,
  unknown,
}

class ScannerService {
  
  LinksService _linksService;
  
  void update(LinksService linksService) {
    this._linksService = linksService;
  }
  
  Future<String> start() {
    return Future.value();
  }

  ScanStatus statusFromResult(String result) {
    if (result != null) {
      return ScanStatus.successful;
    } else {
      return ScanStatus.failed;
    }

    // switch(result.type) {
    //   case ResultType.Barcode:
    //     return ScanStatus.successful;
    //
    //   case ResultType.Cancelled:
    //     return ScanStatus.cancelled;
    //
    //   case ResultType.Error:
    //   default:
    //     return ScanStatus.failed;
    // }
  }

  ScanContentType contentTypeOf(String content) {
    if(content == null) {
      return ScanContentType.unknown;
    } else if(content.startsWith("esr:")) {
      return ScanContentType.esr;
    } else if(content.contains("-")) {
      final words = content.split("-");
      if(words.length >= 5) {
        return ScanContentType.inviteUrl;
      }
    } else if(content.startsWith("https://seedswallet.page.link/")) {
      return ScanContentType.inviteUrl;
    }

    return ScanContentType.unknown;
  }

  Stream<Uri> decodeInviteUrl(String link) => _linksService.unpackDynamicLink(link).asStream();


}
