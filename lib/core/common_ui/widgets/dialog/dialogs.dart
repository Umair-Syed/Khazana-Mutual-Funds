import 'package:flutter/material.dart';
import 'input_dialog.dart';

sealed class Dialogs {
  const Dialogs._();

  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonText,
    IconData? icon,
    Color? iconColor,
  }) async {
    await showDialog(
      context: context,
      builder:
          (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                width: 0.5,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  if (icon != null) Icon(icon, size: 60, color: iconColor),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      fixedSize: const Size(double.maxFinite, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  static Future<String?> showInputDialog(
    BuildContext context, {
    required String title,
    String? description,
    String? initialValue,
    required String hintText,
    required String submitText,
    String cancelText = "Cancel",
    bool isDestructive = false,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Function(String)? onSubmit,
    Function? onCancel,
    bool isMultiLine = false,
  }) async {
    return await InputDialog.show(
      context: context,
      title: title,
      description: description,
      initialValue: initialValue,
      hintText: hintText,
      submitText: submitText,
      cancelText: cancelText,
      isDestructive: isDestructive,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onSubmit: onSubmit,
      onCancel: onCancel,
      isMultiLine: isMultiLine,
    );
  }
}
