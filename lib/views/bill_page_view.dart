import 'package:flutter/material.dart';
import 'package:sea/views/Bill/consumer_bill.dart';
import 'package:sea/views/Bill/current_data_view.dart';
import 'package:sea/views/Bill/previous_data_view.dart';
import 'package:sea/views/Bill/total_units_view.dart';

class BillPageView extends StatefulWidget {
  const BillPageView({super.key});

  @override
  State<BillPageView> createState() => _BillPageViewState();
}

class _BillPageViewState extends State<BillPageView> {
  final PageController _pageController = PageController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          PreviousDataView(pageController: _pageController),
          CurrentDataView(pageController: _pageController,),
          TotalUnits(pageController: _pageController,),
          ConsumerBill( pageController: _pageController,),
        ],
      ),
    );
  }
}
