import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/screens/character/character_detail_screen.dart';
import 'package:lorelabappf/ui/screens/character/create_character_screen.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';
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
      backgroundColor: Colors.transparent, // Let the cosmic background show through
      appBar: AppBar(title: Text('Characters')),
      body: Consumer<CharacterViewmodel>(
        builder: (context, viewModel, child) {
          if (viewModel.characters.isEmpty) {
            return Center(
              child: Text(
                "No characters found",
                style: CosmicTheme.bodyStyle,
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: viewModel.characters.length,
            itemBuilder: (context, index) {
              final character = viewModel.characters[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: CosmicTheme.listItemDecoration2, // Using blue edge version
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    character.name,
                    style: CosmicTheme.listTitleStyle,
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      character.backstory,
                      style: CosmicTheme.listSubtitleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
                        icon: Icon(
                          Icons.edit,
                          color: CosmicTheme.editGreen                        ),
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
                        icon: Icon(
                          Icons.delete,
                          color: CosmicTheme.deleteRed,
                        ),
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
                                    style: TextStyle(color: CosmicTheme.galaxyPink),
                                  ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}