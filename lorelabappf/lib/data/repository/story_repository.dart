import 'package:lorelabappf/data/models/story_model.dart';
import 'package:lorelabappf/services/story_service.dart';

class StoryRepository {
  final StoryService _service = StoryService();

  Future<List<Story>> getStories(String? userId) => _service.fetchStories(userId);
  Future<void> addStory(Story story) => _service.addStory(story);
  Future<void> updateStory(Story story) => _service.updateStory(story);
  Future<void> deleteStory(String id) => _service.deleteStory(id);
  Future<List<Story>> getStoriesForWorld(String worldRef) => _service.getStoriesForWorld(worldRef);
}
