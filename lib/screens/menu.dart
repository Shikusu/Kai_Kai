import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final Function(String) onNavigate;
  const MenuScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Menu Screen',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
