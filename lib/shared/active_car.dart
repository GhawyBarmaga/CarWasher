// ignore_for_file: use_build_context_synchronously



import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:intl/intl.dart';

Widget activeCarList() {
  final cars = Hive.box('cars');
  //List<Map<String, dynamic>> carsList = [];
  final carsActive = cars.values
      .map((record) => Map<String, dynamic>.from(record))
      .where((record) => record['exitDate'] == '')
      .toList();

  if (carsActive.isNotEmpty) {
    return ListView.builder(
      itemCount: carsActive.length,
      itemBuilder: (context, index) {
        final car = carsActive[index];
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text('CarName: ${car['name']}'),
            subtitle: Column(
              children: [
                Text('Service: ${car['service']}'),
                Text('Licence: ${car['licence']}'),
                Text(
                    'Entry Time: ${DateFormat('HH:mm').format(car['entryDate'])}'),
                if (car['notes']?.isNotEmpty ?? false)
                  Text('Notes: ${car['notes']}'),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () => _showCheckoutDialog(context, car),
              child: const Text('Checkout'),
            ),
          ),
        );
      },
    );
  }

  return const Center(child: Text("No Active Cars"));
}

_showCheckoutDialog(BuildContext context, car) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Checkout Car'),
      content: Text('Are you sure you want to checkout car ${car['name']}?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(child: const Text('Checkout'), onPressed: () {
          
        }),
      ],
    ),
  );
