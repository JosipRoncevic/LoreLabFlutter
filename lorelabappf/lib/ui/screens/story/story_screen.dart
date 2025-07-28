import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/screens/story/create_story_screen.dart';
import 'package:lorelabappf/ui/screens/story/story_details_screen.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';
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
      backgroundColor: Colors.transparent, // Let the cosmic background show through
      //appBar: AppBar(title: Text('Stories')),
      body: Consumer<StoryViewmodel>(
        builder: (context, viewModel, child) {
          if (viewModel.stories.isEmpty) {
            return Center(
              child: Text(
                "No stories found",
                style: CosmicTheme.bodyStyle,
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: viewModel.stories.length,
            itemBuilder: (context, index) {
              final story = viewModel.stories[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: CosmicTheme.listItemDecoration3, // Using blue edge version
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Icon(
                    Icons.book,
                    size: 36,
                    color: CosmicTheme.storyGreen,
                  ),
                  title: Text(
                    story.title,
                    style: CosmicTheme.listTitleStyle,
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      story.content,
                      style: CosmicTheme.listSubtitleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
                        icon: Icon(
                          Icons.edit,
                          color: CosmicTheme.editGreen,
                        ),
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
                                'Delete Story',
                                style: CosmicTheme.headingStyle.copyWith(fontSize: 20),
                              ),
                              content: Text(
                                'Are you sure you want to delete "${story.title}"?',
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
                            await context.read<StoryViewmodel>().deleteStory(story.id);
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