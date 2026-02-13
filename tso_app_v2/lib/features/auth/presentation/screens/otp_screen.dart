// lib/features/auth/presentation/screens/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/custom_button.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  const OTPScreen({super.key, this.mobileNumber = ''});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
        (index) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _handleVerification() {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 6) {
      // Navigate to dashboard after successful verification
      context.go('/dashboard');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully verified!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header
                const Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter the OTP sent to ${widget.mobileNumber}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Wrong number? ',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/sign_in');
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // OTP Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                        (index) => Container(
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _otpControllers[index].text.isNotEmpty
                              ? Colors.blue.shade700
                              : Colors.grey.shade200,
                          width: _otpControllers[index].text.isNotEmpty ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            setState(() {});
                            _onOtpChanged(value, index);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Timer
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 20,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '00:30',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Verify Button
                CustomButton(
                  text: 'VERIFY & PROCEED',
                  onPressed: _handleVerification,
                  color: Colors.blue.shade700,
                  icon: Icons.check_circle_outline,
                ),
                const SizedBox(height: 30),
                // Resend
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Didn't receive the code?",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}