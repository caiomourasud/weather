class City {
  String? name;
  String? lat;
  String? lng;
  String? country;
  String? admin1;
  String? admin2;

  City({
    this.name,
    this.lat,
    this.lng,
    this.country,
    this.admin1,
    this.admin2,
  });

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    country = json['country'];
    admin1 = json['admin1'];
    admin2 = json['admin2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['lat'] = lat;
    data['lng'] = lng;
    data['country'] = country;
    data['admin1'] = admin1;
    data['admin2'] = admin2;
    return data;
  }
}
