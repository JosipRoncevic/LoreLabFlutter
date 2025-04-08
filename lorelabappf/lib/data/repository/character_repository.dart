import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/services/character_service.dart';

class CharacterRepository {
  final CharacterService _service = CharacterService();

  Future<List<Character>> getCharacters() => _service.fetchCharacters();
  Future<void> addCharacter(Character character) => _service.addCharacter(character);
  Future<void> updateCharacter(Character character) => _service.updateCharacter(character);
  Future<void> deleteCharacter(String id) => _service.deleteCharacter(id);

}