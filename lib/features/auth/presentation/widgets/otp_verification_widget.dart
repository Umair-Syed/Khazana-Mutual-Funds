import 'dart:async';
import 'package:flutter/material.dart';

class OtpVerificationWidget extends StatefulWidget {
  final String email;
  final Function(String) onOtpSubmit;
  final VoidCallback onResendOtp;

  const OtpVerificationWidget({
    super.key,
    required this.email,
    required this.onOtpSubmit,
    required this.onResendOtp,
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

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    // Add listeners to all controllers to check when OTP is complete
    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(_checkOtpCompletion);
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
        _errorMessage = null; // Clear error when user types
      });
    }
  }

  void _submitOtp() {
    if (_isOtpValid) {
      final otp = _controllers.map((c) => c.text).join();
      widget.onOtpSubmit(otp);
    }
  }

  void _resendOtp() {
    if (_canResend) {
      // clear all controllers
      for (var controller in _controllers) {
        controller.clear();
      }
      setState(() {
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
                children: List.generate(6, (index) => _buildOtpField(index)),
              ),

              if (_errorMessage != null)
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
                  child: Text(
                    'Proceed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          _isOtpValid
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.grey[700],
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

              // Page indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
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
          ),
          Container(
            height: 2,
            color: _errorMessage != null ? Colors.red : Colors.red[700],
          ),
        ],
      ),
    );
  }
}
