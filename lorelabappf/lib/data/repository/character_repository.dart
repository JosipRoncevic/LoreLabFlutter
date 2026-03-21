import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/services/character_service.dart';

class CharacterRepository {
  final CharacterService _service = CharacterService();

  Future<List<Character>> getCharacters(String? userId) => _service.fetchCharacters(userId);
  Future<void> addCharacter(Character character) => _service.addCharacter(character);
  Future<void> updateCharacter(Character character) => _service.updateCharacter(character);
  Future<void> deleteCharacter(String id) => _service.deleteCharacter(id);
  Future<List<Character>> getCharacterForWorld(String worldRef) => _service.getCharactersForWorld(worldRef);
  List<DocumentReference> buildCharacterRefs(List<String> ids) => _service.buildCharacterRefs(ids);
}