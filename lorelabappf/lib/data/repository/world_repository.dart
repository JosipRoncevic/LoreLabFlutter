import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/world_model.dart';
import '../services/world_service.dart';

class WorldRepository {
  final WorldService _service = WorldService();

  Future<List<World>> getWorlds() => _service.fetchWorlds();
  Future<void> addWorld(World world) => _service.addWorld(world);
  Future<void> updateWorld(World world) => _service.updateWorld(world);
  Future<void> deleteWorld(String id) => _service.deleteWorld(id);
  DocumentReference getWorldReference(String worldId) {
  return _service.getWorldReference(worldId);
}
}