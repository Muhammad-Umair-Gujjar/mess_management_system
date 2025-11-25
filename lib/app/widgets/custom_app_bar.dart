import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        title: title != null
            ? Text(title!).animate().fadeIn(delay:  300.ms ).slideX(begin: -0.3)
            : null,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                onPressed: onBackPressed ?? () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ).animate().fadeIn(delay:  300.ms ).scale()
            : null,
        actions: actions
            ?.map((action) => action.animate().fadeIn(delay:  300.ms ).scale())
            .toList(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDrawer extends StatelessWidget {
  final String userRole;
  final String userName;
  final String userEmail;
  final List<DrawerItem> menuItems;

  const CustomDrawer({
    super.key,
    required this.userRole,
    required this.userName,
    required this.userEmail,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardBackground,
      child: Column(
        children: [
          // Header
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        FontAwesomeIcons.user,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ).animate().scale(delay:  300.ms ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay:  300.ms ).slideX(begin: -0.3),
                    const SizedBox(height: 4),
                    Text(
                      userRole.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ).animate().fadeIn(delay:  300.ms ).slideX(begin: -0.3),
                  ],
                ),
              ),
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return DrawerMenuTile(item: item, index: index)
                    .animate()
                    .fadeIn(delay: (500 +  100 ).ms)
                    .slideX(begin: -0.3);
              },
            ),
          ),
          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(
                FontAwesomeIcons.rightFromBracket,
                color: AppColors.error,
              ),
              title: Text(
                AppStrings.logout,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.error),
              ),
              onTap: () {
                Get.offAllNamed('/login');
              },
            ),
          ).animate().fadeIn(delay:  300.ms ).slideY(begin: 0.3),
        ],
      ),
    );
  }
}

class DrawerItem {
  final IconData icon;
  final String title;
  final String route;
  final bool isActive;

  const DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
    this.isActive = false,
  });
}

class DrawerMenuTile extends StatelessWidget {
  final DrawerItem item;
  final int index;

  const DrawerMenuTile({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: item.isActive ? AppColors.primaryGradient : null,
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: item.isActive ? Colors.white : AppColors.textSecondary,
        ),
        title: Text(
          item.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: item.isActive ? Colors.white : AppColors.textPrimary,
            fontWeight: item.isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          Get.back();
          Get.toNamed(item.route);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}




