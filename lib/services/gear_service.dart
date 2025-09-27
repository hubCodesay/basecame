import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gear.dart';

class GearService {
  final CollectionReference<Map<String, dynamic>> _gearCol = FirebaseFirestore
      .instance
      .collection('gear');

  /// Create a new gear document. Returns the new doc id.
  Future<String> createGear(Gear gear) async {
    final data = gear.toMap(setServerTimestamps: true);
    final docRef = await _gearCol.add(data);
    // update the document with its own id in mapPointId so UI and map
    // features can reference it. Use the generated docRef.id.
    await docRef.set({'mapPointId': docRef.id}, SetOptions(merge: true));
    return docRef.id;
  }

  /// Update an existing gear document. Requires gear.id to be set.
  Future<void> updateGear(Gear gear) async {
    if (gear.id == null || gear.id!.isEmpty) {
      throw ArgumentError('gear.id is required to update');
    }
    final docRef = _gearCol.doc(gear.id);
    final data = gear.toMap(setServerTimestamps: true);
    await docRef.set(data, SetOptions(merge: true));
  }

  /// Simple fetch by id
  Future<Gear?> getGearById(String id) async {
    final doc = await _gearCol.doc(id).get();
    if (!doc.exists) return null;
    return Gear.fromDoc(doc);
  }
}
