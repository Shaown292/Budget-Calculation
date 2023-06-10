import 'package:calculating_budget/response_handler.dart';
import 'package:calculating_budget/web/expense_view_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    setPathUrlStrategy();
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyC5rkyuJlHfsj0R63TDAaSu8cqtGAVfgVw",
          authDomain: "calculating-budget.firebaseapp.com",
          projectId: "calculating-budget",
          storageBucket: "calculating-budget.appspot.com",
          messagingSenderId: "496380132132",
          appId: "1:496380132132:web:80ba9312e95dbe515091b1",
          measurementId: "G-SB81V7D3EX"
      ),
    );
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResponseHanlder(),
    );
  }
}
