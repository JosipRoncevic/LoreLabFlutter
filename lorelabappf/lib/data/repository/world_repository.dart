import 'package:lorelabappf/services/world_service.dart';
import '../models/world_model.dart';

class WorldRepository {
  final WorldService _service = WorldService();

  Future<List<World>> getWorlds() => _service.fetchWorlds();
  Future<void> addWorld(World world) => _service.addWorld(world);
}