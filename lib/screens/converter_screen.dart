import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/providers/converter_provider.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final converterProvider = Provider.of<ConverterProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final orientation = MediaQuery.of(context).orientation;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: orientation == Orientation.landscape
          ? _buildLandscapeLayout(context, converterProvider, isDarkMode)
          : _buildPortraitLayout(context, converterProvider, isDarkMode),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, ConverterProvider converterProvider, bool isDarkMode) {
    return Column(
      children: [
        _buildConverterCard(context, converterProvider, isDarkMode),
        const SizedBox(height: 16),
        Expanded(
          child: _buildInfoCard(context, converterProvider),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, ConverterProvider converterProvider, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: _buildConverterCard(context, converterProvider, isDarkMode),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _buildInfoCard(context, converterProvider),
        ),
      ],
    );
  }

  Widget _buildConverterCard(BuildContext context, ConverterProvider converterProvider, bool isDarkMode) {
    final orientation = MediaQuery.of(context).orientation;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: converterProvider.selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: converterProvider.categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  converterProvider.setCategory(value);
                }
              },
            ),
            const SizedBox(height: 16),
            orientation == Orientation.landscape
                ? _buildLandscapeInputs(converterProvider, isDarkMode)
                : _buildPortraitInputs(converterProvider, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitInputs(ConverterProvider converterProvider, bool isDarkMode) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Value',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade800 : Colors.blue.shade50,
                ),
                onChanged: converterProvider.setInputValue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: converterProvider.fromUnit,
                decoration: const InputDecoration(
                  labelText: 'From',
                  border: OutlineInputBorder(),
                ),
                items: converterProvider.currentUnits.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    converterProvider.setFromUnit(value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_downward, size: 32, color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  color: isDarkMode ? Colors.grey.shade800 : Colors.blue.shade50,
                ),
                child: Text(
                  converterProvider.outputValue,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: converterProvider.toUnit,
                decoration: const InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(),
                ),
                items: converterProvider.currentUnits.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    converterProvider.setToUnit(value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLandscapeInputs(ConverterProvider converterProvider, bool isDarkMode) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Value',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade800 : Colors.blue.shade50,
                ),
                onChanged: converterProvider.setInputValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: converterProvider.fromUnit,
                decoration: const InputDecoration(
                  labelText: 'From',
                  border: OutlineInputBorder(),
                ),
                items: converterProvider.currentUnits.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    converterProvider.setFromUnit(value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_downward, size: 32, color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  color: isDarkMode ? Colors.grey.shade800 : Colors.blue.shade50,
                ),
                child: Text(
                  converterProvider.outputValue,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: converterProvider.toUnit,
                decoration: const InputDecoration(
                  labelText: 'To',
                  border: OutlineInputBorder(),
                ),
                items: converterProvider.currentUnits.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    converterProvider.setToUnit(value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, ConverterProvider converterProvider) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unit Converter Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Categories:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...converterProvider.categories.map((category) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text('• $category'),
                    )).toList(),
                    const SizedBox(height: 16),
                    Text(
                      'How to use:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Select a category from the dropdown'),
                    const Text('2. Enter a value to convert'),
                    const Text('3. Select the units to convert from and to'),
                    const Text('4. The converted value will appear automatically'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

