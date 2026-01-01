import '../../../core/utils/parse_utils.dart';

class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? image;
  final String route;
  final int? parentId;
  final List<CategoryModel>? children;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    required this.route,
    this.parentId,
    this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: parseInt(json['id']),
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
      route: json['route'],
      parentId: parseInt(json['parent_id']),
      children: json['children'] != null
          ? (json['children'] as List)
                .map((i) => CategoryModel.fromJson(i))
                .toList()
          : null,
    );
  }
}
