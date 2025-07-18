import 'package:cloud_firestore/cloud_firestore.dart';

class World {
  final String id;
  final String name;
  final String description;
  final Timestamp createdOn;
  final Timestamp updatedOn;
  final String userId;


  World({
    required this.id,
    required this.name,
    required this.description,
    required this.createdOn,
    required this.updatedOn,
    required this.userId
  });

  factory World.fromMap(Map<String, dynamic> map, String documentId){
    return World(
      id: documentId, 
      name: map['name'], 
      description: map['description'],
      createdOn: map['createdOn'] ?? Timestamp.now(),
      updatedOn: map['updatedOn'] ?? Timestamp.now(),
      userId: map['userId'],
    );
  }

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'userId': userId,
    };
  }
}