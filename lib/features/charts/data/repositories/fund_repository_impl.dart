import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/fund_entity.dart';
import '../../domain/repositories/fund_repository.dart';
import '../datasources/fund_data_source.dart';

class FundRepositoryImpl implements FundRepository {
  final FundDataSource dataSource;

  FundRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<FundEntity>>> getAllFunds() async {
    try {
      final funds = await dataSource.getAllFunds();
      return Right(funds);
    } on DataFailure catch (e) {
      return Left(DataFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
