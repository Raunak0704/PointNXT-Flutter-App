import '../../core/app_export.dart';
import './widgets/background_decoration_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/welcome_header_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Mock credentials for authentication
  final Map<String, String> _mockCredentials = {
    'admin@pointnxt.com': 'admin123',
    'manager@pointnxt.com': 'manager456',
    'staff@pointnxt.com': 'staff789',
  };

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (_mockCredentials.containsKey(username) &&
        _mockCredentials[username] == password) {
      // Success - Navigate to dashboard (placeholder)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );

        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/dashboard-screen');
          }
        });
      }
    } else {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Invalid credentials. Please check your username and password.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleForgotPassword() {
    Navigator.of(context).pushNamed(AppRoutes.passwordResetScreen);
  }

  void _handleSignUp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign up functionality coming soon!'),
      ),
    );
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
                    SizedBox(height: 8.h),

                    // Welcome header with illustration
                    const WelcomeHeaderWidget(),

                    SizedBox(height: 6.h),

                    // Login form card
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
                      child: LoginFormWidget(
                        formKey: _formKey,
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                        usernameFocusNode: _usernameFocusNode,
                        passwordFocusNode: _passwordFocusNode,
                        isPasswordVisible: _isPasswordVisible,
                        isLoading: _isLoading,
                        onTogglePasswordVisibility: _togglePasswordVisibility,
                        onSignIn: _handleSignIn,
                        onForgotPassword: _handleForgotPassword,
                        onSignUp: _handleSignUp,
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
