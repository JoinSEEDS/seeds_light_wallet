import 'package:equatable/equatable.dart';

class PlantedModel extends Equatable {
  final double quantity;

  const PlantedModel(this.quantity);

  @override
  List<Object?> get props => [quantity];

  factory PlantedModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      var split = (json['rows'][0]['planted'] as String).split(' ');
      var amount = double.parse(split.first);
      return PlantedModel(amount);
    } else {
      return const PlantedModel(0);
    }
  }
}
