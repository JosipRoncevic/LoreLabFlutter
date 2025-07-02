import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/story_model.dart';
import 'package:lorelabappf/ui/screens/story/create_story_screen.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';
import 'package:lorelabappf/ui/viewmodel/story_viewmodel.dart';
import 'package:provider/provider.dart';

class StoryDetailsScreen extends StatelessWidget {
  final Story story;

  const StoryDetailsScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatingStoryScreen(
                    story: story,
                    isEditing: true,
                  ),
                ),
              );
              if (result == true) {
                Navigator.pop(context, true);
              }
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
                                'Delete Story',
                                style: CosmicTheme.headingStyle.copyWith(fontSize: 20),
                              ),
                              content: Text(
                                'Are you sure you want to delete "${story.title}"?',
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
                await context.read<StoryViewmodel>().deleteStory(story.id);
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: Container(
        //decoration: CosmicTheme.backgroundDecoration,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(story.title, style: CosmicTheme.headingStyle),
              const SizedBox(height: 12),
              Text(story.content, style: CosmicTheme.bodyStyle),
              const SizedBox(height: 12),
              FutureBuilder<String>(
                future: _fetchWorldName(story.worldRef),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading world...", style: CosmicTheme.bodyStyle);
                  } else if (snapshot.hasError) {
                    return const Text("Error loading world", style: CosmicTheme.bodyStyle);
                  } else {
                    return Text("World: ${snapshot.data}", style: CosmicTheme.listTitleStyle);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text("Characters:", style: CosmicTheme.listTitleStyle),
              const SizedBox(height: 8),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchCharacterNamesWithValidation(story.characterRefs, story.worldRef),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: CosmicTheme.galaxyPink);
                  } else if (snapshot.hasError) {
                    return const Text("Failed to load characters", style: CosmicTheme.bodyStyle);
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Text("No characters associated with this story.", style: CosmicTheme.bodyStyle);
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: snapshot.data!.map((char) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: CosmicTheme.listItemDecoration2,
                              child: Text(char['name'], style: CosmicTheme.bodyStyle),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        if (snapshot.data!.any((c) => c['isMismatch'] == true))
                          Text(
                            "⚠ Some characters are not in the same world as this story.",
                            style: CosmicTheme.bodyStyle.copyWith(
                              color: Colors.red.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                "Created on: ${formatTimestamp(story.createdOn)}",
                style: CosmicTheme.bodyStyle.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
              Text(
                "Last updated: ${formatTimestamp(story.updatedOn)}",
                style: CosmicTheme.bodyStyle.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _fetchWorldName(DocumentReference worldRef) async {
    final doc = await worldRef.get();
    return doc.exists ? (doc.data() as Map<String, dynamic>)['name'] ?? 'Unknown World' : 'Unknown World';
  }

  Future<List<Map<String, dynamic>>> _fetchCharacterNamesWithValidation(
      List<DocumentReference> refs, DocumentReference storyWorldRef) async {
    final characters = <Map<String, dynamic>>[];

    for (final ref in refs) {
      final doc = await ref.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final name = data['name'] ?? 'Unnamed';
        final characterWorldRef = data['worldId'];

        final isMismatch = characterWorldRef?.path != storyWorldRef.path;

        characters.add({
          'name': name,
          'isMismatch': isMismatch,
        });
      }
    }
    return characters;
  }

  String formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} "
        "${_twoDigits(date.hour)}:${_twoDigits(date.minute)}";
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
