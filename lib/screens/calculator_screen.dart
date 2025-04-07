import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/providers/calculator_provider.dart';
import 'package:calculator_app/widgets/calculator_button.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool _showScientificKeypad = true;

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            // Landscape layout
            return Row(
              children: [
                // Display and basic keypad
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildDisplay(calculatorProvider, isDarkMode),
                      Expanded(
                        child: _buildMainKeypad(calculatorProvider, isDarkMode),
                      ),
                    ],
                  ),
                ),
                // Scientific keypad
                Expanded(
                  flex: 2,
                  child: _buildScientificKeypad(calculatorProvider, isDarkMode),
                ),
              ],
            );
          } else {
            // Portrait layout
            return Column(
              children: [
                _buildDisplay(calculatorProvider, isDarkMode),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: calculatorProvider.toggleAngleMode,
                      icon: const Icon(Icons.rotate_right),
                      label: Text(calculatorProvider.isRadianMode ? 'RAD' : 'DEG'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _showScientificKeypad = !_showScientificKeypad;
                        });
                      },
                      icon: Icon(_showScientificKeypad ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                      label: Text(_showScientificKeypad ? 'Basic' : 'Scientific'),
                    ),
                  ],
                ),
                if (_showScientificKeypad)
                  SizedBox(
                    height: 180,
                    child: _buildScientificKeypad(calculatorProvider, isDarkMode),
                  ),
                Expanded(
                  child: _buildMainKeypad(calculatorProvider, isDarkMode),
                ),
              ],
            );
          }
        }
    );
  }

  Widget _buildDisplay(CalculatorProvider calculatorProvider, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDarkMode ? Colors.black54 : Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  calculatorProvider.input,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  calculatorProvider.result,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScientificKeypad(CalculatorProvider calculatorProvider, bool isDarkMode) {
    final buttonColor = isDarkMode ? Colors.grey.shade800 : Colors.blue.shade100;

    return Container(
      color: isDarkMode ? Colors.black38 : Colors.blue.shade50,
      child: GridView.count(
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 4,
        childAspectRatio: 1.5,
        children: [
          CalculatorButton(
            text: 'sin',
            onPressed: () => calculatorProvider.applyFunction('sin'),
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'cos',
            onPressed: () => calculatorProvider.applyFunction('cos'),
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'tan',
            onPressed: () => calculatorProvider.applyFunction('tan'),
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'π',
            onPressed: () => calculatorProvider.addConstant('π'),
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'log',
            onPressed: () => calculatorProvider.applyFunction('log'),
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'ln',
            onPressed: () => calculatorProvider.applyFunction('ln'),
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'sqrt',
            onPressed: () => calculatorProvider.applyFunction('sqrt'),
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'e',
            onPressed: () => calculatorProvider.addConstant('e'),
            color: buttonColor,
          ),
          CalculatorButton(
            text: '(',
            onPressed: () => calculatorProvider.addParenthesis(true),
            color: buttonColor,
          ),
          CalculatorButton(
            text: ')',
            onPressed: () => calculatorProvider.addParenthesis(false),
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'x²',
            onPressed: calculatorProvider.square,
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'x³',
            onPressed: calculatorProvider.cube,
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'e^x',
            onPressed: calculatorProvider.exponential,
            color: buttonColor,
          ),
          CalculatorButton(
            text: '1/x',
            onPressed: calculatorProvider.reciprocal,
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'x!',
            onPressed: calculatorProvider.factorial,
            color: buttonColor,
          ),
          CalculatorButton(
            text: 'mod',
            onPressed: () => calculatorProvider.addInput('mod'),
            color: buttonColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMainKeypad(CalculatorProvider calculatorProvider, bool isDarkMode) {
    final numberColor = isDarkMode ? Colors.grey.shade700 : Colors.white;
    final operatorColor = isDarkMode ? Colors.grey.shade800 : Colors.blue.shade200;
    final functionColor = isDarkMode ? Colors.grey.shade900 : Colors.blue.shade300;

    return Container(
      color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
      child: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 1.3,
        children: [
          CalculatorButton(
            text: 'C',
            onPressed: calculatorProvider.clear,
            color: isDarkMode ? Colors.redAccent.shade700 : Colors.redAccent.shade100,
          ),
          CalculatorButton(
            text: '⌫',
            onPressed: calculatorProvider.delete,
            color: functionColor,
          ),
          CalculatorButton(
            text: '%',
            onPressed: () => calculatorProvider.addInput('%'),
            color: functionColor,
          ),
          CalculatorButton(
            text: '÷',
            onPressed: () => calculatorProvider.addInput('÷'),
            color: operatorColor,
          ),
          CalculatorButton(
            text: '7',
            onPressed: () => calculatorProvider.addInput('7'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '8',
            onPressed: () => calculatorProvider.addInput('8'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '9',
            onPressed: () => calculatorProvider.addInput('9'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '×',
            onPressed: () => calculatorProvider.addInput('×'),
            color: operatorColor,
          ),
          CalculatorButton(
            text: '4',
            onPressed: () => calculatorProvider.addInput('4'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '5',
            onPressed: () => calculatorProvider.addInput('5'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '6',
            onPressed: () => calculatorProvider.addInput('6'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '-',
            onPressed: () => calculatorProvider.addInput('-'),
            color: operatorColor,
          ),
          CalculatorButton(
            text: '1',
            onPressed: () => calculatorProvider.addInput('1'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '2',
            onPressed: () => calculatorProvider.addInput('2'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '3',
            onPressed: () => calculatorProvider.addInput('3'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '+',
            onPressed: () => calculatorProvider.addInput('+'),
            color: operatorColor,
          ),
          CalculatorButton(
            text: '0',
            onPressed: () => calculatorProvider.addInput('0'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '.',
            onPressed: () => calculatorProvider.addInput('.'),
            color: numberColor,
          ),
          CalculatorButton(
            text: '=',
            onPressed: calculatorProvider.evaluateResult,
            color: isDarkMode ? Colors.blue.shade800 : Colors.blue.shade400,
            textColor: Colors.white,
            flex: 2,
          ),
        ],
      ),
    );
  }
}

