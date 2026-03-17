import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/authentication/auth_gate.dart';
import 'package:lorelabappf/data/repository/character_repository.dart';
import 'package:lorelabappf/data/repository/story_repository.dart';
import 'package:lorelabappf/data/repository/world_repository.dart';
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
        ChangeNotifierProvider(create: (context) => WorldViewModel(WorldRepository())),
        ChangeNotifierProvider(create: (context) => CharacterViewmodel(CharacterRepository())),
        ChangeNotifierProvider(create: (context) => StoryViewmodel(StoryRepository())),
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
      home: AuthGate(),
    );
  }
}