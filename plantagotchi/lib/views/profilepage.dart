import 'package:flutter/material.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: colors.primary,
      ),
      body: Center(
        child: Text(
          'Profile Page',
          style: TextStyle(color: colors.onPrimary, fontSize: 24),
        ),
      ),
    );
  }
}
