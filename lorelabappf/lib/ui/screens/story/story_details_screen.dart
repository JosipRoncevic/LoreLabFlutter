import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/story_model.dart';
import 'package:lorelabappf/ui/screens/story/create_story_screen.dart';
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
              if (result == true){
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
                  title: const Text('Delete Story'),
                  content: const Text('Are you sure you want to delete this Story?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              story.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              story.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: _fetchWorldName(story.worldRef),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading world...");
                } else if (snapshot.hasError) {
                  return const Text("Error loading world");
                } else {
                  return Text(
                    "World: ${snapshot.data}",
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              "Characters:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchCharacterNamesWithValidation(story.characterRefs, story.worldRef),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text("Failed to load characters");
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Text("No characters associated with this story.");
                } else {
                  return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: snapshot.data!.map((char) {
                    final isMismatch = char['isMismatch'] == true;
                    return Chip(
                    label: Text(char['name']),
                    backgroundColor: isMismatch ? Colors.red.shade100 : Colors.blue.shade100,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                if (snapshot.data!.any((c) => c['isMismatch'] == true))
                  Text(
                    "⚠ Some characters are not in the same world as this story.",
                    style: TextStyle(color: Colors.red.shade700, fontStyle: FontStyle.italic),
                  ),
                ],
              );
            }
          },
        ),

            const SizedBox(height: 12),
            Text(
              "Created on: ${formatTimestamp(story.createdOn)}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              "Last updated: ${formatTimestamp(story.updatedOn)}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              
            ),
          ],
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
