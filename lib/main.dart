import 'package:anomana/screens/dashboard.dart';
import 'package:anomana/screens/ingredient.dart';
import 'package:anomana/screens/menu.dart';
import 'package:anomana/screens/recette.dart';
import 'package:anomana/utils/color_pattern.dart';
import 'package:anomana/widgets/sidebar_button.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    minimumSize: Size(800, 600),
    center: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  String currentPage = "Tableau de bord";
  Size? windowSize;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _updateWindowSize();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _updateWindowSize() async {
    final size = await windowManager.getSize();
    setState(() => windowSize = size);
  }

  @override
  void onWindowResize() {
    _updateWindowSize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kai Kai',
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Scaffold(
        body: windowSize != null && windowSize!.width >= 800
            ? Row(
                children: [
                  _Sidebar(
                    current: currentPage,
                    onSelect: (value) {
                      setState(() => currentPage = value);
                    },
                  ),
                  Expanded(
                    child: _ContentArea(
                      page: currentPage,
                      onNavigate: (newPage) {
                        setState(() => currentPage = newPage);
                      },
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final String current;
  final ValueChanged<String> onSelect;

  const _Sidebar({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withValues(alpha: 0.1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🍽 Kai Kai",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          SidebarButton(
            text: "Tableau de bord",
            selected: current == "Tableau de bord",
            onPressed: () => onSelect("Tableau de bord"),
          ),
          SidebarButton(
            text: "Menu",
            selected: current == "menu",
            onPressed: () => onSelect("menu"),
          ),
          SidebarButton(
            text: "Recette",
            selected: current == "recette",
            onPressed: () => onSelect("recette"),
          ),
          SidebarButton(
            text: "Ingrédient",
            selected: current == "ingrédients",
            onPressed: () => onSelect("ingrédients"),
          ),
        ],
      ),
    );
  }
}

class _ContentArea extends StatelessWidget {
  final String page;
  final Function(String) onNavigate;

  const _ContentArea({required this.page, required this.onNavigate});

  Widget _buildScreen() {
    switch (page) {
      case "Tableau de bord":
        return DashboardScreen(onNavigate: onNavigate);
      case "menu":
        return MenuScreen(onNavigate: onNavigate);
      case "recette":
        return RecetteScreen();
      case "ingrédients":
        return IngredientScreen(onNavigate: onNavigate);
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      color: theme.colorScheme.surface,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: _buildScreen(),
      ),
    );
  }
}
