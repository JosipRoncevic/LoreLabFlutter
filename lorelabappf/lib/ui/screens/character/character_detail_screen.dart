import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/ui/screens/character/create_character_screen.dart';
import 'package:lorelabappf/ui/viewmodel/character_viewmodel.dart';
import 'package:provider/provider.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  Future<String> _fetchWorldName(DocumentReference worldRef) async {
    final doc = await worldRef.get();
    return doc.exists ? (doc.data() as Map<String, dynamic>)['name'] ?? 'Unknown World' : 'Unknown World';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatingCharacterScreen(
                    character: character,
                    isEditing: true,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete Character'),
                  content: const Text('Are you sure you want to delete this Character?'),
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
                await context.read<CharacterViewmodel>().deleteCharacter(character.id);
                Navigator.pop(context);
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
              character.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              character.backstory,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: _fetchWorldName(character.worldRef),
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
            const SizedBox(height: 12),
            Text(
              "Created on: ${formatTimestamp(character.createdOn)}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              "Last updated: ${formatTimestamp(character.updatedOn)}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              
            ),
          ],
        ),
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} "
        "${_twoDigits(date.hour)}:${_twoDigits(date.minute)}";
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
