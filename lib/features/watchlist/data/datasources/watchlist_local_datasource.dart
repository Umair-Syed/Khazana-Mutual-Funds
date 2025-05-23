import 'package:hive/hive.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import '../models/watchlist_model.dart';
import '../../domain/entities/watchlist_fund_entity.dart';

abstract class WatchlistLocalDataSource {
  Future<List<WatchlistModel>> getAllWatchlists();
  Future<WatchlistModel?> getWatchlistById(String id);
  Future<WatchlistModel> saveWatchlist(WatchlistModel watchlist);
  Future<void> deleteWatchlist(String id);
  Future<List<WatchlistFundEntity>> getAvailableFunds();
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  static const String _watchlistBoxName = 'watchlists';
  late Box<WatchlistModel> _watchlistBox;

  WatchlistLocalDataSourceImpl() {
    _watchlistBox = Hive.box<WatchlistModel>(_watchlistBoxName);
  }

  @override
  Future<List<WatchlistModel>> getAllWatchlists() async {
    return _watchlistBox.values.toList();
  }

  @override
  Future<WatchlistModel?> getWatchlistById(String id) async {
    return _watchlistBox.get(id);
  }

  @override
  Future<WatchlistModel> saveWatchlist(WatchlistModel watchlist) async {
    await _watchlistBox.put(watchlist.id, watchlist);
    return watchlist;
  }

  @override
  Future<void> deleteWatchlist(String id) async {
    await _watchlistBox.delete(id);
  }

  @override
  Future<List<WatchlistFundEntity>> getAvailableFunds() async {
    try {
      final fundsList = await FundDataHelper.getFundsList();

      return fundsList
          .map(
            (fund) => WatchlistFundEntity(
              id: fund['id'] ?? '',
              name: fund['name'] ?? '',
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load funds: $e');
    }
  }
}
