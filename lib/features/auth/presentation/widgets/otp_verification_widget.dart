import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_state.dart';

// Create a custom text input formatter to handle backspace
class OtpInputFormatter extends TextInputFormatter {
  final TextEditingController controller;
  final VoidCallback? onBackspace;

  OtpInputFormatter(this.controller, {this.onBackspace});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Detect backspace: if new text is empty and old text was not
    if (oldValue.text.isNotEmpty && newValue.text.isEmpty) {
      onBackspace?.call();
    }
    return newValue;
  }
}

class OtpVerificationWidget extends StatefulWidget {
  final String email;
  final Function(String) onOtpSubmit;
  final VoidCallback onResendOtp;
  final bool showErrorMessage;
  final String? errorMessage;

  const OtpVerificationWidget({
    super.key,
    required this.email,
    required this.onOtpSubmit,
    required this.onResendOtp,
    this.showErrorMessage = false,
    this.errorMessage,
  });

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _resendTimer;
  int _secondsRemaining = 30;
  bool _canResend = false;
  bool _isOtpValid = false;
  String? _errorMessage;
  bool _hasAttemptedSubmit = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    // Add listeners to all controllers to check when OTP is complete
    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(_checkOtpCompletion);

      // Add listener to focus nodes to handle backspace
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          // Select all text when focused
          _controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[i].text.length,
          );
        }
      });
    }
  }

  @override
  void didUpdateWidget(OtpVerificationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.errorMessage != widget.errorMessage ||
        oldWidget.showErrorMessage != widget.showErrorMessage) {
      setState(() {
        _errorMessage = widget.errorMessage;
        if (widget.showErrorMessage) {
          _hasAttemptedSubmit = true;
        }
      });
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _secondsRemaining = 30;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _checkOtpCompletion() {
    bool isComplete = true;
    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        isComplete = false;
        break;
      }
    }

    if (isComplete != _isOtpValid) {
      setState(() {
        _isOtpValid = isComplete;
        if (_isOtpValid) {
          _errorMessage = null; // Clear error when user completes the OTP
        }
      });
    }
  }

  void _submitOtp() {
    setState(() {
      _hasAttemptedSubmit = true;
    });

    if (_isOtpValid) {
      final otp = _controllers.map((c) => c.text).join();
      widget.onOtpSubmit(otp);
    } else {
      setState(() {
        _errorMessage = "Please enter a valid 6-digit OTP";
      });
    }
  }

  void _resendOtp() {
    if (_canResend) {
      // clear all controllers
      for (var controller in _controllers) {
        controller.clear();
      }
      setState(() {
        _hasAttemptedSubmit = false;
        _errorMessage = null;
        _isOtpValid = false;
        widget.onResendOtp();
        _startResendTimer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Masked email for display
    final maskedEmail = widget.email.replaceRange(
      1,
      widget.email.indexOf('@'),
      '*' * (widget.email.indexOf('@') - 1),
    );

    return Container(
      color: Colors.black,
      child: SafeArea(
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
                        color: Colors.blue[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),

              // OTP fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => _buildOtpField(index, Colors.white),
                ),
              ),

              if (_errorMessage != null && _hasAttemptedSubmit)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 28),

              // Resend OTP section
              Row(
                children: [
                  Text(
                    'Didn\'t Receive OTP?',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _canResend ? _resendOtp : null,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _canResend ? 'Resend' : 'Resend (${_secondsRemaining}s)',
                      style: TextStyle(
                        fontSize: 14,
                        color: _canResend ? Colors.blue[400] : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'OTP has been sent on $maskedEmail',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),

              const Spacer(),

              // Proceed button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isOtpValid ? _submitOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    disabledBackgroundColor: Colors.grey[900],
                    disabledForegroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state.status == AuthStateStatus.otpVerifyInProgress) {
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
                              _isOtpValid
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Colors.grey[700],
                        ),
                      );
                    },
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
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    'T&C',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' and ',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index, Color color) {
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              // Add custom formatter to handle backspace
              OtpInputFormatter(
                _controllers[index],
                onBackspace: () {
                  if (index > 0) {
                    // Move to previous field
                    _focusNodes[index - 1].requestFocus();
                  }
                },
              ),
            ],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                // Move to next field
                if (index < _controllers.length - 1) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  // Last field, hide keyboard
                  _focusNodes[index].unfocus();
                }
              }
            },
            // Select all text when focused for easy replacement
            onTap: () {
              _controllers[index].selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controllers[index].text.length,
              );
            },
          ),
          Container(
            height: 2,
            color:
                (_errorMessage != null && _hasAttemptedSubmit)
                    ? Colors.red
                    : Theme.of(context).colorScheme.outline,
          ),
        ],
      ),
    );
  }
}
