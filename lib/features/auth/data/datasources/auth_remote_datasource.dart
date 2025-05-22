import 'package:khazana_mutual_funds/core/error/failures.dart';
import 'package:khazana_mutual_funds/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String email);
  Future<UserModel> verifyOtp(String email, String otp);
  Future<UserModel?> getCurrentUser();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> sendOtp(String email) async {
    try {
      await supabaseClient.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
      );
    } catch (e) {
      throw AuthFailure('Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> verifyOtp(String email, String otp) async {
    try {
      final response = await supabaseClient.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.email,
      );

      if (response.user == null) {
        throw const AuthFailure('User not found after verification');
      }

      return UserModel(uid: response.user!.id, email: email);
    } catch (e) {
      throw AuthFailure('Failed to verify OTP: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;

      if (user == null) {
        return null;
      }

      final email = user.email ?? '';

      return UserModel(uid: user.id, email: email);
    } catch (e) {
      throw AuthFailure('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw AuthFailure('Failed to sign out: ${e.toString()}');
    }
  }
}
