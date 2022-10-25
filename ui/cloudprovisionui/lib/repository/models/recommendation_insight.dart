class RecommendationInsight {
  String recommendationServiceName;
  String recommendationServiceRegion;
  String recommendationPriority;
  String recommendationDescription;
  String recommendationLastRefreshTime;
  String recommendationState;
  String recommendationActionValue;
  String insightName;
  String insightDescription;
  String insightSeverity;
  String insightState;
  String insightServiceName;
  String insightServiceRegion;

  RecommendationInsight(
      this.recommendationServiceName,
      this.recommendationServiceRegion,
      this.recommendationPriority,
      this.recommendationDescription,
      this.recommendationLastRefreshTime,
      this.recommendationState,
      this.recommendationActionValue,
      this.insightName,
      this.insightDescription,
      this.insightSeverity,
      this.insightState,
      this.insightServiceName,
      this.insightServiceRegion);

  RecommendationInsight.fromJson(Map<String, dynamic> parsedJson)
      : recommendationServiceName = parsedJson['recommendationServiceName'],
        recommendationServiceRegion = parsedJson['recommendationServiceRegion'],
        recommendationPriority = parsedJson['recommendationPriority'],
        recommendationDescription = parsedJson['recommendationDescription'],
        recommendationLastRefreshTime =
            parsedJson['recommendationLastRefreshTime'],
        recommendationState = parsedJson['recommendationState'],
        recommendationActionValue = parsedJson['recommendationActionValue'],
        insightName = parsedJson['insightName'],
        insightDescription = parsedJson['insightDescription'],
        insightSeverity = parsedJson['insightSeverity'],
        insightState = parsedJson['insightState'],
        insightServiceName = parsedJson['insightServiceName'],
        insightServiceRegion = parsedJson['insightServiceRegion'];

  Map<String, dynamic> toJson() {
    return {
      'recommendationServiceName': recommendationServiceName,
      'recommendationServiceRegion': recommendationServiceRegion,
      'recommendationPriority': recommendationPriority,
      'recommendationDescription': recommendationDescription,
      'recommendationLastRefreshTime': recommendationLastRefreshTime,
      'recommendationState': recommendationState,
      'recommendationActionValue': recommendationActionValue,
      'insightName': insightName,
      'insightDescription': insightDescription,
      'insightSeverity': insightSeverity,
      'insightState': insightState,
      'insightServiceName': insightServiceName,
      'insightServiceRegion': insightServiceRegion,
    };
  }
}
