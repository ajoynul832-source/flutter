// ... imports
import '../../services/api_service.dart';
import 'dart:io';

// ... inside _AiSummarizeScreenState class

  // Replace the _summarizePdf method with this:
  Future<void> _summarizePdf() async {
    if (_fileName == null) return;
    
    // We need the File object. In Phase 1 we only got the name. 
    // Ensure your _pickFile method saves the 'path'.
    // Assuming you have: File? _selectedFile;

    setState(() => _isLoading = true);

    // Call Real API
    final apiService = ApiService();
    // Note: ensure _selectedFile is not null
    // If using FilePicker result: File(result.files.single.path!)
    final summary = await apiService.summarizePdf(File(_selectedFile!.path));

    setState(() {
      _isLoading = false;
      _summary = summary;
    });
  }