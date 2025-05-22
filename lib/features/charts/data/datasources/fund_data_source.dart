import '../../../../core/error/failures.dart';
import '../../../../core/utils/funds_data_utils/fund_data_helper.dart';
import '../../../../core/utils/funds_data_utils/fund_model.dart' as core_model;
import '../models/fund_model.dart';

abstract class FundDataSource {
  Future<List<FundModel>> getAllFunds();
}

class FundDataSourceImpl implements FundDataSource {
  FundDataSourceImpl();

  @override
  Future<List<FundModel>> getAllFunds() async {
    try {
      final List<core_model.FundOverView> fundsOverview =
          await FundDataHelper.getAllFundsOverview();
      final List<FundModel> funds = [];

      for (var overview in fundsOverview) {
        funds.add(
          FundModel.fromFundOverview(
            overview.id,
            overview.name,
            overview.category,
            overview.nav,
            overview.oneYearReturn,
            overview.threeYearReturn,
            overview.fiveYearReturn,
            25.50, // Using a default value for expense ratio as it's not in FundOverView
          ),
        );
      }

      return funds;
    } catch (e) {
      throw DataFailure(e.toString());
    }
  }
}
