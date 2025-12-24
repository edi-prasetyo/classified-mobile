class PropertyModel {
  final int id;
  final String title;
  final String location;
  final String imageUrl;
  final int price;
  final int bedrooms;
  final int bathrooms;

  PropertyModel({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
  });
}
