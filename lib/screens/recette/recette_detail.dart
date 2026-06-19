import 'package:flutter/material.dart';

class Ingredient {
  final String name;
  final double unitPrice;

  const Ingredient({required this.name, required this.unitPrice});
}

class IngredientLine {
  final Ingredient ingredient;
  final int quantity;

  const IngredientLine({required this.ingredient, required this.quantity});

  double get total => ingredient.unitPrice * quantity;
}

const List<Ingredient> kIngredients = [
  Ingredient(name: 'Farine (kg)', unitPrice: 1.20),
  Ingredient(name: 'Œufs (unité)', unitPrice: 0.25),
  Ingredient(name: 'Beurre (kg)', unitPrice: 8.50),
  Ingredient(name: 'Lait (L)', unitPrice: 0.90),
  Ingredient(name: 'Sucre (kg)', unitPrice: 0.80),
  Ingredient(name: 'Sel (kg)', unitPrice: 0.40),
  Ingredient(name: 'Levure (g)', unitPrice: 0.05),
  Ingredient(name: 'Huile (L)', unitPrice: 2.30),
];

class RecetteDetail extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onBack;

  const RecetteDetail({
    super.key,
    required this.onNavigate,
    required this.onBack,
  });

  @override
  State<RecetteDetail> createState() => _RecetteDetailState();
}

class _RecetteDetailState extends State<RecetteDetail>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _perPlateCtrl = TextEditingController();

  Ingredient? _selectedIngredient;
  final _quantityCtrl = TextEditingController(text: '1');

  final List<IngredientLine> _lines = [];

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _perPlateCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  double get _grandTotal => _lines.fold(0.0, (sum, l) => sum + l.total);

  void _addIngredient() {
    final qty = int.tryParse(_quantityCtrl.text.trim()) ?? 0;
    if (_selectedIngredient == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sélectionnez un ingrédient et une quantité valide.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      final idx = _lines.indexWhere(
        (l) => l.ingredient.name == _selectedIngredient!.name,
      );
      if (idx >= 0) {
        _lines[idx] = IngredientLine(
          ingredient: _selectedIngredient!,
          quantity: _lines[idx].quantity + qty,
        );
      } else {
        _lines.add(
          IngredientLine(ingredient: _selectedIngredient!, quantity: qty),
        );
      }
      _selectedIngredient = null;
      _quantityCtrl.text = '1';
    });
  }

  void _removeLine(int index) {
    setState(() => _lines.removeAt(index));
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ajoutez au moins un ingrédient.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recette enregistrée !'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: widget.onBack,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Détail de la recette',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(height: 10),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    TextFormField(
                                      controller: _nameCtrl,
                                      decoration: const InputDecoration(
                                        labelText: 'Nom de la recette',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.restaurant_menu),
                                      ),
                                      validator: (v) =>
                                          (v == null || v.trim().isEmpty)
                                          ? 'Champ obligatoire'
                                          : null,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _descriptionCtrl,
                                      maxLines: 2,
                                      decoration: const InputDecoration(
                                        labelText: 'Description',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.description),
                                        alignLabelWithHint: true,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _perPlateCtrl,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      decoration: const InputDecoration(
                                        labelText: 'Nombre de portions',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(
                                          Icons.payments_outlined,
                                        ),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return 'Champ obligatoire';
                                        }
                                        if (double.tryParse(v.trim()) == null) {
                                          return 'Nombre invalide';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'Ajouter un ingrédient',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const SizedBox(height: 12),
                                            DropdownButtonFormField<Ingredient>(
                                              initialValue: _selectedIngredient,
                                              isExpanded: true,
                                              decoration: const InputDecoration(
                                                labelText: 'Ingrédient',
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10,
                                                    ),
                                              ),
                                              items: kIngredients
                                                  .map(
                                                    (ing) => DropdownMenuItem(
                                                      value: ing,
                                                      child: Text(ing.name),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (v) => setState(
                                                () => _selectedIngredient = v,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormField(
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                labelText: 'Prix unitaire (Ar)',
                                                border:
                                                    const OutlineInputBorder(),
                                                prefixIcon: const Icon(
                                                  Icons.price_check_outlined,
                                                ),
                                                hintText:
                                                    _selectedIngredient != null
                                                    ? '${_selectedIngredient!.unitPrice.toStringAsFixed(2)} Ar'
                                                    : '—',
                                              ),
                                              controller: TextEditingController(
                                                text:
                                                    _selectedIngredient != null
                                                    ? _selectedIngredient!
                                                          .unitPrice
                                                          .toStringAsFixed(2)
                                                    : '',
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormField(
                                              controller: _quantityCtrl,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: 'Quantité',
                                                border: OutlineInputBorder(),
                                                prefixIcon: Icon(
                                                  Icons.shopping_cart_outlined,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            FilledButton.icon(
                                              onPressed: _addIngredient,
                                              icon: const Icon(Icons.add),
                                              label: const Text('Insérer'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: _save,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.save_outlined),
                              label: const Text('Enregistrer'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Ingrédients ajoutés',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            _TableHeader(),
                            const Divider(height: 1),
                            Expanded(
                              child: _lines.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.inbox_outlined,
                                            size: 48,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.outlineVariant,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Aucun ingrédient ajouté',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.outline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: _lines.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(height: 1),
                                      itemBuilder: (ctx, i) {
                                        final line = _lines[i];
                                        return _IngredientRow(
                                          line: line,
                                          onDelete: () => _removeLine(i),
                                        );
                                      },
                                    ),
                            ),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    flex: 5,
                                    child: Text(
                                      'TOTAL',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${_grandTotal.toStringAsFixed(2)} Ar',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.outline,
      letterSpacing: 0.5,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('INGRÉDIENT', style: style)),
          Expanded(
            flex: 2,
            child: Text('PX UNIT.', style: style, textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 1,
            child: Text('QTÉ', style: style, textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 2,
            child: Text('TOTAL', style: style, textAlign: TextAlign.right),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final IngredientLine line;
  final VoidCallback onDelete;

  const _IngredientRow({required this.line, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(line.ingredient.name, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${line.ingredient.unitPrice.toStringAsFixed(2)} Ar',
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('${line.quantity}', textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${line.total.toStringAsFixed(2)} Ar',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: Theme.of(context).colorScheme.error,
              tooltip: 'Supprimer',
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}
