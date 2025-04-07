import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final int flex;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? (isDarkMode ? Colors.grey.shade800 : Colors.white),
            foregroundColor: textColor ?? (isDarkMode ? Colors.white : Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16),
            elevation: 4,
          ),
          child: _buildButtonContent(text),
        ),
      ),
    );
  }

  Widget _buildButtonContent(String text) {
    // For special mathematical notations, use Math widget
    if (text == 'x²') {
      return Math.tex(r'x^2', textStyle: const TextStyle(fontSize: 20));
    } else if (text == 'x³') {
      return Math.tex(r'x^3', textStyle: const TextStyle(fontSize: 20));
    } else if (text == 'e^x') {
      return Math.tex(r'e^x', textStyle: const TextStyle(fontSize: 20));
    } else if (text == '1/x') {
      return Math.tex(r'\frac{1}{x}', textStyle: const TextStyle(fontSize: 20));
    } else if (text == 'x!') {
      return Math.tex(r'x!', textStyle: const TextStyle(fontSize: 20));
    } else if (text == 'π') {
      return Math.tex(r'\pi', textStyle: const TextStyle(fontSize: 20));
    } else if (text == 'sqrt') {
      return Math.tex(r'\sqrt{x}', textStyle: const TextStyle(fontSize: 20));
    } else {
      return Text(
        text,
        style: const TextStyle(fontSize: 20),
      );
    }
  }
}

