import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/styles.dart';
import '../data/security_repository.dart';
import '../data/security_service.dart';
import '../models/recommendation_insight.dart';
import '../models/service.dart';

class RecommendationsWidget extends StatefulWidget {
  final Service service;
  const RecommendationsWidget({
    super.key,
    required this.service,
  });

  @override
  State<RecommendationsWidget> createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState extends State<RecommendationsWidget> {
  bool _loadingRecommendationsInsights = false;
  List<RecommendationInsight> _recommendations = [];

  @override
  void initState() {
    _loadingRecommendationsInsights = true;
    loadRecommendationsInsights();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Recommendations and Insights: ",
              style: AppText.fontStyleBold,
            ),
          ],
        ),
        const SizedBox(height: 4),
        _loadingRecommendationsInsights
            ? LinearProgressIndicator()
            : buildRecommendationsSection(),
      ],
    );
  }

  void loadRecommendationsInsights() async {
    List<RecommendationInsight> recommendations =
        await SecurityRepository(service: SecurityService())
            .getSecurityRecommendations(
      widget.service.projectId,
      widget.service.serviceId,
    );

    setState(() {
      _recommendations = recommendations;
      _loadingRecommendationsInsights = false;
    });
  }

  buildRecommendationsSection() {
    List<Widget> rows = [];
    for (RecommendationInsight rec in _recommendations) {
      rows.add(Row(
        children: [
          Text(
            "Insight:",
            style: AppText.fontStyleBold,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            rec.insightDescription,
            style: AppText.fontStyle,
          ),
        ],
      ));

      rows.add(Row(
        children: [
          Text(
            "Recommendation:",
            style: AppText.fontStyleBold,
          ),
          SizedBox(
            width: 4,
          ),
          SizedBox(
            child: Text(
              rec.recommendationDescription,
              style: AppText.fontStyle,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          TextButton(
            onPressed: () async {
              final Uri _url = Uri.parse(rec.recommendationActionValue);
              if (!await launchUrl(_url)) {
                throw 'Could not launch $_url';
              }
            },
            child: Text(
              "Fix it",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppText.linkFontStyle,
            ),
          ),
        ],
      ));
    }
    return Column(
      children: rows,
    );
  }
}
