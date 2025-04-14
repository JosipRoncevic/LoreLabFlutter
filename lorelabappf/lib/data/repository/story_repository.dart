import 'package:lorelabappf/data/models/story_model.dart';
import 'package:lorelabappf/services/story_service.dart';

class StoryRepository {
  final StoryService _service = StoryService();

  Future<List<Story>> getStories() => _service.fetchStories();
  Future<void> addStory(Story story) => _service.addStory(story);
  Future<void> updateStory(Story story) => _service.updateStory(story);
  Future<void> deleteStory(String id) => _service.deleteStory(id);
}
