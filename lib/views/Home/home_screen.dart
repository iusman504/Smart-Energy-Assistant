import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sea/components/home_components/home_container.dart';
import 'package:sea/components/home_components/image_carousel.dart';
import 'package:sea/constants/custom_appbar.dart';
import 'package:sea/constants/notification_services.dart';
import 'package:sea/views/Home/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).fetchValues();
    NotificationServices().initializeNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return Scaffold(
      appBar: const CustomAppBar(title: 'SMART ENERGY ASSISTANT'),
      body: Consumer<HomeProvider>(
        builder: (context, vm, child) {
          return Column(
            children: [
              const Center(
                child: ImageCarousel(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HomeContainer(
                            numValue: vm.voltage.toInt(),
                            unit: 'V',
                            unitValue: 'Voltage'),
                        const SizedBox(
                          width: 20,
                        ),
                        HomeContainer(
                            numValue: vm.current.toInt(),
                            unit: 'I',
                            unitValue: 'Current'),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HomeContainer(
                            numValue: vm.humidity.toInt(),
                            unit: '%',
                            unitValue: 'Humidity'),
                        const SizedBox(
                          width: 20,
                        ),
                        HomeContainer(
                            numValue: vm.temperature.toInt(),
                            unit: 'C',
                            unitValue: 'Temperature'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
