import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/main_navigation.dart';
import 'package:lorelabappf/ui/viewmodel/world_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorldViewModel()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainNavigation(),
    );
  }
}
