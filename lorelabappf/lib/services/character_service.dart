import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lorelabappf/data/models/character_model.dart';

class CharacterService {
  final CollectionReference _charactersRef = 
    FirebaseFirestore.instance.collection('characters');

  Future<List<Character>> fetchCharacters() async {
    var snapshot = await _charactersRef.get();
    return snapshot.docs.map((doc) => Character
      .fromMap(doc.data() as Map<String,dynamic>, doc.id))
      .toList();
  }

  Future<void> addCharacter(Character character) async {
    await _charactersRef.add(character.toMap());
  }

  Future<void> updateCharacter(Character character) async {
    await _charactersRef.doc(character.id).update(character.toMap());
  }

  Future<void> deleteCharacter(String id) async {
    await _charactersRef.doc(id).delete();
  }

}