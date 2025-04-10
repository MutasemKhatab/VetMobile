import 'package:flutter/material.dart';
import 'package:vet/models/vet.dart';
import 'package:vet/services/api/vet_api_helper.dart';

class VetProvider with ChangeNotifier {
  List<Vet> _vets = [];

  List<Vet> get vets => _vets;

  void setVets(List<Vet> vets) {
    _vets = vets;
    notifyListeners();
  }

  void addVet(Vet vet) async {
    final newVet = await VetApiHelper.addVet(vet);
    _vets.add(newVet);
    notifyListeners();
  }

  void updateVet(Vet vet) async {
    final result = await VetApiHelper.updateVet(vet);
    if (!result) return;
    final index = _vets.indexWhere((element) => element.id == vet.id);
    _vets[index] = vet;
    notifyListeners();
  }

  Future<void> fetchVets() async {
    final vets = await VetApiHelper.fetchVets();
    setVets(vets);
  }

  Future<bool> deleteVet(int id) async {
    final result = await VetApiHelper.deleteVet(id);
    if (!result) return false;
    _vets.removeWhere((element) => element.id == id);
    notifyListeners();
    return true;
  }

  void clearVets() {
    _vets = [];
    notifyListeners();
  }
}
