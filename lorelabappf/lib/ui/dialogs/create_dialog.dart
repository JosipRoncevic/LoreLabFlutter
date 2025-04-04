import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/screens/create_world_screen.dart';

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
              print("Creating Character...");
            },
          ),
           ListTile(
            leading: Icon(Icons.book),
            title: Text("Story"),
            onTap: () {
              Navigator.pop(context);
              print("Creating Story...");
            },
          ),
        ],
      ),
    );
  }
}