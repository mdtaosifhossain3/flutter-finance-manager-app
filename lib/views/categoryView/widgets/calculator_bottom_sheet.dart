import 'package:flutter/material.dart';

class CalculatorBottomSheet extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onClose;

  const CalculatorBottomSheet({
    super.key,
    required this.controller,
    required this.onClose,
  });

  @override
  State<CalculatorBottomSheet> createState() => _CalculatorBottomSheetState();
}

class _CalculatorBottomSheetState extends State<CalculatorBottomSheet> {
  String _expression = "";
  String _result = "";

  @override
  void initState() {
    super.initState();
    // Initialize expression with current value if it's a valid number
    if (widget.controller.text.isNotEmpty) {
      _expression = widget.controller.text;
    }
  }

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = "";
        _result = "";
      } else if (value == 'DEL') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        // This case is now handled by the dedicated "Done" button,
        // but keeping it here for robustness if '=' is ever pressed directly.
        _evaluate();
      } else if (value == '%') {
        _handlePercentage();
      } else {
        // Handle operators
        if (_isOperator(value)) {
          if (_expression.isNotEmpty &&
              _isOperator(_expression[_expression.length - 1])) {
            // Replace last operator
            _expression =
                _expression.substring(0, _expression.length - 1) + value;
          } else {
            _expression += value;
          }
        } else {
          _expression += value;
        }
      }
    });
  }

  bool _isOperator(String value) {
    return value == '+' || value == '-' || value == '×' || value == '÷';
  }

  void _handlePercentage() {
    if (_expression.isEmpty) return;

    // Find the last number
    String lastNumber = "";
    int i = _expression.length - 1;
    while (i >= 0 && !_isOperator(_expression[i])) {
      lastNumber = _expression[i] + lastNumber;
      i--;
    }

    if (lastNumber.isNotEmpty) {
      double? val = double.tryParse(lastNumber);
      if (val != null) {
        String newVal = (val / 100).toString();
        if (newVal.endsWith('.0')) {
          newVal = newVal.substring(0, newVal.length - 2);
        }

        _expression = _expression.substring(0, i + 1) + newVal;
      }
    }
  }

  void _evaluate() {
    if (_expression.isEmpty) {
      widget.onClose(); // Close if nothing to evaluate
      return;
    }

    String evalExpression = _expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/');

    // Remove trailing operator
    if (_expression.isNotEmpty &&
        _isOperator(_expression[_expression.length - 1])) {
      evalExpression = evalExpression.substring(0, evalExpression.length - 1);
    }

    try {
      final result = _calculate(evalExpression);
      String formattedResult = result.toString();
      if (formattedResult.endsWith('.0')) {
        formattedResult = formattedResult.substring(
          0,
          formattedResult.length - 2,
        );
      }

      setState(() {
        _result = formattedResult;
        widget.controller.text = formattedResult;
        _expression = formattedResult;
      });
      // Close after successful evaluation
      widget.onClose();
    } catch (e) {
      setState(() {
        _result = "Error";
      });
    }
  }

  double _calculate(String expression) {
    // Basic parser for + - * /
    // We'll use a simple approach: split by operators and handle precedence
    // Note: This is a simplified parser. For complex expressions, a proper parser is needed.
    // We will handle * and / first, then + and -

    // 1. Tokenize
    List<String> tokens = [];
    String currentNumber = "";
    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      if (char == '+' || char == '-' || char == '*' || char == '/') {
        if (currentNumber.isNotEmpty) {
          tokens.add(currentNumber);
          currentNumber = "";
        }
        tokens.add(char);
      } else {
        currentNumber += char;
      }
    }
    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber);
    }

    if (tokens.isEmpty) return 0;

    // 2. Handle * and /
    List<String> intermediateTokens = [];
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        if (intermediateTokens.isEmpty) {
          // This case should ideally not happen with a valid expression,
          // but adding a check for robustness.
          // If the expression starts with an operator, or has consecutive operators.
          // For now, just skip and continue.
          continue;
        }
        double left = double.parse(intermediateTokens.removeLast());
        double right = double.parse(tokens[i + 1]);
        double res = tokens[i] == '*' ? left * right : left / right;
        intermediateTokens.add(res.toString());
        i++; // Skip next number
      } else {
        intermediateTokens.add(tokens[i]);
      }
    }

    if (intermediateTokens.isEmpty) return 0;

    // 3. Handle + and -
    double finalResult = double.parse(intermediateTokens[0]);
    for (int i = 1; i < intermediateTokens.length; i += 2) {
      String op = intermediateTokens[i];
      double val = double.parse(intermediateTokens[i + 1]);
      if (op == '+') {
        finalResult += val;
      } else {
        finalResult -= val;
      }
    }

    return finalResult;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display Area
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression.isEmpty ? "0" : _expression,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                if (_result.isNotEmpty && _result != _expression)
                  Text(
                    "= $_result",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          // Main Layout: Row with 2 columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Side: Numbers and Operators (Flex 4)
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildRow(['1', '2', '3', '÷']),
                    SizedBox(height: 12),
                    _buildRow(['4', '5', '6', '×']),
                    SizedBox(height: 12),
                    _buildRow(['7', '8', '9', '-']),
                    SizedBox(height: 12),
                    _buildRow(['.', '0', 'DEL', '+']),
                  ],
                ),
              ),
              SizedBox(width: 12),
              // Right Side: Actions (Flex 1)
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildButton('C', color: Theme.of(context).cardColor),
                    SizedBox(height: 12),
                    _buildButton('%', color: Theme.of(context).cardColor),
                    SizedBox(height: 12),
                    // Done Button - Spans 2 rows height roughly
                    // We can use a Container with calculated height or AspectRatio
                    // Since other buttons are aspect ratio 1, this should be height of 2 buttons + spacing
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Approximate height based on width (since aspect ratio is 1 for others)
                        // But here we are in a column.
                        // Let's just use a fixed aspect ratio that is double the others?
                        // Or better, just a Container that fills the rest?
                        // The left side has 4 rows. This side has 2 buttons + Done.
                        // So Done should be roughly 2 rows height.
                        return AspectRatio(
                          aspectRatio:
                              0.67, // Tweak this to match 2 buttons height + spacing
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _evaluate,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue, // Primary Blue
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> items) {
    return Row(
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: _buildButton(
              item,
              color: Theme.of(context).cardColor,
              textColor: ['÷', '×', '-', '+'].contains(item)
                  ? Theme.of(context).primaryColor
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onPressed(text),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: text == 'DEL'
                  ? Icon(
                      Icons.backspace_outlined,
                      size: 20,
                      color: Theme.of(context).iconTheme.color,
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            textColor ??
                            Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
