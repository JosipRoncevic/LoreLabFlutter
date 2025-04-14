import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/screens/character/create_character_screen.dart';
import 'package:lorelabappf/ui/screens/story/create_story_screen.dart';
import 'package:lorelabappf/ui/screens/world/create_world_screen.dart';

class CreateDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create New"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.public),
            title: Text("World"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatingWorldsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Character"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatingCharacterScreen(),
                ),
              );
            },
          ),
           ListTile(
            leading: Icon(Icons.book),
            title: Text("Story"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatingStoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}