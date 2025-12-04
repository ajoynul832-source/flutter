import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AiSummarizeScreen extends StatefulWidget {
  const AiSummarizeScreen({super.key});

  @override
  State<AiSummarizeScreen> createState() => _AiSummarizeScreenState();
}

class _AiSummarizeScreenState extends State<AiSummarizeScreen> {
  String? _fileName;
  String _summary = '';
  bool _isLoading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _summary = '';
      });
    }
  }

  Future<void> _summarizePdf() async {
    if (_fileName == null) return;

    setState(() => _isLoading = true);

    // Simulate Network/AI Latency
    await Future.delayed(const Duration(seconds: 2));

    // MOCK RESPONSE - In a real app, use http.post to your backend
    setState(() {
      _isLoading = false;
      _summary = "This is a simulated AI summary of the document. \n\n"
          "The document covers the architectural patterns of Flutter applications "
          "and how they differ from React. It emphasizes the widget tree structure, "
          "state management solutions like Provider, and the use of Packages.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI PDF Summarization')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor, 
                    style: BorderStyle.solid
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.upload, size: 40, color: Theme.of(context).hintColor),
                    const SizedBox(height: 10),
                    if (_fileName != null)
                      Text(_fileName!, style: const TextStyle(fontWeight: FontWeight.bold))
                    else
                      Column(
                        children: [
                          const Text("Click to upload", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("PDF (MAX. 5MB)", style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        ],
                      )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: (_fileName != null && !_isLoading) ? _summarizePdf : null,
                icon: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(LucideIcons.wand2, size: 18),
                label: Text(_isLoading ? 'Summarizing...' : 'Summarize PDF'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_summary.isNotEmpty)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(LucideIcons.fileText, size: 20),
                            SizedBox(width: 8),
                            Text("Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                        const Divider(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(_summary, style: const TextStyle(fontSize: 16, height: 1.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}