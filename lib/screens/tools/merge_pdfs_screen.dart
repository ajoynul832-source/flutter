import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MergePdfsScreen extends StatefulWidget {
  const MergePdfsScreen({super.key});

  @override
  State<MergePdfsScreen> createState() => _MergePdfsScreenState();
}

class _MergePdfsScreenState extends State<MergePdfsScreen> {
  final List<File> _selectedFiles = [];
  bool _isMerging = false;

  Future<void> _pickPdfs() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());
      });
    }
  }

  Future<void> _merge() async {
    setState(() => _isMerging = true);
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isMerging = false);
    
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Merge functionality requires native library integration (Placeholder).")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Merge PDFs")),
      body: Column(
        children: [
          Expanded(
            child: _selectedFiles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.files, size: 64, color: Theme.of(context).disabledColor),
                        const SizedBox(height: 16),
                        const Text("Add PDFs to merge"),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _pickPdfs,
                          icon: const Icon(LucideIcons.plus),
                          label: const Text("Select PDFs"),
                        )
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _selectedFiles.length,
                    onReorder: (oldIndex, newIndex) {
                       setState(() {
                        if (oldIndex < newIndex) newIndex -= 1;
                        final item = _selectedFiles.removeAt(oldIndex);
                        _selectedFiles.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      final file = _selectedFiles[index];
                       // Get file size (approx)
                      final sizeMb = (file.lengthSync() / (1024 * 1024)).toStringAsFixed(2);
                      
                      return Card(
                        key: ValueKey(file.path),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(LucideIcons.fileText, color: Colors.red),
                          title: Text(file.path.split('/').last, maxLines: 1),
                          subtitle: Text("$sizeMb MB"),
                          trailing: const Icon(LucideIcons.gripVertical),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selectedFiles.length < 2 ? null : _merge,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: _isMerging 
                 ? const CircularProgressIndicator(color: Colors.white)
                 : const Text("Merge Files"),
              ),
            ),
          )
        ],
      ),
    );
  }
}