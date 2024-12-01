import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {

  NetworkApiServices._internal();
  static final  NetworkApiServices _instance = NetworkApiServices._internal();
  static NetworkApiServices get instance => _instance;


  final header = {
    'Content-Type': 'application/json',
  };


  @override
  Future geminiResponse(String url, String prompt, String imagePath) async {
    List<int> imageBytes = File(imagePath).readAsBytesSync();
    String base64File = base64.encode(imageBytes);
    final data = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
            {
              "inlineData": {
                "mimeType": "image/jpeg",
                "data": base64File,
              }
            }
          ]
        }
      ],
    };
    dynamic responseJson;
    try {
      final response = await http.post(Uri.parse(url), headers: header, body: jsonEncode(data)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson['candidates'][0]['content']['parts'][0]['text'];
       // return responseJson;
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
