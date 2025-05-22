import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khazana_mutual_funds/core/navigation/routes.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/widgets/email_input_widget.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/widgets/otp_verification_widget.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/widgets/welcome_widget.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final PageController _pageController = PageController();
  String? _currentEmail;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
              ),
            );
          } else if (state.status == AuthStateStatus.authenticated) {
            // Navigate to home screen when authenticated
            context.go(AppRoute.home.path);
          }
        },
        builder: (context, state) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swiping
            children: [
              // Welcome screen
              WelcomeWidget(
                onNext:
                    () => _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
              ),

              // Email input screen
              EmailInputWidget(
                onEmailSubmit: (email) {
                  _currentEmail = email;
                  context.read<AuthBloc>().add(SendOtpEvent(email));
                  _pageController.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),

              // OTP verification screen
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final email = state.email ?? _currentEmail ?? '';
                  return OtpVerificationWidget(
                    email: email,
                    showErrorMessage: state.status == AuthStateStatus.otpError,
                    errorMessage: state.errorMessage,
                    onOtpSubmit: (otp) {
                      context.read<AuthBloc>().add(
                        VerifyOtpEvent(email: email, otp: otp),
                      );
                    },
                    onResendOtp: () {
                      context.read<AuthBloc>().add(SendOtpEvent(email));
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
