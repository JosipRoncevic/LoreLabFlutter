import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lorelabappf/data/models/story_model.dart';

class StoryService {
  final CollectionReference _storiesRef = 
    FirebaseFirestore.instance.collection('stories');

  Future<List<Story>> fetchStories() async {
    var snapshot = await _storiesRef.get();
    return snapshot.docs.map((doc) => Story
      .fromMap(doc.data() as Map<String, dynamic>, doc.id))
      .toList();
  }

  Future<void> addStory(Story story) async {
    await _storiesRef.add({
      ...story.toMap(),
      'createdOn': FieldValue.serverTimestamp(),
      'updatedOn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateStory(Story story) async {
    await _storiesRef.doc(story.id).update({
      ...story.toMap(),
      'updatedOn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteStory(String id) async {
    await _storiesRef.doc(id).delete();
  }
}
