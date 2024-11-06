import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatefulWidget {
  const LineChart({super.key});

  @override
  State<LineChart> createState() => _LineChartState();
}

List chartData = [
  [2005, 24 , 25],
  [2006, 30 , 60],
  [2007, 66 , 52],
  [2008, 40 , 75],
  [2009, 23 , 67],
  [2010, 66 , 81],
  [2011, 88 , 88],
  [2012, 50 , 25],
  [2013, 23 , 90],
];

class _LineChartState extends State<LineChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SfCartesianChart(
        series: [
          LineSeries(
            markerSettings: MarkerSettings(isVisible: true),
            dataSource: chartData,
              color: Colors.orange,
              name: 'Voltage',
              xValueMapper: (data, index)=>data[0],
              yValueMapper: (data, index)=>data[1]),
          LineSeries(
            markerSettings: MarkerSettings(isVisible: true),
            dataSource: chartData,
              color: Colors.green,
              name: 'Current',
              xValueMapper: (data, index)=>data[0],
              yValueMapper: (data, index)=>data[2]),
        ],
        legend: Legend(isVisible: true),
      ),
    );
  }
}












// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// class ApiService {
//   final String apiKey = 'AIzaSyDV7W1x82DoRwtdT-6AB_Psyeic-E6yNME';
//   final String endpoint = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent'; // replace with the correct endpoint
//
//   Future<Map<String, dynamic>> sendImageToGemini(File image) async {
//     final request = http.MultipartRequest('POST', Uri.parse(endpoint));
//     request.headers['Authorization'] = 'Bearer $apiKey';
//
//     request.files.add(await http.MultipartFile.fromPath('image', image.path));
//
//     request.fields['prompt'] = jsonEncode({
//       "prompt": "Following is the image of an electric meter with units written on its display. Analyze the following image and provide the units value written on its display in JSON format. Note that your response will be only in JSON format, don't provide me any additional text."
//     });
//
//     final response = await request.send();
//
//     if (response.statusCode == 200) {
//       final responseData = await response.stream.bytesToString();
//       return jsonDecode(responseData);
//     } else {
//       throw Exception('Failed to send image to Gemini API');
//
//     }
//   }
// }
