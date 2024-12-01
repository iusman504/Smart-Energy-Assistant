import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sea/res/components/constant.dart';

import '../../utils/utils.dart';
import '../login/login_provider.dart';

class BillProvider with ChangeNotifier {
  bool showCheckbox = false;
  bool showFirstCheckbox = false;
  bool showSecondCheckbox = false;
  bool _isChecked1 = false;
  bool get isChecked1 => _isChecked1;
  bool _isChecked2 = false;
  bool get isChecked2 => _isChecked2;
  String? selectedConsumerType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    print("Loading state: $value");
    _isLoading = value;
    notifyListeners();
  }



  Future<void> testReadValue() async {
    try {
      setLoading(true);
      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      TConstant.unitsP1 = await _fetchValue(dbRef.child('unitsP1'));
      TConstant.unitsP2 = await _fetchValue(dbRef.child('unitsP2'));
      TConstant.unitsP3 = await _fetchValue(dbRef.child('unitsP3'));
      TConstant.unitsP4 = await _fetchValue(dbRef.child('unitsP4'));
      TConstant.unitsUp1 = await _fetchValue(dbRef.child('unitsUp1'));
      TConstant.unitsUp2 = await _fetchValue(dbRef.child('unitsUp2'));
      TConstant.unitsUp3 = await _fetchValue(dbRef.child('unitsUp3'));
      TConstant.unitsUp4 = await _fetchValue(dbRef.child('unitsUp4'));
      TConstant.unitsUp5 = await _fetchValue(dbRef.child('unitsUp5'));
      TConstant.unitsUp6 = await _fetchValue(dbRef.child('unitsUp6'));
      TConstant.unitsUp7 = await _fetchValue(dbRef.child('unitsUp7'));
      TConstant.unitsUp8 = await _fetchValue(dbRef.child('unitsUp8'));
      TConstant.electricityDuty = await _fetchValue(dbRef.child('electricityDuty'));
      TConstant.tvFee = await _fetchValue(dbRef.child('tvFee'));
      TConstant.gst = await _fetchValue(dbRef.child('gst'));
      TConstant.annualQtr = await _fetchValue(dbRef.child('annualQtr'));
      TConstant.fcSur = await _fetchValue(dbRef.child('fcSur'));
      TConstant.totalFpa = await _fetchValue(dbRef.child('totalFpa'));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setLoading(false);
      //  notifyListeners();
      });
    } catch (e) {
      setLoading(false);
      debugPrint("Error reading values from Firebase: $e");
    }
  }

  Future<double> _fetchValue(DatabaseReference ref) async {
    try {
      DatabaseEvent event = await ref.once();
      dynamic value = event.snapshot.value;
      return _parseDouble(value);
    } catch (e) {
      debugPrint("Error fetching value: $e");
      return 0.0;
    }
  }

  double _parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      return 0.0; // Default value in case of unknown type
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


  double _calculateTotalCost(double totalUnits) {
    if (isChecked1) {
      if (totalUnits <= 50) {
        TConstant.unitsPrice =TConstant.unitsP1;
        return totalUnits * TConstant.unitsP1;
      } else if (totalUnits <= 100) {
        TConstant.unitsPrice = TConstant.unitsP2;
        return totalUnits * TConstant.unitsP2;
      }
    } else if (isChecked2) {
      if (totalUnits <= 100) {
        TConstant.unitsPrice = TConstant.unitsP3;
        notifyListeners();
        return totalUnits * TConstant.unitsP3;
      } else if (totalUnits <= 200) {
        TConstant.unitsPrice = TConstant.unitsP4;
        return totalUnits * TConstant.unitsP4;
      }
    } else {
      if (totalUnits <= 100) {
        TConstant.unitsPrice = TConstant.unitsUp1;
        return totalUnits * TConstant.unitsUp1;
      } else if (totalUnits <= 200) {
        TConstant.unitsPrice = TConstant.unitsUp2;
        return totalUnits * TConstant.unitsUp2;
      } else if (totalUnits <= 300) {
        TConstant.unitsPrice = TConstant.unitsUp3;
        return totalUnits * TConstant.unitsUp3;
      } else if (totalUnits <= 400) {
        TConstant.unitsPrice = TConstant.unitsUp4;
        return totalUnits * TConstant.unitsUp4;
      } else if (totalUnits <= 500) {
        TConstant.unitsPrice = TConstant.unitsUp5;
        return totalUnits * TConstant.unitsUp5;
      } else if (totalUnits <= 600) {
        TConstant.unitsPrice = TConstant.unitsUp6;
        return totalUnits * TConstant.unitsUp6;
      } else if (totalUnits <= 700) {
        TConstant.unitsPrice = TConstant.unitsUp7;
        return totalUnits * TConstant.unitsUp7;
      } else {
        TConstant.unitsPrice = TConstant.unitsUp8;
        return totalUnits * TConstant.unitsUp8;
      }

    }
    notifyListeners();
    return 0.0;
  }

  void _calculateBill() {
  //  double totalUnits = TConstant.totalUnits;
    TConstant.totalCost = _calculateTotalCost(TConstant.totalUnits);
    // TConstant.totalCost = totalCost;
    double ed = (TConstant.electricityDuty / 100) * TConstant.totalCost;
    double fc =  TConstant.fcSur * TConstant.totalUnits;
double gst = (ed + fc + TConstant.totalCost) * (TConstant.gst/100);
    if (selectedConsumerType == 'Residential') {
      TConstant.currentBill = TConstant.totalCost +
          ed +
          // TConstant.electricityDuty +
          TConstant.tvFee +
          gst +
        //  TConstant.gst +
          TConstant.annualQtr +
          fc +
          // TConstant.fcSur +
          TConstant.totalFpa;
      notifyListeners();
    }
    else if (selectedConsumerType == 'Mosque') {
      TConstant.tvFee = 0;
      TConstant.currentBill = TConstant.totalCost +
          ed +
          //   TConstant.electricityDuty +
          // TConstant.gst +
          gst +
          TConstant.annualQtr +
          fc +
          // TConstant.fcSur +
          TConstant.totalFpa;
      notifyListeners();
    }

    debugPrint('Total Cost: $TConstant.totalCost');
    debugPrint('Current Bill: ${TConstant.currentBill}');
  }

  void _navigateToNextPage(PageController pageController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.page != null) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 1 ),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // void validate(BuildContext context){
  //   if (selectedConsumerType == null) {
  //     showSnackBar('Please Select Consumer Type', context);
  //   }
  // }

  void nextPage(BuildContext context, PageController pageController) {
    if (selectedConsumerType == null) {
      Utils().showSnackBar('Please Select Consumer Type', context);
    }

    else {
      testReadValue().then((value){
        Provider.of<LoginProvider>(context, listen: false).fetchUserDetails();
      })
          .then((value){
        _calculateBill();
        _navigateToNextPage(pageController);
      });

    }
  }

  void updateCheckboxVisibility() {
      if (selectedConsumerType == 'Residential' || selectedConsumerType == 'Mosque') {
        if (TConstant.totalUnits <= 100) {
          showCheckbox = true;
          showFirstCheckbox = true;
          showSecondCheckbox = true;
        } else if (TConstant.totalUnits <= 200) {
          showCheckbox = true;
          showFirstCheckbox = false;
          showSecondCheckbox = true;
        } else {
          showCheckbox = false;
          showFirstCheckbox = false;
          showSecondCheckbox = false;
        }
      } else {
        showCheckbox = false;
        showFirstCheckbox = false;
        showSecondCheckbox = false;
      }
   notifyListeners();
  }



  void changeConsumerType(value){
    selectedConsumerType = value;
    updateCheckboxVisibility();
    _isChecked1 = false;
    _isChecked2 = false;

  }

 void updateCheckBox1 ( bool? value) {
  // if (totalUnits > 100) {
  // showSnackBar('Units Is More Than 100', context);
  // } else {
  _isChecked1 = value ?? false;
  if (_isChecked1){
    _isChecked2 = false;
  }
notifyListeners();
 // }
  }

 void updateCheckBox2 ( bool? value) {
  _isChecked2 = value ?? false;
  if (_isChecked2){
    _isChecked1 = false;
  }
notifyListeners();
  }

}
