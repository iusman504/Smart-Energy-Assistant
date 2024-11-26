import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sea/constants/colors.dart';
import 'package:sea/constants/custom_appbar.dart';
import 'package:sea/components/bottom_dilogue_widget.dart';
import 'package:sea/constants/custom_button.dart';
import 'package:sea/constants/custom_textfield.dart';
import 'package:sea/constants/divider.dart';
import 'package:sea/utils/screen_size.dart';
import 'package:sea/views/Bill/data_provider.dart';


class CurrentDataView extends StatefulWidget {
  final PageController pageController;

  const CurrentDataView({
    super.key,
    required this.pageController,
  });

  @override
  State<CurrentDataView> createState() => _CurrentDataViewState();
}

class _CurrentDataViewState extends State<CurrentDataView>
    with AutomaticKeepAliveClientMixin<CurrentDataView> {


  @override
  bool get wantKeepAlive => true;





  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  ChangeNotifierProvider(create: (_)=> DataProvider(),
    child: Consumer<DataProvider>(builder: (context, vm, child) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'CURRENT DATA'),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showImageSourceDialog(
                            context,
                            vm,
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: screenHeight(context) * 0.35,
                          width: screenWidth(context) * 0.75,
                          decoration: BoxDecoration(
                            color: vm.pickedImage != null
                                ? null
                                : Colours
                                .kContainerColor, // Set color when _image is null
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(25),
                            image: vm.pickedImage != null
                                ? DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(vm.pickedImage!.path)),
                            )
                                : null,
                          ),
                          child: vm.pickedImage != null
                              ? Stack(
                            children: [
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    vm.clearCurrentImage();

                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          )
                              : const Text(
                            'Upload Meter Picture',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomButton(
                      btnText: 'Extract Units',
                      btnHeight: screenHeight(context) * 0.053,
                      btnWidth: screenWidth(context) * 0.7,
                      onPress: vm.pickedImage != null
                          ? () {
                        if (vm.pickedImage != null) {
                          vm.getCurrentData(vm.pickedImage, context);
                        }
                      }
                          : () {
                        vm.showSnackBar('Please Select Image First', context);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CustomDivider(),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Units Manually',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomTextField(
                              keyboardType: TextInputType.number,
                              controller: vm.cResponseController,
                              hintText: 'Enter Current Units',
                              read: false,
                              onPress: () {}),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Reading Date',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    CustomTextField(
                                      controller: vm.dateController,
                                      hintText: 'Select Reading Date',
                                      read: true,
                                      onPress: () {
                                        vm.selectCurrentDate(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Reading Time',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    CustomTextField(
                                      controller: vm.timeController,
                                      hintText: 'Select Reading Time',
                                      read: true,
                                      onPress: () {
                                        vm.selectTime(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(btnText: 'Previous', btnHeight: screenHeight(context)*0.053, btnWidth: screenWidth(context)*0.42, onPress:  (){
                                vm.previousPage(widget.pageController);
                              }),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomButton(btnText: 'Next', btnHeight: screenHeight(context)*0.053, btnWidth: screenWidth(context)*0.42, onPress: (){
                                vm.validateAndProceed(context, widget.pageController, false);
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (vm.scanning)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: SpinKitThreeBounce(color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
      );
    },),
    );


  }
}
