
/// Token per USD
class StatModel {
  final String supplyString;
  final String maxSupplyString;
  final String issuer;

  const StatModel(this.supplyString, this.maxSupplyString, this.issuer);

  factory StatModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      final supplyString = json['rows'][0]['supply'] ?? '';
      final maxSupplyString = json['rows'][0]['max_supply'] ?? '';
      final issuer = json['rows'][0]['issuer'] ?? '';
      return StatModel(supplyString, maxSupplyString, issuer);
    } else {
      return const StatModel('', '', '');
    }
  }
}
