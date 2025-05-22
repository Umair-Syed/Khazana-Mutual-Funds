import 'package:dartz/dartz.dart';
import 'package:khazana_mutual_funds/core/error/failures.dart';
import 'package:khazana_mutual_funds/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendOtp(String email);
  Future<Either<Failure, User>> verifyOtp(String email, String otp);
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> signOut();
}
