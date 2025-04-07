import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class StorageViewerScreen extends StatefulWidget {
  const StorageViewerScreen({super.key});

  @override
  State<StorageViewerScreen> createState() => _StorageViewerScreenState();
}

class _StorageViewerScreenState extends State<StorageViewerScreen> {
  Map<String, dynamic> _fileData = {};
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadStorageData();
  }

  Future<void> _loadStorageData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Load file data only
      Map<String, dynamic> fileData = {};
      try {
        final directory = await getApplicationDocumentsDirectory();
        final historyFile = File('${directory.path}/calculator_history.json');

        if (await historyFile.exists()) {
          final contents = await historyFile.readAsString();
          try {
            fileData['calculator_history.json'] = jsonDecode(contents);
          } catch (e) {
            fileData['calculator_history.json'] = "Error parsing JSON: $e";
          }
        }
      } catch (e) {
        fileData['error'] = "Error accessing files: $e";
      }

      setState(() {
        _fileData = fileData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading storage data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStorageData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Error Loading Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _error,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadStorageData,
                icon: Icon(Icons.refresh),
                label: Text('Try Again'),
              ),
            ],
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'File Data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _fileData.isEmpty
                  ? _buildEmptyState('No file data found', isDarkMode)
                  : Card(
                elevation: 2,
                child: ListView.separated(
                  itemCount: _fileData.keys.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final key = _fileData.keys.elementAt(index);
                    final value = _fileData[key];

                    if (value is String) {
                      return ListTile(
                        title: Text(key),
                        subtitle: Text(value),
                      );
                    }

                    return ExpansionTile(
                      title: Text(key),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: Text(
                                value is Map || value is List
                                    ? const JsonEncoder.withIndent('  ').convert(value)
                                    : value.toString(),
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.storage,
            size: 48,
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

