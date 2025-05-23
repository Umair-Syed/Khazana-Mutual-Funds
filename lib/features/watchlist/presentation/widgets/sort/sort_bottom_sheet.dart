import 'package:flutter/material.dart';
import '../watchlist_content.dart';
import 'sort_option_tile.dart';

class SortBottomSheet extends StatelessWidget {
  final SortOption? currentSortOption;
  final ValueChanged<SortOption> onSortChanged;

  const SortBottomSheet({
    super.key,
    required this.currentSortOption,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          _buildHeader(context),
          SortOptionTile(
            title: 'Title',
            subtitle: 'Sort alphabetically by fund name',
            option: SortOption.title,
            currentSortOption: currentSortOption,
            icon: Icons.sort_by_alpha,
            onTap: onSortChanged,
          ),
          SortOptionTile(
            title: 'NAV',
            subtitle: 'Sort by Net Asset Value (highest first)',
            option: SortOption.nav,
            currentSortOption: currentSortOption,
            icon: Icons.trending_up,
            onTap: onSortChanged,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(100),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text('Sort by', style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required SortOption? currentSortOption,
    required ValueChanged<SortOption> onSortChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SortBottomSheet(
            currentSortOption: currentSortOption,
            onSortChanged: onSortChanged,
          ),
    );
  }
}
