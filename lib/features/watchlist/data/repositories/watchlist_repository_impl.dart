import 'package:dartz/dartz.dart';
import 'package:khazana_mutual_funds/core/error/failures.dart';
import '../../domain/entities/watchlist_entity.dart';
import '../../domain/entities/watchlist_fund_entity.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_local_datasource.dart';
import '../models/watchlist_model.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<WatchlistEntity>>> getAllWatchlists() async {
    try {
      final watchlistModels = await localDataSource.getAllWatchlists();
      final watchlists =
          watchlistModels.map((model) => model.toEntity()).toList();
      return Right(watchlists);
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WatchlistEntity>> getWatchlistById(String id) async {
    try {
      final watchlistModel = await localDataSource.getWatchlistById(id);
      if (watchlistModel == null) {
        return Left(LocalFailure('Watchlist not found'));
      }
      return Right(watchlistModel.toEntity());
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WatchlistEntity>> createWatchlist(String name) async {
    try {
      final now = DateTime.now();
      final id = now.millisecondsSinceEpoch.toString();

      final watchlistEntity = WatchlistEntity(
        id: id,
        name: name,
        fundIds: [],
        createdAt: now,
        updatedAt: now,
      );

      final watchlistModel = WatchlistModel.fromEntity(watchlistEntity);
      final savedModel = await localDataSource.saveWatchlist(watchlistModel);

      return Right(savedModel.toEntity());
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WatchlistEntity>> updateWatchlistName(
    String id,
    String name,
  ) async {
    try {
      final existingModel = await localDataSource.getWatchlistById(id);
      if (existingModel == null) {
        return Left(LocalFailure('Watchlist not found'));
      }

      final updatedModel = existingModel.copyWith(
        name: name,
        updatedAt: DateTime.now(),
      );

      final savedModel = await localDataSource.saveWatchlist(updatedModel);
      return Right(savedModel.toEntity());
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWatchlist(String id) async {
    try {
      await localDataSource.deleteWatchlist(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WatchlistEntity>> addFundToWatchlist(
    String watchlistId,
    String fundId,
  ) async {
    try {
      final existingModel = await localDataSource.getWatchlistById(watchlistId);
      if (existingModel == null) {
        return Left(LocalFailure('Watchlist not found'));
      }

      if (existingModel.fundIds.contains(fundId)) {
        return Right(existingModel.toEntity()); // Fund already exists
      }

      final updatedFundIds = List<String>.from(existingModel.fundIds)
        ..add(fundId);
      final updatedModel = existingModel.copyWith(
        fundIds: updatedFundIds,
        updatedAt: DateTime.now(),
      );

      final savedModel = await localDataSource.saveWatchlist(updatedModel);
      return Right(savedModel.toEntity());
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WatchlistEntity>> removeFundFromWatchlist(
    String watchlistId,
    String fundId,
  ) async {
    try {
      final existingModel = await localDataSource.getWatchlistById(watchlistId);
      if (existingModel == null) {
        return Left(LocalFailure('Watchlist not found'));
      }

      final updatedFundIds = List<String>.from(existingModel.fundIds)
        ..remove(fundId);
      final updatedModel = existingModel.copyWith(
        fundIds: updatedFundIds,
        updatedAt: DateTime.now(),
      );

      final savedModel = await localDataSource.saveWatchlist(updatedModel);
      return Right(savedModel.toEntity());
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WatchlistFundEntity>>> getAvailableFunds() async {
    try {
      final funds = await localDataSource.getAvailableFunds();
      return Right(funds);
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }
}

class LocalFailure extends Failure {
  const LocalFailure(super.message);
}
