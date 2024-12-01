import 'package:flutter/material.dart';

import 'Bill/consumer_bill.dart';
import 'Bill/current_data_view.dart';
import 'Bill/previous_data_view.dart';
import 'Bill/total_units_view.dart';


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
