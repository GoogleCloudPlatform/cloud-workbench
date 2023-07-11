import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../firebase_options.dart';

class Environment {
  static String getProjectId() {
    return DefaultFirebaseOptions.currentPlatform.projectId;
  }

  static String getRegion() {
    return dotenv.get("DEFAULT_REGION");
  }

  static String getWorkstationCluster() {
    return "workstations-cluster";
  }
}