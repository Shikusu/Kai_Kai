import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../models/unit.dart';
import '../repositories/ingredient_repository.dart';
import '../repositories/unit_repository.dart';

class IngredientScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const IngredientScreen({super.key, required this.onNavigate});

  @override
  State<IngredientScreen> createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  final _ingredientRepo = IngredientRepository();
  final _unitRepo = UnitRepository();

  List<Ingredient> ingredients = [];
  List<Unit> units = [];
  bool _loading = true;

  final _nameController = TextEditingController();

  final List<String> _categories = [
    'Légume',
    'Fruit',
    'Viande',
    'Épice',
    'Huile',
    'Autre',
  ];
  String _selectedCategory = 'Légume';
  Unit? _selectedUnit;

  String searchQuery = '';

  List<Ingredient> get filteredIngredients {
    if (searchQuery.isEmpty) return ingredients;
    return ingredients.where((ing) {
      return ing.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final loadedUnits = await _unitRepo.getAll();
    final loadedIngredients = await _ingredientRepo.getAll();
    setState(() {
      units = loadedUnits;
      ingredients = loadedIngredients;
      // Keep current selection if still valid, otherwise default to first unit.
      if (_selectedUnit == null ||
          !units.any((u) => u.id == _selectedUnit!.id)) {
        _selectedUnit = units.isNotEmpty ? units.first : null;
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingrédients')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
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
                                    child: DropdownButtonFormField<Unit>(
                                      initialValue: _selectedUnit,
                                      decoration: const InputDecoration(
                                        labelText: 'Unité',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: units.map((unit) {
                                        return DropdownMenuItem(
                                          value: unit,
                                          child: Text(unit.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedUnit = value;
                                        });
                                      },
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
                  ),
                ),
                Expanded(
                  flex: 2,
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
                              child: filteredIngredients.isEmpty
                                  ? const Center(
                                      child: Text('Aucun ingrédient'),
                                    )
                                  : ListView.separated(
                                      itemCount: filteredIngredients.length,
                                      separatorBuilder: (_, _) =>
                                          const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final ingredient =
                                            filteredIngredients[index];
                                        return ListTile(
                                          title: Text(ingredient.name),
                                          subtitle: Text(
                                            '${ingredient.category} - ${ingredient.unitName ?? ''}',
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () =>
                                                _showEditIngredientDialog(
                                                  ingredient,
                                                ),
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

  Future<void> _addIngredient() async {
    if (_nameController.text.trim().isEmpty || _selectedUnit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    await _ingredientRepo.insert(
      Ingredient(
        name: _nameController.text.trim(),
        category: _selectedCategory,
        unitId: _selectedUnit!.id!,
      ),
    );

    _nameController.clear();
    await _loadData();

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Ingrédient ajouté')));
  }

  /// Adds a unit and selects it on the main form.
  void _showCreateUnitDialog() {
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
            onPressed: () async {
              final name = newUnitController.text.trim();
              if (name.isEmpty) return;
              final unit = await _unitRepo.getOrCreate(name);
              await _loadData();
              setState(() => _selectedUnit = unit);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showEditIngredientDialog(Ingredient ingredient) {
    final nameController = TextEditingController(text: ingredient.name);
    String selectedCategory = ingredient.category;
    Unit? selectedUnit = units.firstWhere(
      (u) => u.id == ingredient.unitId,
      orElse: () => units.first,
    );

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
                    child: DropdownButtonFormField<Unit>(
                      initialValue: selectedUnit,
                      decoration: const InputDecoration(labelText: 'Unité'),
                      items: units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedUnit = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showCreateUnitDialogForEdit(
                      setDialogState,
                      (unit) => selectedUnit = unit,
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
              onPressed: () async {
                if (nameController.text.trim().isEmpty ||
                    selectedUnit == null) {
                  return;
                }
                await _ingredientRepo.update(
                  ingredient.copyWith(
                    name: nameController.text.trim(),
                    category: selectedCategory,
                    unitId: selectedUnit!.id!,
                  ),
                );
                await _loadData();
                if (context.mounted) Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ingrédient modifié')),
                  );
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateUnitDialogForEdit(
    StateSetter setDialogState,
    void Function(Unit) onSelected,
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
            onPressed: () async {
              final name = newUnitController.text.trim();
              if (name.isEmpty) return;
              final unit = await _unitRepo.getOrCreate(name);
              await _loadData();
              setDialogState(() => onSelected(unit));
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
