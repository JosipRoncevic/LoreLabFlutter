import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:lorelabappf/data/repository/world_repository.dart';
import '../../data/models/world_model.dart';

class WorldViewModel extends ChangeNotifier {
  final WorldRepository _repository;

  WorldViewModel(this._repository);

  List<World> worlds = [];

  bool isLoading = false;

  Future<void> loadWorlds() async {
  isLoading = true;
  notifyListeners();

  worlds = await _repository.getWorlds();

  isLoading = false;
  notifyListeners();
}

  Future<void> createWorld({
  required String name,
  required String description,
  required Timestamp createdOn,
  required Timestamp updatedOn,
  required String userId,
}) async {
      final now = Timestamp.now();

  final newWorld = World(
    id: '',
    name: name,
    description: description,
    createdOn: now,
    updatedOn: now,
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