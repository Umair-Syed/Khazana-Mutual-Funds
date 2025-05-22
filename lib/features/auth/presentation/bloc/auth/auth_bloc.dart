import 'package:bloc/bloc.dart';
import 'package:khazana_mutual_funds/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:khazana_mutual_funds/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:khazana_mutual_funds/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:khazana_mutual_funds/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignOutUseCase signOutUseCase;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.getCurrentUserUseCase,
    required this.signOutUseCase,
  }) : super(const AuthState()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStateStatus.loading));

    final result = await sendOtpUseCase(event.email);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(status: AuthStateStatus.otpSent, email: event.email),
      ),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.otpVerifyInProgress));

    final params = VerifyOtpParams(email: event.email, otp: event.otp);

    final result = await verifyOtpUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStateStatus.otpError,
          errorMessage: "Invalid OTP! Please try again",
        ),
      ),
      (user) => emit(
        state.copyWith(status: AuthStateStatus.authenticated, user: user),
      ),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStateStatus.loading));

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status:
              user != null
                  ? AuthStateStatus.authenticated
                  : AuthStateStatus.unauthenticated,
          user: user,
        ),
      ),
    );
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStateStatus.loading));

    final result = await signOutUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(const AuthState(status: AuthStateStatus.unauthenticated)),
    );
  }
}
