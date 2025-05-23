import 'package:equatable/equatable.dart';

class WatchlistEntity extends Equatable {
  final String id;
  final String name;
  final List<String> fundIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WatchlistEntity({
    required this.id,
    required this.name,
    required this.fundIds,
    required this.createdAt,
    required this.updatedAt,
  });

  WatchlistEntity copyWith({
    String? id,
    String? name,
    List<String>? fundIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WatchlistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      fundIds: fundIds ?? this.fundIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, fundIds, createdAt, updatedAt];
}
