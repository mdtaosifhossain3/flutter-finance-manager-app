import 'package:finance_manager_app/config/myColors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;
  final Map<IconData, String> socialLinks;

  const ProfileCard({
    super.key,
    required this.name,
    required this.role,
    required this.imagePath,
    required this.socialLinks,
  });

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.18,
            child: Image.asset(
              imagePath,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            role,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: socialLinks.entries.map((entry) {
              // Filter for LinkedIn, Email, Facebook only if not already filtered by data
              // But user asked to "add only", implying data might need change or widget should filter.
              // Better to control data passed to it, but I will ensure icons are small here.
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _buildSocialIcon(
                  context,
                  icon: entry.key,
                  color: _getColorForIcon(entry.key, context),
                  onTap: () => _launchUrl(entry.value),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getColorForIcon(IconData icon, BuildContext context) {
    if (icon == FontAwesomeIcons.linkedin) return const Color(0xFF0077B5);
    if (icon == FontAwesomeIcons.facebook) return const Color(0xFF1877F2);
    if (icon == Icons.email) return Colors.redAccent;
    return AppColors.primaryBlue;
  }

  Widget _buildSocialIcon(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FaIcon(icon, color: color, size: 16),
      ),
    );
  }
}
