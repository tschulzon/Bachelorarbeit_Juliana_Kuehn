import 'package:flutter/material.dart';

class AddPlant extends StatelessWidget {
  const AddPlant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Plant'),
      ),
      body: Center(
        child: Text(
          'Add Plant Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
