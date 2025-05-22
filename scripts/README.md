# Mutual Fund Data Generator

This directory contains scripts for generating mock data for the Khazana Mutual Funds app.

## Generate Fund Data Script

The `generate_fund_data.py` script creates mock data for mutual funds, including NAV history and user holdings. The data is saved in `assets/data/funds.json`.

### Usage

There are multiple ways to use this script:

1. **Generate all predefined funds**:

   ```bash
   python3 scripts/generate_fund_data.py
   ```

   or

   ```bash
   python3 scripts/generate_fund_data.py --all
   ```

2. **Generate a single fund with custom parameters**:
   ```bash
   python3 scripts/generate_fund_data.py --id "fund-id" --name "Fund Name" --initial-nav 90.50 --today-nav 104.20
   ```

### Arguments

- `--all`: Generate all predefined funds (optional)
- `--id`: Fund ID (e.g., "motilal-oswal-midcap")
- `--name`: Fund name (e.g., "Motilal Oswal Midcap Direct Growth")
- `--initial-nav`: Initial NAV value (e.g., 90.50)
- `--today-nav`: Current NAV value (e.g., 104.20)
- `--output`: (Optional) Output JSON file path (default: `assets/data/funds.json`)

### Predefined Funds

The script includes the following predefined funds:

1. Motilal Oswal Midcap Direct Growth
2. HDFC Top 100 Direct Growth
3. Axis Small Cap Direct Growth
4. ICICI Prudential Balanced Advantage Direct Growth
5. SBI Short Term Debt Direct Growth
6. Kotak Banking and Financial Services Fund Direct Growth
7. Nippon India Pharma Fund Direct Growth
8. Franklin India Bluechip Fund Direct Growth
9. Tata Digital India Fund Direct Growth
10. Aditya Birla Sun Life Equity Fund Direct Growth

### Adding More Predefined Funds

To add more funds to the predefined list, edit the `funds_list` in the `generate_all_funds` function inside `generate_fund_data.py`:

```python
funds_list = [
    # Format: (id, name, initial_nav, today_nav)
    ("motilal-oswal-midcap", "Motilal Oswal Midcap Direct Growth", 90.50, 104.20),
    # Add your new fund here:
    ("new-fund-id", "New Fund Name", 100.00, 120.00),
]
```

### Example

```bash
python3 scripts/generate_fund_data.py --id "hdfc-largecap" --name "HDFC Top 100 Direct Growth" --initial-nav 650.25 --today-nav 780.40
```

### Generated Data

The script generates:

1. Fund metadata (ID, name, AUM, category)
2. NAV history for the past 3 years with realistic daily fluctuations
3. Random user holdings with purchase date close to the start of the timeline

### Data Structure

```json
{
  "id": "motilal-oswal-midcap",
  "name": "Motilal Oswal Midcap Direct Growth",
  "meta": {
    "aum": 2548000000,
    "category": "Midcap"
  },
  "navHistory": [
    { "date": "2022-06-01", "nav": 91.59 },
    { "date": "2022-06-02", "nav": 91.67 },
    // ... daily data points ...
    { "date": "2025-05-22", "nav": 104.2 }
  ],
  "userHolding": {
    "investedAmount": 304000,
    "units": 3319.14,
    "purchaseNav": 91.59,
    "lastPurchaseDate": "2022-08-20"
  }
}
```
