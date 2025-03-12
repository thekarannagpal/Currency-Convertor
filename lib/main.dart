import 'package:flutter/material.dart';
import './currency_converter_material_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext Context) {
    return const MaterialApp(
      home: CurrencyConverterMaterialPage(),
    );
  }
}
