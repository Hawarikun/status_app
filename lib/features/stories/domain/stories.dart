import 'package:json_annotation/json_annotation.dart';

part 'stories.g.dart';

@JsonSerializable()
class Story {
  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final double? lat;
  final double? lon;

  factory Story.fromMap(Map<String, dynamic> map) => _$StoryFromJson(map);
}
