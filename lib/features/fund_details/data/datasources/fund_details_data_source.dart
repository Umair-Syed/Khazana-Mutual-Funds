import '../../../../core/utils/funds_data_utils/fund_data_helper.dart';
import '../../domain/entities/fund_details_entity.dart';

abstract class FundDetailsDataSource {
  Future<FundDetailsEntity> getFundDetails(String fundId);
}

class FundDetailsDataSourceImpl implements FundDetailsDataSource {
  @override
  Future<FundDetailsEntity> getFundDetails(String fundId) async {
    final fund = await FundDataHelper.getFundsAllDataFromId(fundId);

    if (fund.navHistory.isEmpty) {
      throw Exception('No NAV history found');
    }

    final currentNav = fund.navHistory.last.nav;
    double oneDayChange = 0;
    double oneDayChangePercentage = 0;

    if (fund.navHistory.length > 1) {
      final previousNav = fund.navHistory[fund.navHistory.length - 2].nav;
      oneDayChange = currentNav - previousNav;
      oneDayChangePercentage = (oneDayChange / previousNav) * 100;
    }

    return FundDetailsEntity(
      id: fund.id,
      name: fund.name,
      category: fund.meta.category,
      navHistory: fund.navHistory,
      userHolding: fund.userHolding,
      currentNav: currentNav,
      oneDayChange: oneDayChange,
      oneDayChangePercentage: oneDayChangePercentage,
    );
  }
}
