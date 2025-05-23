import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khazana_mutual_funds/core/error/failures.dart';
import 'package:khazana_mutual_funds/core/usecases/usecase.dart';
import '../entities/watchlist_entity.dart';
import '../repositories/watchlist_repository.dart';

class CreateWatchlist
    implements UseCase<WatchlistEntity, CreateWatchlistParams> {
  final WatchlistRepository repository;

  CreateWatchlist(this.repository);

  @override
  Future<Either<Failure, WatchlistEntity>> call(
    CreateWatchlistParams params,
  ) async {
    return await repository.createWatchlist(params.name);
  }
}

class CreateWatchlistParams extends Equatable {
  final String name;

  const CreateWatchlistParams({required this.name});

  @override
  List<Object?> get props => [name];
}
