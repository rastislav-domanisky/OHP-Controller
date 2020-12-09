import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './screens/HomeScreen.dart';
import './screens/NewSwitchScreen.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OHP Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff2c3e50),
        accentColor: Color(0xffecf0f1),
        canvasColor: Color(0xff34495e),
      ),
      routes: {
        HomeScreen.routeName: (BuildContext ctx) => HomeScreen(),
        NewSwitchScreen.routeName: (BuildContext ctx) => NewSwitchScreen(),
      },
      home: HomeScreen(),
    );
  }
}
