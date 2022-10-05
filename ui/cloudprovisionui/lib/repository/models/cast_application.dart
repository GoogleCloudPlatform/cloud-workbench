import 'package:cloudprovision/repository/models/cast_recommendation.dart';

class CastApplication {
  String name;
  int id;
  List<CastRecommendation> recommendations;

  CastApplication({
    required this.id,
    required this.name,
    required this.recommendations,
  });

  CastApplication.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        recommendations = parsedJson['recommendations'] == null
            ? []
            : (parsedJson['recommendations'] as List)
                .map((i) => CastRecommendation.fromJson(i))
                .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'recommendations': recommendations,
    };
  }
}
