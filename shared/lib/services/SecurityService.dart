import 'package:googleapis/containeranalysis/v1.dart' as ca;
import 'package:googleapis/recommender/v1.dart' as ra;

import 'BaseService.dart';

class SecurityService extends BaseService {
  SecurityService(String accessToken) : super(accessToken);
  /// Returns list of vulnerabilities
  /// [projectId]
  /// [serviceId]
  Future<List<Map<String, String>>> getContainerVulnerabilities(String? projectId, String serviceId) async {
    String parent = "projects/${projectId}";

    var containerAnalysisApi = ca.ContainerAnalysisApi(getAuthenticatedClient());

    ca.VulnerabilityOccurrencesSummary list = await containerAnalysisApi
        .projects.occurrences
        .getVulnerabilitySummary(parent);
    List<Map<String, String>> response = [];

    for (ca.FixableTotalByDigest f in list.counts!) {
      if (f.resourceUri!.contains(serviceId)) {
        if (f.severity != null) {
          response.add(Map.from({
            'severity': f.severity,
            'totalCount': f.totalCount,
            'fixableCount': f.fixableCount == null ? "0" : f.fixableCount,
            'resourceUri': f.resourceUri,
          }));
        }
      }
    }

    return response;
  }

  // Returns Security Recommendations
  /// [projectId]
  /// [region]
  /// [serviceId]
  getSecurityRecommendations(String? projectId, String? region, String serviceId) async {
    String parent = "projects/${projectId}";

    List<Map<String, String>> response = [];

    parent =
        "projects/${projectId}/locations/${region}/recommenders/google.run.service.IdentityRecommender";
    ra.RecommenderApi rApi = ra.RecommenderApi(getAuthenticatedClient());
    ra.GoogleCloudRecommenderV1ListRecommendationsResponse list =
        await rApi.projects.locations.recommenders.recommendations.list(parent);

    for (ra.GoogleCloudRecommenderV1Recommendation r in list.recommendations!) {
      String serviceName = r.content!.overview!['serviceName'] as String;

      if (serviceName != serviceId) continue;

      Map<String, String> responseMap = Map.from({
        'recommendationServiceName': serviceName,
        'recommendationServiceRegion': r.content!.overview!['serviceRegion'],
        'recommendationPriority': r.priority,
        'recommendationDescription': r.description,
        'recommendationLastRefreshTime': r.lastRefreshTime,
        'recommendationState': r.stateInfo!.state,
      });

      for (ra.GoogleCloudRecommenderV1RecommendationInsightReference ins
          in r.associatedInsights!) {
        var insight = await rApi.projects.locations.insightTypes.insights
            .get(ins.insight!);

        responseMap['insightName'] = insight.name!;
        responseMap['insightDescription'] = insight.description!;
        responseMap['insightSeverity'] = insight.severity!;
        responseMap['insightState'] = insight.stateInfo!.state!;
        responseMap['insightServiceName'] =
            insight.content!['serviceName']! as String;
        responseMap['insightServiceRegion'] =
            insight.content!['serviceRegion']! as String;
      }

      for (ra.GoogleCloudRecommenderV1OperationGroup opGroup
          in r.content!.operationGroups!) {
        for (ra.GoogleCloudRecommenderV1Operation operation
            in opGroup.operations!) {
          responseMap['recommendationActionValue'] = operation.value! as String;
        }
      }

      response.add(responseMap);
    }

    return response;
  }

  // Returns Security Insights
  /// [projectId]
  /// [region]
  /// [serviceId]
  getSecurityInsights(String? projectId, String? region, String serviceId) async {
    List<Map<String, String>> response = [];

    String parent =
        "projects/${projectId}/locations/${region}/recommenders/google.run.service.IdentityRecommender";
    ra.RecommenderApi rApi = ra.RecommenderApi(getAuthenticatedClient());
    ra.GoogleCloudRecommenderV1ListRecommendationsResponse list =
        await rApi.projects.locations.recommenders.recommendations.list(parent);

    for (ra.GoogleCloudRecommenderV1Recommendation r in list.recommendations!) {
      for (ra.GoogleCloudRecommenderV1RecommendationInsightReference ins
          in r.associatedInsights!) {
        print("associatedInsights: ${ins.insight}");

        var insight = await rApi.projects.locations.insightTypes.insights
            .get(ins.insight!);

        response.add(Map.from({
          'serviceName': insight.content!['serviceName'],
          'serviceRegion': insight.content!['serviceRegion'],
          'priority': insight.severity,
          'description': insight.description,
          'lastRefreshTime': insight.lastRefreshTime,
          'state': insight.stateInfo!.state,
        }));
      }
    }

    return response;
  }
}
