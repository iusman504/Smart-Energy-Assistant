import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../components/image_cropper.dart';
import '../../utils/constant.dart';

class PreviousProvider with ChangeNotifier{
  XFile? pickedImage;
  String myText = '';
  bool scanning = false;

  final TextEditingController pResponseController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController timeController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();


  final apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=AIzaSyDCv1kjUsY-A347ZjZiUh3QNJTzd6A_XH8';

  final header = {
    'Content-Type': 'application/json',
  };

  Future<void> getImage(ImageSource source) async {
    XFile? result = await _imagePicker.pickImage(source: source);
    //return result;
    if(result!= null){
      pickedImage = result;
      notifyListeners();
    }
  }

  Future<void> cropImage(String path, BuildContext context) async {
    XFile? croppedFile = await imageCropperView(path, context); // Your cropping function
    if (croppedFile != null) {
      pickedImage = croppedFile;
      notifyListeners();
    }
  }

  getData(image, BuildContext context) async {
      scanning = true;
      myText = '';
      pResponseController.clear();
  notifyListeners();

    try {
      List<int> imageBytes = File(image.path).readAsBytesSync();
      String base64File = base64.encode(imageBytes);

      // Hard-coded prompt
      // const promptValue =
      //     "Following is the image of a electric meter with units written on its display. Analyze the following image and provide the units_value written on its display. Note that don't provide me any additional text just provide me units_value without adding the unit ie kwh";

      const promptValue =
          "Analyze the following image of an electric meter and provide the units_value displayed on it. do not include the unit (kWh). Only respond with the units_value exactly as it appears on the display.";



      final data = {
        "contents": [
          {
            "parts": [
              {"text": promptValue},
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

      await http
          .post(Uri.parse(apiUrl), headers: header, body: jsonEncode(data))
          .then((response) {
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          myText = result['candidates'][0]['content']['parts'][0]['text'];
          if (myText != ' 9999' && myText != ' 9949' && myText != ' 9947') {
            double formattedValue = int.parse(myText) / 100;

            pResponseController.text = formattedValue.toStringAsFixed(2);
          } else {
             showSnackBar('Select Another Image', context);

          }

          debugPrint(response.body);
        } else {
          myText = 'Response status : ${response.statusCode}';
          pResponseController.text = myText;
        }
      }).catchError((error) {
        debugPrint('Error occurred $error');
         showSnackBar('Check Your Internet Connection', context);
      });
    } catch (e) {
      debugPrint('Error occurred: Try Again');
      showSnackBar('Error occurred: Try Again', context);
    }


      scanning = false;
   notifyListeners();
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: 'Cancel', textColor: Colors.red, onPressed: () {}),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime oneMonthBefore = DateTime(now.year, now.month - 1, now.day);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: oneMonthBefore,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      notifyListeners();
      // _dateController.text = picked.toString().split(" ")[0];
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
        timeController.text = picked.format(context);
     notifyListeners();
    }
  }

  void validateAndNextPage(BuildContext context, PageController pageController) {
    if (pResponseController.text.isEmpty) {
      showSnackBar('Please Enter Previous Units', context);
    } else if (dateController.text.isEmpty) {
     showSnackBar('Please Select Reading Date', context);
    } else if (timeController.text.isEmpty) {
    showSnackBar('Please Select Reading Time', context);
    } else {
      TConstant.prevUnits = pResponseController.text;
      _nextPage(pageController);
    }
  }


  void _nextPage(PageController pageController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.page != null) {
        pageController.animateToPage(
          pageController.page!.toInt() + 1,
          duration: const Duration(milliseconds: 01),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}