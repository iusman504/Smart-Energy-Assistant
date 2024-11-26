import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sea/components/total_container.dart';
import 'package:sea/constants/app_dropdown.dart';
import 'package:sea/constants/colors.dart';
import 'package:sea/constants/custom_appbar.dart';
import 'package:sea/constants/custom_button.dart';
import 'package:sea/utils/screen_size.dart';
import 'package:sea/views/Bill/bill_provider.dart';

import '../../utils/constant.dart';

class TotalUnits extends StatefulWidget {
  final PageController pageController;

  const TotalUnits({
    super.key,
    required this.pageController,
  });

  @override
  State<TotalUnits> createState() => _TotalUnitsState();
}

class _TotalUnitsState extends State<TotalUnits> {




  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=>BillProvider(),
    child: Consumer<BillProvider>(builder: (context, vm, child) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'TOTAL UNITS'),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Previous Units',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TotalContainer(text: TConstant.prevUnits),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Units',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TotalContainer(text: TConstant.currUnits),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Units',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TotalContainer(text: TConstant.totalUnits.toStringAsFixed(2)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Consumer Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppDropDown(
                        labelText: 'Select Consumer Type',
                        items: const ['Residential', 'Mosque'],
                        onChanged: vm.changeConsumerType
                      ),
                    ],
                  ),
                  if (vm.showCheckbox) ...[
                    const SizedBox(height: 10),
                    if (vm.showFirstCheckbox)
                      Row(
                        children: [
                          Checkbox(
                            value: vm.isChecked1,
                            checkColor: Colors.white,
                            activeColor: Colours.kGreenColor,
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            onChanged:vm.updateCheckBox1
                          ),
                          const Expanded(
                            child: Text(
                              'I am consuming 100 or less units for last 1 Year',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (vm.showSecondCheckbox)
                      Row(
                        children: [
                          Checkbox(
                            value: vm.isChecked2,
                            checkColor: Colors.white,
                            activeColor: Colours.kGreenColor,
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            onChanged: vm.updateCheckBox2,
                          ),
                          const Expanded(
                            child: Text(
                              'I am consuming 200 or less units for last 6 months',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        btnText: 'Previous',
                        btnHeight: screenHeight(context) * 0.053,
                        btnWidth: screenWidth(context) * 0.42,
                        onPress: (){
                          vm.previousPage(widget.pageController);
                        },
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        loading: vm.isLoading,
                        btnText: 'Generate Bill',
                        btnHeight: screenHeight(context) * 0.053,
                        btnWidth: screenWidth(context) * 0.42,
                        onPress: (){

                          // vm.testReadValue().then((value){
                            vm.nextPage(context, widget.pageController);
                          // });

                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },),
    );

  }
}
