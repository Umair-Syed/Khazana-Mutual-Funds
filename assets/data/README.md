# Mutual Fund Mock Data

This directory contains mock data for the Khazana Mutual Funds app.

## Data Structure

The `funds.json` file contains an array of mutual fund objects with the following structure:

```json
[
  {
    "id": "motilal-oswal-midcap",
    "name": "Motilal Oswal Midcap Direct Growth",
    "meta": {
      "aum": 2548000000, // Assets Under Management in INR
      "category": "Midcap" // Fund category (Midcap, Largecap, Smallcap, Debt, Hybrid, etc.)
    },
    "navHistory": [
      { "date": "2022-06-01", "nav": 91.59 }, // Daily NAV data points for 3 years
      // ... more data points ...
      { "date": "2025-05-22", "nav": 104.2 } // Current date NAV
    ],
    "userHolding": {
      "investedAmount": 304000, // Amount invested by user in INR
      "units": 3319.14, // Number of units held
      "purchaseNav": 91.59, // NAV at purchase time
      "lastPurchaseDate": "2022-08-20" // Date of purchase
    }
  }
  // ... more funds ...
]
```

## Using the Data in Flutter

To use this data in your Flutter app:

1. Make sure the data file is included in your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/data/funds.json
```

2. Load the data in your Flutter app:

```dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<dynamic>> loadFundsData() async {
  final jsonString = await rootBundle.loadString('assets/data/funds.json');
  final jsonData = jsonDecode(jsonString);
  return jsonData;
}
```

3. Use the data in your widgets:

```dart
FutureBuilder(
  future: loadFundsData(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final funds = snapshot.data;
      return ListView.builder(
        itemCount: funds.length,
        itemBuilder: (context, index) {
          final fund = funds[index];
          return ListTile(
            title: Text(fund['name']),
            subtitle: Text(fund['meta']['category']),
            trailing: Text('₹${fund['navHistory'].last['nav']}'),
          );
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  },
)
```

## Generating More Data

Use the `generate_fund_data.py` script in the `scripts` directory to add more funds to the dataset:

```bash
python3 scripts/generate_fund_data.py --id "fund-id" --name "Fund Name" --initial-nav 90.50 --today-nav 104.20
```
