import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_state.dart';

class EmailInputWidget extends StatefulWidget {
  final Function(String) onEmailSubmit;

  const EmailInputWidget({super.key, required this.onEmailSubmit});

  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> {
  final _emailController = TextEditingController();
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateEmail);
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    setState(() {
      _isEmailValid = emailRegex.hasMatch(_emailController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Welcome back text
            const Text(
              'Welcome Back,',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Row(
              children: [
                Text(
                  'We Missed You!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Text('🎉', style: TextStyle(fontSize: 20)),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                children: [
                  const TextSpan(text: 'Glad to have you back at '),
                  TextSpan(
                    text: 'Dhan Saarthi',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            const Text(
              'Enter your email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Email input field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withAlpha(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'user@example.com',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.grey[600],
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),

            const Spacer(),

            // Proceed button
            Center(
              child: SizedBox(
                width: 280,
                child: ElevatedButton(
                  onPressed:
                      _isEmailValid
                          ? () => widget.onEmailSubmit(_emailController.text)
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isEmailValid
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainer,
                    disabledBackgroundColor:
                        Theme.of(context).colorScheme.surfaceContainer,
                    disabledForegroundColor: Colors.grey[700],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color:
                            _isEmailValid
                                ? Colors.transparent
                                : Colors.grey[700]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state.status == AuthStateStatus.loading) {
                        return const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }
                      return Text(
                        'Proceed',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              _isEmailValid
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Colors.grey[700],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Terms and policy text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'By signing in, you agree to our ',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade100),
                ),
                Text(
                  'T&C',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' and ',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade100),
                ),
                Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
