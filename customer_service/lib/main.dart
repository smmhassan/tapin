import 'package:customer_service/utils/OurTheme.dart';
import 'package:flutter/material.dart';

import 'screens/login/login.dart';
import 'screens/userdash/userdash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: OurTheme().buildTheme(),
      home: UserDash(),
    );
  }
}
