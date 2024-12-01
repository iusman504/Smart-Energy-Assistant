import 'package:sea/res/app_urls.dart';

import '../data/network/base_api_services.dart';
import '../data/network/network_api_services.dart';

class ApiRepository {

  BaseApiServices _apiServices = NetworkApiServices.instance;

  Future<dynamic> fetchResponse(String imagePath,) async{
    try{
      dynamic response = await _apiServices.geminiResponse(AppUrls.geminiUrl, AppUrls.promptValue, imagePath, );
      return response;
    }
    catch(e){
      print(e);
      throw e;
    }
  }
}