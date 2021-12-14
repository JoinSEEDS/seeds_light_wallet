import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/utils/string_extension.dart';

class InviteModel extends Equatable {
  final int inviteId;
  final String transferQuantity;
  final String sowQuantity;
  final String sponsor;
  final String? account;
  final String inviteHash;
  final String inviteSecret;

  const InviteModel({
    required this.inviteId,
    required this.transferQuantity,
    required this.sowQuantity,
    required this.sponsor,
    this.account,
    required this.inviteHash,
    required this.inviteSecret,
  });

  bool get isClaimed => !account.isNullOrEmpty;

  double get inviteTotalAmount => transferQuantity.quantityAsDouble + sowQuantity.quantityAsDouble;

  /// Returns the rounded amount in seeds with its symbol Ex: 10.00 SEEDS
  String get seedsFormattedInviteTotalAmount => '${inviteTotalAmount.seedsFormatted} $currencySeedsCode';

  factory InviteModel.fromJson(Map<String, dynamic> json) {
    return InviteModel(
      inviteId: json['invite_id'],
      transferQuantity: json['transfer_quantity'],
      sowQuantity: json['sow_quantity'],
      sponsor: json['sponsor'],
      account: json['account'],
      inviteHash: json['invite_hash'],
      inviteSecret: json['invite_secret'],
    );
  }

  @override
  List<Object?> get props => [
        inviteId,
        transferQuantity,
        sowQuantity,
        sponsor,
        account,
        inviteHash,
        inviteSecret,
      ];
}
