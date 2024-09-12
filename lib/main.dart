import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';
  String _history = '';
  bool _isNewCalculation = false;

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _result = '';
        _history = '';
        _isNewCalculation = false;
      } else if (buttonText == '=') {
        try {
          final evaluator = const ExpressionEvaluator();
          final exp = Expression.parse(_expression);
          final result = evaluator.eval(exp, {});
          _result = result.toStringAsFixed(8).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
          _history = '$_expression = $_result';
          _expression = _result;
          _isNewCalculation = true;
        } catch (e) {
          _result = 'Error';
          _history = '$_expression = Error';
          _expression = '';
          _isNewCalculation = true;
        }
      } else {
        if (_isNewCalculation) {
          if (isOperator(buttonText)) {
            _expression += ' $buttonText ';
          } else {
            _history = _expression;
            _expression = buttonText;
          }
          _isNewCalculation = false;
        } else {
          if (isOperator(buttonText)) {
            _expression += ' $buttonText ';
          } else if (buttonText == '.' && _canAddDecimal()) {
            _expression += buttonText;
          } else if (buttonText != '.') {
            _expression += buttonText;
          }
        }
        _result = '';
      }
    });
  }

  bool isOperator(String buttonText) {
    return ['+', '-', '*', '/'].contains(buttonText);
  }

  bool _canAddDecimal() {
    final parts = _expression.split(' ');
    if (parts.isEmpty) return true;
    final lastPart = parts.last;
    return !lastPart.contains('.');
  }

  Widget _buildButton(String buttonText, {Color? color}) {
    return Expanded(
      child: MaterialButton(
        padding: const EdgeInsets.all(24.0),
        onPressed: () => _onButtonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        color: color,
        textColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _history,
                    style: const TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('/', color: Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('*', color: Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-', color: Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('=', color: Colors.green),
              _buildButton('+', color: Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              _buildButton('C', color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}