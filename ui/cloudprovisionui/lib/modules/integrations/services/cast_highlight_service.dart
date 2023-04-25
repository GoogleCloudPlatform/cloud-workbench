import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/cast_application.dart';
import '../models/cast_recommendation.dart';

class CastHighlightService {
  Future<List<CastApplication>> loadAssessmentByCampaignId(
      int campaignId, String castAccessToken) async {
    //  70869
    // 38314
    List<int> apps = [74, 609, 106187];

    List<CastApplication> castApplications = [];

    int domainId = 4;

    Map<String, String> requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer " + castAccessToken,
      HttpHeaders.contentTypeHeader: "application/json",
    };

    for (int appId in apps) {
      var endpointPath = '/WS2/domains/${domainId}/applications/${appId}';

      var url = Uri.https("demo.casthighlight.com", endpointPath);

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 30));
      Map<String, dynamic> app = json.decode(response.body);

      endpointPath =
          '/WS2/domains/${domainId}/applications/${appId}/recommendation';
      url = Uri.https("demo.casthighlight.com", endpointPath);
      response = await http.get(url, headers: requestHeaders);

      List<dynamic> castRecs = json.decode(response.body)[2]['recommendations'];

      List<CastRecommendation> castRecommendations = [];

      castRecs.forEach((element) {
        List<dynamic> castTriggers = element['triggers'];

        List<String> triggers = [];
        castTriggers.forEach((trigger) {
          triggers.add(trigger['details']['label']);
        });
        castRecommendations.add(CastRecommendation(
            id: element['id'], name: element['name'], triggers: triggers));
      });

      castApplications.add(CastApplication(
          id: app["id"],
          name: app["name"],
          recommendations: castRecommendations));
    }
    return castApplications;
  }
}
