import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/data/repository/character_repository.dart';

class CharacterViewmodel extends ChangeNotifier{
  final CharacterRepository _repository;

  CharacterViewmodel(this._repository);

  List<Character> characters = [];

  bool isLoading = false;

  Future<void> loadCharacters() async {
    isLoading = true;
    notifyListeners();
    characters = await _repository.getCharacters();
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

}