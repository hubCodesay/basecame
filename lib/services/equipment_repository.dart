import 'dart:async';

import 'package:basecam/models/equipment.dart';

class EquipmentRepository {
  final List<Equipment> _store = [];

  Stream<List<Equipment>> streamEquipment() async* {
    yield _store;
  }

  Future<void> addEquipment(Equipment e) async {
    _store.add(e);
  }
}

final equipmentRepo = EquipmentRepository();
