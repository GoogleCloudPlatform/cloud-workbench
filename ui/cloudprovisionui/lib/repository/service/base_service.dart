import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseService {
  final String cloudProvisionServerUrl = dotenv.get('CLOUD_PROVISION_API_URL');
}
