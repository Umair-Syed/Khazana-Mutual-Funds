import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/common_ui/widgets/triple_rail.dart';

class CreateWatchlistSheet extends StatefulWidget {
  final Function(String) onCreateWatchlist;

  const CreateWatchlistSheet({super.key, required this.onCreateWatchlist});

  @override
  State<CreateWatchlistSheet> createState() => _CreateWatchlistSheetState();
}

class _CreateWatchlistSheetState extends State<CreateWatchlistSheet> {
  final TextEditingController _nameController = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _nameController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            TripleRail(
              middle: Text(
                'Create new watchlist',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: Theme.of(context).colorScheme.outline.withAlpha(90)),
            const SizedBox(height: 12),

            // Watchlist name field
            Text(
              'Watchlist Name',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Mid-Cap',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 24),

            // Create button with dynamic styling
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _hasText
                        ? () {
                          final name = _nameController.text.trim();
                          if (name.isNotEmpty) {
                            widget.onCreateWatchlist(name);
                            Navigator.of(context).pop();
                          }
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side:
                        _hasText
                            ? BorderSide.none
                            : BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1,
                            ),
                  ),
                  backgroundColor:
                      _hasText
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerHigh,
                  foregroundColor:
                      _hasText
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                child: Text(
                  'Create',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color:
                        _hasText
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
