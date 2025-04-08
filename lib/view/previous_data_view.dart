import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sea/utils/screen_size.dart';
import '../res/colors.dart';
import '../res/components/bottom_dilogue_widget.dart';
import '../res/components/custom_appbar.dart';
import '../res/components/custom_button.dart';
import '../res/components/custom_textfield.dart';
import '../res/components/divider.dart';
import '../utils/utils.dart';
import '../view_model/data_view_model.dart';

class PreviousDataView extends StatefulWidget {
  final PageController pageController;
  const PreviousDataView({super.key, required this.pageController});

  @override
  State<PreviousDataView> createState() => _PreviousDataViewState();
}

class _PreviousDataViewState extends State<PreviousDataView>
    with AutomaticKeepAliveClientMixin<PreviousDataView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (_) => DataProvider(),
      child: Consumer<DataProvider>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: const CustomAppBar(title: 'PREVIOUS DATA'),
            body: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
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
                              width: screenHeight(context) * 0.35,
                              decoration: BoxDecoration(
                                color: vm.pickedImage != null
                                    ? null
                                    : Colours.kContainerColor,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(25),
                                image: vm.pickedImage != null
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(
                                            File(vm.pickedImage!.path)),
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
                                              vm.clearPreviousImage();
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
                                     vm.getPreviousData(vm.pickedImage!.path, context);
                                  }
                                }
                              : () {
                            Utils().showSnackBar(
                                      'Please Upload Image First', context);
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
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                controller: vm.pResponseController,
                                hintText: 'Enter Previous Units',
                                read: false,
                                onPress: () {},
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            vm.selectPreviousDate(context);
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: CustomButton(
                                      btnText: 'Next',
                                      btnHeight: screenHeight(context) * 0.053,
                                      btnWidth: screenWidth(context) * 0.42,
                                      onPress: () {
                                        vm.validateAndProceed(
                                            context, widget.pageController, true);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (vm.loading)Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: SpinKitThreeBounce(color: Colors.white, size: 20),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
