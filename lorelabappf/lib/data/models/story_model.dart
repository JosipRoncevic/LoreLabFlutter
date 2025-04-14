import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String id;
  final String title;
  final String content;
  final DocumentReference worldRef;
  final List<DocumentReference> characterRefs;

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.worldRef,
    required this.characterRefs,
  });

  factory Story.fromMap(Map<String, dynamic> map, String documentId) {
    return Story(
      id: documentId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      worldRef: map['worldRef'] as DocumentReference,
      characterRefs: (map['charactersRef'] as List<dynamic>)
          .map((ref) => ref as DocumentReference)
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'worldRef': worldRef,
      'charactersRef': characterRefs,
    };
  }
}
