import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/world_model.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/data/models/story_model.dart';
import 'package:lorelabappf/ui/screens/character/character_detail_screen.dart';
import 'package:lorelabappf/ui/screens/story/story_details_screen.dart';
import 'package:lorelabappf/ui/screens/world/create_world_screen.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';
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
                              backgroundColor: CosmicTheme.deepSpace,
                              title: Text(
                                'Delete World',
                                style: CosmicTheme.headingStyle.copyWith(fontSize: 20),
                              ),
                              content: Text(
                                'Are you sure you want to delete "${world.name}"?',
                                style: CosmicTheme.bodyStyle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: CosmicTheme.starWhite.withOpacity(0.7)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: CosmicTheme.deleteRed),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                await context.read<WorldViewModel>().deleteWorld(world.id);
                Navigator.pop(context, true);
              }
            }
          ),
        ],
      ),
      body: Container(
        //decoration: CosmicTheme.backgroundDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(world.name, style: CosmicTheme.headingStyle),
                const SizedBox(height: 12),
                Text(world.description, style: CosmicTheme.bodyStyle),
                const SizedBox(height: 24),

                Text("Characters in this world:", style: CosmicTheme.listTitleStyle),
                const SizedBox(height: 8),
                FutureBuilder<List<Character>>(
                  future: _charactersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: CosmicTheme.galaxyPink);
                    } else if (snapshot.hasError) {
                      return Text("Failed to load characters", style: CosmicTheme.bodyStyle);
                    } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Text("No characters found.", style: CosmicTheme.bodyStyle);
                    } else {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: snapshot.data!
                            .map((character) => GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CharacterDetailScreen(character: character),
                                      ),
                                    );
                                    if (result == true) {
                                      setState(() {
                                        _loadData();
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: CosmicTheme.listItemDecoration2,
                                    child: Text(character.name, style: CosmicTheme.bodyStyle),
                                  ),
                                ))
                            .toList(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),

                Text("Stories in this world:", style: CosmicTheme.listTitleStyle),
                const SizedBox(height: 8),
                FutureBuilder<List<Story>>(
                  future: _storiesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: CosmicTheme.galaxyPink);
                    } else if (snapshot.hasError) {
                      return Text("Failed to load stories", style: CosmicTheme.bodyStyle);
                    } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Text("No stories found.", style: CosmicTheme.bodyStyle);
                    } else {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: snapshot.data!
                            .map((story) => GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => StoryDetailsScreen(story: story),
                                      ),
                                    );
                                    if (result == true) {
                                      setState(() {
                                        _loadData();
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: CosmicTheme.listItemDecoration3,
                                    child: Text(story.title, style: CosmicTheme.bodyStyle),
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
                  style: CosmicTheme.bodyStyle.copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                ),
                Text(
                  "Last updated: ${formatTimestamp(world.updatedOn)}",
                  style: CosmicTheme.bodyStyle.copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                ),
              ],
            ),
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
