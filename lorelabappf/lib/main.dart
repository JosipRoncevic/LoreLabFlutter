import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/authentication/auth_screen.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';
import 'package:lorelabappf/ui/viewmodel/character_viewmodel.dart';
import 'package:lorelabappf/ui/viewmodel/story_viewmodel.dart';
import 'package:lorelabappf/ui/viewmodel/world_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorldViewModel()),
        ChangeNotifierProvider(create: (context) => CharacterViewmodel()),
        ChangeNotifierProvider(create: (context) => StoryViewmodel()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CosmicTheme.themeData,
      home: AuthScreen(),
    );
  }
}