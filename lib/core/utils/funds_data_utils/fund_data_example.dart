import 'package:flutter/material.dart';

import 'fund_data_helper.dart';
import 'fund_model.dart';

/// Example widget showing how to use the FundDataHelper class
class FundDataExample extends StatefulWidget {
  const FundDataExample({Key? key}) : super(key: key);

  @override
  State<FundDataExample> createState() => _FundDataExampleState();
}

class _FundDataExampleState extends State<FundDataExample> {
  List<Map<String, String>>? _funds;
  List<NavPoint>? _navHistory;
  UserHolding? _userHolding;
  double? _todayNav;
  String? _selectedFundId;

  @override
  void initState() {
    super.initState();
    _loadFundsList();
  }

  /// Load the list of funds
  Future<void> _loadFundsList() async {
    final funds = await FundDataHelper.getFundsList();
    setState(() {
      _funds = funds;
      // Select the first fund by default
      if (funds.isNotEmpty) {
        _selectedFundId = funds.first['id'];
        _loadFundData(_selectedFundId!);
      }
    });
  }

  /// Load data for a specific fund
  Future<void> _loadFundData(String fundId) async {
    // Load NAV history for the past 3 months
    final navHistory = await FundDataHelper.getNavHistory(
      fundId,
      NavHistoryRange.threeMonths,
    );

    // Load user holdings
    final userHolding = await FundDataHelper.getUserHolding(fundId);

    // Load today's NAV
    final todayNav = await FundDataHelper.getTodayNav(fundId);

    setState(() {
      _navHistory = navHistory;
      _userHolding = userHolding;
      _todayNav = todayNav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fund Data Example')),
      body:
          _funds == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedFundId,
                      hint: const Text('Select a fund'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFundId = newValue;
                          if (newValue != null) {
                            _loadFundData(newValue);
                          }
                        });
                      },
                      items:
                          _funds!.map<DropdownMenuItem<String>>((
                            Map<String, String> fund,
                          ) {
                            return DropdownMenuItem<String>(
                              value: fund['id'],
                              child: Text(fund['name']!),
                            );
                          }).toList(),
                    ),
                  ),
                  if (_todayNav != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Today\'s NAV',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${_todayNav!.toStringAsFixed(2)}',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_userHolding != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Investment',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Invested Amount'),
                                      Text(
                                        '₹${_userHolding!.investedAmount.toStringAsFixed(2)}',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Units'),
                                      Text(
                                        '${_userHolding!.units.toStringAsFixed(2)}',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_navHistory != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'NAV History (Past 3 Months)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  if (_navHistory != null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _navHistory!.length,
                        itemBuilder: (context, index) {
                          final navPoint = _navHistory![index];
                          return ListTile(
                            title: Text(
                              '${navPoint.date.day}/${navPoint.date.month}/${navPoint.date.year}',
                            ),
                            trailing: Text(
                              '₹${navPoint.nav.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
    );
  }
}
