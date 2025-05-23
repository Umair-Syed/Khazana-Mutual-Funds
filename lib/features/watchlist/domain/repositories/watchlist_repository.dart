import 'package:dartz/dartz.dart';
import 'package:khazana_mutual_funds/core/error/failures.dart';
import '../entities/watchlist_entity.dart';
import '../entities/watchlist_fund_entity.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<WatchlistEntity>>> getAllWatchlists();
  Future<Either<Failure, WatchlistEntity>> getWatchlistById(String id);
  Future<Either<Failure, WatchlistEntity>> createWatchlist(String name);
  Future<Either<Failure, WatchlistEntity>> updateWatchlistName(
    String id,
    String name,
  );
  Future<Either<Failure, void>> deleteWatchlist(String id);
  Future<Either<Failure, WatchlistEntity>> addFundToWatchlist(
    String watchlistId,
    String fundId,
  );
  Future<Either<Failure, WatchlistEntity>> removeFundFromWatchlist(
    String watchlistId,
    String fundId,
  );
  Future<Either<Failure, List<WatchlistFundEntity>>> getAvailableFunds();
}
