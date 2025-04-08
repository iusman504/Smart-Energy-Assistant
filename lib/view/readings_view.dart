import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../res/colors.dart';
import '../res/components/custom_appbar.dart';
import '../view_model/home_view_model.dart';

class Readings extends StatefulWidget {
  const Readings({super.key});

  @override
  _ReadingsState createState() => _ReadingsState();
}

class _ReadingsState extends State<Readings> {
  String? userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserId();
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.updateData();
      homeProvider.loadData();
    });
  }

  void _fetchUserId() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final homeProvider =  Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: const CustomAppBar(title: 'READINGS'),
      body: Consumer<HomeProvider>(
        builder: (context, vm, child) {
          return Padding(
              padding: const EdgeInsets.all(20.0),
              child: userId == 'SOP9cF1Qw5gehMO2qTnjr7SoruH3'
                  ? Column(
                      children: [
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: 300,
                              gridData: const FlGridData(show: false),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  axisNameWidget: const Text(
                                    'Values',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize:
                                        50,
                                    interval: 25,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  axisNameWidget: const Text(
                                    'Time',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  sideTitles: SideTitles(
                                    //showTitles: true,
                                    interval: 9000000, // 15 minutes interval
                                    getTitlesWidget: (value, meta) {
                                      DateTime date =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              value.toInt());
                                      return Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          DateFormat(
                                            'hh:mm a',
                                          ).format(date),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                show: true,
                              ),
                              borderData: FlBorderData(
                                border: const Border(
                                  left: BorderSide(color: Colors.white),
                                  bottom: BorderSide(color: Colors.white),
                                  right: BorderSide(color: Colors.transparent),
                                  top: BorderSide(color: Colors.transparent),
                                ),
                                show: true,
                              ),
                              lineBarsData: [
                                if (vm.showVoltage)
                                  vm.buildLineChartBarData(
                                      vm.voltageData, Colors.blue),
                                if (vm.showCurrent)
                                  vm.buildLineChartBarData(
                                      vm.currentData, Colors.green),
                                if (vm.showHumidity)
                                  vm.buildLineChartBarData(
                                      vm.humidityData, Colors.red),
                                if (vm.showTemp)
                                  vm.buildLineChartBarData(
                                      vm.tempData, Colors.orange),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Checkbox(
                                  value: vm.showVoltage,
                                  checkColor: Colors.white,
                                  activeColor: Colours.kGreenColor,
                                  side: const BorderSide(
                                      color: Colors.white, width: 1.5),
                                  onChanged: vm.showVoltageData,
                                ),
                                const Text(
                                  'Voltage',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Checkbox(
                                  value: vm.showCurrent,
                                  checkColor: Colors.white,
                                  activeColor: Colours.kGreenColor,
                                  side: const BorderSide(
                                      color: Colors.white, width: 1.5),
                                  onChanged: vm.showCurrentData,
                                ),
                                const Text(
                                  'Current',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Checkbox(
                                    value: vm.showHumidity,
                                    checkColor: Colors.white,
                                    activeColor: Colours.kGreenColor,
                                    side: const BorderSide(
                                        color: Colors.white, width: 1.5),
                                    onChanged: vm.showHumidityData),
                                const Text(
                                  'Humidity',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Checkbox(
                                  value: vm.showTemp,
                                  checkColor: Colors.white,
                                  activeColor: Colours.kGreenColor,
                                  side: const BorderSide(
                                      color: Colors.white, width: 1.5),
                                  onChanged: vm.showTempData,
                                ),
                                const Text(
                                  'Temperature',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Expanded(
                      child: const Center(
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 40,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Access Restricted',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'You do not have permission to view sensor data.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ));
        },
      ),
    );
  }
}
