import 'package:cloud_firestore/cloud_firestore.dart';

class Character {
  final String id;
  final String name;
  final String backstory;
  final DocumentReference worldRef;
  final Timestamp createdOn;
  final Timestamp updatedOn;

  Character({
    required this.id,
    required this.name,
    required this.backstory,
    required this.worldRef,
    required this.createdOn,
    required this.updatedOn,
  });

  factory Character.fromMap(Map<String, dynamic> map, String documentId){
    return Character(
      id: documentId, 
      name: map['name'], 
      backstory: map['backstory'],
      worldRef: map['worldId'],
      createdOn: map['createdOn'] ?? Timestamp.now(),
      updatedOn: map['updatedOn'] ?? Timestamp.now(),
    );
  }

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'backstory': backstory,
      'worldId': worldRef,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}