import 'dart:async';
import 'package:basecam/models/equipment.dart';

class EquipmentRepository {
  Stream<List<Equipment>> streamEquipmentsForUser(String userId) async* {
    yield <Equipment>[];
  }

  Future<void> ensureCollectionExists() async {}
}

final equipmentRepo = EquipmentRepository();
