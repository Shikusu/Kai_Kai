import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title
          Text(
            'Tableau de bord',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Re-bienvenue!',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Stats Cards Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.restaurant_menu,
                  title: 'Nombre de recettes',
                  value: '24', // TODO: Replace with actual count from DB
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.kitchen,
                  title: 'Ingredients totals',
                  value: '156', // TODO: Replace with actual count from DB
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  icon: Icons.favorite,
                  title: 'Menus sauvegardés',
                  value: '8', // TODO: Replace with actual count from DB
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent Recipes Section
          Text(
            'Recettes récentes',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Recent recipes list
          Expanded(
            child: ListView.builder(
              itemCount: 5, // TODO: Replace with actual recent recipes from DB
              itemBuilder: (context, index) {
                return _buildRecentRecipeCard(
                  context,
                  name:
                      'Recipe ${index + 1}', // TODO: Replace with actual recipe name
                  category: 'Entrée', // TODO: Replace with actual category
                  date:
                      'Il y a ${index + 1} jours', // TODO: Replace with actual date
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 32),
                const Spacer(),
                // TODO: Add trend indicator (up/down arrow) if needed
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for recent recipe cards
  Widget _buildRecentRecipeCard(
    BuildContext context, {
    required String name,
    required String category,
    required String date,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: const Icon(
            Icons.restaurant,
            color: Color.fromARGB(255, 78, 173, 197),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text('$category • $date'),
        onTap: () => onNavigate("recette"),
      ),
    );
  }
}
