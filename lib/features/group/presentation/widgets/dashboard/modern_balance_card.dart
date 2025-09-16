import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class ModernBalanceCard extends StatelessWidget {
  final String title;
  final String value;
  final List<BalanceInfo> infoItems;
  final Color? gradientStart;
  final Color? gradientEnd;

  const ModernBalanceCard({
    super.key,
    required this.title,
    required this.value,
    required this.infoItems,
    this.gradientStart,
    this.gradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientStart ?? AppColors.primary,
            gradientEnd ?? AppColors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (gradientStart ?? AppColors.primary).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (infoItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: infoItems
                  .map(
                    (item) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: infoItems.indexOf(item) < infoItems.length - 1
                              ? 16
                              : 0,
                        ),
                        child: _buildBalanceInfo(item),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceInfo(BalanceInfo item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(item.icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BalanceInfo {
  final String label;
  final String value;
  final IconData icon;

  const BalanceInfo({
    required this.label,
    required this.value,
    required this.icon,
  });
}
