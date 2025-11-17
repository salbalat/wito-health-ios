import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() => runApp(WitoHealthApp());

class WitoHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WITO Health iOS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
