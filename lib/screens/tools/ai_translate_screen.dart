import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/api_service.dart';

class AiTranslateScreen extends StatefulWidget {
  const AiTranslateScreen({super.key});

  @override
  State<AiTranslateScreen> createState() => _AiTranslateScreenState();
}

class _AiTranslateScreenState extends State<AiTranslateScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _textController = TextEditingController();
  
  String _selectedLanguage = 'Spanish';
  String _resultText = '';
  bool _isLoading = false;

  final List<String> _languages = [
    'French', 'Spanish', 'German', 'Japanese', 'Chinese', 'Russian', 'Arabic'
  ];

  Future<void> _handleTranslate() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    
    // Call the API
    final result = await _apiService.translateText(
      _textController.text, 
      _selectedLanguage
    );

    setState(() {
      _resultText = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Translate")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: TextField(
                controller: _textController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter text to translate...",
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Language Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  isExpanded: true,
                  icon: const Icon(LucideIcons.chevronDown),
                  items: _languages.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() => _selectedLanguage = newValue!);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Action Button
            FilledButton.icon(
              onPressed: _isLoading ? null : _handleTranslate,
              icon: _isLoading 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(LucideIcons.languages, size: 18),
              label: Text(_isLoading ? "Translating..." : "Translate"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),

            // Result Area
            if (_resultText.isNotEmpty) ...[
              const SizedBox(height: 30),
              const Row(
                children: [
                  Icon(LucideIcons.type, size: 20),
                  SizedBox(width: 8),
                  Text("Translated Text", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
                ),
                child: Text(
                  _resultText,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}