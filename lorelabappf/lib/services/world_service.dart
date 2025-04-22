import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/world_model.dart';

class WorldService {
  final CollectionReference _worldsRef = 
    FirebaseFirestore.instance.collection('worlds');

  Future<List<World>> fetchWorlds() async {
    var snapshot = await _worldsRef.get();
    return snapshot.docs.map((doc) => World
      .fromMap(doc.data() as Map<String,dynamic>, doc.id))
      .toList();
  }

  Future<void> addWorld(World world) async {
    await _worldsRef.add({
      ...world.toMap(),
      'createdOn': FieldValue.serverTimestamp(),
      'updatedOn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateWorld(World world) async {
    await _worldsRef.doc(world.id).update({
      ...world.toMap(),
      'updatedOn': FieldValue.serverTimestamp(),
    });
}

    Future<void> deleteWorld(String id) async {
      await _worldsRef.doc(id).delete();
    }

}