import 'package:flutter/material.dart';

class Friendspage extends StatelessWidget {
  const Friendspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: Center(
        child: Text(
          'Friendspage',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
