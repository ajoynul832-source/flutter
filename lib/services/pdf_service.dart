import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfService {
  
  /// Convert a list of Images (Files) into a single PDF
  Future<File?> createPdfFromImages({
    required List<File> images,
    required String outputName,
  }) async {
    final pdf = pw.Document();

    for (var imageFile in images) {
      final imageBytes = await imageFile.readAsBytes();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }

    try {
      final output = await getApplicationDocumentsDirectory();
      // Ensure name ends with .pdf
      final name = outputName.endsWith('.pdf') ? outputName : '$outputName.pdf';
      final file = File("${output.path}/$name");
      
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      debugPrint("Error saving PDF: $e");
      return null;
    }
  }

  /// Open the generated PDF
  Future<void> openPdf(File file) async {
    await OpenFile.open(file.path);
  }
}