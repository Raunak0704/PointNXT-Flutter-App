import '../../core/app_export.dart';
import '../login_screen/widgets/background_decoration_widget.dart';
import './widgets/password_reset_form_widget.dart';
import './widgets/password_reset_header_widget.dart';

// lib/presentation/password_reset_screen/password_reset_screen.dart

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Trigger haptic feedback for success
    HapticFeedback.lightImpact();

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });

      // Auto-navigate back to login after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          _handleBackToLogin();
        }
      });
    }
  }

  void _handleBackToLogin() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen);
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: Stack(
          children: [
            // Background with gradient and decorative elements
            const BackgroundDecorationWidget(),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Password reset header with icon
                    const PasswordResetHeaderWidget(),

                    SizedBox(height: 6.h),

                    // Password reset form card
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: 90.w,
                        minHeight: 45.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: PasswordResetFormWidget(
                        formKey: _formKey,
                        emailController: _emailController,
                        emailFocusNode: _emailFocusNode,
                        isLoading: _isLoading,
                        isSuccess: _isSuccess,
                        onSendResetLink: _handleSendResetLink,
                        onBackToLogin: _handleBackToLogin,
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
