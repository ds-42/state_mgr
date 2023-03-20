import 'package:flutter/material.dart';
import 'package:state_mgr/state_mgr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stater Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStaterPage(title: 'Stater Demo page'),
    );
  }
}

class MyStaterPage extends StatelessWidget {
  final String title;

  const MyStaterPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stater(manager: () => CounterState('Energy')),
          Stater(manager: () => CounterState('Health')),
          Stater(manager: () => CounterState('Damage')),
        ],
      ),
    );
  }
}

class CounterState extends StateManager {
  String label;

  CounterState(this.label);

  int _value = 0;

  int get value => _value;

  set value(int value) {
    if (value < 0) value = 0;
    if (_value == value) return;
    _value = value;
    invalidate();
  }

  void dec() => value--;

  void inc() => value++;

  @override
  Widget build() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$label: $value',
          style: Theme.of(context).textTheme.headline4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.red.shade100),
                onPressed: value > 0 ? dec : null,
                child: const Icon(Icons.keyboard_arrow_left)),
            const SizedBox(width: 5),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green.shade100),
                onPressed: inc,
                child: const Icon(Icons.keyboard_arrow_right)),
          ],
        )
      ],
    );
  }
}
