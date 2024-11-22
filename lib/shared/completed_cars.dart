import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

Widget completedCars() {
  final cars = Hive.box('cars');
  final completedCars =
    cars.values
      .map((record) => Map<String, dynamic>.from(record))
      .where((record) => record['exitDate'] == '')
      .toList();
  //  ..sort((a, b) => b.exitTime!.compareTo(a.exitTime!).cast<Map<String, dynamic>>());
  if (completedCars.isEmpty) {
    return const Center(child: Text('No completed services'));
  }
  return ListView.builder(
    itemCount: completedCars.length,
    itemBuilder: (context, index) {
      final car = completedCars[index];
      //final duration = car['exitDate']!.difference(car['entryDate']!);
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
              //Text('Exit Time: ${DateFormat('HH:mm').format(car['exitDate'])}'),
              //Text('Duration: ${duration.inMinutes} minutes'),
              Text('Price: ${car['price']}'),
              if (car['notes']?.isNotEmpty ?? false)
                Text('Notes: ${car['notes']}'),
            ],
          ),
        ),
      );
    },
  );
}
