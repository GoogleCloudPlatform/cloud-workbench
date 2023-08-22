import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/styles.dart';
import '../data/security_repository.dart';
import '../models/recommendation_insight.dart';
import '../models/service.dart';

class RecommendationsWidget extends ConsumerStatefulWidget {
  final Service service;
  const RecommendationsWidget({
    super.key,
    required this.service,
  });

  @override
  ConsumerState<RecommendationsWidget> createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState extends ConsumerState<RecommendationsWidget> {
  @override
  void initState() {
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
        buildRecommendationsSection(),
      ],
    );
  }

  buildRecommendationsSection() {

    var recommendationInsight = ref.watch(securityRecommendationsProvider(
        projectId: widget.service.projectId,
        region: widget.service.region,
        serviceId: widget.service.serviceId));

    return recommendationInsight.when(
        loading: () => LinearProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
    data: (recommendations) {
      List<Widget> rows = [];
      for (RecommendationInsight rec in recommendations) {
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
    });
  }
}
