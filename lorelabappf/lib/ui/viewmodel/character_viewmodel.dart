import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/data/repository/character_repository.dart';

class CharacterViewmodel extends ChangeNotifier{
  final CharacterRepository _repository = CharacterRepository();

  List<Character> characters = [];

  Future<void> loadCharacters() async {
    characters = await _repository.getCharacters();
    notifyListeners();
  }

  Future<void> createCharacter( {
    required String name,
    required String backstory,
    required DocumentReference worldRef,
    required Timestamp createdOn,
    required Timestamp updatedOn,
  }) 
  async {
    final newCharacter = Character(
      id: '',
      name: name,
      backstory: backstory,
      worldRef: worldRef,
      createdOn: createdOn,
      updatedOn: updatedOn
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

}