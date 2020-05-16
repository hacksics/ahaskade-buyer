class Location {
  final double lat;
  final double lon;
  Location({this.lat, this.lon});
  factory Location.fromJson(dynamic json) {
    return Location(lat: json['lat'] as double, lon: json['lon'] as double);
  }

  Map<String, dynamic> toJson() => {'lat': this.lat, 'lon': this.lon};

  @override
  String toString() {
    return '{ "lat": ${this.lat}, "lon": ${this.lon}}';
  }
}
