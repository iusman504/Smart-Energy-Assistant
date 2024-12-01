import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/components/custom_appbar.dart';
import '../res/components/home_container.dart';
import '../res/components/image_carousel.dart';
import '../res/components/notification_services.dart';
import '../view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userId;
  @override
  void initState() {
    super.initState();
    _fetchUserId();
    Provider.of<HomeProvider>(context, listen: false).fetchValues();
    NotificationServices().initializeNotifications(context);
  }

  void _fetchUserId() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid; // Fetch the UID of the currently logged-in user
    });
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
              userId == 'SOP9cF1Qw5gehMO2qTnjr7SoruH3'
                  ? Expanded(
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
