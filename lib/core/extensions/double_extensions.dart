extension DoubleExtension on double {
  String formatWithPrecision(int precision) {
    return toStringAsFixed(precision);
  }

  String formatAsCurrency() {
    return '₹${toStringAsFixed(2)}';
  }

  String formatAsPercentage() {
    return '${toStringAsFixed(2)}%';
  }

  String formatAsIndianCurrency() {
    if (this >= 10000000) {
      // Crores (1 crore = 10,000,000)
      double crores = this / 10000000;
      return '₹${crores.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}cr';
    } else if (this >= 100000) {
      // Lakhs (1 lakh = 100,000)
      double lakhs = this / 100000;
      return '₹${lakhs.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}L';
    } else if (this >= 1000) {
      // Thousands (1k = 1,000)
      double thousands = this / 1000;
      return '₹${thousands.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}k';
    } else {
      return '₹${toStringAsFixed(0)}';
    }
  }
}
