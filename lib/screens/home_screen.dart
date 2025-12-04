import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/file_list_item.dart'; // See mock below
import '../widgets/quick_action_btn.dart'; // Needs implementation

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Home',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  'What can we help you with today?',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 30),
                
                // Recent Action Cards (Simplified Row)
                Row(
                  children: [
                    _buildRecentCard(context, LucideIcons.download, 'Downloads', null),
                    const SizedBox(width: 10),
                    _buildRecentCard(context, LucideIcons.history, 'Opened', '3'),
                    const SizedBox(width: 10),
                    _buildRecentCard(context, LucideIcons.wand2, 'Processed', '2'),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Recent Files List (Mock)
                const Text('Recent Files', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                // Replace with actual ListView builder in real app
                const MockFileListItem(name: 'Vacation_01.jpg', info: '4.5 MB - 2023-10-26', icon: LucideIcons.image),
                const MockFileListItem(name: 'Budget.xlsx', info: '1.2 MB - 2023-10-25', icon: LucideIcons.fileSpreadsheet),
                
                const SizedBox(height: 30),
                
                // Quick Actions
                Text(
                  'QUICK ACTION',
                  style: TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.bold, 
                    color: Theme.of(context).hintColor
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuickActionBtn(icon: LucideIcons.penLine, label: 'Edit PDF', onTap: () {}),
                    QuickActionBtn(icon: LucideIcons.merge, label: 'Merge', onTap: () {}),
                    QuickActionBtn(icon: LucideIcons.camera, label: 'Scan', onTap: () {}),
                    QuickActionBtn(icon: LucideIcons.layoutGrid, label: 'Tools', onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentCard(BuildContext context, IconData icon, String label, String? badge) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 22),
                if (badge != null) Text(badge, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// Simple Widgets for this screen
class QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionBtn({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Icon(icon, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class MockFileListItem extends StatelessWidget {
  final String name;
  final String info;
  final IconData icon;

  const MockFileListItem({super.key, required this.name, required this.info, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      subtitle: Text(info),
      trailing: const Icon(LucideIcons.moreVertical, size: 16),
      contentPadding: EdgeInsets.zero,
    );
  }
}