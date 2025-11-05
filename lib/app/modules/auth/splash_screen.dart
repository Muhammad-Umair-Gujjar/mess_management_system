import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/common/reusable_button.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isDataLoaded = false;
  bool _showContent = false;
  String _loadingText = 'Initializing MessMaster...';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut),
    );

    _startLoadingSequence();
  }

  void _startLoadingSequence() async {
    // Start fade in animation
    _fadeController.forward();

    // Simulate data loading with different phases
    await _simulateDataLoading();

    // Show splash content for a moment
    setState(() {
      _showContent = true;
    });

    // Wait a bit more then navigate
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Get.offAllNamed('/landing');
    }
  }

  Future<void> _simulateDataLoading() async {
    final loadingSteps = [
      'Loading app data...',
      'Connecting to database...',
      'Fetching user preferences...',
      'Initializing components...',
      'Almost ready...',
    ];

    for (int i = 0; i < loadingSteps.length; i++) {
      if (mounted) {
        setState(() {
          _loadingText = loadingSteps[i];
        });
        await Future.delayed(const Duration(milliseconds: 800));
      }
    }

    setState(() {
      _isDataLoaded = true;
      _loadingText = 'Ready!';
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.8),
              AppColors.accent,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    children: [
                      Expanded(flex: 6, child: _buildMainContent()),
                      Expanded(flex: 2, child: _buildLoadingSection()),
                      if (_showContent) _buildQuickActions(),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App Logo/Animation
          Container(
            width: 180.w,
            height: 180.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 80.sp,
                  color: AppColors.primary,
                ),
                SizedBox(height: 8.h),
                Text(
                  'MessMaster',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40.h),

          // App Title and Subtitle
          Text(
            'MessMaster',
            style: TextStyle(
              fontSize: 42.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Smart Meal Management System',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Attendance • Billing • Menu Planning',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Loading indicator
        if (!_isDataLoaded) ...[
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 20.h),
        ],

        // Loading text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _loadingText,
            key: ValueKey(_loadingText),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        if (_isDataLoaded) ...[
          SizedBox(height: 20.h),
          Icon(Icons.check_circle, color: Colors.green[300], size: 32.sp),
        ],
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionButton(
                'Student Login',
                Icons.school,
                () => Get.offAllNamed('/landing', arguments: 'student'),
              ),
              _buildQuickActionButton(
                'Staff Login',
                Icons.person_outline,
                () => Get.offAllNamed('/landing', arguments: 'staff'),
              ),
              _buildQuickActionButton(
                'Admin Login',
                Icons.admin_panel_settings,
                () => Get.offAllNamed('/landing', arguments: 'admin'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
