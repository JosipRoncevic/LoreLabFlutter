import 'package:lorelabappf/services/world_service.dart';
import '../models/world_model.dart';

class WorldRepository {
  final WorldService _service = WorldService();

  Future<List<World>> getWorlds() => _service.fetchWorlds();
  Future<void> addWorld(World world) => _service.addWorld(world);
  Future<void> updateWorld(World world) => _service.updateWorld(world);
  Future<void> deleteWorld(String id) => _service.deleteWorld(id);

}