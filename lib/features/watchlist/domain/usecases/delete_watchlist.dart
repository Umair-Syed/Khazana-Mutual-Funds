import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:khazana_mutual_funds/core/error/failures.dart';
import 'package:khazana_mutual_funds/core/usecases/usecase.dart';
import '../repositories/watchlist_repository.dart';

class DeleteWatchlist implements UseCase<void, DeleteWatchlistParams> {
  final WatchlistRepository repository;

  DeleteWatchlist(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteWatchlistParams params) async {
    return await repository.deleteWatchlist(params.id);
  }
}

class DeleteWatchlistParams extends Equatable {
  final String id;

  const DeleteWatchlistParams({required this.id});

  @override
  List<Object?> get props => [id];
}
