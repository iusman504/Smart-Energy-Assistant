import 'package:flutter/material.dart';

import 'consumer_bill.dart';
import 'current_data_view.dart';
import 'previous_data_view.dart';
import 'total_units_view.dart';


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
