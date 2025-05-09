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

    return orientation == Orientation.landscape
        ? _buildLandscapeLayout(calculatorProvider, isDarkMode)
        : _buildPortraitLayout(calculatorProvider, isDarkMode);
  }

  Widget _buildPortraitLayout(CalculatorProvider calculatorProvider, bool isDarkMode) {
    return Column(
      children: [
        _buildDisplay(calculatorProvider, isDarkMode),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: calculatorProvider.toggleAngleMode,
                icon: const Icon(Icons.rotate_right, size: 18),
                label: Text(
                  calculatorProvider.isRadianMode ? 'RAD' : 'DEG',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showScientificKeypad = !_showScientificKeypad;
                  });
                },
                icon: Icon(
                  _showScientificKeypad ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 18,
                ),
                label: Text(
                  _showScientificKeypad ? 'Basic' : 'Scientific',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        if (_showScientificKeypad) ...[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.16,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _buildScientificKeypad(calculatorProvider, isDarkMode),
            ),
          ),
        ],
        Expanded(
          child: _buildMainKeypad(calculatorProvider, isDarkMode),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(CalculatorProvider calculatorProvider, bool isDarkMode) {
    return Row(
      children: [
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
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: calculatorProvider.toggleAngleMode,
                      icon: const Icon(Icons.rotate_right, size: 16),
                      label: Text(
                        calculatorProvider.isRadianMode ? 'RAD' : 'DEG',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildScientificKeypad(
                    calculatorProvider,
                    isDarkMode,
                    isLandscape: true
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisplay(CalculatorProvider calculatorProvider, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: isDarkMode ? Colors.black54 : Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 30,
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                calculatorProvider.input,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                calculatorProvider.result,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScientificKeypad(
      CalculatorProvider calculatorProvider,
      bool isDarkMode,
      {bool isLandscape = false}
      ) {
    final buttonColor = isDarkMode ? Colors.grey.shade800 : Colors.blue.shade100;

    final firstRowButtons = [
      CalculatorButton(text: 'sin', onPressed: () => calculatorProvider.applyFunction('sin'), color: buttonColor),
      CalculatorButton(text: 'cos', onPressed: () => calculatorProvider.applyFunction('cos'), color: buttonColor),
      CalculatorButton(text: 'tan', onPressed: () => calculatorProvider.applyFunction('tan'), color: buttonColor),
      CalculatorButton(text: 'π', onPressed: () => calculatorProvider.addConstant('π'), color: buttonColor),
    ];

    final secondRowButtons = [
      CalculatorButton(text: 'log', onPressed: () => calculatorProvider.applyFunction('log'), color: buttonColor),
      CalculatorButton(text: 'ln', onPressed: () => calculatorProvider.applyFunction('ln'), color: buttonColor),
      CalculatorButton(text: 'sqrt', onPressed: () => calculatorProvider.applyFunction('sqrt'), color: buttonColor),
      CalculatorButton(text: 'x!', onPressed: calculatorProvider.factorial, color: buttonColor),
    ];

    final additionalButtons = [
      CalculatorButton(text: 'x²', onPressed: calculatorProvider.square, color: buttonColor),
      CalculatorButton(text: 'x³', onPressed: calculatorProvider.cube, color: buttonColor),
    ];

    if (isLandscape) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: [...firstRowButtons, ...secondRowButtons, ...additionalButtons].length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) => [...firstRowButtons, ...secondRowButtons, ...additionalButtons][index],
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: Row(children: firstRowButtons.map((b) => Expanded(child: Padding(padding: const EdgeInsets.all(4.0), child: b))).toList()),
          ),
          Expanded(
            child: Row(children: secondRowButtons.map((b) => Expanded(child: Padding(padding: const EdgeInsets.all(4.0), child: b))).toList()),
          ),
        ],
      );
    }
  }

  Widget _buildMainKeypad(CalculatorProvider calculatorProvider, bool isDarkMode) {
    final numberColor = isDarkMode ? Colors.grey.shade700 : Colors.white;
    final operatorColor = isDarkMode ? Colors.grey.shade800 : Colors.blue.shade200;
    final functionColor = isDarkMode ? Colors.grey.shade900 : Colors.blue.shade300;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 1.3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: [
          CalculatorButton(text: 'C', onPressed: calculatorProvider.clear, color: isDarkMode ? Colors.redAccent.shade700 : Colors.redAccent.shade100),
          CalculatorButton(text: '⌫', onPressed: calculatorProvider.delete, color: functionColor),
          CalculatorButton(text: '%', onPressed: () => calculatorProvider.addInput('%'), color: functionColor),
          CalculatorButton(text: '÷', onPressed: () => calculatorProvider.addInput('÷'), color: operatorColor),

          CalculatorButton(text: '7', onPressed: () => calculatorProvider.addInput('7'), color: numberColor),
          CalculatorButton(text: '8', onPressed: () => calculatorProvider.addInput('8'), color: numberColor),
          CalculatorButton(text: '9', onPressed: () => calculatorProvider.addInput('9'), color: numberColor),
          CalculatorButton(text: '×', onPressed: () => calculatorProvider.addInput('×'), color: operatorColor),

          CalculatorButton(text: '4', onPressed: () => calculatorProvider.addInput('4'), color: numberColor),
          CalculatorButton(text: '5', onPressed: () => calculatorProvider.addInput('5'), color: numberColor),
          CalculatorButton(text: '6', onPressed: () => calculatorProvider.addInput('6'), color: numberColor),
          CalculatorButton(text: '-', onPressed: () => calculatorProvider.addInput('-'), color: operatorColor),

          CalculatorButton(text: '1', onPressed: () => calculatorProvider.addInput('1'), color: numberColor),
          CalculatorButton(text: '2', onPressed: () => calculatorProvider.addInput('2'), color: numberColor),
          CalculatorButton(text: '3', onPressed: () => calculatorProvider.addInput('3'), color: numberColor),
          CalculatorButton(text: '+', onPressed: () => calculatorProvider.addInput('+'), color: operatorColor),

          // Parentheses buttons added here
          CalculatorButton(text: '(', onPressed: () => calculatorProvider.addParenthesis(true), color: functionColor),
          CalculatorButton(text: '0', onPressed: () => calculatorProvider.addInput('0'), color: numberColor),
          CalculatorButton(text: ')', onPressed: () => calculatorProvider.addParenthesis(false), color: functionColor),
          CalculatorButton(text: '=', onPressed: calculatorProvider.evaluateResult,
              color: isDarkMode ? Colors.blue.shade800 : Colors.blue.shade400, textColor: Colors.white),

          CalculatorButton(text: '.', onPressed: () => calculatorProvider.addInput('.'), color: numberColor),
          CalculatorButton(text: '^', onPressed: () => calculatorProvider.addInput('^'), color: operatorColor),
        ],
      ),
    );
  }
}