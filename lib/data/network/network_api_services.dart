import 'dart:convert';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {

  NetworkApiServices._internal();
  static final  NetworkApiServices _instance = NetworkApiServices._internal();
  static NetworkApiServices get instance => _instance;

  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyDCv1kjUsY-A347ZjZiUh3QNJTzd6A_XH8',
  );

  Future<DataPart> fileToPart(String mimeType, String path) async {
    return DataPart(mimeType, await File(path).readAsBytes());
  }

  Future<dynamic> geminiResponse(String prompt, String imagePath) async {
    try {
      final image = await fileToPart('image/jpeg', imagePath);
      final response = await model.generateContent([
        Content.multi([TextPart(prompt), image]),
      ]);
      print('object ${response.text}' );
     // return returnResponse(response );
     return response.text;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  dynamic returnResponse(response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseText =  response.text;
        return responseText;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorizedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error Occurred While Communicating With Server With Status Code${response.statusCode.toString()}');
    }
  }
}