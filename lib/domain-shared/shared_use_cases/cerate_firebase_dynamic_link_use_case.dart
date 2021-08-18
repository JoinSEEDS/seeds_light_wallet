import 'package:async/async.dart';
import 'package:seeds/datasource/local/firebase_dynamic_link_service.dart';

class CreateFirebaseDynamicLinkUseCase {
  final FirebaseDynamicLinkService _firebaseDynamicLinkService = FirebaseDynamicLinkService();

  Future<Result> createDynamicLink(String targetLink, String link) async {
    return _firebaseDynamicLinkService.createDynamicLink(targetLink, link);
  }
}
