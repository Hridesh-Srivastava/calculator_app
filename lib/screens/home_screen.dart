import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/providers/converter_provider.dart';
import 'package:calculator_app/providers/theme_provider.dart';
import 'package:calculator_app/screens/calculator_screen.dart';
import 'package:calculator_app/screens/converter_screen.dart';
import 'package:calculator_app/screens/graph_screen.dart';
import 'package:calculator_app/screens/history_screen.dart';

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
      child: OrientationBuilder(
          builder: (context, orientation) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Scientific Calculator', style: TextStyle(fontWeight: FontWeight.bold)),
                actions: [
                  IconButton(
                    icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    onPressed: themeProvider.toggleTheme,
                    tooltip: 'Toggle Theme',
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
                  isScrollable: orientation == Orientation.portrait,
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
            );
          }
      ),
    );
  }
}

