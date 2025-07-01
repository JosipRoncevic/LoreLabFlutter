import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/screens/character/create_character_screen.dart';
import 'package:lorelabappf/ui/screens/story/create_story_screen.dart';
import 'package:lorelabappf/ui/screens/world/create_world_screen.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';

class CreateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: CosmicTheme.backgroundDecoration.copyWith(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: CosmicTheme.galaxyPink.withOpacity(0.3),
              blurRadius: 16,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Create New",
              style: CosmicTheme.headingStyle,
            ),
            const SizedBox(height: 16),
            _buildOption(
              context,
              icon: Icons.public,
              label: "World",
              decoration: CosmicTheme.listItemDecoration,
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
            const SizedBox(height: 8),
            _buildOption(
              context,
              icon: Icons.person,
              label: "Character",
              decoration: CosmicTheme.listItemDecoration2,
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
            const SizedBox(height: 8),
            _buildOption(
              context,
              icon: Icons.book,
              label: "Story",
              decoration: CosmicTheme.listItemDecoration3,
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
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required BoxDecoration decoration,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: decoration,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: CosmicTheme.starWhite),
            SizedBox(width: 16),
            Text(label, style: CosmicTheme.bodyStyle),
          ],
        ),
      ),
    );
  }
}
