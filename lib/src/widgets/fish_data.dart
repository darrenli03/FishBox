// fish_data.dart
class FishData {
  final String name;
  final String imageUrl;
  final double estimatedLength;
  final int id;

  FishData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.estimatedLength,
  });

  factory FishData.fromJson(Map<String, dynamic> json) {
    return FishData(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      estimatedLength: json['estimatedLength'],
    );
  }
}