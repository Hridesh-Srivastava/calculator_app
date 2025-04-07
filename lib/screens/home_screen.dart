import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/providers/converter_provider.dart';
import 'package:calculator_app/providers/theme_provider.dart';
import 'package:calculator_app/screens/calculator_screen.dart';
import 'package:calculator_app/screens/converter_screen.dart';
import 'package:calculator_app/screens/graph_screen.dart';
import 'package:calculator_app/screens/history_screen.dart';
import 'package:calculator_app/screens/storage_viewer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => ConverterProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scientific Calculator',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: themeProvider.toggleTheme,
              tooltip: 'Toggle Theme',
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'storage',
                  child: Text('View Local Storage'),
                ),
                const PopupMenuItem(
                  value: 'about',
                  child: Text('About'),
                ),
              ],
              onSelected: (value) {
                if (value == 'storage') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StorageViewerScreen(),
                    ),
                  );
                } else if (value == 'about') {
                  _showAboutDialog(context);
                }
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
              Tab(icon: Icon(Icons.history), text: 'History'),
              Tab(icon: Icon(Icons.show_chart), text: 'Graph'),
              Tab(icon: Icon(Icons.swap_horiz), text: 'Converter'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            CalculatorScreen(),
            HistoryScreen(),
            GraphScreen(),
            ConverterScreen(),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Scientific Calculator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('A comprehensive scientific calculator app with unit conversion, graphing, and calculation history.'),
            const SizedBox(height: 16),
            const Text('Features:'),
            const SizedBox(height: 8),
            const Text('• Scientific calculations'),
            const Text('• Unit conversion'),
            const Text('• Function graphing'),
            const Text('• Calculation history'),
            const Text('• Dark/light theme'),
            const SizedBox(height: 16),
            const Text('Data is stored locally on your device using SharedPreferences and local files.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

