import 'package:flutter/material.dart';
import '../../bloc/watchlist_state.dart';
import 'dart:ui';

class WatchlistsSheet extends StatelessWidget {
  final WatchlistLoaded state;
  final Function(String, String) onEditWatchlist;
  final Function(String) onDeleteWatchlist;
  final VoidCallback onCreateNewWatchlist;

  const WatchlistsSheet({
    super.key,
    required this.state,
    required this.onEditWatchlist,
    required this.onDeleteWatchlist,
    required this.onCreateNewWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.3,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'All Watchlist',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Divider(color: Theme.of(context).colorScheme.outline.withAlpha(90)),
            // Watchlists list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.watchlists.length,
                itemBuilder: (context, index) {
                  final watchlist = state.watchlists[index];
                  return ListTile(
                    title: Text(watchlist.name),
                    trailing: IconButton(
                      onPressed:
                          () => _showEditBottomSheet(
                            context,
                            watchlist.id,
                            watchlist.name,
                          ),
                      icon: const Icon(Icons.edit),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),

            // Create new watchlist button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCreateNewWatchlist();
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  label: Text(
                    'Create a new watchlist',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerLow,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBottomSheet(
    BuildContext context,
    String watchlistId,
    String currentName,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Blur backdrop
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
              // Bottom sheet content
              EditWatchlistSheet(
                watchlistId: watchlistId,
                currentName: currentName,
                onEditWatchlist: onEditWatchlist,
                onDeleteWatchlist: onDeleteWatchlist,
              ),
            ],
          ),
    );
  }
}

class EditWatchlistSheet extends StatelessWidget {
  final String watchlistId;
  final String currentName;
  final Function(String, String) onEditWatchlist;
  final Function(String) onDeleteWatchlist;

  const EditWatchlistSheet({
    super.key,
    required this.watchlistId,
    required this.currentName,
    required this.onEditWatchlist,
    required this.onDeleteWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: currentName);

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
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Edit Watchlist',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDeleteWatchlist(watchlistId);
                  },
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Watchlist name field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Update button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty && name != currentName) {
                    onEditWatchlist(watchlistId, name);
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimary,
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
