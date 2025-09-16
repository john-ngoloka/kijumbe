import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class ModernStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const ModernStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCardGrid extends StatelessWidget {
  final List<StatCardData> stats;
  final int crossAxisCount;

  const StatCardGrid({super.key, required this.stats, this.crossAxisCount = 2});

  @override
  Widget build(BuildContext context) {
    return Column(children: _buildRows());
  }

  List<Widget> _buildRows() {
    List<Widget> rows = [];
    for (int i = 0; i < stats.length; i += crossAxisCount) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < crossAxisCount && i + j < stats.length; j++) {
        final stat = stats[i + j];
        rowChildren.add(
          Expanded(
            child: ModernStatCard(
              icon: stat.icon,
              title: stat.title,
              value: stat.value,
              color: stat.color,
            ),
          ),
        );
        if (j < crossAxisCount - 1 && i + j + 1 < stats.length) {
          rowChildren.add(const SizedBox(width: 16));
        }
      }
      rows.add(Row(children: rowChildren));
      if (i + crossAxisCount < stats.length) {
        rows.add(const SizedBox(height: 16));
      }
    }
    return rows;
  }
}

class StatCardData {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatCardData({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });
}
