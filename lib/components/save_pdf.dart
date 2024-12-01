import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void _downloadBill(BuildContext context) async {
  final pdf = pw.Document();

  // Add content to PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Bill Details',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Name: $Name'),
          pw.Text('Bill Month: $billMonth'),
          pw.Text('Reading Date: $date'),
          pw.Text('Previous Units: $prevUnits'),
          pw.Text('Current Units: $currUnits'),
          pw.Text('Units Consumed: $totalUnits'),
          pw.Text('Units Price: $unitsPrice'),
          pw.Text('Total Cost: $cost'),
          pw.Text('Electricity Duty: $ed'),
          pw.Text('TV Fee: $tvFee'),
          pw.Text('GST: $GST'),
          pw.Text('FC-SUR: $fcSur'),
          pw.Text('Current Bill: $currBill'),
          pw.SizedBox(height: 20),
          pw.Text(
            'Note: This is an estimated bill. Annual QTR and FPA are excluded, and there may be slight variations in other taxes.',
            style: pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );

  // Get directory to save the PDF
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/Bill_$billMonth.pdf';

  // Save PDF to file
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  // Show confirmation message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Bill downloaded successfully!\nSaved at $filePath'),
      duration: Duration(seconds: 3),
    ),
  );
}
