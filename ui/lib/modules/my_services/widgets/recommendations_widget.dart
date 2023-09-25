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

      if (recommendations.isEmpty)
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Information will be available within 24 hours after service deployment"),
          ],
        ));

      return Column(
        children: rows,
      );
    });
  }
}
