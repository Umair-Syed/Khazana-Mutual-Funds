import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/bloc/fund_details_bloc.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/pages/fund_details_view.dart';
import 'package:khazana_mutual_funds/injection_container.dart';

class FundDetailsScreen extends StatelessWidget {
  const FundDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fundId = GoRouterState.of(context).pathParameters['fundId'] ?? '';

    return BlocProvider(
      create: (context) => sl<FundDetailsBloc>()..add(LoadFundDetails(fundId)),
      child: const FundDetailsView(),
    );
  }
}
