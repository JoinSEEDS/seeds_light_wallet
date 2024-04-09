
/// Token per USD
class StatModel {
  final String supplyString;
  final String maxSupplyString;
  final String issuer;

  const StatModel(this.supplyString, this.maxSupplyString, this.issuer);

  factory StatModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      final supplyString = json['rows'][0]['supply'] as String? ?? '';
      final maxSupplyString = json['rows'][0]['max_supply'] as String? ?? '';
      final issuer = json['rows'][0]['issuer'] as String? ?? '';
      return StatModel(supplyString, maxSupplyString, issuer);
    } else {
      return const StatModel('', '', '');
    }
  }
}
