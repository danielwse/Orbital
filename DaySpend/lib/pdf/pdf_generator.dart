import 'dart:io' as io;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:DaySpend/pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';

Future<void> generatePDF() async {
  final output = await getTemporaryDirectory();
  final file = io.File("${output.path}/example.pdf");
  bool exist = await file.exists();
  if (!exist) {
    print("attempted to generated pdf");
    final Uint8List bytes = await generateResume(PdfPageFormat.a4);
    print("Location is at: " + file.path);
    await file.writeAsBytes(bytes);
  }
  print("Launching file");
  OpenFile.open(file.path);
}