import 'package:flutter/material.dart';

import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Loader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        hintColor: Colors.blueAccent,
        textTheme: TextTheme(
          // ignore: deprecated_member_use
          headline1: TextStyle(fontSize: 22.0, color: Colors.blueAccent),
          // ignore: deprecated_member_use
          headline2: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Colors.blueAccent,
          ),
          // ignore: deprecated_member_use
          bodyText1: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 24, 185, 30),
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}
