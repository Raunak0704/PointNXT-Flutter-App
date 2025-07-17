import '../../../core/app_export.dart';

class BackgroundDecorationWidget extends StatelessWidget {
  const BackgroundDecorationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundGradientStart,
            AppTheme.backgroundGradientEnd,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Top curved decoration
          Positioned(
            top: -10.h,
            right: -15.w,
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Bottom curved decoration
          Positioned(
            bottom: -15.h,
            left: -20.w,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Additional decorative elements
          Positioned(
            top: 20.h,
            left: -10.w,
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryPurple.withValues(alpha: 0.1),
              ),
            ),
          ),

          Positioned(
            bottom: 25.h,
            right: -5.w,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
