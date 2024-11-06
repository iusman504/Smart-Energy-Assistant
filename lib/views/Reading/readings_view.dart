import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:sea/constants/colors.dart';
import 'package:sea/constants/custom_appbar.dart';
import 'package:sea/views/Home/home_provider.dart';
import 'package:intl/intl.dart';

class Readings extends StatefulWidget {
  const Readings({super.key});

  @override
  _ReadingsState createState() => _ReadingsState();
}

class _ReadingsState extends State<Readings> {



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.updateData();
      homeProvider.loadData();
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
            child: Column(
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
                          axisNameWidget: const Text('Values',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50, // Add space between left border and titles
                            interval:
                            25,
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
                          axisNameWidget: const Text('Time',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),),
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 900000, // 15 minutes interval
                            getTitlesWidget: (value, meta) {
                              DateTime date = DateTime.fromMillisecondsSinceEpoch(
                                  value.toInt());
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(DateFormat('hh:mm a', ).format(date),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),),
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
                          vm.buildLineChartBarData(vm.voltageData, Colors.blue),
                        if (vm.showCurrent)
                          vm.buildLineChartBarData(vm.currentData, Colors.green),
                        if (vm.showHumidity)
                          vm.buildLineChartBarData(vm.humidityData, Colors.red),
                        if (vm.showTemp)
                          vm.buildLineChartBarData(vm.tempData, Colors.orange),
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
                          side: const BorderSide(color: Colors.white, width: 1.5),
                          onChanged:vm.showVoltageData,
                        ),
                        const Text('Voltage', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                      ],
                    ),
                    Column(
                      children: [
                        Checkbox(
                          value: vm.showCurrent,
                          checkColor: Colors.white,
                          activeColor: Colours.kGreenColor,
                          side: const BorderSide(color: Colors.white, width: 1.5),
                          onChanged: vm.showCurrentData,
                        ),
                        const Text('Current', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                      ],
                    ),
                    Column(
                      children: [
                        Checkbox(
                            value: vm.showHumidity,
                            checkColor: Colors.white,
                            activeColor: Colours.kGreenColor,
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            onChanged: vm.showHumidityData
                        ),
                        const Text('Humidity', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                      ],
                    ),
                    Column(
                      children: [
                        Checkbox(
                          value: vm.showTemp,
                          checkColor: Colors.white,
                          activeColor: Colours.kGreenColor,
                          side: const BorderSide(color: Colors.white, width: 1.5),
                          onChanged: vm.showTempData,
                        ),
                        const Text('Temperature', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
