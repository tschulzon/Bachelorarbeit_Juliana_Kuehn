import 'package:flutter/material.dart';

class Plantspage extends StatelessWidget {
  const Plantspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plants'),
      ),
      body: Center(
        child: Text(
          'Plantspage',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
