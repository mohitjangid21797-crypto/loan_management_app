import 'package:flutter/material.dart';
import 'package:loan_management_app/core/extensions/context_extensions.dart';

/// A labelled number with an icon, used on the dashboard.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Draws the value in the error colour (for example overdue counts).
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final color = highlight ? context.colors.error : context.colors.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Semantics(
          container: true,
          label: '$label: $value',
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color),
                const SizedBox(height: 8),
                Text(label, style: context.textStyles.labelLarge),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: context.textStyles.titleLarge?.copyWith(
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
