import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  bool _isInitializing = true;
  bool _hasError = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  static const Duration _splashDuration = Duration(seconds: 3);
  static const Duration _timeoutDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Text fade animation
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Text slide animation
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      setState(() {
        _isInitializing = true;
        _hasError = false;
      });

      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _fetchEssentialConfig(),
        _prepareCachedData(),
        Future.delayed(_splashDuration), // Minimum splash duration
      ]).timeout(_timeoutDuration);

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate checking authentication
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock authentication check - in real app, check stored tokens/credentials
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock loading preferences - theme, language, etc.
  }

  Future<void> _fetchEssentialConfig() async {
    // Simulate fetching essential configuration
    await Future.delayed(const Duration(milliseconds: 400));
    // Mock API call for app configuration
  }

  Future<void> _prepareCachedData() async {
    // Simulate preparing cached data
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock data preparation for offline functionality
  }

  void _navigateToNextScreen() {
    // Mock authentication status - in real app, check actual auth state
    final bool isAuthenticated = false; // Mock value

    // ignore: dead_code
    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/dashboard-screen');
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  void _retryInitialization() {
    if (_retryCount < _maxRetries) {
      setState(() {
        _retryCount++;
      });
      _initializeApp();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryLight,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryLight,
              AppTheme.primaryVariantLight,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMainContent(),
              ),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo Section
        AnimatedBuilder(
          animation: _logoController,
          builder: (context, child) {
            return Transform.scale(
              scale: _logoScaleAnimation.value,
              child: Opacity(
                opacity: _logoFadeAnimation.value,
                child: _buildLogo(),
              ),
            );
          },
        ),

        SizedBox(height: 6.h),

        // Text Section
        AnimatedBuilder(
          animation: _textController,
          builder: (context, child) {
            return SlideTransition(
              position: _textSlideAnimation,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: _buildBrandingText(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40.w, // Increased from 25.w
      height: 40.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w), // Optional: adjust based on logo margins
        child: Image.asset(
          'assets/images/logo.webp',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildBrandingText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          // Main tagline
          Text(
            'Supercharge your E-Commerce Business with pointNXT',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
          ),

          SizedBox(height: 2.h),

          // Subtext
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              'CONNECT. PROCESS. TRACK.',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.secondaryLight,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        children: [
          if (_hasError) ...[
            _buildErrorSection(),
            SizedBox(height: 4.h),
          ] else if (_isInitializing) ...[
            _buildLoadingIndicator(),
            SizedBox(height: 2.h),
            Text(
              'Initializing...',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.h),
          ],

          // Version info
          Text(
            'Version 1.0.1',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 6.w,
      height: 6.w,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: const AlwaysStoppedAnimation<Color>(
          AppTheme.secondaryLight,
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: AppTheme.secondaryLight,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          'Connection timeout',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        if (_retryCount < _maxRetries)
          TextButton(
            onPressed: _retryInitialization,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.secondaryLight,
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 1.h,
              ),
            ),
            child: Text(
              'Retry ($_retryCount/$_maxRetries)',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/login-screen'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.secondaryLight,
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 1.h,
              ),
            ),
            child: Text(
              'Continue Offline',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
