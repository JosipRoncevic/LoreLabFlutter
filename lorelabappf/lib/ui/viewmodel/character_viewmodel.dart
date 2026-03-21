import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/data/repository/character_repository.dart';

class CharacterViewmodel extends ChangeNotifier{
  final CharacterRepository _repository;

  CharacterViewmodel(this._repository);

  List<Character> characters = [];

  bool isLoading = false;
  final userId = FirebaseAuth.instance.currentUser?.uid;


  Future<void> loadCharacters() async {
    isLoading = true;
    notifyListeners();
    characters = await _repository.getCharacters(userId);
    isLoading = false;
    notifyListeners();

  }

  Future<void> createCharacter( {
    required String name,
    required String backstory,
    DocumentReference? worldRef,
    required Timestamp createdOn,
    required Timestamp updatedOn,
    required String userId,
  }) 
  async {
    final now = Timestamp.now();
    final newCharacter = Character(
      id: '',
      name: name,
      backstory: backstory,
      worldRef: worldRef,
      createdOn: now,
      updatedOn: now,
      userId: userId,
    );
    await _repository.addCharacter(newCharacter);
    await loadCharacters();
  }

  Future<void> updateCharacter(Character updatedCharacter) async {
    await _repository.updateCharacter(updatedCharacter);
    await loadCharacters();
}

  Future<void> deleteCharacter(String id) async {
    await _repository.deleteCharacter(id);
    await loadCharacters();
  }

  Future<List<Character>> loadCharactersForWorld(String worldRef) async {
  return await _repository.getCharacterForWorld(worldRef);
}

Future<String> getWorldName(DocumentReference? worldRef) async {
  if (worldRef == null) return "No World";

  final doc = await worldRef.get();
  if (!doc.exists) return "Unknown World";

  final data = doc.data() as Map<String, dynamic>;
  return data['name'] ?? "Unknown World";
}

  List<DocumentReference> buildCharacterRefs(List<String> ids) {
  return _repository.buildCharacterRefs(ids);
}

}