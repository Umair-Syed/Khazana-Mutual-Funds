import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khazana_mutual_funds/core/error/failures.dart';
import 'package:khazana_mutual_funds/core/usecases/usecase.dart';
import '../entities/watchlist_entity.dart';
import '../repositories/watchlist_repository.dart';

class AddFundToWatchlist
    implements UseCase<WatchlistEntity, AddFundToWatchlistParams> {
  final WatchlistRepository repository;

  AddFundToWatchlist(this.repository);

  @override
  Future<Either<Failure, WatchlistEntity>> call(
    AddFundToWatchlistParams params,
  ) async {
    return await repository.addFundToWatchlist(
      params.watchlistId,
      params.fundId,
    );
  }
}

class AddFundToWatchlistParams extends Equatable {
  final String watchlistId;
  final String fundId;

  const AddFundToWatchlistParams({
    required this.watchlistId,
    required this.fundId,
  });

  @override
  List<Object?> get props => [watchlistId, fundId];
}
