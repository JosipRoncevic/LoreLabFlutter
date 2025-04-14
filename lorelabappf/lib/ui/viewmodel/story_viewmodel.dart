import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lorelabappf/data/models/story_model.dart';
import 'package:lorelabappf/data/repository/story_repository.dart';

class StoryViewmodel extends ChangeNotifier {
  final StoryRepository _repository = StoryRepository();

  List<Story> stories = [];

  Future<void> loadStories() async {
    stories = await _repository.getStories();
    notifyListeners();
  }

  Future<void> createStory({
    required String title,
    required String content,
    required DocumentReference worldRef,
    required List<DocumentReference> characterRefs,
  }) async {
    final newStory = Story(
      id: '',
      title: title,
      content: content,
      worldRef: worldRef,
      characterRefs: characterRefs,
    );

    await _repository.addStory(newStory);
    await loadStories();
  }

  Future<void> updateStory(Story updatedStory) async {
    await _repository.updateStory(updatedStory);
    await loadStories();
  }

  Future<void> deleteStory(String id) async {
    await _repository.deleteStory(id);
    await loadStories();
  }
}
