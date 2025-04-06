import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/screens/create_world_screen.dart';
import 'package:lorelabappf/ui/screens/world_detail_screen.dart';
import 'package:provider/provider.dart';

import '../viewmodel/world_viewmodel.dart';

class WorldsScreen extends StatelessWidget {
  const WorldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorldViewModel>().loadWorlds();
    });

    return Scaffold(
      appBar: AppBar(title: Text('Worlds')),
      body: Consumer<WorldViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.worlds.isEmpty) {
            return Center(child: Text("No worlds found"));
          }
          return ListView.builder(
            itemCount: viewModel.worlds.length,
            itemBuilder: (context, index) {
              final world = viewModel.worlds[index];
              return ListTile(
                title: Text(world.name),
                subtitle: Text(world.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorldDetailScreen(world: world),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.edit),
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
              );
            },
          );
        },
      ),
    );
  }
}