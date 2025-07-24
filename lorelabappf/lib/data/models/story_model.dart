import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String id;
  final String title;
  final String content;
  final DocumentReference worldRef;
  final List<DocumentReference> characterRefs;
  final Timestamp createdOn;
  final Timestamp updatedOn;
  final String userId;

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.worldRef,
    required this.characterRefs,
    required this.createdOn,
    required this.updatedOn,
    required this.userId,
  });

  factory Story.fromMap(Map<String, dynamic> map, String documentId) {
    return Story(
      id: documentId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      worldRef: map['worldId'] as DocumentReference,
      characterRefs: (map['characterRefs'] as List<dynamic>)
          .map((ref) => ref as DocumentReference)
          .toList(),
      createdOn: map['createdOn'] ?? Timestamp.now(),
      updatedOn: map['updatedOn'] ?? Timestamp.now(),
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'worldRef': worldRef,
      'characterRefs': characterRefs,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'userId': userId,
    };
  }
}
