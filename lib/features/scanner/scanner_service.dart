import 'package:majascan/majascan.dart';
import 'package:seeds/constants/app_colors.dart';
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
    return MajaScan.startScan(
      title: "QRcode scanner", 
      barColor: AppColors.red, 
      titleColor: AppColors.green, 
      qRCornerColor: AppColors.lightGreen,
      qRScannerColor: AppColors.purple,
      flashlightEnable: true, 
      scanAreaScale: 0.7 /// value 0.0 to 1.0
    );
  }

  ScanStatus statusFromResult(String result) {
    return ScanStatus.successful;
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
