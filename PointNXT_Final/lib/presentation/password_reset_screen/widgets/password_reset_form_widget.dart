// lib/presentation/password_reset_screen/widgets/password_reset_form_widget.dart

import '../../../core/app_export.dart';

class PasswordResetFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final bool isLoading;
  final bool isSuccess;
  final VoidCallback onSendResetLink;
  final VoidCallback onBackToLogin;

  const PasswordResetFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.emailFocusNode,
    required this.isLoading,
    required this.isSuccess,
    required this.onSendResetLink,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(6.w),
        child: Form(
            key: formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 2.h),

              // Title
              Text('Reset Password',
                  style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),

              SizedBox(height: 1.h),

              // Subtitle
              Text(
                  isSuccess
                      ? 'Password reset link sent successfully!'
                      : 'Enter your email address below',
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: isSuccess ? Colors.green : AppTheme.textSecondary,
                      height: 1.4)),

              SizedBox(height: 4.h),

              if (!isSuccess) ...[
                // Email input field
                TextFormField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => onSendResetLink(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email_outlined,
                            color: emailFocusNode.hasFocus
                                ? AppTheme.inputFocus
                                : AppTheme.textSecondary,
                            size: 5.w))),

                SizedBox(height: 6.h),

                // Send reset link button
                SizedBox(
                    width: double.infinity,
                    height: 7.h,
                    child: ElevatedButton(
                        onPressed: isLoading ? null : onSendResetLink,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                            shadowColor: Colors.transparent),
                        child: isLoading
                            ? SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white)))
                            : Text('Send Reset Link',
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600)))),
              ] else ...[
                // Success state
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                            width: 1)),
                    child: Column(children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.green, size: 12.w),
                      SizedBox(height: 2.h),
                      Text('Check your email',
                          style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.green)),
                      SizedBox(height: 1.h),
                      Text(
                          'We\'ve sent a password reset link to\n${emailController.text}',
                          style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.textSecondary,
                              height: 1.4),
                          textAlign: TextAlign.center),
                    ])),

                SizedBox(height: 4.h),
              ],

              SizedBox(height: 2.h),

              // Back to login link
              Center(
                  child: TextButton(
                      onPressed: onBackToLogin,
                      style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryPurple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.arrow_back_ios,
                            size: 4.w, color: AppTheme.primaryPurple),
                        SizedBox(width: 1.w),
                        Text('Back to Login',
                            style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primaryPurple)),
                      ]))),

              SizedBox(height: 2.h),
            ])));
  }
}
