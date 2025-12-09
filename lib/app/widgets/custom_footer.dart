import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.textPrimary.withOpacity(0.9),
            AppColors.textPrimary,
          ],
        ),
      ),
      child: Column(
        children: [
          // Top Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo & Description
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.appTagline,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),
                    const SizedBox(height: 16),
                    Text(
                      'Streamline your hostel mess management with our comprehensive solution for attendance tracking, billing, and menu management.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Quick Links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.quickLinks,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3),
                    const SizedBox(height: 16),
                    ...[
                      'About Us',
                      'Contact Us',
                      'Privacy Policy',
                      'Terms of Service',
                    ].asMap().entries.map((entry) {
                      final index = entry.key;
                      final title = entry.value;
                      return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => _launchUrl(title),
                              child: Text(
                                title,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (400 + 100).ms)
                          .slideX(begin: 0.3);
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Contact Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Info',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      FontAwesomeIcons.envelope,
                      'support@hostelmess.com',
                      0,
                    ),
                    _buildContactItem(
                      FontAwesomeIcons.phone,
                      '+92 123 456 7890',
                      1,
                    ),
                    _buildContactItem(
                      FontAwesomeIcons.locationDot,
                      'University Campus, City',
                      2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Divider
          Divider(
            color: Colors.white.withOpacity(0.2),
            thickness: 1,
          ).animate().fadeIn(delay: 300.ms).scaleX(),
          const SizedBox(height: 24),
          // Bottom Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Copyright
              Text(
                AppStrings.copyright,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),
              // Social Links
              Row(
                children: [
                  _buildSocialIcon(FontAwesomeIcons.facebook, 0),
                  const SizedBox(width: 16),
                  _buildSocialIcon(FontAwesomeIcons.twitter, 1),
                  const SizedBox(width: 16),
                  _buildSocialIcon(FontAwesomeIcons.instagram, 2),
                  const SizedBox(width: 16),
                  _buildSocialIcon(FontAwesomeIcons.linkedin, 3),
                ],
              ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (500 + 100).ms).slideX(begin: 0.3);
  }

  Widget _buildSocialIcon(IconData icon, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
    ).animate().fadeIn(delay: (1000 + 100).ms).scale();
  }

  void _launchUrl(String title) async {
    // Mock URL launching
    final urls = {
      'About Us': 'https://hostelmess.com/about',
      'Contact Us': 'https://hostelmess.com/contact',
      'Privacy Policy': 'https://hostelmess.com/privacy',
      'Terms of Service': 'https://hostelmess.com/terms',
    };

    final url = urls[title];
    if (url != null) {
      // In a real app, you would launch the URL
      // await launchUrl(Uri.parse(url));
      print('Opening: $url');
    }
  }
}
