import 'dart:convert';

class LocationData {
  int id;
  String name;
  String city;
  String state;
  String directionInOneLine;
  String details;
  bool haveDetails;
  int tagId;
  double log;
  double lat;
  LocationData({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.directionInOneLine,
    required this.details,
    required this.haveDetails,
    required this.tagId,
    required this.log,
    required this.lat,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'location_name': name,
      'city': city,
      'state': state,
      'direction_line_1': directionInOneLine,
      'details': details,
      'have_details': details == "" ? false : true,
      'longitude': double.parse(log.toString()),
      'latitude': double.parse(lat.toString()),
      'tag_id': tagId
    };
  }

  factory LocationData.fromMap(Map<dynamic, dynamic> map) {
    return LocationData(
      name: map['location_name'] ?? '',
      id: map['id'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      directionInOneLine: map['direction_line_1'] ?? '',
      details: map['details'] ?? '',
      tagId: map['tag_id'] ?? 0,
      lat: map['latitude'] ?? 0.0,
      log: map['longitude'] ?? 0.0,
      haveDetails: map['have_details'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationData.fromJson(String source) =>
      LocationData.fromMap(json.decode(source));
}
