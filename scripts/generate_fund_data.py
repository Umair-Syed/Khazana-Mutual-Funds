#!/usr/bin/env python3
import json
import argparse
import random
import datetime
import os
from pathlib import Path

def generate_nav_history(initial_nav, today_nav, start_date, end_date):
    """Generate NAV history with realistic fluctuations."""
    date_range = []
    current_date = start_date
    while current_date <= end_date:
        date_range.append(current_date)
        current_date += datetime.timedelta(days=1)
    
    # Calculate a trend line between initial and today nav
    days_total = (end_date - start_date).days
    daily_change = (today_nav - initial_nav) / days_total
    
    # Generate daily NAVs with fluctuations
    navs = []
    current_nav = initial_nav
    
    for i, date in enumerate(date_range):
        # Add random fluctuation (more volatile in middle periods)
        volatility = 0.003  # Base volatility
        # More volatility in middle periods
        phase = i / len(date_range)
        if 0.3 < phase < 0.7:
            volatility *= 2
            
        # Random walk with trend
        fluctuation = random.uniform(-volatility, volatility)
        current_nav = current_nav + daily_change + (current_nav * fluctuation)
        
        # Ensure NAV stays positive
        current_nav = max(current_nav, 0.1)
        
        # Include data points for each day
        navs.append({
            "date": date.strftime("%Y-%m-%d"),
            "nav": round(current_nav, 2)
        })
    
    # Ensure the final NAV matches the target
    if navs[-1]["date"] == end_date.strftime("%Y-%m-%d"):
        navs[-1]["nav"] = round(today_nav, 2)
    else:
        navs.append({
            "date": end_date.strftime("%Y-%m-%d"),
            "nav": round(today_nav, 2)
        })
    
    return navs

def generate_fund_data(fund_id, fund_name, initial_nav, today_nav):
    """Generate a complete fund dataset."""
    # Set up dates
    end_date = datetime.date.today()
    start_date = end_date - datetime.timedelta(days=365*3)  # 3 years of data
    
    # Random purchase date near the start
    purchase_offset = random.randint(0, 90)  # Within first 3 months
    purchase_date = start_date + datetime.timedelta(days=purchase_offset)
    
    # Generate random AUM between 500M and 5000M
    aum = random.randint(500, 5000) * 1000000
    
    # Determine category from name
    category = "Equity"
    if "midcap" in fund_id.lower() or "Midcap" in fund_name:
        category = "Midcap"
    elif "smallcap" in fund_id.lower() or "Smallcap" in fund_name:
        category = "Smallcap"
    elif "largecap" in fund_id.lower() or "Largecap" in fund_name:
        category = "Largecap"
    elif "debt" in fund_id.lower() or "Debt" in fund_name:
        category = "Debt"
    elif "hybrid" in fund_id.lower() or "Hybrid" in fund_name:
        category = "Hybrid"
    
    # Generate NAV history
    nav_history = generate_nav_history(initial_nav, today_nav, start_date, end_date)
    
    # Random invested amount between 50,000 and 500,000
    invested_amount = random.randint(50, 500) * 1000
    
    # Get NAV on purchase date (closest to purchase_date)
    purchase_date_str = purchase_date.strftime("%Y-%m-%d")
    closest_date = min(nav_history, key=lambda x: abs(datetime.datetime.strptime(x["date"], "%Y-%m-%d").date() - purchase_date))
    purchase_nav = closest_date["nav"]
    
    # Calculate units based on invested amount and purchase NAV
    units = round(invested_amount / purchase_nav, 2)
    
    return {
        "id": fund_id,
        "name": fund_name,
        "meta": {
            "aum": aum,
            "category": category
        },
        "navHistory": nav_history,
        "userHolding": {
            "investedAmount": invested_amount,
            "units": units,
            "purchaseNav": purchase_nav,
            "lastPurchaseDate": purchase_date_str
        }
    }

