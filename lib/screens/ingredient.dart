import 'package:flutter/material.dart';

class IngredientScreen extends StatefulWidget {
  const IngredientScreen({super.key});

  @override
  State<IngredientScreen> createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  // TODO: Replace with actual data from database
  List<Map<String, dynamic>> ingredients = [
    {'id': 1, 'name': 'Tomate', 'category': 'Légume', 'unit': 'kg'},
    {'id': 2, 'name': 'Oignon', 'category': 'Légume', 'unit': 'pièce'},
    {'id': 3, 'name': 'Sel', 'category': 'Épice', 'unit': 'g'},
    {'id': 4, 'name': 'Huile d\'olive', 'category': 'Huile', 'unit': 'ml'},
    {'id': 5, 'name': 'Poulet', 'category': 'Viande', 'unit': 'kg'},
  ];

  final _nameController = TextEditingController();
  final _unitController = TextEditingController();

  final List<String> _categories = [
    'Légume',
    'Fruit',
    'Viande',
    'Épice',
    'Huile',
    'Autre',
  ];
  String _selectedCategory = 'Légume';
  String searchQuery = '';

  List<Map<String, dynamic>> get filteredIngredients {
    if (searchQuery.isEmpty) return ingredients;
    return ingredients.where((ing) {
      return ing['name'].toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingrédients')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Nouvel ingrédient',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nom',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedCategory,
                              decoration: const InputDecoration(
                                labelText: 'Catégorie',
                                border: OutlineInputBorder(),
                              ),
                              items: _categories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _unitController,
                                    decoration: const InputDecoration(
                                      labelText: 'Unité',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: _showCreateUnitDialog,
                                  icon: const Icon(Icons.add),
                                  tooltip: 'Créer une unité',
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _addIngredient,
                              child: const Text('Ajouter'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Rechercher',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) =>
                            setState(() => searchQuery = value),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredIngredients.length,
                          itemBuilder: (context, index) {
                            final ingredient = filteredIngredients[index];
                            return ListTile(
                              title: Text(ingredient['name']),
                              subtitle: Text(
                                '${ingredient['category']} - ${ingredient['unit']}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _showEditIngredientDialog(ingredient),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addIngredient() {
    if (_nameController.text.trim().isEmpty ||
        _unitController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() {
      ingredients.add({
        'id': ingredients.length + 1,
        'name': _nameController.text.trim(),
        'category': _selectedCategory,
        'unit': _unitController.text.trim(),
      });
      _nameController.clear();
      _unitController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Ingrédient ajouté')));
  }

  void _showCreateUnitDialog() {
    final unitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Créer une unité'),
        content: TextField(
          controller: unitController,
          decoration: const InputDecoration(
            labelText: 'Nom de l\'unité',
            hintText: 'ex: kg, litre, pièce',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (unitController.text.trim().isNotEmpty) {
                setState(() {
                  _unitController.text = unitController.text.trim();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showEditIngredientDialog(Map<String, dynamic> ingredient) {
    final nameController = TextEditingController(text: ingredient['name']);
    String selectedCategory = ingredient['category'];
    final unitController = TextEditingController(text: ingredient['unit']);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Modifier l\'ingrédient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: unitController,
                      decoration: const InputDecoration(labelText: 'Unité'),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showCreateUnitDialogForEdit(
                      unitController,
                      setDialogState,
                    ),
                    icon: const Icon(Icons.add),
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  ingredient['name'] = nameController.text.trim();
                  ingredient['category'] = selectedCategory;
                  ingredient['unit'] = unitController.text.trim();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ingrédient modifié')),
                );
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateUnitDialogForEdit(
    TextEditingController unitController,
    StateSetter setDialogState,
  ) {
    final newUnitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Créer une unité'),
        content: TextField(
          controller: newUnitController,
          decoration: const InputDecoration(
            labelText: 'Nom de l\'unité',
            hintText: 'ex: kg, litre, pièce',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newUnitController.text.trim().isNotEmpty) {
                setDialogState(() {
                  unitController.text = newUnitController.text.trim();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
