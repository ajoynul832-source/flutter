import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/universal_row.dart';
import '../services/file_service.dart';
import 'qr_scanner_screen.dart';
import 'camera_capture_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String _filter = 'scanned'; // 'scanned' or 'converted'

  Future<void> _openCamera() async {
    final File? result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const CameraCaptureScreen())
    );
    
    if (result != null) {
      // In a real app, this is where you'd trigger the FileService to add it
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image captured! (Saved locally)")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Scanner', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.qrCode),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScannerScreen())),
                      ),
                      FilledButton.icon(
                        onPressed: () => _showNewScanSheet(context),
                        icon: const Icon(LucideIcons.scanLine, size: 16),
                        label: const Text("New Scan"),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildTab("Scanned Images", "scanned"),
                  const SizedBox(width: 20),
                  _buildTab("Converted PDFs", "converted"),
                ],
              ),
            ),
            const Divider(),

            // List (Mocked for now, but uses UI components)
            Expanded(
              child: ListView(
                children: _filter == 'scanned' 
                ? [
                    const UniversalRow(icon: LucideIcons.image, label: "Receipt_Walmart.jpg", sub: "10:23 AM", hasArrow: true),
                    const Divider(height: 1, indent: 50),
                    const UniversalRow(icon: LucideIcons.image, label: "Whiteboard_01.jpg", sub: "Yesterday", hasArrow: true),
                  ] 
                : [
                    const UniversalRow(icon: LucideIcons.fileText, label: "Scan_2025.pdf", sub: "3 Pages", hasArrow: true),
                    const Divider(height: 1, indent: 50),
                    const UniversalRow(icon: LucideIcons.fileText, label: "Contract.pdf", sub: "1.2 MB", hasArrow: true),
                  ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, String id) {
    final isActive = _filter == id;
    return GestureDetector(
      onTap: () => setState(() => _filter = id),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: isActive ? Border(bottom: BorderSide(color: Theme.of(context).primaryColor, width: 2)) : null
        ),
        child: Text(
          label, 
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            color: isActive ? Theme.of(context).colorScheme.onBackground : Theme.of(context).hintColor
          ),
        ),
      ),
    );
  }

  void _showNewScanSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("New Scan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            UniversalRow(
              icon: LucideIcons.camera, 
              label: "Camera", 
              hasArrow: true,
              onTap: () {
                Navigator.pop(ctx);
                _openCamera();
              },
            ),
            const Divider(height: 1, indent: 50),
            UniversalRow(
              icon: LucideIcons.image, 
              label: "From Gallery", 
              hasArrow: true,
              onTap: () async {
                Navigator.pop(ctx);
                // Use FileService from Phase 3
                Provider.of<FileService>(context, listen: false).pickAndImportFile();
              },
            ),
          ],
        ),
      ),
    );
  }
}