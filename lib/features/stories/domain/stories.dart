class Story {
  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String createdAt;
  final double? lat;
  final double? lon;

  factory Story.fromMap(Map<String, dynamic> map) => Story(
        id: map["id"],
        name: map["name"],
        description: map["description"],
        imageUrl: map["photoUrl"],
        createdAt: map["createdAt"],
        lat: map["lat"],
        lon: map["lon"],
      );
}
