import 'package:flutter/material.dart';

class RecetteScreen extends StatelessWidget {
  const RecetteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Recette Screen',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
