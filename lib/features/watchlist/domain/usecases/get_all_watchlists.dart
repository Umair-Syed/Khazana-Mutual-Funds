import 'package:dartz/dartz.dart';
import 'package:khazana_mutual_funds/core/error/failures.dart';
import 'package:khazana_mutual_funds/core/usecases/usecase.dart';
import '../entities/watchlist_entity.dart';
import '../repositories/watchlist_repository.dart';

class GetAllWatchlists implements UseCase<List<WatchlistEntity>, NoParams> {
  final WatchlistRepository repository;

  GetAllWatchlists(this.repository);

  @override
  Future<Either<Failure, List<WatchlistEntity>>> call(NoParams params) async {
    return await repository.getAllWatchlists();
  }
}
