import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/watchlist_bloc.dart';
import '../../../bloc/watchlist_state.dart';
import 'watchlists_sheet.dart';
import 'create_watchlist_sheet.dart';
import 'dart:ui';

class WatchlistBottomSheet extends StatefulWidget {
  final Function(String) onCreateWatchlist;
  final Function(String, String) onEditWatchlist;
  final Function(String) onDeleteWatchlist;

  const WatchlistBottomSheet({
    super.key,
    required this.onCreateWatchlist,
    required this.onEditWatchlist,
    required this.onDeleteWatchlist,
  });

  @override
  State<WatchlistBottomSheet> createState() => _WatchlistBottomSheetState();
}

class _WatchlistBottomSheetState extends State<WatchlistBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state is WatchlistLoaded) {
          if (state.watchlists.isEmpty) {
            // Show create watchlist directly if no watchlists exist
            return CreateWatchlistSheet(
              onCreateWatchlist: widget.onCreateWatchlist,
            );
          } else {
            // Show list of watchlists with edit options
            return WatchlistsSheet(
              state: state,
              onEditWatchlist: widget.onEditWatchlist,
              onDeleteWatchlist: widget.onDeleteWatchlist,
              onCreateNewWatchlist: _showCreateWatchlistSheet,
            );
          }
        }

        return CreateWatchlistSheet(
          onCreateWatchlist: widget.onCreateWatchlist,
        );
      },
    );
  }

  void _showCreateWatchlistSheet() {
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
              CreateWatchlistSheet(onCreateWatchlist: widget.onCreateWatchlist),
            ],
          ),
    );
  }
}
