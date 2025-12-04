import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../services/file_service.dart';
import '../models/file_model.dart';
import '../widgets/universal_row.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  // Filters: 'root', 'onDevice', 'images', 'documents'
  String _currentView = 'root'; 
  
  // Sub-filter inside lists: 'all', 'image', 'document'
  String _activeFilter = 'all'; 

  @override
  Widget build(BuildContext context) {
    final fileService = Provider.of<FileService>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _currentView == 'root' 
                  ? _buildRootView(context, fileService) 
                  : _buildFileListView(context, fileService),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => fileService.pickAndImportFile(),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  // 1. Dynamic Header
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          if (_currentView != 'root')
            IconButton(
              icon: const Icon(LucideIcons.chevronLeft),
              onPressed: () => setState(() => _currentView = 'root'),
            ),
          Text(
            _getTitle(),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentView) {
      case 'onDevice': return 'On Device';
      case 'images': return 'Images';
      case 'documents': return 'Documents';
      default: return 'Files';
    }
  }

  // 2. Root View (The main dashboard of Files tab)
  Widget _buildRootView(BuildContext context, FileService service) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Storage Cards
        Row(
          children: [
            Expanded(
              child: _buildStorageCard(
                context, 
                LucideIcons.hardDrive, 
                "On Device", 
                "${service.files.length} Files",
                () => setState(() => _currentView = 'onDevice'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStorageCard(
                context, 
                LucideIcons.cloud, 
                "Cloud Drive", 
                "Connect",
                () { /* TODO: Cloud Dialog */ },
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        
        // Quick Access Categories
        Text("QUICK ACCESS", style: TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              UniversalRow(icon: LucideIcons.download, label: 'Downloads', badge: '0', onTap: () {}), // Logic harder for downloads on Android 11+
              const Divider(height: 1),
              UniversalRow(icon: LucideIcons.image, label: 'Images', hasArrow: true, onTap: () => setState(() => _currentView = 'images')),
              const Divider(height: 1),
              UniversalRow(icon: LucideIcons.bookOpen, label: 'Documents', hasArrow: true, onTap: () => setState(() => _currentView = 'documents')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStorageCard(BuildContext context, IconData icon, String title, String sub, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(sub, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
          ],
        ),
      ),
    );
  }

  // 3. File List View (Filtered)
  Widget _buildFileListView(BuildContext context, FileService service) {
    // Filter Logic
    List<LocalFile> filteredFiles = service.files;

    if (_currentView == 'images') {
      filteredFiles = service.files.where((f) => f.type == FileType.image).toList();
    } else if (_currentView == 'documents') {
      filteredFiles = service.files.where((f) => f.type == FileType.document).toList();
    }

    if (_activeFilter == 'image') {
      filteredFiles = filteredFiles.where((f) => f.type == FileType.image).toList();
    } else if (_activeFilter == 'document') {
      filteredFiles = filteredFiles.where((f) => f.type == FileType.document).toList();
    }

    return Column(
      children: [
        // Filter Chips (Only show if we are in 'On Device' view)
        if (_currentView == 'onDevice')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Images', 'image'),
                const SizedBox(width: 8),
                _buildFilterChip('Docs', 'document'),
              ],
            ),
          ),
        
        // List
        Expanded(
          child: filteredFiles.isEmpty 
          ? Center(child: Text("No files found", style: TextStyle(color: Theme.of(context).hintColor)))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: filteredFiles.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final file = filteredFiles[index];
                return ListTile(
                  leading: Icon(_getFileIcon(file.type), color: Theme.of(context).primaryColor),
                  title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text("${file.sizeString} • ${file.dateString}"),
                  trailing: const Icon(LucideIcons.moreVertical, size: 16),
                  contentPadding: EdgeInsets.zero,
                  onTap: () => service.openFile(file.path),
                );
              },
            ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _activeFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : Theme.of(context).dividerColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon(FileType type) {
    switch (type) {
      case FileType.image: return LucideIcons.image;
      case FileType.document: return LucideIcons.fileText;
      case FileType.video: return LucideIcons.video;
      case FileType.audio: return LucideIcons.music;
      default: return LucideIcons.file;
    }
  }
}