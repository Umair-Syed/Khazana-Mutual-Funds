import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension Context on BuildContext {
  void showSnackBarMessage(String message,
      {bool isError = false,
      bool isSuccess = false,
      int? duration,
      String? actionLabel,
      void Function()? actionCallback}) {
    final theme = Theme.of(this);
    final Color? foregroundColor;
    final Color? backgroundColor;

    if (isError) {
      foregroundColor = theme.colorScheme.onSurface;
      backgroundColor = theme.colorScheme.surfaceContainerHighest;
    } else if (isSuccess) {
      foregroundColor = theme.colorScheme.onSurface;
      backgroundColor = theme.colorScheme.surfaceContainerHighest;
    } else {
      foregroundColor = theme.colorScheme.onSurface;
      backgroundColor = theme.colorScheme.surfaceContainerHighest;
    }

    FocusScope.of(this).unfocus();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: duration ?? 2000),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isError
                ? Colors.red.shade700
                : isSuccess
                    ? Colors.green.shade700
                    : theme.colorScheme.surfaceContainerHighest,
            width: 1,
          ),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: foregroundColor),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (actionLabel != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextButton(
                  onPressed: () {
                    actionCallback?.call();
                  },
                  child: Text(
                    actionLabel,
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