def save_or_update_fund_data(fund_data, output_file):
    """Save or update fund data in the output file."""
    # Create directory if it doesn't exist
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    
    # Read existing data if file exists
    if os.path.exists(output_file):
        with open(output_file, 'r') as f:
            try:
                funds = json.load(f)
            except json.JSONDecodeError:
                funds = []
    else:
        funds = []
    
    # Check if fund already exists and update it
    fund_exists = False
    for i, fund in enumerate(funds):
        if fund["id"] == fund_data["id"]:
            funds[i] = fund_data
            fund_exists = True
            break
    
    # Add new fund if it doesn't exist
    if not fund_exists:
        funds.append(fund_data)
    
    # Write updated data
    with open(output_file, 'w') as f:
        json.dump(funds, f, indent=2)
    
    return len(funds)

def generate_all_funds(output_file='assets/data/funds.json'):
    """Generate data for all funds in the predefined list."""
    # Define a list of funds with their details
    funds_list = [
        # Format: (id, name, initial_nav, today_nav)
        ("motilal-oswal-midcap", "Motilal Oswal Midcap Direct Growth", 90.50, 104.20),
        ("hdfc-largecap", "HDFC Top 100 Direct Growth", 650.25, 780.40),
        ("axis-smallcap", "Axis Small Cap Direct Growth", 45.80, 63.25),
        ("icici-hybrid", "ICICI Prudential Balanced Advantage Direct Growth", 38.75, 51.20),
        ("sbi-debt", "SBI Short Term Debt Direct Growth", 25.40, 29.75),
        ("kotak-banking", "Kotak Banking and Financial Services Fund Direct Growth", 55.30, 72.45),
        ("nippon-pharma", "Nippon India Pharma Fund Direct Growth", 320.15, 380.90),
        ("franklin-bluechip", "Franklin India Bluechip Fund Direct Growth", 780.50, 980.25),
        ("tata-digital", "Tata Digital India Fund Direct Growth", 42.75, 68.30),
        ("aditya-birla-equity", "Aditya Birla Sun Life Equity Fund Direct Growth", 105.60, 145.80),
        # Benchmark indexes
        ("nifty-midcap-150", "Nifty Midcap 150 Index", 95.75, 110.40)
    ]
    
    # Process each fund
    for i, (fund_id, fund_name, initial_nav, today_nav) in enumerate(funds_list):
        fund_data = generate_fund_data(fund_id, fund_name, initial_nav, today_nav)
        count = save_or_update_fund_data(fund_data, output_file)
        print(f"[{i+1}/{len(funds_list)}] Fund '{fund_name}' {'updated' if count > i+1 else 'added'} to {output_file}")
    
    print(f"Total funds in file: {count}")
    return count

def main():
    parser = argparse.ArgumentParser(description='Generate mock data for mutual funds')
    parser.add_argument('--id', help='Fund ID')
    parser.add_argument('--name', help='Fund name')
    parser.add_argument('--initial-nav', type=float, help='Initial NAV value')
    parser.add_argument('--today-nav', type=float, help='Current NAV value')
    parser.add_argument('--output', default='assets/data/funds.json', help='Output JSON file path')
    parser.add_argument('--all', action='store_true', help='Generate all predefined funds')
    
    args = parser.parse_args()
    
    # Generate all predefined funds if --all flag is used
    if args.all:
        generate_all_funds(args.output)
    # Generate a single fund if all required arguments are provided
    elif args.id and args.name and args.initial_nav is not None and args.today_nav is not None:
        fund_data = generate_fund_data(args.id, args.name, args.initial_nav, args.today_nav)
        count = save_or_update_fund_data(fund_data, args.output)
        print(f"Fund '{args.name}' {'updated' if count > 1 else 'added'} to {args.output}")
        print(f"Total funds in file: {count}")
    # If no command-line arguments, generate all funds
    elif not any([args.id, args.name, args.initial_nav, args.today_nav]):
        generate_all_funds(args.output)
    else:
        parser.print_help()
        print("\nError: Missing required arguments for generating a single fund.")
        print("Either use --all flag to generate all predefined funds, or provide all required arguments for a single fund.")

if __name__ == "__main__":
    main() 