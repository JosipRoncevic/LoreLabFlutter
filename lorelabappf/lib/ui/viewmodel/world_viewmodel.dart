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

  Future<void> createWorld(String name, String description) async {
    final newWorld = World(
      id: '',
      name: name,
      description: description,
    );

    await _repository.addWorld(newWorld);
    await loadWorlds();
  }
}