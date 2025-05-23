import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_mutual_funds/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:khazana_mutual_funds/features/watchlist/presentation/pages/watchlist_view.dart';
import 'package:khazana_mutual_funds/injection_container.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WatchlistBloc>(),
      child: const WatchlistView(),
    );
  }
}
