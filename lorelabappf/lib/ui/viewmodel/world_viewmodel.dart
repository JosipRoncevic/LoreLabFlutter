import 'package:flutter/widgets.dart';
import 'package:lorelabappf/data/repository/world_repository.dart';
import '../../data/models/world_model.dart';

class WorldViewModel extends ChangeNotifier{
  final WorldRepository _repository = WorldRepository();

  List<World> worlds = [];

  Future<void> loadWorlds() async {
    worlds = await _repository.getWorlds();
    notifyListeners();
  }

  Future<void> createWorld({required name, required description, required createdOn, required updatedOn, required userId}) async {
    final newWorld = World(
      id: '',
      name: name,
      description: description,
      createdOn: createdOn,
      updatedOn: updatedOn,
      userId: userId,
    );

    await _repository.addWorld(newWorld);
    await loadWorlds();
  }

  Future<void> updateWorld(World updatedWorld) async {
  await _repository.updateWorld(updatedWorld);
  await loadWorlds();
}

  Future<void> deleteWorld(String id) async {
  await _repository.deleteWorld(id);
  await loadWorlds();
}

}