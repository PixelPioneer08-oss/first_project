import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _output = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _output = '';
      } else if (value == '=') {
        try {
          final result = _evaluateExpression(_input);
          _output = result.toString();
          _input = _output;
        } catch (e) {
          _output = 'Error';
        }
      } else {
        if (value != '=') {
          _input += value;
        }
      }
    });
  }

  double _evaluateExpression(String input) {
    final expression = input.replaceAll('×', '*').replaceAll('÷', '/').trim();
    final parsedExpression = Expression.parse(expression);
    final evaluator = const ExpressionEvaluator();
    final result = evaluator.eval(parsedExpression, {});

    if (result is int) return result.toDouble();
    if (result is double) return result;
    throw Exception('Invalid expression');
  }

  Widget _buildButton(String label, {double fontSize = 24}) {
    final isOperator = ['+', '-', '×', '÷', '='].contains(label);
    final backgroundColor = isOperator
        ? (label == '=' ? Colors.green : Colors.orange)
        : (label == 'C' ? Colors.red : Colors.deepPurple);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(label),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(22),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: TextStyle(fontSize: fontSize),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> labels) {
    return Row(children: labels.map((label) => _buildButton(label)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _input,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _output,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildButtonRow(['7', '8', '9', '÷']),
            _buildButtonRow(['4', '5', '6', '×']),
            _buildButtonRow(['1', '2', '3', '-']),
            _buildButtonRow(['0', '.', '=', '+']),
            _buildButtonRow(['C']),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
