import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UniversalRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sub;
  final String? badge;
  final bool hasArrow;
  final VoidCallback? onTap;

  const UniversalRow({
    super.key,
    required this.icon,
    required this.label,
    this.sub,
    this.badge,
    this.hasArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: isDark ? const Color(0xFF18181B) : Colors.white, // zinc-900 / white
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 22, color: Theme.of(context).colorScheme.onSurface),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    if (sub != null)
                      Text(
                        sub!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              if (hasArrow) ...[
                const SizedBox(width: 8),
                Icon(LucideIcons.chevronRight, 
                  size: 18, 
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}