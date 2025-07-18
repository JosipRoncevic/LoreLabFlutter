import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/world_model.dart';

class WorldService {
  final CollectionReference _worldsRef = 
    FirebaseFirestore.instance.collection('worlds');


Future<List<World>> fetchWorlds() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return [];

  var snapshot = await _worldsRef
      .where('userId', isEqualTo: userId)
      .orderBy('createdOn', descending: true)
      .get();

  return snapshot.docs.map(
    (doc) => World.fromMap(doc.data() as Map<String, dynamic>, doc.id),
  ).toList();
}


  Future<void> addWorld(World world) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  await _worldsRef.add({
    'name': world.name,
    'description': world.description,
    'userId': userId,
    'createdOn': FieldValue.serverTimestamp(),
    'updatedOn': FieldValue.serverTimestamp(),
  });
}


  Future<void> updateWorld(World world) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  await _worldsRef.doc(world.id).update({
    'name': world.name,
    'description': world.description,
    'userId': userId,
    'updatedOn': FieldValue.serverTimestamp(),
  });
}


    Future<void> deleteWorld(String id) async {
      await _worldsRef.doc(id).delete();
    }

}