// lib/providers/vet_owner_provider.dart
import 'package:flutter/material.dart';
import 'package:vet/models/vet_owner.dart';
import 'package:vet/services/auth/service_provider.dart';

class VetOwnerProvider with ChangeNotifier {
  VetOwner? _vetOwner;

  VetOwner? get vetOwner => _vetOwner;

  void setVetOwner(VetOwner vetOwner) {
    _vetOwner = vetOwner;
    notifyListeners();
  }
 
  Future<void> fetchVetOwner() async {
    final vetOwner = await ServiceProvider.vetOwnerApiHelper.fetchVetOwner();
    setVetOwner(vetOwner);
  }

  void clearVetOwner() {
    _vetOwner = null;
    notifyListeners();
  }
}
