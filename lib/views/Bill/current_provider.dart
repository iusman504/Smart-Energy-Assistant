import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CurrentProvider with ChangeNotifier{

  XFile? pickedImage;
  String myText = '';
  bool scanning = false;
}