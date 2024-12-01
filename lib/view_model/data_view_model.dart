import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../data/response/api_response.dart';
import '../repository/api_repository.dart';
import '../res/components/image_cropper.dart';
import '../res/components/constant.dart';
import '../utils/utils.dart';

class DataProvider with ChangeNotifier{
  XFile? pickedImage;
  String myText = '';
  // bool scanning = false;

  bool _loading = false;
  bool get loading =>_loading;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

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
      timeController.text = DateFormat('hh:mm a').format(DateTime.now());
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



  final _myRepo =ApiRepository();

  ApiResponse apiResponse= ApiResponse.loading();

  setResponse(ApiResponse response){
    apiResponse = response;
    notifyListeners();
  }
  // final prompt = "Analyze the following image of an electric meter and provide the units_value displayed on it. Do not include the unit (kWh). Only respond with the units_value exactly as it appears on the display.";

  Future<dynamic> getResponse (String imagePath, TextEditingController responseController, BuildContext context)  async{
    setResponse(ApiResponse.loading());
    setLoading(true);
    _myRepo.fetchResponse(imagePath).then((value){
      setResponse(ApiResponse.completed(value));
      print(value);

      try{
        double formattedValue;
        if (value.contains('.')) {
          formattedValue = double.parse(value);
        } else {
          formattedValue = int.parse(value) / 100;
        }
        responseController.text = formattedValue.toStringAsFixed(2);
      } catch(e){
        Utils().showSnackBar('Please Select Another Image', context);
      }

      setLoading(false);
    }).onError((error, stackTrace){
      setResponse(ApiResponse.error(error.toString()));
      Utils().showSnackBar(error.toString(), context);
      setLoading(false);
    });
  }

  Future<void> getPreviousData(imagePath, BuildContext context ) async {
    await getResponse(imagePath, pResponseController, context);
  }

  Future<void> getCurrentData(imagePath, BuildContext context) async {
    await getResponse(imagePath, cResponseController, context);
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
      Utils().showSnackBar('Please Enter Previous Units', context);
    } else if (!isPrevious && cResponseController.text.isEmpty) {
      Utils().showSnackBar('Please Enter Current Units', context);
    } else if (dateController.text.isEmpty) {
      Utils().showSnackBar('Please Select Reading Date', context);
    } else if (timeController.text.isEmpty) {
      Utils().showSnackBar('Please Select Reading Time', context);
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
          Utils().showSnackBar('Current > Previous', context);
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