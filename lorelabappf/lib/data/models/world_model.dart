class World {
  final String id;
  final String name;
  final String description;

  World({
    required this.id,
    required this.name,
    required this.description,
  });

  factory World.fromMap(Map<String, dynamic> map, String documentId){
    return World(
      id: documentId, 
      name: map['name'], 
      description: map['description'],
    );
  }

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }
}