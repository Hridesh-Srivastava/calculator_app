import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class CalculatorProvider extends ChangeNotifier {
  String _input = '0';
  String _result = '';
  List<String> _history = [];
  bool _isRadianMode = true;
  String _graphEquation = 'x^2';

  String get input => _input;
  String get result => _result;
  List<String> get history => _history;
  bool get isRadianMode => _isRadianMode;
  String get graphEquation => _graphEquation;

  CalculatorProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      // First try to load from app documents directory (more reliable)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/calculator_history.json');

      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(contents);
        _history = jsonList.cast<String>();
      } else {
        // Fall back to shared preferences
        final prefs = await SharedPreferences.getInstance();
        _history = prefs.getStringList('history') ?? [];
      }
    } catch (e) {
      // If there's an error, try shared preferences as fallback
      try {
        final prefs = await SharedPreferences.getInstance();
        _history = prefs.getStringList('history') ?? [];
      } catch (e) {
        // If all fails, start with empty history
        _history = [];
      }
    }
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    try {
      // Save to app documents directory (more reliable)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/calculator_history.json');
      await file.writeAsString(jsonEncode(_history));

      // Also save to shared preferences as backup
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('history', _history);
    } catch (e) {
      // If there's an error, try shared preferences as fallback
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('history', _history);
      } catch (e) {
        // If all fails, log the error (in a real app, you'd want to handle this better)
        debugPrint('Error saving history: $e');
      }
    }
  }

  void setGraphEquation(String equation) {
    _graphEquation = equation;
    notifyListeners();
  }

  List<FlSpot> generateGraphPoints(String equation, {double start = -10, double end = 10, int points = 100}) {
    List<FlSpot> spots = [];
    try {
      Parser p = Parser();
      Expression exp = p.parse(equation.replaceAll('x', 'x'));

      double step = (end - start) / points;

      for (int i = 0; i <= points; i++) {
        double x = start + step * i;
        ContextModel cm = ContextModel();
        cm.bindVariable(Variable('x'), Number(x));

        try {
          double y = exp.evaluate(EvaluationType.REAL, cm);

          // Skip points that are too large or undefined
          if (y.isFinite && y.abs() < 1000) {
            spots.add(FlSpot(x, y));
          }
        } catch (e) {
          // Skip points that cause evaluation errors
        }
      }
    } catch (e) {
      // Return empty list if equation parsing fails
    }
    return spots;
  }

  void addToHistory(String calculation, String result) {
    _history.insert(0, '$calculation = $result');
    if (_history.length > 100) {
      _history.removeLast();
    }
    _saveHistory();
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
  }

  void toggleAngleMode() {
    _isRadianMode = !_isRadianMode;
    notifyListeners();
  }

  void addInput(String value) {
    if (_input == '0' && !_isOperator(value) && value != '.') {
      _input = value;
    } else {
      _input += value;
    }
    calculate();
    notifyListeners();
  }

  bool _isOperator(String value) {
    return value == '+' || value == '-' || value == '×' || value == '÷' || value == '%' || value == 'mod' || value == '^';
  }

  void clear() {
    _input = '0';
    _result = '';
    notifyListeners();
  }

  void delete() {
    if (_input.length > 1) {
      _input = _input.substring(0, _input.length - 1);
    } else {
      _input = '0';
    }
    calculate();
    notifyListeners();
  }

  void calculate() {
    try {
      String expression = _input
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', '${math.pi}')
          .replaceAll('e', '${math.e}')
          .replaceAll('mod', '%');

      // Handle special functions
      expression = _handleSpecialFunctions(expression);

      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval.isInfinite || eval.isNaN) {
        _result = 'Error';
      } else {
        _result = eval % 1 == 0 ? eval.toInt().toString() : eval.toString();
      }
    } catch (e) {
      _result = '';
    }
    notifyListeners();
  }

  String _handleSpecialFunctions(String expression) {
    // Replace sin, cos, tan, etc. with their math library equivalents
    expression = _replaceTrigFunctions(expression, 'sin');
    expression = _replaceTrigFunctions(expression, 'cos');
    expression = _replaceTrigFunctions(expression, 'tan');
    expression = _replaceTrigFunctions(expression, 'sinh');
    expression = _replaceTrigFunctions(expression, 'cosh');
    expression = _replaceTrigFunctions(expression, 'tanh');

    // Handle log and ln
    RegExp logRegex = RegExp(r'log$$([^)]+)$$');
    expression = expression.replaceAllMapped(logRegex, (match) {
      return '(log(${match.group(1)})/log(10))';
    });

    RegExp lnRegex = RegExp(r'ln$$([^)]+)$$');
    expression = expression.replaceAllMapped(lnRegex, (match) {
      return 'log(${match.group(1)})';
    });

    // Handle sqrt
    RegExp sqrtRegex = RegExp(r'sqrt$$([^)]+)$$');
    expression = expression.replaceAllMapped(sqrtRegex, (match) {
      return 'sqrt(${match.group(1)})';
    });

    // Handle abs
    RegExp absRegex = RegExp(r'abs$$([^)]+)$$');
    expression = expression.replaceAllMapped(absRegex, (match) {
      return 'abs(${match.group(1)})';
    });

    // Handle x^2 and x^3
    RegExp squareRegex = RegExp(r'([0-9.]+|[a-z]+$$[^)]+$$)\^2');
    expression = expression.replaceAllMapped(squareRegex, (match) {
      return '(${match.group(1)}*${match.group(1)})';
    });

    RegExp cubeRegex = RegExp(r'([0-9.]+|[a-z]+$$[^)]+$$)\^3');
    expression = expression.replaceAllMapped(cubeRegex, (match) {
      return '(${match.group(1)}*${match.group(1)}*${match.group(1)})';
    });

    // Handle e^x
    RegExp expRegex = RegExp(r'e\^([0-9.]+|[a-z]+$$[^)]+$$)');
    expression = expression.replaceAllMapped(expRegex, (match) {
      return 'exp(${match.group(1)})';
    });

    // Handle factorial
    RegExp factorialRegex = RegExp(r'([0-9]+)!');
    expression = expression.replaceAllMapped(factorialRegex, (match) {
      int n = int.parse(match.group(1)!);
      return _factorial(n).toString();
    });

    // Handle 1/x
    RegExp reciprocalRegex = RegExp(r'1/([0-9.]+|[a-z]+$$[^)]+$$)');
    expression = expression.replaceAllMapped(reciprocalRegex, (match) {
      return '(1/${match.group(1)})';
    });

    // Handle XOR (^) operator - convert to pow function
    RegExp xorRegex = RegExp(r'([0-9.]+)\^([0-9.]+)');
    expression = expression.replaceAllMapped(xorRegex, (match) {
      return 'pow(${match.group(1)}, ${match.group(2)})';
    });

    return expression;
  }

  int _factorial(int n) {
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }

  String _replaceTrigFunctions(String expression, String funcName) {
    RegExp regex = RegExp('$funcName' r'$$([^)]+)$$');
    return expression.replaceAllMapped(regex, (match) {
      try {
        double value = double.parse(match.group(1)!);
        if (!_isRadianMode && (funcName == 'sin' || funcName == 'cos' || funcName == 'tan')) {
          value = value * math.pi / 180; // Convert to radians
        }
        return '$funcName($value)';
      } catch (e) {
        // If we can't parse as double, just return the original match
        return '${match.group(0)}';
      }
    });
  }

  void evaluateResult() {
    if (_result.isNotEmpty && _result != 'Error') {
      addToHistory(_input, _result);
      _input = _result;
      _result = '';
    }
    notifyListeners();
  }

  void applyFunction(String function) {
    if (_input == '0') {
      _input = '$function(';
    } else {
      _input += '$function(';
    }
    notifyListeners();
  }

  void addParenthesis(bool isOpening) {
    if (isOpening) {
      if (_input == '0') {
        _input = '(';
      } else {
        _input += '(';
      }
    } else {
      _input += ')';
    }
    calculate();
    notifyListeners();
  }

  void addConstant(String constant) {
    if (_input == '0') {
      _input = constant;
    } else {
      _input += constant;
    }
    calculate();
    notifyListeners();
  }

  void square() {
    if (_result.isNotEmpty && _result != 'Error') {
      double value = double.parse(_result);
      _input = '${value}^2';
      calculate();
    } else if (_input != '0') {
      _input += '^2';
      calculate();
    }
    notifyListeners();
  }

  void cube() {
    if (_result.isNotEmpty && _result != 'Error') {
      double value = double.parse(_result);
      _input = '${value}^3';
      calculate();
    } else if (_input != '0') {
      _input += '^3';
      calculate();
    }
    notifyListeners();
  }

  void exponential() {
    if (_input == '0') {
      _input = 'e^(';
    } else {
      _input += 'e^(';
    }
    notifyListeners();
  }

  void reciprocal() {
    if (_result.isNotEmpty && _result != 'Error') {
      double value = double.parse(_result);
      _result = (1 / value).toString();
      _input = '1/(${_input})';
    } else if (_input != '0') {
      _input = '1/(${_input})';
      calculate();
    }
    notifyListeners();
  }

  void factorial() {
    if (_result.isNotEmpty && _result != 'Error' && double.parse(_result) % 1 == 0) {
      int value = int.parse(_result);
      if (value >= 0 && value <= 20) { // Limit to avoid overflow
        _input = '$value!';
        calculate();
      }
    } else if (_input != '0') {
      _input += '!';
      calculate();
    }
    notifyListeners();
  }
}

// This class is needed for the graph
class FlSpot {
  final double x;
  final double y;

  FlSpot(this.x, this.y);
}

