import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../res/colors.dart';
import '../res/components/custom_appbar.dart';
import '../res/components/custom_button.dart';
import '../utils/screen_size.dart';

class BillDetailsHistory extends StatelessWidget {
  final String Name;
  final String docId;
  final String date;
  final String billMonth;
  final String prevUnits;
  final String currUnits;
  final String totalUnits;
  final String unitsPrice;
  final String cost;
  final String ed;
  final double tvFee;
  final String GST;
//  final double Qtr;
  final String fcSur;
 // final double fpa;
  final String currBill;
  const BillDetailsHistory(
      {
        required this.Name,
        required this.docId,
        required this.date,
      required this.billMonth,
      required this.prevUnits,
      required this.currUnits,
      required this.totalUnits,
      required this.unitsPrice,
      required this.tvFee,
      required this.currBill,
      required this.fcSur,
      required this.ed,
      required this.cost,
   //   required this.fpa,
      required this.GST,
    //  required this.Qtr,
      super.key});




  void _printBill(BuildContext context) async {
    try {
      final pdf = pw.Document();

      // Add content to PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                textAlign: pw.TextAlign.center,
                'Bill Details',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              buildRow('Name:', Name),
              buildRow('Bill Month:', billMonth),
              buildRow('Reading Date:', date),
              buildRow('Previous Units:', prevUnits),
              buildRow('Current Units:', currUnits),
              buildRow('Units Consumed:', totalUnits),
              buildRow('Units Price', unitsPrice),
              buildRow('Total Cost:', cost),
              buildRow('Electricity Duty:', ed),
              buildRow('TV Fee:', tvFee),
              buildRow('GST:', GST),
              buildRow('FC-SUR:', fcSur),
              buildRow('Current Bill:', currBill),
              pw.SizedBox(height: 20),
              pw.Text(
                textAlign: pw.TextAlign.center,
                'Note: This is an estimated bill. Annual QTR and FPA are excluded, and there may be slight variations in other taxes.',
                style: pw.TextStyle(fontSize: 12, ),
              ),
            ],
          ),
        ),
      );

      // Print the PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to print the bill: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    var heightX = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(
        title: date,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              'Bill History',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: heightX * 0.03,
            ),
            _DetailRow('Name:', Name),
            _DetailRow('Bill Month:', billMonth),
            _DetailRow('Reading Date:', date),
            _DetailRow('Previous Units:', prevUnits),
            _DetailRow('Current Units:', currUnits),
            _DetailRow('Units Consumed:', totalUnits),
            _DetailRow('Units Price:', unitsPrice),
            _DetailRow('Total Cost:', cost),
            _DetailRow('Electricity Duty:', ed),
            _DetailRow('TV Fee:', tvFee),
            _DetailRow('GST:', GST),
         //   _DetailRow('Annual QTR:', Qtr),
            _DetailRow('FC-SUR:', fcSur),
         //   _DetailRow('Total FPA:', fpa),
            _DetailRow('Current Bill:', currBill),
            SizedBox(
              height: heightX * 0.03,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:Colours.kGreenColor, // Slightly transparent background
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Text(
                'Note: This is an estimated bill. Annual QTR and FPA are excluded, and there may be slight variations in other taxes.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14, // Adjust font size
                  fontWeight: FontWeight.w400, // Regular weight
                ),
                textAlign: TextAlign.center, // Center align the text
              ),
            ),
            SizedBox(
              height: heightX * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                    btnText: 'Download Bill',
                    btnHeight: screenHeight(context) * 0.053,
                    btnWidth: screenWidth(context) * 0.42,
                    onPress: (){
                      _printBill(context);
                    }),
                CustomButton(
                    btnText: 'Delete Bill',
                    btnHeight: screenHeight(context) * 0.053,
                    btnWidth: screenWidth(context) * 0.42,
                    onPress: ()async{
                      await FirebaseFirestore.instance.collection('Bill_Details').doc(docId).delete().then((value){
                        Navigator.pop(context);
                      });
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _DetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  pw.Widget buildRow(String label, dynamic value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,

          ),
          pw.Text(
            value.toString(),
          ),
        ],
      ),
    );
  }
}




