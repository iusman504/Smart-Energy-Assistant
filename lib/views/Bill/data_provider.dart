import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../components/image_cropper.dart';
import '../../utils/constant.dart';

class DataProvider with ChangeNotifier{
  XFile? pickedImage;
  String myText = '';
  bool scanning = false;

  final TextEditingController pResponseController = TextEditingController();

  final TextEditingController cResponseController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController timeController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  DataProvider() {
    cResponseController.addListener(_onCResponseChanged);
  }

  void _onCResponseChanged() {
    if (cResponseController.text.isNotEmpty) {
      dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      timeController.text = DateFormat('HH:mm a').format(DateTime.now());
    } else {
      dateController.clear();
      timeController.clear();
    }
    notifyListeners();
  }
  final apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=AIzaSyDCv1kjUsY-A347ZjZiUh3QNJTzd6A_XH8';

  final header = {
    'Content-Type': 'application/json',
  };

  Future<void> getImage(ImageSource source) async {
    XFile? result = await _imagePicker.pickImage(source: source);

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

  void clearPreviousImage() {
    pickedImage = null;
    pResponseController.clear();
    notifyListeners();
  }

  void clearCurrentImage() {
    pickedImage = null;
    cResponseController.clear();
    notifyListeners();
  }

  Future<void> analyzeMeterImage( image, TextEditingController responseController, BuildContext context) async {
    scanning = true;
    myText = '';
    responseController.clear();
    notifyListeners();

    try {
      List<int> imageBytes = File(image.path).readAsBytesSync();
      String base64File = base64.encode(imageBytes);

      const promptValue = "Analyze the following image of an electric meter and provide the units_value displayed on it. Do not include the unit (kWh). Only respond with the units_value exactly as it appears on the display.";

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

      final response = await http.post(Uri.parse(apiUrl), headers: header, body: jsonEncode(data));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        myText = result['candidates'][0]['content']['parts'][0]['text'];

        if (myText != '9999' && myText != '9949' && myText != '9947') {
          double formattedValue = int.parse(myText) / 100;
          responseController.text = formattedValue.toStringAsFixed(2);
        } else {
          showSnackBar('Select Another Image', context);
        }
      } else {
        myText = 'Response status: ${response.statusCode}';
        responseController.text = myText;
      }
      debugPrint(response.body);
    } catch (error) {
      debugPrint('Error occurred: $error');
      showSnackBar('Check Your Internet Connection', context);
    } finally {
      scanning = false;
      notifyListeners();
    }
  }

  Future<void> getPreviousData(image, BuildContext context) async {
    await analyzeMeterImage(image, pResponseController, context);
  }

  Future<void> getCurrentData(image, BuildContext context) async {
    await analyzeMeterImage(image, cResponseController, context);
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

  Future<void> selectDate(BuildContext context, {required DateTime initialDate}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      notifyListeners();
    }
  }

  Future<void> selectPreviousDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime oneMonthBefore = DateTime(now.year, now.month - 1, now.day);
    await selectDate(context, initialDate: oneMonthBefore);
  }

  Future<void> selectCurrentDate(BuildContext context) async {
    await selectDate(context, initialDate: DateTime.now());
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(
        DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
      );

      timeController.text = formattedTime;
      notifyListeners();
    }
  }

  void previousPage(PageController pageController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.page != null) {
        pageController.animateToPage(
          pageController.page!.toInt() - 1,
          duration: const Duration(milliseconds: 01),
          curve: Curves.easeInOut,
        );
      }
    });
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

  void validateAndProceed(BuildContext context, PageController pageController, bool isPrevious) {
    if (isPrevious && pResponseController.text.isEmpty) {
      showSnackBar('Please Enter Previous Units', context);
    } else if (!isPrevious && cResponseController.text.isEmpty) {
      showSnackBar('Please Enter Current Units', context);
    } else if (dateController.text.isEmpty) {
      showSnackBar('Please Select Reading Date', context);
    } else if (timeController.text.isEmpty) {
      showSnackBar('Please Select Reading Time', context);
    } else {
      if (isPrevious) {
        TConstant.prevUnits = pResponseController.text;
        _nextPage(pageController);
      } else {
        TConstant.currUnits = cResponseController.text;
        double current = double.parse(TConstant.currUnits);
        double pre = double.parse(TConstant.prevUnits);
        if (current > pre) {
          TConstant.totalUnits = current - pre;
          _nextPage(pageController);
        } else {
          showSnackBar('Current > Previous', context);
        }
      }
    }
  }

  void updateDateTimeFields(BuildContext context) {
    if (cResponseController.text.isNotEmpty) {
        dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        timeController.text = TimeOfDay.now().format(context);
        print("Date and time set: ${dateController.text}, ${timeController.text}");
     notifyListeners();
    } else {
        dateController.clear();
        timeController.clear();
   notifyListeners();
    }
  }

}