import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/screens/story/create_story_screen.dart';
import 'package:lorelabappf/ui/screens/story/story_details_screen.dart';
import 'package:lorelabappf/ui/viewmodel/story_viewmodel.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryViewmodel>().loadStories();
    });

    return Scaffold(
      appBar: AppBar(title: Text('Stories')),
      body: Consumer<StoryViewmodel>(
        builder: (context, viewModel, child) {
          if (viewModel.stories.isEmpty) {
            return Center(child: Text("No stories found"));
          }
          return ListView.builder(
            itemCount: viewModel.stories.length,
            itemBuilder: (context, index) {
              final story = viewModel.stories[index];
              return ListTile(
                title: Text(story.title),
                subtitle: Text(story.content),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryDetailsScreen(story: story),
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
                            builder: (_) => CreatingStoryScreen(
                              story: story,
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
                            title: Text('Delete Story'),
                            content: Text('Are you sure you want to delete "${story.title}"?'),
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
                          await context.read<StoryViewmodel>().deleteStory(story.id);
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
