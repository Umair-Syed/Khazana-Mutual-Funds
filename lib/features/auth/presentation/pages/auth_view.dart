import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_state.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _emailController = TextEditingController();
  String _otp = '';

  @override
  void dispose() {
    _emailController.dispose();
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
          }
        },
        builder: (context, state) {
          if (state.status == AuthStateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AuthStateStatus.otpSent) {
            return _buildOtpVerificationUI(context, state);
          }

          return _buildEmailEntryUI(context);
        },
      ),
    );
  }

  Widget _buildEmailEntryUI(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Login with Email',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_emailController.text.isNotEmpty) {
                  context.read<AuthBloc>().add(
                    SendOtpEvent(_emailController.text),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Get OTP'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpVerificationUI(BuildContext context, AuthState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Verify OTP',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter the OTP sent to ${state.email}',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            OtpTextField(
              numberOfFields: 6,
              borderColor: Theme.of(context).primaryColor,
              focusedBorderColor: Theme.of(context).primaryColor,
              showFieldAsBox: true,
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {
                _otp = verificationCode;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_otp.isNotEmpty && _otp.length == 6) {
                  context.read<AuthBloc>().add(
                    VerifyOtpEvent(email: state.email!, otp: _otp),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Verify OTP'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(SendOtpEvent(state.email!));
              },
              child: const Text('Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
