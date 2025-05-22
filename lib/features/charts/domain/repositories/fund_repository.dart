import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/fund_entity.dart';

abstract class FundRepository {
  Future<Either<Failure, List<FundEntity>>> getAllFunds();
}
