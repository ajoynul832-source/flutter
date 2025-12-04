import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../widgets/tool_card.dart';
import 'ai_summarize_screen.dart';

// NEW IMPORTS (required for navigation)
import 'tools/ai_translate_screen.dart';      // <-- ADDED
import 'tools/image_to_pdf_screen.dart';
import 'tools/merge_pdfs_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tools',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- AI TOOLS ----------
          _buildSection('AI Tools', [
            ToolCard(
              icon: LucideIcons.fileText,
              label: 'AI Summary',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiSummarizeScreen()),
              ),
            ),

            // ⭐ UPDATED: AI TRANSLATE BUTTON WORKS NOW
            ToolCard(
              icon: LucideIcons.languages,
              label: 'AI Translate',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiTranslateScreen()),
              ),
            ),

            const ToolCard(
              icon: LucideIcons.sparkles,
              label: 'AI Clean Scan',
            ),
          ]),

          // ---------- CONVERT ----------
          _buildSection('Convert', [
            ToolCard(
              icon: LucideIcons.image,
              label: 'Image to PDF',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ImageToPdfScreen()),
              ),
            ),
            const ToolCard(icon: LucideIcons.fileText, label: 'PDF to Word'),
            const ToolCard(icon: LucideIcons.fileSpreadsheet, label: 'PDF to Excel'),
            const ToolCard(icon: LucideIcons.fileImage, label: 'PDF to JPG'),
          ]),

          // ---------- ORGANIZE ----------
          _buildSection('Organize', [
            ToolCard(
              icon: LucideIcons.merge,
              label: 'Merge PDFs',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MergePdfsScreen()),
              ),
            ),
          ]),

          // ---------- EDIT ----------
          _buildSection('Edit', [
            const ToolCard(icon: LucideIcons.penLine, label: 'Edit PDF'),
            const ToolCard(icon: LucideIcons.rotateCw, label: 'Rotate Pages'),
            const ToolCard(icon: LucideIcons.crop, label: 'Crop PDF'),
            const ToolCard(icon: LucideIcons.stamp, label: 'Watermark'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: children,
        ),
      ],
    );
  }
}