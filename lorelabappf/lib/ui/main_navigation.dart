import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/dialogs/create_dialog.dart';
import 'package:lorelabappf/ui/screens/character/characters_screen.dart';
import 'package:lorelabappf/ui/screens/story/story_screen.dart';
import 'package:lorelabappf/ui/screens/world/worlds_screen.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    WorldsScreen(),
    CharactersScreen(),
    StoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: CosmicTheme.backgroundImageDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Image.asset(
              CosmicTheme.logoAsset,
              height: 40,
            ),

          ),
          body: _screens[_selectedIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: _showCreateDialog,
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.public), 
                label: 'Worlds'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person), 
                label: 'Characters'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book), 
                label: 'Stories'
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Worlds';
      case 1:
        return 'Characters';
      case 2:
        return 'Stories';
      default:
        return '';
    }
  }
}