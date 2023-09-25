// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
