import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learnfirebase_app/Page/ShowUser.dart';
void main()async{
  //Learn
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShowScreen(),
    );
  }
}
