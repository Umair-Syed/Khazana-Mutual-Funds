import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/fund_details_entity.dart';
import '../repositories/fund_details_repository.dart';

class GetFundDetails implements UseCase<FundDetailsEntity, FundParams> {
  final FundDetailsRepository repository;

  GetFundDetails(this.repository);

  @override
  Future<Either<Failure, FundDetailsEntity>> call(FundParams params) async {
    return await repository.getFundDetails(params.fundId);
  }
}

class FundParams extends Equatable {
  final String fundId;

  const FundParams({required this.fundId});

  @override
  List<Object?> get props => [fundId];
}
