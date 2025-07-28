import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/screens/world/create_world_screen.dart';
import 'package:lorelabappf/ui/screens/world/world_detail_screen.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/world_viewmodel.dart';

class WorldsScreen extends StatelessWidget {
  const WorldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorldViewModel>().loadWorlds();
    });

    return Scaffold(
      backgroundColor: Colors.transparent, // Let the cosmic background show through
      //appBar: AppBar(title: Text('Worlds')),
      body: Consumer<WorldViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.worlds.isEmpty) {
            return Center(
              child: Text(
                "No worlds found",
                style: CosmicTheme.bodyStyle,
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: viewModel.worlds.length,
            itemBuilder: (context, index) {
              final world = viewModel.worlds[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: CosmicTheme.listItemDecoration,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Icon(
                    Icons.public,
                    size: 36,
                    color: CosmicTheme.galaxyPink,
                  ),
                  title: Text(
                    world.name,
                    style: CosmicTheme.listTitleStyle,
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      world.description,
                      style: CosmicTheme.listSubtitleStyle,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorldDetailScreen(world: world),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: CosmicTheme.editGreen,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreatingWorldsScreen(
                                world: world,
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