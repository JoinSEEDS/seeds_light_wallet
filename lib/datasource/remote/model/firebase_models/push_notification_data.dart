import 'package:collection/collection.dart' show IterableExtension;

/// Serialize the data of a push notification
class PushNotificationData {
  final NotificationTypes? notificationType;
  final String? invoice;
  final bool isRefreshConfig;

  const PushNotificationData({
    this.notificationType,
    this.invoice,
    required this.isRefreshConfig,
  });

  factory PushNotificationData.fromJson(Map<String, dynamic> json) {
    return PushNotificationData(
      notificationType: NotificationTypes.values.firstWhereOrNull((i) => i.name == json['notification_type_id']),
      invoice: json['invoice'],
      isRefreshConfig: json['CONFIG_STATE'] != null,
    );
  }
}

enum NotificationTypes {
  paymentReceived,
  guardianInviteReceived,
  guardianRequestApproved,
  guardianThresholdReached,
  invoiceNotificationTypeId,
}
