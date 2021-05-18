import 'package:equatable/equatable.dart';

class InviteModel extends Equatable {
  final int? inviteId;
  final String? transferQuantity;
  final String? sowQuantity;
  final String? sponsor;
  final String? account;
  final String? inviteHash;
  final String? inviteSecret;

  const InviteModel({
    this.inviteId,
    this.transferQuantity,
    this.sowQuantity,
    this.sponsor,
    this.account,
    this.inviteHash,
    this.inviteSecret,
  });

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
