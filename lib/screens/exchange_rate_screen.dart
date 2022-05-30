import 'package:flutter/material.dart';

class ExchangeRateScreen extends StatelessWidget {
  final Map rates;
  final String name;

  const ExchangeRateScreen({required this.rates, required this.name});

  @override
  Widget build(BuildContext context) {
    List _currencies = rates.keys.toList();
    List _exchangeValues = rates.values.toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Exchange Rates for $name"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Scrollbar(
            isAlwaysShown: true,
            child: ListView.builder(
              itemCount: _currencies.length,
              itemBuilder: (_context, _index) {
                String _currency = _currencies[_index].toString().toUpperCase();
                String _exchange = _exchangeValues[_index].toString();

                return ListTile(
                  title: Text(
                    "$_currency : $_exchange",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
