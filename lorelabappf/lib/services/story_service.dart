import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lorelabappf/data/models/story_model.dart';

class StoryService {
  final CollectionReference _storiesRef = 
    FirebaseFirestore.instance.collection('stories');

  Future<List<Story>> fetchStories() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if(userId == null) return [];

    var snapshot = await _storiesRef
      .where('userId', isEqualTo: userId)
      .orderBy('createdOn', descending: true)
      .get();
    
    return snapshot.docs.map(
      (doc) => Story.fromMap(doc.data() as Map<String, dynamic>, doc.id),
    ).toList();
  }

  Future<void> addStory(Story story) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    await _storiesRef.add({
      'title': story.title,
      'content': story.content,
      'worldId': story.worldRef,
      'characterRefs': story.characterRefs,
      'userId': userId,
      'createdOn': FieldValue.serverTimestamp(),
      'updatedOn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateStory(Story story) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    await _storiesRef.doc(story.id).update({
      'title': story.title,
      'content': story.content,
      'worldId': story.worldRef,
      'characterRefs': story.characterRefs,
      'userId': userId,
      'updatedOn': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteStory(String id) async {
    await _storiesRef.doc(id).delete();
  }
}
