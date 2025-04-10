import 'package:flutter/material.dart';
import 'package:vet/models/vaccine.dart';
import 'package:vet/services/api/vaccine_api_helper.dart';

class VaccineProvider with ChangeNotifier {
  final Map<int, List<Vaccine>> _vaccines = {}; // vetId -> List of vaccines

  List<Vaccine> getVaccinesForVet(int vetId) {
    return _vaccines[vetId] ?? [];
  }

  Future<void> fetchVaccinesForVet(int vetId) async {
    final vaccines = await VaccineApiHelper.fetchVaccines(vetId);
    _vaccines[vetId] = vaccines;
    notifyListeners();
  }
}
