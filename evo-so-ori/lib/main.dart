import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesorder/ui/pages/pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthServices.firebaseUserStream,
      child: MaterialApp(
        home: Splash(), //MyAPPx(), //
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
