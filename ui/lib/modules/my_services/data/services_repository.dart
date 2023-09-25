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

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../catalog/data/build_repository.dart';
import '../../catalog/data/build_service.dart';
import '../models/service.dart';
import 'package:cloudprovision/modules/auth/repositories/auth_provider.dart';
import 'package:cloudprovision/modules/auth/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'services_repository.g.dart';

class ServicesRepository {
  final FirebaseFirestore firestore;
  final String userId;
  final CollectionReference<Map<String, dynamic>> _servicesRef;

  ServicesRepository(this.firestore, this.userId)
      : _servicesRef = firestore.collection('users/$userId/services');

  Future<List<Service>> loadServices() async {
    var querySnapshot =
        await _servicesRef.orderBy('deploymentDate', descending: true).get();
    var entries = querySnapshot.docs
        .map((doc) => Service.fromJson(doc.data())..id = doc.id)
        .toList();

    return entries;
  }

  // Get by firestore docID
  Future<Service> get(String id) async {
    var document = _servicesRef.doc(id);
    var snapshot = await document.get();
    return Service.fromJson(snapshot.data()!)..id = snapshot.id;
  }

  // Get by Service ID
  Future<Service> getByServiceID(String serviceId) async {
    var snapshot =
        await _servicesRef.where("serviceId", isEqualTo: serviceId).get();
    var docData = snapshot.docs.first.data();
    return Service.fromJson(docData);
  }

  Future<Service> addService(Service deployedService) async {
    var document = await _servicesRef.add(deployedService.toJson());
    return await get(document.id);
  }

  Future<void> deleteService(Service service) async {
    var document = await _servicesRef.doc(service.id);
    if (document != null)
      await document.delete();
    else
      print("Service not found");
  }
}

// ServicesRepositoryProvider
@riverpod
ServicesRepository servicesRepository(ServicesRepositoryRef ref) {
  final AuthRepository authRepo = ref.read(authRepositoryProvider);
  return ServicesRepository(
      FirebaseFirestore.instance, authRepo.currentUser()!.uid);
}

// ServicesProvider
@riverpod
Future<List<Service>> services(ServicesRef ref) {
  final servicesRepository = ref.watch(servicesRepositoryProvider);
  return servicesRepository.loadServices();
}

// ServiceByDocIdProvider
@riverpod
Future<Service> serviceByDocId(ServiceByDocIdRef ref, String serviceDocId) {
  final servicesRepository = ref.watch(servicesRepositoryProvider);
  final result = servicesRepository.get(serviceDocId);
  return result;
}
