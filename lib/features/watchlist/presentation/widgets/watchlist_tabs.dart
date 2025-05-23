import 'package:flutter/material.dart';
import '../../domain/entities/watchlist_entity.dart';

class WatchlistTabs extends StatelessWidget {
  final List<WatchlistEntity> watchlists;
  final WatchlistEntity? selectedWatchlist;
  final Function(String) onWatchlistSelected;

  const WatchlistTabs({
    super.key,
    required this.watchlists,
    required this.selectedWatchlist,
    required this.onWatchlistSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: watchlists.length,
        itemBuilder: (context, index) {
          final watchlist = watchlists[index];
          final isSelected = selectedWatchlist?.id == watchlist.id;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              labelPadding: const EdgeInsets.symmetric(horizontal: 14),
              label: Text(watchlist.name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onWatchlistSelected(watchlist.id);
                }
              },
              backgroundColor: Colors.transparent,
              selectedColor: Theme.of(context).colorScheme.primary,
              showCheckmark: false,
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
