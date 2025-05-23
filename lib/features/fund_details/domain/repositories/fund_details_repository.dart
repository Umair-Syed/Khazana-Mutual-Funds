import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/fund_details_entity.dart';

abstract class FundDetailsRepository {
  Future<Either<Failure, FundDetailsEntity>> getFundDetails(String fundId);
}
