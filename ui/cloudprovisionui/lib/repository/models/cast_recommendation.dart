class CastRecommendation {
  final String id;
  final String name;
  final List<String> triggers;

  CastRecommendation({
    required this.id,
    required this.name,
    required this.triggers,
  });

  CastRecommendation.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        triggers = parsedJson['triggers'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'triggers': triggers,
    };
  }
}
