import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/world_model.dart';
import 'package:lorelabappf/ui/viewmodel/world_viewmodel.dart';
import 'package:provider/provider.dart';
import 'create_world_screen.dart';

class WorldDetailScreen extends StatelessWidget {
  final World world;

  const WorldDetailScreen({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
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
                    isEditing:true
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
                title: Text('Delete World'),
                content: Text('Are you sure you want to delete this world?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
                ],
              ),
            );

            if (confirm == true) {
              await context.read<WorldViewModel>().deleteWorld(world.id);
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
              world.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              world.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
