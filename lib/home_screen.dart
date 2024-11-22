import 'package:car_washer/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'shared/active_car.dart';
import 'shared/completed_cars.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cars = Hive.box('cars');
  List<Map<String, dynamic>> carsList = [];
  final carNameController = TextEditingController();
  final licenceController = TextEditingController();
  final notesController = TextEditingController();
  String selectedService = 'Basic';
  final Map<String, double> servicePrices = {
    'Basic': 15.0,
    'Premium': 25.0,
    'Deluxe': 35.0,
  };
  //----------------addcar--------------------
  void addCar() {
    final newCar = {
      'name': carNameController.text,
      'licence': licenceController.text,
      'service': selectedService,
      'notes': notesController.text,
      "entryDate": DateTime.now(),
      "exitDate": "",
      "price": servicePrices[selectedService],
    };
    cars.add(newCar);
    carNameController.clear();
    licenceController.clear();
    notesController.clear();
    Get.back();
    setState(() {
      carsList = cars.values.toList().cast<Map<String, dynamic>>();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Car added successfully'),
      ),
    );
  }

  //================getcars==========================
  void getCars() {
    carsList.clear();
    final data = cars.keys.map((key) {
      final value = cars.get(key);
      return {
        'id': key,
        'name': value['name'],
        'licence': value['licence'],
        'service': value['service'],
        'notes': value['notes'],
        'entryDate': value['entryDate'],
        'exitDate': value['exitDate'],
      };
    }).toList();
    setState(() {
      carsList = data;
    });
  }

  Future<void> deleteAllItems() async {
    // Open the box (replace 'boxName' with the name of your box)
    var box = await Hive.openBox('cars');

    // Clear all items in the box
    await box.clear();
  }

  @override
  void initState() {
    //deleteAllItems();
    getCars();
    super.initState();
  }

  @override
  void dispose() {
    carNameController.dispose();
    licenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Car Wash Manager'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Cars'),
              Tab(text: 'Completed'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.analytics),
              onPressed: () => Get.to(() => const StatsScreen()),
            ),
          ],
        ),
        body: TabBarView(
          children: [
             Center(child: activeCarList()),
            Center(child: completedCars()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddCarDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  //show add car dialog
  void _showAddCarDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height / 2,
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                controller: carNameController,
                decoration: const InputDecoration(labelText: 'Car Name'),
              ),
              TextField(
                controller: licenceController,
                decoration: const InputDecoration(labelText: 'Licence Number'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedService,
                items: ['Basic', 'Premium', 'Deluxe']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                              '$type (\$${servicePrices[type]?.toStringAsFixed(2)})'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => selectedService = value!),
                decoration: const InputDecoration(
                  labelText: 'Service Type',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(children: [
                ElevatedButton(
                  onPressed: () {
                    addCar();
                  },
                  child: const Text('Add Car'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
