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

    return Material(
      color: color ?? (isDarkMode ? Colors.grey.shade800 : Colors.white),
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: _buildButtonText(),
        ),
      ),
    );
  }

  Widget _buildButtonText() {
    // For special mathematical notations, use Math widget
    if (text == 'x²') {
      return Math.tex(r'x^2', textStyle: const TextStyle(fontSize: 18));
    } else if (text == 'x³') {
      return Math.tex(r'x^3', textStyle: const TextStyle(fontSize: 18));
    } else if (text == 'e^x') {
      return Math.tex(r'e^x', textStyle: const TextStyle(fontSize: 18));
    } else if (text == '1/x') {
      return Math.tex(r'\frac{1}{x}', textStyle: const TextStyle(fontSize: 18));
    } else if (text == 'x!') {
      return Math.tex(r'x!', textStyle: const TextStyle(fontSize: 18));
    } else if (text == 'π') {
      return Math.tex(r'\pi', textStyle: const TextStyle(fontSize: 18));
    } else if (text == 'sqrt') {
      return Math.tex(r'\sqrt{x}', textStyle: const TextStyle(fontSize: 18));
    } else {
      return Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      );
    }
  }
}

