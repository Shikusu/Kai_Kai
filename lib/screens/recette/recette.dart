import 'package:flutter/material.dart';

class RecetteScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onOpenDetail;

  const RecetteScreen({
    super.key,
    required this.onNavigate,
    required this.onOpenDetail,
  });

  @override
  State<RecetteScreen> createState() => _RecetteScreenState();
}

class _RecetteScreenState extends State<RecetteScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Implement some initialization operations here.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recette',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(height: 32),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Recette 1'),
              subtitle: const Text('Description de la recette 1'),
              onTap: () => widget.onOpenDetail(),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Gonna be delete functionality
                    },
                    tooltip: "Supprimer la recette",
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: () {
                      // Gotta be print functionality
                    },
                    tooltip: "Exporter en excel",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
