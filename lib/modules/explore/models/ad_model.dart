import '../../../core/utils/parse_utils.dart';

class AdModel {
  final int id;
  final String title;
  final String? description;
  final String slug;
  final int price;
  final String adStatus;
  final String? imageThumb;
  final String createdAt;
  final CategoryAd? category;
  final LocationInfo? province;
  final LocationInfo? regency;
  final UserInfo? user;
  final List<AdImage> images;
  final List<AdAttribute> attributes;

  AdModel({
    required this.id,
    required this.title,
    this.description,
    required this.slug,
    required this.price,
    required this.adStatus,
    this.imageThumb,
    required this.createdAt,
    this.category,
    this.province,
    this.regency,
    this.user,
    required this.images,
    required this.attributes,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: parseInt(json['id']),
      title: json['title'],
      description: json['description'],
      slug: json['slug'],
      price: parseInt(json['price']),
      adStatus: json['ad_status'],
      imageThumb: json['image_thumb'],
      createdAt: json['created_at'],
      category: json['category'] != null
          ? CategoryAd.fromJson(json['category'])
          : null,
      province: json['province'] != null
          ? LocationInfo.fromJson(json['province'])
          : null,
      regency: json['regency'] != null
          ? LocationInfo.fromJson(json['regency'])
          : null,
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
      images:
          (json['images'] as List?)?.map((e) => AdImage.fromJson(e)).toList() ??
          [],
      // Tambahkan ini:
      attributes:
          (json['attributes'] as List?)
              ?.map((e) => AdAttribute.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AdAttribute {
  final int id;
  final String value;
  final String label;
  final String? icon;

  AdAttribute({
    required this.id,
    required this.value,
    required this.label,
    this.icon,
  });

  factory AdAttribute.fromJson(Map<String, dynamic> json) {
    return AdAttribute(
      id: parseInt(json['id']),
      value: json['value'],
      label:
          json['category_attribute']['label'], // Mengambil label dari nested object
      icon: json['category_attribute']['icon'], // Mengambil icon url
    );
  }
}

class AdImage {
  final String imageUrl;
  final String imageThumbUrl;
  final int isPrimary;

  AdImage({
    required this.imageUrl,
    required this.imageThumbUrl,
    required this.isPrimary,
  });

  factory AdImage.fromJson(Map<String, dynamic> json) {
    return AdImage(
      imageUrl: json['image_url'],
      imageThumbUrl: json['image_thumb_url'],
      isPrimary: parseInt(json['is_primary']),
    );
  }
}

class CategoryAd {
  final String name;
  CategoryAd({required this.name});
  factory CategoryAd.fromJson(Map<String, dynamic> json) =>
      CategoryAd(name: json['name']);
}

class LocationInfo {
  final String name;
  LocationInfo({required this.name});
  factory LocationInfo.fromJson(Map<String, dynamic> json) =>
      LocationInfo(name: json['name']);
}

class UserInfo {
  final String name;
  final String phone;
  UserInfo({required this.name, required this.phone});
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      UserInfo(name: json['name'], phone: json['phone']);
}
