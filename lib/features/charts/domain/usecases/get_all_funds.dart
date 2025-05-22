import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/fund_entity.dart';
import '../repositories/fund_repository.dart';

class GetAllFunds implements UseCase<List<FundEntity>, NoParams> {
  final FundRepository repository;

  GetAllFunds(this.repository);

  @override
  Future<Either<Failure, List<FundEntity>>> call(NoParams params) {
    return repository.getAllFunds();
  }
}
