import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlists extends WatchlistEvent {}

class CreateWatchlistEvent extends WatchlistEvent {
  final String name;

  const CreateWatchlistEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

class SelectWatchlist extends WatchlistEvent {
  final String watchlistId;

  const SelectWatchlist({required this.watchlistId});

  @override
  List<Object?> get props => [watchlistId];
}

class UpdateWatchlistNameEvent extends WatchlistEvent {
  final String id;
  final String name;

  const UpdateWatchlistNameEvent({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class DeleteWatchlistEvent extends WatchlistEvent {
  final String id;

  const DeleteWatchlistEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class AddFundToWatchlistEvent extends WatchlistEvent {
  final String watchlistId;
  final String fundId;

  const AddFundToWatchlistEvent({
    required this.watchlistId,
    required this.fundId,
  });

  @override
  List<Object?> get props => [watchlistId, fundId];
}

class RemoveFundFromWatchlistEvent extends WatchlistEvent {
  final String watchlistId;
  final String fundId;

  const RemoveFundFromWatchlistEvent({
    required this.watchlistId,
    required this.fundId,
  });

  @override
  List<Object?> get props => [watchlistId, fundId];
}

class LoadAvailableFunds extends WatchlistEvent {}

class SearchFunds extends WatchlistEvent {
  final String query;

  const SearchFunds({required this.query});

  @override
  List<Object?> get props => [query];
}

class LoadWatchlistFundData extends WatchlistEvent {
  final String watchlistId;

  const LoadWatchlistFundData({required this.watchlistId});

  @override
  List<Object?> get props => [watchlistId];
}
