import 'package:credit_card_checker/pages/card_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardValidator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CardPage(),
    );
  }
}
