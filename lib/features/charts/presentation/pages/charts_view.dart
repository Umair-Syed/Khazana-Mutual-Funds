import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../bloc/fund_bloc.dart';
import '../widgets/fund_card.dart';

class ChartsView extends StatelessWidget {
  const ChartsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<FundBloc>()..add(const LoadFunds()),
      child: const ChartsViewContent(),
    );
  }
}

class ChartsViewContent extends StatelessWidget {
  const ChartsViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 32,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SizedBox(
            height: 20,
            child: SvgPicture.asset(
              'assets/logo.svg',
              fit: BoxFit.contain,
              width: 20,
              height: 20,
            ),
          ),
        ),
        title: const Text('Mutual Funds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Do nothing for now
            },
          ),
        ],
      ),
      body: BlocBuilder<FundBloc, FundState>(
        builder: (context, state) {
          if (state is FundLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FundLoaded) {
            return ListView.builder(
              itemCount: state.funds.length,
              itemBuilder: (context, index) {
                final fund = state.funds[index];
                return FundCard(fund: fund);
              },
            );
          } else if (state is FundError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text('Select a category to view funds'));
        },
      ),
    );
  }
}
