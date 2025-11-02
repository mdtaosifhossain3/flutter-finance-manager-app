import 'package:flutter/material.dart';

import '../../../config/myColors/app_colors.dart';

class AiTextFieldWidget extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textController;
  const AiTextFieldWidget({
    super.key,
    required this.focusNode,
    required this.textController,
  });

  @override
  State<AiTextFieldWidget> createState() => _AiTextFieldWidgetState();
}

class _AiTextFieldWidgetState extends State<AiTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.focusNode.hasFocus
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor,
          width: 1.5,
        ),
        boxShadow: widget.focusNode.hasFocus
            ? [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: widget.textController,
        focusNode: widget.focusNode,
        maxLines: 6,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText:
              'Type or speak your transaction...\n\nExample: "Spent \$50 on groceries at Whole Foods"',
          hintStyle: TextStyle(
            color: AppColors.textMuted.withValues(alpha: 0.6),
            fontSize: 15,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }
}
