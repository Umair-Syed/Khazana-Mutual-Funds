import 'package:hive/hive.dart';
import '../../domain/entities/watchlist_entity.dart';

part 'watchlist_model.g.dart';

@HiveType(typeId: 0)
class WatchlistModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> fundIds;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  WatchlistModel({
    required this.id,
    required this.name,
    required this.fundIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WatchlistModel.fromEntity(WatchlistEntity entity) {
    return WatchlistModel(
      id: entity.id,
      name: entity.name,
      fundIds: List<String>.from(entity.fundIds),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  WatchlistEntity toEntity() {
    return WatchlistEntity(
      id: id,
      name: name,
      fundIds: List<String>.from(fundIds),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  WatchlistModel copyWith({
    String? id,
    String? name,
    List<String>? fundIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WatchlistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fundIds: fundIds ?? this.fundIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
