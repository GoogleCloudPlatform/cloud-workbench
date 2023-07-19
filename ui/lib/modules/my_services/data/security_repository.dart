import '../models/recommendation_insight.dart';
import '../models/vulnerability.dart';
import 'security_service.dart';

class SecurityRepository {
  const SecurityRepository({required this.service});

  final SecurityService service;

  /// Returns list of vulnerabilities
  /// [projectId]
  /// [serviceId]
  Future<List<Vulnerability>> getContainerVulnerabilities(
          String projectId, String serviceId) async =>
      service.getContainerVulnerabilities(projectId, serviceId);

  // Returns Security Recommendations
  /// [projectId]
  /// [serviceId]
  Future<List<RecommendationInsight>> getSecurityRecommendations(
          String projectId, String serviceId) async =>
      service.getSecurityRecommendations(projectId, serviceId);
}
