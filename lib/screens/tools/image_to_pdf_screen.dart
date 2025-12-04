import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/pdf_service.dart';

class ImageToPdfScreen extends StatefulWidget {
  const ImageToPdfScreen({super.key});

  @override
  State<ImageToPdfScreen> createState() => _ImageToPdfScreenState();
}

class _ImageToPdfScreenState extends State<ImageToPdfScreen> {
  final PdfService _pdfService = PdfService();
  final List<File> _selectedFiles = [];
  final TextEditingController _nameController = TextEditingController();
  bool _isConverting = false;

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _convert() async {
    if (_selectedFiles.isEmpty) return;
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a file name")),
      );
      return;
    }

    setState(() => _isConverting = true);

    // 1. Generate PDF
    final File? pdf = await _pdfService.createPdfFromImages(
      images: _selectedFiles,
      outputName: _nameController.text,
    );

    setState(() => _isConverting = false);

    if (pdf != null && mounted) {
      // 2. Success Dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Success!"),
          content: Text("PDF saved to:\n${pdf.path.split('/').last}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Close screen
              },
              child: const Text("Close"),
            ),
            FilledButton(
              onPressed: () {
                _pdfService.openPdf(pdf);
                Navigator.pop(ctx);
              },
              child: const Text("Open"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image to PDF"),
        elevation: 0,
      ),
      body: Column(
        children: [
          // File List Area
          Expanded(
            child: _selectedFiles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.images, size: 64, color: Theme.of(context).disabledColor),
                        const SizedBox(height: 16),
                        const Text("No images selected"),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _pickImages,
                          icon: const Icon(LucideIcons.plus),
                          label: const Text("Select Images"),
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
                      return Card(
                        key: ValueKey(file.path), // Important for reorder
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Image.file(file, width: 40, height: 40, fit: BoxFit.cover),
                          title: Text(file.path.split('/').last, maxLines: 1),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(LucideIcons.gripVertical, color: Colors.grey),
                              IconButton(
                                icon: const Icon(LucideIcons.trash2, color: Colors.red),
                                onPressed: () => _removeFile(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          // Bottom Controls
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: const Offset(0, -2))],
            ),
            child: Column(
              children: [
                 Row(
                   children: [
                     Expanded(
                       child: OutlinedButton(
                         onPressed: _pickImages,
                         child: const Text("Add More"),
                       ),
                     ),
                   ],
                 ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Output File Name",
                    hintText: "e.g. Vacation_Docs",
                    border: OutlineInputBorder(),
                    suffixText: ".pdf",
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (_selectedFiles.isEmpty || _isConverting) ? null : _convert,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: _isConverting 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Convert to PDF"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}