import 'package:flutter/material.dart';
import '../watchlist_content.dart';

class SortOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final SortOption option;
  final SortOption? currentSortOption;
  final IconData icon;
  final ValueChanged<SortOption> onTap;

  const SortOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.option,
    required this.currentSortOption,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentSortOption == option;

    return ListTile(
      leading: Icon(
        icon,
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      trailing:
          isSelected
              ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
              : null,
      onTap: () {
        onTap(option);
        Navigator.of(context).pop();
      },
    );
  }
}
