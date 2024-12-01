import '../data/network/base_api_services.dart';
import '../data/network/network_api_services.dart';

class ApiRepository {

  BaseApiServices _apiServices = NetworkApiServices.instance;

  Future<dynamic> fetchResponse(String prompt, String imagePath) async{
    try{
      dynamic response = await _apiServices.geminiResponse(prompt, imagePath);
      return response;
    }
    catch(e){
      print(e);
      throw e;
    }
  }
}