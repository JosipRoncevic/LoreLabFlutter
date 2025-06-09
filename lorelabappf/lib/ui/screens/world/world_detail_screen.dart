import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/world_model.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/data/models/story_model.dart';
import 'package:lorelabappf/ui/screens/character/character_detail_screen.dart';
import 'package:lorelabappf/ui/screens/story/story_details_screen.dart';
import 'package:lorelabappf/ui/screens/world/create_world_screen.dart';
import 'package:lorelabappf/ui/viewmodel/world_viewmodel.dart';
import 'package:provider/provider.dart';

class WorldDetailScreen extends StatefulWidget {
  final World world;

  const WorldDetailScreen({super.key, required this.world});

  @override
  State<WorldDetailScreen> createState() => _WorldDetailScreenState();
}

class _WorldDetailScreenState extends State<WorldDetailScreen> {
  late Future<List<Character>> _charactersFuture;
  late Future<List<Story>> _storiesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
  final worldRef = FirebaseFirestore.instance.collection('worlds').doc(widget.world.id);
  setState(() {
    _charactersFuture = _fetchCharacters(worldRef);
    _storiesFuture = _fetchStories(worldRef);
  });
}

  @override
  Widget build(BuildContext context) {
    final world = widget.world;

    return Scaffold(
      appBar: AppBar(
        title: Text(world.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatingWorldsScreen(
                    world: world,
                    isEditing: true,
                  ),
                ),
              ).then((_) {
                _loadData();
                setState(() {});
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete World'),
                  content:
                      const Text('Are you sure you want to delete this world?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete')),
                  ],
                ),
              );

              if (confirm == true) {
                await context.read<WorldViewModel>().deleteWorld(world.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(world.name,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(world.description,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              Text("Characters in this world:",
                  style: Theme.of(context).textTheme.titleMedium),
              FutureBuilder<List<Character>>(
                future: _charactersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Failed to load characters");
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Text("No characters found.");
                  } else {
                    return Wrap(
                      spacing: 8,
                      children: snapshot.data!
                          .map((character) => GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CharacterDetailScreen(
                                          character: character),
                                    ),
                                  );
                                  if (result == true){
                                    setState(() {
                                      _loadData();
                                    });
                                  }
                                },
                                child: Chip(
                                  label: Text(character.name),
                                  backgroundColor: Colors.blue.shade100,
                                ),
                              ))
                          .toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              Text("Stories in this world:",
                  style: Theme.of(context).textTheme.titleMedium),
              FutureBuilder<List<Story>>(
                future: _storiesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Failed to load stories");
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Text("No stories found.");
                  } else {
                    return Wrap(
                      spacing: 8,
                      children: snapshot.data!
                          .map((story) => GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          StoryDetailsScreen(story: story),
                                    ),
                                  );

                                  if (result == true) {
                                    setState(() {
                                      _loadData();
                                    });
                                    
                                  }
                                },
                                child: Chip(
                                  label: Text(story.title),
                                  backgroundColor: Colors.green.shade100,
                                ),
                              ))
                          .toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                "Created on: ${formatTimestamp(world.createdOn)}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
              Text(
                "Last updated: ${formatTimestamp(world.updatedOn)}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Character>> _fetchCharacters(DocumentReference worldRef) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('characters')
        .where('worldId', isEqualTo: worldRef)
        .get();

    return querySnapshot.docs
        .map((doc) => Character.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<Story>> _fetchStories(DocumentReference worldRef) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('stories')
        .where('worldRef', isEqualTo: worldRef)
        .get();

    return querySnapshot.docs
        .map((doc) => Story.fromMap(doc.data(), doc.id))
        .toList();
  }

  String formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} "
        "${_twoDigits(date.hour)}:${_twoDigits(date.minute)}";
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
