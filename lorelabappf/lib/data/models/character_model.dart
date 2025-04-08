import 'package:cloud_firestore/cloud_firestore.dart';

class Character {
  final String id;
  final String name;
  final String backstory;
  final DocumentReference worldRef;

  Character({
    required this.id,
    required this.name,
    required this.backstory,
    required this.worldRef,
  });

  factory Character.fromMap(Map<String, dynamic> map, String documentId){
    return Character(
      id: documentId, 
      name: map['name'], 
      backstory: map['backstory'],
      worldRef: map['worldId'],
    );
  }

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'backstory': backstory,
      'worldId': worldRef,
    };
  }
}