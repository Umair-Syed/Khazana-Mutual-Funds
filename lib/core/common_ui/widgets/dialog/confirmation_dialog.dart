import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final bool isDestructive;
  final Function onConfirm;
  final Function? onCancel;
  final bool shouldNotPop;

  const ConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.isDestructive,
    required this.onConfirm,
    this.onCancel,
    this.shouldNotPop = false,
    super.key,
  });

  ConfirmationDialog.withoutCallbacks({
    Key? key,
    required String title,
    required String message,
    required String confirmText,
    required bool isDestructive,
  }) : this(
         key: key,
         title: title,
         message: message,
         confirmText: confirmText,
         isDestructive: isDestructive,
         onConfirm: () {},
       );

  @override
  Widget build(BuildContext context) {
    return !kIsWeb && Platform.isIOS
        ? _IosConfirmationDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          isDestructive: isDestructive,
          onConfirm: onConfirm,
          onCancel: onCancel,
          shouldNotPop: shouldNotPop,
        )
        : _AndroidConfirmationDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          isDestructive: isDestructive,
          onConfirm: onConfirm,
          onCancel: onCancel,
          shouldNotPop: shouldNotPop,
        );
  }
}

class _AndroidConfirmationDialog extends StatelessWidget {
  const _AndroidConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.isDestructive,
    required this.onConfirm,
    required this.onCancel,
    required this.shouldNotPop,
  });

  final String title;
  final String message;
  final String confirmText;
  final bool isDestructive;
  final Function onConfirm;
  final Function? onCancel;
  final bool shouldNotPop;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium!),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
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
            if (shouldNotPop) {
              return;
            }
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor:
                isDestructive
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            onConfirm();
            if (shouldNotPop) {
              return;
            }
            Navigator.pop(context, true);
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}

class _IosConfirmationDialog extends StatelessWidget {
  const _IosConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.isDestructive,
    required this.onConfirm,
    required this.onCancel,
    required this.shouldNotPop,
  });

  final String title;
  final String message;
  final String confirmText;
  final bool isDestructive;
  final Function onConfirm;
  final Function? onCancel;
  final bool shouldNotPop;
  @override
  Widget build(BuildContext context) {
    const OutlinedBorder buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    );

    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            shape: buttonShape,
          ),
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            }
            if (shouldNotPop) {
              return;
            }
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor:
                isDestructive ? Colors.red : const Color(0xFF0F151A),
            shape: buttonShape,
          ),
          onPressed: () {
            onConfirm();
            if (shouldNotPop) {
              return;
            }
            Navigator.pop(context, true);
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
