import 'package:equatable/equatable.dart';

class WatchlistFundEntity extends Equatable {
  final String id;
  final String name;

  const WatchlistFundEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
