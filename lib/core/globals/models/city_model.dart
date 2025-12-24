class CityModel {
  final int id;
  final String name;
  final int provinceId;
  final String provinceName;

  CityModel({
    required this.id,
    required this.name,
    required this.provinceId,
    required this.provinceName,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
      provinceId: json['province_id'],
      provinceName: json['province']?['name'] ?? '',
    );
  }
}
