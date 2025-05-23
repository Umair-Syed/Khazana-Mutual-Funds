import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/fund_details_entity.dart';
import '../../domain/repositories/fund_details_repository.dart';
import '../datasources/fund_details_data_source.dart';

class FundDetailsRepositoryImpl implements FundDetailsRepository {
  final FundDetailsDataSource dataSource;

  FundDetailsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, FundDetailsEntity>> getFundDetails(
    String fundId,
  ) async {
    try {
      final fundDetails = await dataSource.getFundDetails(fundId);
      return Right(fundDetails);
    } catch (e) {
      return Left(DataFailure(e.toString()));
    }
  }
}
