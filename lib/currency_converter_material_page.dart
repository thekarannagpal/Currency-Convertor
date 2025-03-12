import 'package:flutter/material.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  double result = 0;
  final TextEditingController textEditingController = TextEditingController();

  String fromCurrency = "USD";
  String toCurrency = "INR";
  List<String> currencies = ["USD", "INR", "EUR", "GBP", "JPY"];

  void fetchConversionRate() async {
  const apiKey = 'Api_Key'; 
  final url = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/$fromCurrency'; 
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      double rate = data["conversion_rates"][toCurrency]; 
      result = double.parse(textEditingController.text) * rate;
    });
  } else {
    // Handle error
    setState(() {
      result = 0;
    });
    print('Error: ${response.statusCode}, ${response.body}');
  }
  }

  void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
  }


  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(width: 2.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(10),
    );

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Currency Converter',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: "Enter amount in $fromCurrency",
                  hintStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.currency_exchange),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: fromCurrency,
                  items: currencies
                      .map((currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      fromCurrency = value!;
                    });
                  },
                ),
                const SizedBox(width: 20),
                const Icon(Icons.arrow_forward, color: Colors.white),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: toCurrency,
                  items: currencies
                      .map((currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      toCurrency = value!;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: fetchConversionRate,
                style: TextButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(200, 50),
                ),
                child: const Text("Convert"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
