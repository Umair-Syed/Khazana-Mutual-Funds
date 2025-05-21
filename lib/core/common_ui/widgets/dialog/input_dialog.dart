import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final String? description;
  final String? initialValue;
  final String hintText;
  final String cancelText;
  final String submitText;
  final bool isDestructive;
  final Function(String) onSubmit;
  final Function? onCancel;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isMultiLine;

  const InputDialog({
    required this.title,
    this.description,
    this.initialValue,
    required this.hintText,
    required this.submitText,
    this.cancelText = "Cancel",
    this.isDestructive = false,
    required this.onSubmit,
    this.onCancel,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isMultiLine = false,
    super.key,
  });

  static Future<String?> show({
    required BuildContext context,
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
    return await showDialog<String>(
      context: context,
      builder:
          (context) => InputDialog(
            title: title,
            description: description,
            initialValue: initialValue,
            hintText: hintText,
            submitText: submitText,
            cancelText: cancelText,
            isDestructive: isDestructive,
            onSubmit: (value) {
              if (onSubmit != null) {
                onSubmit(value);
              }
              Navigator.pop(context, value);
            },
            onCancel: () {
              if (onCancel != null) {
                onCancel();
              }
              Navigator.pop(context);
            },
            keyboardType: keyboardType,
            obscureText: obscureText,
            isMultiLine: isMultiLine,
          ),
    );
  }

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && Platform.isIOS
        ? _IosInputDialog(
          title: widget.title,
          description: widget.description,
          controller: _controller,
          hintText: widget.hintText,
          submitText: widget.submitText,
          cancelText: widget.cancelText,
          isDestructive: widget.isDestructive,
          onSubmit: widget.onSubmit,
          onCancel: widget.onCancel,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          isMultiLine: widget.isMultiLine,
        )
        : _AndroidInputDialog(
          title: widget.title,
          description: widget.description,
          controller: _controller,
          hintText: widget.hintText,
          submitText: widget.submitText,
          cancelText: widget.cancelText,
          isDestructive: widget.isDestructive,
          onSubmit: widget.onSubmit,
          onCancel: widget.onCancel,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          isMultiLine: widget.isMultiLine,
        );
  }
}

class _AndroidInputDialog extends StatelessWidget {
  const _AndroidInputDialog({
    required this.title,
    required this.description,
    required this.controller,
    required this.hintText,
    required this.submitText,
    required this.cancelText,
    required this.isDestructive,
    required this.onSubmit,
    required this.onCancel,
    required this.keyboardType,
    required this.obscureText,
    required this.isMultiLine,
  });

  final String title;
  final String? description;
  final TextEditingController controller;
  final String hintText;
  final String submitText;
  final String cancelText;
  final bool isDestructive;
  final Function(String) onSubmit;
  final Function? onCancel;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isMultiLine;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          width: 0.5,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 12.0,
              ),
            ),
            keyboardType: keyboardType,
            obscureText: obscureText,
            autofocus: true,
            onSubmitted: (value) {
              onSubmit(value);
              Navigator.pop(context, value);
            },
            maxLines: isMultiLine ? null : 1,
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            }
            Navigator.pop(context);
          },
          child: Text(cancelText),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor:
                isDestructive
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            onSubmit(controller.text);
            Navigator.pop(context, controller.text);
          },
          child: Text(submitText),
        ),
      ],
    );
  }
}

class _IosInputDialog extends StatelessWidget {
  const _IosInputDialog({
    required this.title,
    required this.description,
    required this.controller,
    required this.hintText,
    required this.submitText,
    required this.cancelText,
    required this.isDestructive,
    required this.onSubmit,
    required this.onCancel,
    required this.keyboardType,
    required this.obscureText,
    required this.isMultiLine,
  });

  final String title;
  final String? description;
  final TextEditingController controller;
  final String hintText;
  final String submitText;
  final String cancelText;
  final bool isDestructive;
  final Function(String) onSubmit;
  final Function? onCancel;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isMultiLine;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Column(
        children: [
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Text(description!, style: const TextStyle(fontSize: 13)),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CupertinoTextField(
              controller: controller,
              placeholder: hintText,
              keyboardType: keyboardType,
              obscureText: obscureText,
              autofocus: true,
              onSubmitted: (value) {
                onSubmit(value);
                Navigator.pop(context, value);
              },
              maxLines: isMultiLine ? null : 1,
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            }
            Navigator.pop(context);
          },
          child: Text(cancelText),
        ),
        CupertinoDialogAction(
          isDestructiveAction: isDestructive,
          onPressed: () {
            onSubmit(controller.text);
            Navigator.pop(context, controller.text);
          },
          child: Text(submitText),
        ),
      ],
    );
  }
}
