import 'package:flutter/material.dart';

class AddPlant extends StatelessWidget {
  const AddPlant({super.key});

//   CareEntry(
//   id: const Uuid().v4(),
//   userPlantId: newUserPlant.id,
//   type: 'watering',
//   date: selectedWateringDate,
// );

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
