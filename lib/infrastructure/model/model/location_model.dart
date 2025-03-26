class LocationModel {
  LocationModel({double? latitude, double? longitude, String? address}) {
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
  }

  LocationModel.fromJson(dynamic json) {
    if (json["address"] != null) _address = json["address"];
    _latitude = double.tryParse(json['latitude'].toString());
    _longitude = double.tryParse(json['longitude'].toString());
  }

  double? _latitude;
  double? _longitude;
  String? _address;

  LocationModel copyWith({double? latitude, double? longitude, String? address}) =>
      LocationModel(
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        address: address ?? _address,
      );

  double? get latitude => _latitude;

  double? get longitude => _longitude;

  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['address'] = _address;
    return map;
  }
}
