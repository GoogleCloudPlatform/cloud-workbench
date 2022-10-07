import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudprovision/repository/models/git_settings.dart';
import 'package:cloudprovision/repository/models/service.dart';
import 'package:cloudprovision/repository/service/base_service.dart';

class FirebaseService extends BaseService {
  final FirebaseFirestore firestore;
  final String userId;
  final CollectionReference<Map<String, dynamic>> _servicesRef;
  final CollectionReference<Map<String, dynamic>> _gitSettingsRef;

  FirebaseService(this.firestore, this.userId)
      : _servicesRef = firestore.collection('users/$userId/services'),
        _gitSettingsRef = firestore.collection('users/$userId/settings');

  Future<List<Service>> loadServices() async {
    var querySnapshot = await _servicesRef.get();
    var entries = querySnapshot.docs
        .map((doc) => Service.fromJson(doc.data())..id = doc.id)
        .toList();

    return entries;
  }

  Future<Service> get(String id) async {
    var document = _servicesRef.doc(id);
    var snapshot = await document.get();
    return Service.fromJson(snapshot.data()!)..id = snapshot.id;
  }

  Future<Service> addService(Service deployedService) async {
    var document = await _servicesRef.add(deployedService.toJson());

    return await get(document.id);
  }

  Future<GitSettings> loadGitSettings() async {
    var document = _gitSettingsRef.doc('/git');
    var snapshot = await document.get();

    if (!snapshot.exists) {
      await document.set({
        'instanceGitUsername': "",
        'instanceGitToken': "",
        'customerTemplateGitRepository': "",
        'gcpApiKey': "",
        'updatedDate': FieldValue.serverTimestamp(),
        'createdDate': FieldValue.serverTimestamp(),
      });

      document = _gitSettingsRef.doc("git");
      snapshot = await document.get();
    }

    return GitSettings.fromJson(snapshot.data()!)..id = snapshot.id;
  }

  updateGitSettings(GitSettings gitSettings) async {
    var document = _gitSettingsRef.doc('/git');
    var snapshot = await document.get();

    await document.set({
      'instanceGitUsername': gitSettings.instanceGitUsername,
      'instanceGitToken': gitSettings.instanceGitToken,
      'customerTemplateGitRepository':
          gitSettings.customerTemplateGitRepository,
      'gcpApiKey': gitSettings.gcpApiKey,
      'updatedDate': FieldValue.serverTimestamp(),
      'createdDate': snapshot.exists
          ? snapshot.get("createdDate")
          : FieldValue.serverTimestamp(),
    });

    document = _gitSettingsRef.doc("git");
    snapshot = await document.get();

    return GitSettings.fromJson(snapshot.data()!)..id = snapshot.id;
  }
}
