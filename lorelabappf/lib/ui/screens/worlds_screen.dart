import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/world_viewmodel.dart';

class WorldsScreen extends StatelessWidget {
  const WorldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<WorldViewModel>().loadWorlds(); 

    return Consumer<WorldViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.worlds.isEmpty) {
          return Center(child: Text("No worlds found"));
        }
        return ListView.builder(
          itemCount: viewModel.worlds.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(viewModel.worlds[index].name),
              subtitle: Text(viewModel.worlds[index].description),
            );
          },
        );
      },
    );
  }
}