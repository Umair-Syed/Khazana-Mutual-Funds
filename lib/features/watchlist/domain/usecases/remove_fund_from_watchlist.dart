import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khazana_mutual_funds/core/error/failures.dart';
import 'package:khazana_mutual_funds/core/usecases/usecase.dart';
import '../entities/watchlist_entity.dart';
import '../repositories/watchlist_repository.dart';

class RemoveFundFromWatchlist
    implements UseCase<WatchlistEntity, RemoveFundFromWatchlistParams> {
  final WatchlistRepository repository;

  RemoveFundFromWatchlist(this.repository);

  @override
  Future<Either<Failure, WatchlistEntity>> call(
    RemoveFundFromWatchlistParams params,
  ) async {
    return await repository.removeFundFromWatchlist(
      params.watchlistId,
      params.fundId,
    );
  }
}

class RemoveFundFromWatchlistParams extends Equatable {
  final String watchlistId;
  final String fundId;

  const RemoveFundFromWatchlistParams({
    required this.watchlistId,
    required this.fundId,
  });

  @override
  List<Object?> get props => [watchlistId, fundId];
}
