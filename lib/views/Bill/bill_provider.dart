import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sea/utils/constant.dart';

class BillProvider with ChangeNotifier {
  bool showCheckbox = false;
  bool showFirstCheckbox = false;
  bool showSecondCheckbox = false;
  bool _isChecked1 = false;
  bool get isChecked1 => _isChecked1;
  bool _isChecked2 = false;
  bool get isChecked2 => _isChecked2;
  String? selectedConsumerType;

  double totalUnits = 0.0;
  double unitsPrice = 0.0;
  double unitsP1 = 0.0;
  double unitsP2 = 0.0;
  double unitsP3 = 0.0;
  double unitsP4 = 0.0;
  double unitsUp1 = 0.0;
  double unitsUp2 = 0.0;
  double unitsUp3 = 0.0;
  double unitsUp4 = 0.0;
  double unitsUp5 = 0.0;
  double unitsUp6 = 0.0;
  double unitsUp7 = 0.0;
  double unitsUp8 = 0.0;
  double totalCost = 0.0;
  double currentBill = 0.0;
  double fixedCharges = 0.0;
  double electricityDuty = 0.0;
  double tvFee = 0.0;
  double gst = 0.0;
  double annualQtr = 0.0;
  double fcSur = 0.0;
  double totalFpa = 0.0;

  Future<void> testReadValue() async {
    try {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      unitsP1 = await _fetchValue(dbRef.child('unitsP1'));
      unitsP2 = await _fetchValue(dbRef.child('unitsP2'));
      unitsP3 = await _fetchValue(dbRef.child('unitsP3'));
      unitsP4 = await _fetchValue(dbRef.child('unitsP4'));
      unitsUp1 = await _fetchValue(dbRef.child('unitsUp1'));
      unitsUp2 = await _fetchValue(dbRef.child('unitsUp2'));
      unitsUp3 = await _fetchValue(dbRef.child('unitsUp3'));
      unitsUp4 = await _fetchValue(dbRef.child('unitsUp4'));
      unitsUp5 = await _fetchValue(dbRef.child('unitsUp5'));
      unitsUp6 = await _fetchValue(dbRef.child('unitsUp6'));
      unitsUp7 = await _fetchValue(dbRef.child('unitsUp7'));
      unitsUp8 = await _fetchValue(dbRef.child('unitsUp8'));
      electricityDuty = await _fetchValue(dbRef.child('electricityDuty'));
      tvFee = await _fetchValue(dbRef.child('tvFee'));
      gst = await _fetchValue(dbRef.child('gst'));
      annualQtr = await _fetchValue(dbRef.child('annualQtr'));
      fcSur = await _fetchValue(dbRef.child('fcSur'));
      totalFpa = await _fetchValue(dbRef.child('totalFpa'));
    } catch (e) {
      debugPrint("Error reading values from Firebase: $e");
    }
  }

  Future<double> _fetchValue(DatabaseReference ref) async {
    try {
      DatabaseEvent event = await ref.once();
      dynamic value = event.snapshot.value;
      return value;
    } catch (e) {
      debugPrint("Error fetching value: $e");
      return 0.0;
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

  double _calculateTotalCost(double totalUnits) {
    if (isChecked1) {
      if (totalUnits <= 50) {
        unitsPrice =unitsP1;
        return totalUnits * unitsP1;
      } else if (totalUnits <= 100) {
      unitsPrice = unitsP2;
        return totalUnits * unitsP2;
      }
    } else if (isChecked2) {
      if (totalUnits <= 100) {
        unitsPrice = unitsP3;
        return totalUnits * unitsP3;
      } else if (totalUnits <= 200) {
       unitsPrice = unitsP4;
        return totalUnits * unitsP4;
      }
    } else {
      if (totalUnits <= 100) {
        unitsPrice = unitsUp1;
        return totalUnits * unitsUp1;
      } else if (totalUnits <= 200) {
       unitsPrice = unitsUp2;
        return totalUnits * unitsUp2;
      } else if (totalUnits <= 300) {
        unitsPrice = unitsUp3;
        return totalUnits * unitsUp3;
      } else if (totalUnits <= 400) {
       unitsPrice = unitsUp4;
        return totalUnits * unitsUp4;
      } else if (totalUnits <= 500) {
        unitsPrice = unitsUp5;
        return totalUnits * unitsUp5;
      } else if (totalUnits <= 600) {
        unitsPrice = unitsUp6;
        return totalUnits * unitsUp6;
      } else if (totalUnits <= 700) {
        unitsPrice = unitsUp7;
        return totalUnits * unitsUp7;
      } else {
        unitsPrice = unitsUp8;
        return totalUnits * unitsUp8;
      }
    }
    return 0.0;
  }

  void _calculateBill() {
  //  double totalUnits = TConstant.totalUnits;
      totalCost = _calculateTotalCost(totalUnits);
    // TConstant.totalCost = totalCost;
    double ed = (electricityDuty / 100) * totalCost;
    double fc =  fcSur * totalUnits;

    if (selectedConsumerType == 'Residential') {
      currentBill = totalCost +
          ed +
          // TConstant.electricityDuty +
         tvFee +
          gst +
          annualQtr +
          fc +
          // TConstant.fcSur +
          totalFpa;
    } else if (selectedConsumerType == 'Mosque') {
      tvFee = 0;
      currentBill = totalCost +
          ed +
          //   TConstant.electricityDuty +
          gst +
         annualQtr +
          fc +
          // TConstant.fcSur +
          totalFpa;
    }
    debugPrint('Total Cost: $totalCost');
    debugPrint('Current Bill: ${currentBill}');
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

  void nextPage(BuildContext context, PageController pageController) {
    if (selectedConsumerType == null) {
      showSnackBar('Please Select Consumer Type', context);
    }

    else {
      _calculateBill();
      _navigateToNextPage(pageController);
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

  // void updateCheckboxVisibility() {
  //   if (selectedConsumerType == 'Residential' || selectedConsumerType == 'Mosque') {
  //     showCheckbox = totalUnits <= 200;
  //     showFirstCheckbox = totalUnits <= 100;
  //     showSecondCheckbox = totalUnits > 100 && totalUnits <= 200;
  //   } else {
  //     showCheckbox = showFirstCheckbox = showSecondCheckbox  = false;
  //   }
  //   notifyListeners();
  // }

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
  // if (totalUnits > 100) {
  // showSnackBar('Units Is More Than 100', context);
  // } else {
  _isChecked2 = value ?? false;
  if (_isChecked2){
    _isChecked1 = false;
  }
notifyListeners();
 // }
  }

}
