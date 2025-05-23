import 'package:dartz/dartz.dart';
import 'package:khazana_mutual_funds/core/error/failures.dart';
import 'package:khazana_mutual_funds/core/usecases/usecase.dart';
import '../entities/watchlist_fund_entity.dart';
import '../repositories/watchlist_repository.dart';

class GetAvailableFunds
    implements UseCase<List<WatchlistFundEntity>, NoParams> {
  final WatchlistRepository repository;

  GetAvailableFunds(this.repository);

  @override
  Future<Either<Failure, List<WatchlistFundEntity>>> call(
    NoParams params,
  ) async {
    return await repository.getAvailableFunds();
  }
}
