import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/providers/calculator_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context);
    final history = calculatorProvider.history;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: history.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No calculation history yet',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your calculations will appear here',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      )
          : ListView.separated(
        itemCount: history.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              history[index],
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.right,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () {
                final parts = history[index].split(' = ');
                if (parts.length == 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Result copied: ${parts[1]}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              tooltip: 'Copy result',
            ),
          );
        },
      ),
      floatingActionButton: history.isEmpty
          ? null
          : FloatingActionButton(
        onPressed: calculatorProvider.clearHistory,
        tooltip: 'Clear History',
        child: const Icon(Icons.delete),
      ),
    );
  }
}

