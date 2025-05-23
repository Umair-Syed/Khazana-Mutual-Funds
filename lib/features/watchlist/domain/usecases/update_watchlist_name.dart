import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khazana_mutual_funds/core/error/failures.dart';
import 'package:khazana_mutual_funds/core/usecases/usecase.dart';
import '../entities/watchlist_entity.dart';
import '../repositories/watchlist_repository.dart';

class UpdateWatchlistName
    implements UseCase<WatchlistEntity, UpdateWatchlistNameParams> {
  final WatchlistRepository repository;

  UpdateWatchlistName(this.repository);

  @override
  Future<Either<Failure, WatchlistEntity>> call(
    UpdateWatchlistNameParams params,
  ) async {
    return await repository.updateWatchlistName(params.id, params.name);
  }
}

class UpdateWatchlistNameParams extends Equatable {
  final String id;
  final String name;

  const UpdateWatchlistNameParams({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
