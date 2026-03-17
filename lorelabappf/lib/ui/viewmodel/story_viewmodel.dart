import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lorelabappf/data/models/story_model.dart';
import 'package:lorelabappf/data/repository/story_repository.dart';

class StoryViewmodel extends ChangeNotifier {
  final StoryRepository _repository;
  StoryViewmodel(this._repository);

  List<Story> stories = [];

  bool isLoading = false;

  Future<void> loadStories() async {
    isLoading = true;
    notifyListeners();
    stories = await _repository.getStories();
    isLoading = false;
    notifyListeners();
    
  }

  Future<void> createStory({
    required String title,
    required String content,
    DocumentReference? worldRef,
    required List<DocumentReference> characterRefs,
    required String userId,
    required Timestamp createdOn,
    required Timestamp updatedOn,
  }) async {
    final now = Timestamp.now();
    final newStory = Story(
      id: '',
      title: title,
      content: content,
      worldRef: worldRef,
      characterRefs: characterRefs,
      userId: userId,
      createdOn: now,
      updatedOn: now
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
  Future<List<Story>> loadStoriesForWorld(String worldRef) async {
  return await _repository.getStoriesForWorld(worldRef);
}
}
