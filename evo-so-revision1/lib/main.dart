import 'package:flutter/material.dart';
import 'package:salesorder/ui/pages/pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(), //MyAPPx(), //
      debugShowCheckedModeBanner: false,
    );
  }
}
