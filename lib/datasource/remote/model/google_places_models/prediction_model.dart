class PlacesAutocompleteResponse {
  final List<PredictionModel> predictions;
  final String status;
  final String? errorMessage;

  const PlacesAutocompleteResponse({
    required this.predictions,
    required this.status,
    this.errorMessage,
  });

  factory PlacesAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlacesAutocompleteResponse(
      predictions: json['predictions'].map<PredictionModel>((i) => PredictionModel.fromJson(i)).toList(),
      status: json['status'],
      errorMessage: json['error_message'],
    );
  }
}

class PredictionModel {
  final String placeId;
  final String description;

  const PredictionModel({required this.placeId, required this.description});

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(placeId: json['place_id'], description: json['description']);
  }
}

class Component {
  static const route = 'route';
  static const locality = 'locality';
  static const administrativeArea = 'administrative_area';
  static const postalCode = 'postal_code';
  static const country = 'country';

  final String component;
  final String value;

  Component(this.component, this.value);

  @override
  String toString() => '$component:$value';
}
