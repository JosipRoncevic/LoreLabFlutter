import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/screens/character/character_detail_screen.dart';
import 'package:lorelabappf/ui/screens/character/create_character_screen.dart';
import 'package:lorelabappf/ui/viewmodel/character_viewmodel.dart';
import 'package:provider/provider.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterViewmodel>().loadCharacters();
    });

    return Scaffold(
      appBar: AppBar(title: Text('Characters')),
      body: Consumer<CharacterViewmodel>(
        builder: (context, viewModel, child) {
          if (viewModel.characters.isEmpty) {
            return Center(child: Text("No characters found"));
          }
          return ListView.builder(
            itemCount: viewModel.characters.length,
            itemBuilder: (context, index) {
              final character = viewModel.characters[index];
              return ListTile(
                title: Text(character.name),
                subtitle: Text(character.backstory),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterDetailScreen(character: character),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
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
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Delete Character'),
                            content: Text('Are you sure you want to delete "${character.name}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await context.read<CharacterViewmodel>().deleteCharacter(character.id);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}