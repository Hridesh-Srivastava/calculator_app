import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/providers/calculator_provider.dart';
import 'dart:math' as math;

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final TextEditingController _equationController = TextEditingController();
  double _minX = -10;
  double _maxX = 10;
  double _minY = -10;
  double _maxY = 10;

  @override
  void initState() {
    super.initState();
    final calculatorProvider = Provider.of<CalculatorProvider>(context, listen: false);
    _equationController.text = calculatorProvider.graphEquation;
  }

  @override
  void dispose() {
    _equationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _equationController,
            decoration: InputDecoration(
              labelText: 'Enter equation (e.g., x^2, sin(x), 2*x+1)',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  calculatorProvider.setGraphEquation(_equationController.text);
                  setState(() {});
                },
              ),
            ),
            onSubmitted: (value) {
              calculatorProvider.setGraphEquation(value);
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Slider(
                  min: -50,
                  max: 50,
                  divisions: 100,
                  value: _minX,
                  label: 'Min X: ${_minX.toStringAsFixed(1)}',
                  onChanged: (value) {
                    setState(() {
                      _minX = value;
                    });
                  },
                ),
              ),
              Text('Min X: ${_minX.toStringAsFixed(1)}'),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  min: -50,
                  max: 50,
                  divisions: 100,
                  value: _maxX,
                  label: 'Max X: ${_maxX.toStringAsFixed(1)}',
                  onChanged: (value) {
                    setState(() {
                      _maxX = value;
                    });
                  },
                ),
              ),
              Text('Max X: ${_maxX.toStringAsFixed(1)}'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: GraphPainter(
                    equation: calculatorProvider.graphEquation,
                    minX: _minX,
                    maxX: _maxX,
                    minY: _minY,
                    maxY: _maxY,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final String equation;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final bool isDarkMode;

  GraphPainter({
    required this.equation,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Calculate scale factors
    final scaleX = width / (maxX - minX);
    final scaleY = height / (maxY - minY);

    // Paint for axes
    final axisPaint = Paint()
      ..color = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade800
      ..strokeWidth = 1;

    // Paint for grid
    final gridPaint = Paint()
      ..color = isDarkMode ? Colors.grey.shade800.withOpacity(0.5) : Colors.grey.shade300
      ..strokeWidth = 0.5;

    // Paint for graph
    final graphPaint = Paint()
      ..color = isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw grid
    _drawGrid(canvas, size, scaleX, scaleY, gridPaint);

    // Draw axes
    _drawAxes(canvas, size, scaleX, scaleY, axisPaint);

    // Draw graph
    _drawGraph(canvas, size, scaleX, scaleY, graphPaint);
  }

  void _drawGrid(Canvas canvas, Size size, double scaleX, double scaleY, Paint paint) {
    final width = size.width;
    final height = size.height;

    // Draw vertical grid lines
    for (double x = minX.ceil().toDouble(); x <= maxX; x += 1) {
      if (x == 0) continue;
      final xPos = (x - minX) * scaleX;
      canvas.drawLine(Offset(xPos, 0), Offset(xPos, height), paint);
    }

    // Draw horizontal grid lines
    for (double y = minY.ceil().toDouble(); y <= maxY; y += 1) {
      if (y == 0) continue;
      final yPos = height - (y - minY) * scaleY;
      canvas.drawLine(Offset(0, yPos), Offset(width, yPos), paint);
    }
  }

  void _drawAxes(Canvas canvas, Size size, double scaleX, double scaleY, Paint paint) {
    final width = size.width;
    final height = size.height;

    // X-axis
    final yAxisPos = height - (0 - minY) * scaleY;
    if (yAxisPos >= 0 && yAxisPos <= height) {
      canvas.drawLine(Offset(0, yAxisPos), Offset(width, yAxisPos), paint);
    }

    // Y-axis
    final xAxisPos = (0 - minX) * scaleX;
    if (xAxisPos >= 0 && xAxisPos <= width) {
      canvas.drawLine(Offset(xAxisPos, 0), Offset(xAxisPos, height), paint);
    }

    // Draw axis labels
    final textStyle = TextStyle(
      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade800,
      fontSize: 10,
    );

    // X-axis labels
    for (double x = minX.ceil().toDouble(); x <= maxX; x += 1) {
      if (x == 0) continue;
      final xPos = (x - minX) * scaleX;
      final textSpan = TextSpan(text: x.toInt().toString(), style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(xPos - textPainter.width / 2, yAxisPos + 5));
    }

    // Y-axis labels
    for (double y = minY.ceil().toDouble(); y <= maxY; y += 1) {
      if (y == 0) continue;
      final yPos = height - (y - minY) * scaleY;
      final textSpan = TextSpan(text: y.toInt().toString(), style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(xAxisPos + 5, yPos - textPainter.height / 2));
    }
  }

  void _drawGraph(Canvas canvas, Size size, double scaleX, double scaleY, Paint paint) {
    final width = size.width;
    final height = size.height;

    final path = Path();
    bool isFirstPoint = true;

    // Generate points
    final step = (maxX - minX) / width;
    for (double x = minX; x <= maxX; x += step) {
      try {
        final y = _evaluateEquation(x);

        if (y.isNaN || y.isInfinite || y < minY || y > maxY) {
          isFirstPoint = true;
          continue;
        }

        final xPos = (x - minX) * scaleX;
        final yPos = height - (y - minY) * scaleY;

        if (isFirstPoint) {
          path.moveTo(xPos, yPos);
          isFirstPoint = false;
        } else {
          path.lineTo(xPos, yPos);
        }
      } catch (e) {
        isFirstPoint = true;
      }
    }

    canvas.drawPath(path, paint);
  }

  double _evaluateEquation(double x) {
    try {
      // Handle basic cases first
      if (equation == 'x') return x;
      if (equation == 'x^2') return x * x;
      if (equation == 'x^3') return x * x * x;
      if (equation == 'sqrt(x)') return x >= 0 ? math.sqrt(x) : double.nan;
      if (equation == 'abs(x)') return x.abs();
      if (equation == 'exp(x)') return math.exp(x);
      if (equation == 'sin(x)') return math.sin(x);
      if (equation == 'cos(x)') return math.cos(x);
      if (equation == 'tan(x)') return math.tan(x);
      if (equation == 'asin(x)') return math.asin(x);
      if (equation == 'acos(x)') return math.acos(x);
      if (equation == 'atan(x)') return math.atan(x);
      if (equation == 'sinh(x)') return (math.exp(x) - math.exp(-x)) / 2;
      if (equation == 'cosh(x)') return (math.exp(x) + math.exp(-x)) / 2;
      if (equation == 'tanh(x)') return (math.exp(2 * x) - 1) / (math.exp(2 * x) + 1);
      if (equation == 'log(x)') return x > 0 ? math.log(x) / math.ln10 : double.nan;
      if (equation == 'ln(x)') return x > 0 ? math.log(x) : double.nan;

      // Handle functions with regex
      final matches = RegExp(r'([a-z]+)\(([^)]+)\)').firstMatch(equation);
      if (matches != null) {
        final function = matches.group(1)!;
        final argument = _evaluateExpression(matches.group(2)!, x);

        switch (function) {
          case 'sin':
            return math.sin(argument);
          case 'cos':
            return math.cos(argument);
          case 'tan':
            return math.tan(argument);
          case 'asin':
            return math.asin(argument);
          case 'acos':
            return math.acos(argument);
          case 'atan':
            return math.atan(argument);
          case 'sinh':
            return (math.exp(argument) - math.exp(-argument)) / 2;
          case 'cosh':
            return (math.exp(argument) + math.exp(-argument)) / 2;
          case 'tanh':
            return (math.exp(2 * argument) - 1) / (math.exp(2 * argument) + 1);
          case 'sqrt':
            return argument >= 0 ? math.sqrt(argument) : double.nan;
          case 'abs':
            return argument.abs();
          case 'exp':
            return math.exp(argument);
          case 'log':
            return argument > 0 ? math.log(argument) / math.ln10 : double.nan;
          case 'ln':
            return argument > 0 ? math.log(argument) : double.nan;
          default:
            return double.nan;
        }
      }

      // Handle exponents
      final expMatch = RegExp(r'([^)^]+)\^([^)^]+)').firstMatch(equation);
      if (expMatch != null) {
        final base = _evaluateExpression(expMatch.group(1)!, x);
        final exponent = _evaluateExpression(expMatch.group(2)!, x);
        return math.pow(base, exponent).toDouble();
      }

      // Handle basic arithmetic expressions
      return _evaluateExpression(equation, x);
    } catch (e) {
      return double.nan;
    }
  }

  double _evaluateExpression(String expr, double x) {
    // Replace x with its value
    expr = expr.replaceAll('x', '($x)');

    // Replace constants
    expr = expr.replaceAll('pi', '${math.pi}');
    expr = expr.replaceAll('e', '${math.e}');

    // Evaluate using Dart's expression evaluation
    try {
      return _evaluate(expr);
    } catch (e) {
      return double.nan;
    }
  }

  double _evaluate(String expr) {
    // Remove all whitespace
    expr = expr.replaceAll(RegExp(r'\s+'), '');

    // Handle parentheses
    while (expr.contains('(')) {
      final start = expr.lastIndexOf('(');
      final end = expr.indexOf(')', start);
      if (end == -1) throw Exception('Mismatched parentheses');

      final inner = expr.substring(start + 1, end);
      final value = _evaluate(inner);
      expr = expr.replaceRange(start, end + 1, value.toString());
    }

    // Handle multiplication and division
    final multDiv = RegExp(r'(-?\d+\.?\d*)([*/])(-?\d+\.?\d*)');
    while (multDiv.hasMatch(expr)) {
      final match = multDiv.firstMatch(expr)!;
      final left = double.parse(match.group(1)!);
      final op = match.group(2)!;
      final right = double.parse(match.group(3)!);

      final result = op == '*' ? left * right : left / right;
      expr = expr.replaceRange(match.start, match.end, result.toString());
    }

    // Handle addition and subtraction
    final addSub = RegExp(r'(-?\d+\.?\d*)([+-])(-?\d+\.?\d*)');
    while (addSub.hasMatch(expr)) {
      final match = addSub.firstMatch(expr)!;
      final left = double.parse(match.group(1)!);
      final op = match.group(2)!;
      final right = double.parse(match.group(3)!);

      final result = op == '+' ? left + right : left - right;
      expr = expr.replaceRange(match.start, match.end, result.toString());
    }

    return double.parse(expr);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FlSpot {
  final double x;
  final double y;

  FlSpot(this.x, this.y);
}