import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_helper.dart';

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
  String _loadingText = 'Initializing Hostel Mess Management...';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    // Wait a bit more then navigate directly to login
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Get.offAllNamed('/login');
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
        await Future.delayed(const Duration(milliseconds: 300));
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
                      SizedBox(
                        height: ResponsiveHelper.getSpacing(context, 'large'),
                      ),
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
            width: ResponsiveHelper.getValue<double>(
              context,
              mobile: 120,
              tablet: 150,
              desktop: 180,
            ),
            height: ResponsiveHelper.getValue<double>(
              context,
              mobile: 120,
              tablet: 150,
              desktop: 180,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, 'large'),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: ResponsiveHelper.getIconSize(context, 'large'),
                  color: AppColors.primary,
                ),
               ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.getSpacing(context, 'large')),

          // App Title and Subtitle
          Text(
            'Hostel Mess Management',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'heading1'),
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'small')),
          Text(
            'Smart Meal Management System',
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'xs')),
          Text(
            'Attendance • Billing • Menu Planning',
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'body3'),
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
            width: ResponsiveHelper.getValue<double>(
              context,
              mobile: 30,
              tablet: 35,
              desktop: 40,
            ),
            height: ResponsiveHelper.getValue<double>(
              context,
              mobile: 30,
              tablet: 35,
              desktop: 40,
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
        ],

        // Loading text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _loadingText,
            key: ValueKey(_loadingText),
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'body2'),
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        if (_isDataLoaded) ...[
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          Icon(
            Icons.check_circle,
            color: Colors.green[300],
            size: ResponsiveHelper.getIconSize(context, 'medium'),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSpacing(context, 'large'),
      ),
      child: Column(
        children: [
          Text(
            'Quick Access',
            style: TextStyle(
              fontSize: ResponsiveHelper.getFontSize(context, 'heading5'),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context, 'medium')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionButton(
                context,
                'Student Login',
                Icons.school,
                () => Get.offAllNamed('/landing', arguments: 'student'),
              ),
              _buildQuickActionButton(
                context,
                'Staff Login',
                Icons.person_outline,
                () => Get.offAllNamed('/landing', arguments: 'staff'),
              ),
              _buildQuickActionButton(
                context,
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
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.getValue<double>(
          context,
          mobile: 60,
          tablet: 70,
          desktop: 80,
        ),
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.getSpacing(context, 'small'),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getBorderRadius(context, 'small'),
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: ResponsiveHelper.getIconSize(context, 'small'),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, 'xs')),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, 'body3'),
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
