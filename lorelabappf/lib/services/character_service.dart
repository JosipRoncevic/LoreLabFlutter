import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lorelabappf/data/models/character_model.dart';

class CharacterService {
  final CollectionReference _charactersRef = 
    FirebaseFirestore.instance.collection('characters');

  Future<List<Character>> fetchCharacters() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if(userId == null) return [];

    var snapshot = await _charactersRef
      .where('userId', isEqualTo: userId)
      .orderBy('createdOn', descending: true)
      .get();

    return snapshot.docs.map(
      (doc) => Character.fromMap(doc.data() as Map<String, dynamic>, doc.id),
    ).toList();
  }

  Future<void> addCharacter(Character character) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    await _charactersRef.add({
      'name': character.name,
      'backstory': character.backstory,
      'worldId': character.worldRef,
      'userId': userId,
      'createdOn': FieldValue.serverTimestamp(),
      'updatedOn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateCharacter(Character character) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    await _charactersRef.doc(character.id).update({
      'name': character.name,
      'backstory': character.backstory,
      'worldId': character.worldRef,
      'userId': userId,
      'updatedOn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCharacter(String id) async {
    await _charactersRef.doc(id).delete();
  }
}