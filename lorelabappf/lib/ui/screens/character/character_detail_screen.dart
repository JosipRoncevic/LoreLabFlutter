import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/ui/screens/character/create_character_screen.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';
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
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatingCharacterScreen(
                    character: character,
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
                                'Delete Character',
                                style: CosmicTheme.headingStyle.copyWith(fontSize: 20),
                              ),
                              content: Text(
                                'Are you sure you want to delete "${character.name}"?',
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
                await context.read<CharacterViewmodel>().deleteCharacter(character.id);
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: Container(
        // decoration: CosmicTheme.backgroundDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(character.name, style: CosmicTheme.headingStyle),
                const SizedBox(height: 12),

                Text(character.backstory, style: CosmicTheme.bodyStyle),
                const SizedBox(height: 24),

                FutureBuilder<String>(
                  future: _fetchWorldName(character.worldRef),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: CosmicTheme.galaxyPink);
                    } else if (snapshot.hasError) {
                      return Text("Error loading world", style: CosmicTheme.bodyStyle);
                    } else {
                      return Text("World: ${snapshot.data}", style: CosmicTheme.listTitleStyle);
                    }
                  },
                ),
                const SizedBox(height: 24),

                Text(
                  "Created on: ${formatTimestamp(character.createdOn)}",
                  style: CosmicTheme.bodyStyle.copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                ),
                Text(
                  "Last updated: ${formatTimestamp(character.updatedOn)}",
                  style: CosmicTheme.bodyStyle.copyWith(fontStyle: FontStyle.italic, fontSize: 14),
                ),
              ],
            ),
          ),
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
